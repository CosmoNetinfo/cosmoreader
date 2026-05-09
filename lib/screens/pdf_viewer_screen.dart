import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:path/path.dart' as p;
import '../models/recent_file.dart';
import '../models/bookmark.dart';
import '../models/annotation.dart';
import '../services/recent_files_service.dart';
import '../services/reading_state_service.dart';
import '../services/bookmark_service.dart';
import '../services/search_service.dart';
// import '../services/annotation_service.dart';
import '../widgets/viewer/viewer_toolbar.dart';
import '../widgets/viewer/viewer_bottom_bar.dart';
import '../widgets/viewer/search_bar_overlay.dart';
import '../widgets/viewer/annotation_toolbar.dart';
import '../widgets/viewer/bookmarks_panel.dart';
import '../widgets/viewer/thumbnail_drawer.dart';
import '../widgets/viewer/document_outline.dart';
import '../widgets/viewer/document_info_sheet.dart';
import '../theme/cosmonet_colors.dart';
import '../theme/text_styles.dart';
import '../utils/shortcut_intents.dart';

class PdfViewerScreen extends StatefulWidget {
  final String filePath;

  const PdfViewerScreen({super.key, required this.filePath});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final PdfViewerController _pdfController = PdfViewerController();
  final RecentFilesService _recentFilesService = RecentFilesService();
  final ReadingStateService _readingStateService = ReadingStateService();
  final BookmarkService _bookmarkService = BookmarkService();
  final SearchService _searchService = SearchService();
  // final AnnotationService _annotationService = AnnotationService();
  
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _showUI = true;
  Timer? _hideTimer;
  // bool _isReady = false;
  int _totalPages = 0;
  int _currentPage = 1;
  PdfDocument? _document;

  // Search State
  bool _isSearchActive = false;
  List<SearchResult> _searchResults = [];
  int _currentSearchMatchIndex = 0;

  // Annotation State
  bool _isAnnotationMode = false;
  AnnotationType? _activeAnnotationType;
  Color _activeAnnotationColor = CosmonetColors.highlightYellow;

  @override
  void initState() {
    super.initState();
    _startHideTimer();
  }

  void _onDocumentLoaded(PdfDocument document) async {
    setState(() {
      _document = document;
      _totalPages = document.pages.length;
    });

    // Check for resume
    final lastPage = await _readingStateService.getLastPage(widget.filePath);
    if (lastPage != null && lastPage > 1 && mounted) {
      _showResumeDialog(lastPage);
    }

    // Add to recent
    final file = File(widget.filePath);
    await _recentFilesService.addFile(RecentFile(
      path: widget.filePath,
      name: p.basename(widget.filePath),
      totalPages: _totalPages,
      currentPage: 1,
      lastOpened: DateTime.now(),
      fileSize: file.lengthSync() / (1024 * 1024),
    ));
  }

  void _showResumeDialog(int page) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CosmonetColors.bgElevated,
        title: const Text('Riprendi lettura', style: TextStyle(color: Colors.white)),
        content: Text('Vuoi riprendere da pagina $page?', style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: CosmonetColors.accentBlue),
            onPressed: () {
              _pdfController.goToPage(pageNumber: page);
              Navigator.pop(context);
            },
            child: const Text('Sì', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _startHideTimer() {
    _cancelHideTimer();
    _hideTimer = Timer(const Duration(seconds: 4), () {
      if (mounted && _showUI && !_isSearchActive && !_isAnnotationMode) {
        setState(() => _showUI = false);
      }
    });
  }

  void _cancelHideTimer() {
    _hideTimer?.cancel();
  }

  void _toggleUI() {
    if (_isSearchActive || _isAnnotationMode) return;
    setState(() {
      _showUI = !_showUI;
      if (_showUI) _startHideTimer();
    });
  }

  Future<void> _updateProgress(int page) async {
    setState(() => _currentPage = page);
    await _readingStateService.saveLastPage(widget.filePath, page);
    
    // Update recent file entry
    final files = await _recentFilesService.getRecentFiles();
    final index = files.indexWhere((e) => e.path == widget.filePath);
    if (index != -1) {
      final oldFile = files[index];
      await _recentFilesService.addFile(RecentFile(
        path: oldFile.path,
        name: oldFile.name,
        totalPages: oldFile.totalPages,
        currentPage: page,
        lastOpened: DateTime.now(),
        fileSize: oldFile.fileSize,
      ));
    }
  }

  // --- Search Logic ---
  void _startSearch(String query) async {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    final results = await _searchService.searchInDocument(widget.filePath, query);
    setState(() {
      _searchResults = results;
      _currentSearchMatchIndex = results.isNotEmpty ? 0 : -1;
    });
    if (results.isNotEmpty) {
      _goToSearchMatch(0);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nessun risultato trovato nel documento.'),
            backgroundColor: CosmonetColors.textSecondary,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _goToSearchMatch(int index) {
    if (_searchResults.isEmpty) return;
    final match = _searchResults[index];
    _pdfController.goToPage(pageNumber: match.pageIndex);
    // TODO: Highlight text in viewer if pdfrx supports it easily
  }

  // --- Bookmark Logic ---
  void _addBookmark() async {
    final bookmark = Bookmark(
      filePath: widget.filePath,
      pageNumber: _currentPage,
      note: 'Pagina $_currentPage',
      createdAt: DateTime.now(),
    );
    await _bookmarkService.addBookmark(bookmark);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Segnalibro aggiunto a pagina $_currentPage'),
          backgroundColor: CosmonetColors.accentBlue,
        ),
      );
    }
  }

  @override
  void dispose() {
    _cancelHideTimer();
    // PdfViewerController doesn't have a dispose method in this version
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: readerShortcuts,
      child: Actions(
        actions: {
          NextPageIntent: CallbackAction<NextPageIntent>(onInvoke: (intent) { if (_currentPage < _totalPages) _pdfController.goToPage(pageNumber: _currentPage + 1); return null; }),
          PrevPageIntent: CallbackAction<PrevPageIntent>(onInvoke: (intent) { if (_currentPage > 1) _pdfController.goToPage(pageNumber: _currentPage - 1); return null; }),
          FirstPageIntent: CallbackAction<FirstPageIntent>(onInvoke: (intent) { _pdfController.goToPage(pageNumber: 1); return null; }),
          LastPageIntent: CallbackAction<LastPageIntent>(onInvoke: (intent) { _pdfController.goToPage(pageNumber: _totalPages); return null; }),
          SearchIntent: CallbackAction<SearchIntent>(onInvoke: (intent) { setState(() { _isSearchActive = true; _showUI = false; }); return null; }),
          EscapeIntent: CallbackAction<EscapeIntent>(onInvoke: (intent) { setState(() { _isSearchActive = false; _showUI = true; }); return null; }),
          BookmarkIntent: CallbackAction<BookmarkIntent>(onInvoke: (intent) { _addBookmark(); return null; }),
          // Zoom handling would go here, but pdfrx handles basic zooming natively. We can leave it for now or implement matrix changes.
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            key: _scaffoldKey,
      backgroundColor: Colors.black,
      drawer: Drawer(
        child: DocumentOutline(
          document: _document,
          onPageSelected: (page) => _pdfController.goToPage(pageNumber: page),
        ),
      ),
      endDrawer: ThumbnailDrawer(
        filePath: widget.filePath,
        document: _document,
        currentPage: _currentPage,
        onPageSelected: (page) => _pdfController.goToPage(pageNumber: page),
      ),
      body: Stack(
        children: [
          // PDF Viewer
          GestureDetector(
            onTap: _toggleUI,
            child: PdfViewer.file(
              widget.filePath,
              controller: _pdfController,
              params: PdfViewerParams(
                backgroundColor: Colors.black,
                maxScale: 5.0,
                onDocumentChanged: (document) { if (document != null) _onDocumentLoaded(document); },
                onPageChanged: (page) {
                  if (page != null) _updateProgress(page);
                },
                loadingBannerBuilder: (context, bytesDownloaded, totalBytes) {
                  return const Center(child: CircularProgressIndicator(color: CosmonetColors.accentBlue));
                },
                errorBannerBuilder: (context, error, stackTrace, documentRef) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text('Impossibile aprire il documento', style: CosmonetTextStyles.titleMedium),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // Search Bar Overlay
          if (_isSearchActive)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 0,
              right: 0,
              child: SearchBarOverlay(
                onSearch: _startSearch,
                onClose: () => setState(() {
                  _isSearchActive = false;
                  _searchResults = [];
                  _showUI = true;
                }),
                onNext: () {
                  if (_searchResults.isNotEmpty) {
                    setState(() {
                      _currentSearchMatchIndex = (_currentSearchMatchIndex + 1) % _searchResults.length;
                    });
                    _goToSearchMatch(_currentSearchMatchIndex);
                  }
                },
                onPrevious: () {
                  if (_searchResults.isNotEmpty) {
                    setState(() {
                      _currentSearchMatchIndex = (_currentSearchMatchIndex - 1 + _searchResults.length) % _searchResults.length;
                    });
                    _goToSearchMatch(_currentSearchMatchIndex);
                  }
                },
                currentMatch: _currentSearchMatchIndex + 1,
                totalMatches: _searchResults.length,
              ),
            ),

          // Annotation Toolbar
          if (_isAnnotationMode)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Center(
                child: AnnotationToolbar(
                  activeType: _activeAnnotationType,
                  activeColor: _activeAnnotationColor,
                  onTypeSelected: (type) => setState(() => _activeAnnotationType = type),
                  onColorSelected: (color) => setState(() => _activeAnnotationColor = color),
                  onClose: () => setState(() {
                    _isAnnotationMode = false;
                    _showUI = true;
                  }),
                ),
              ),
            ),

          // Toolbar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            top: (_showUI && !_isSearchActive) ? 0 : -120,
            left: 0,
            right: 0,
            child: ViewerToolbar(
              fileName: p.basename(widget.filePath),
              onBack: () => Navigator.pop(context),
              onSearch: () => setState(() {
                _isSearchActive = true;
                _showUI = false;
              }),
              onBookmark: _addBookmark,
              onAnnotations: () => setState(() {
                _isAnnotationMode = true;
                _showUI = false;
              }),
              onOutline: () => _scaffoldKey.currentState?.openDrawer(),
              onInfo: () {
                if (_document != null) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => DocumentInfoSheet(
                      document: _document!,
                      filePath: widget.filePath,
                      fileSize: '${(File(widget.filePath).lengthSync() / (1024 * 1024)).toStringAsFixed(2)} MB',
                    ),
                  );
                }
              },
            ),
          ),

          // Bottom Bar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            bottom: (_showUI && !_isAnnotationMode) ? 0 : -120,
            left: 0,
            right: 0,
            child: ViewerBottomBar(
              currentPage: _currentPage,
              totalPages: _totalPages,
              onPageChanged: (page) {
                _pdfController.goToPage(pageNumber: page);
                _startHideTimer();
              },
              onThumbnails: () => _scaffoldKey.currentState?.openEndDrawer(),
              onBookmarksList: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => DraggableScrollableSheet(
                    initialChildSize: 0.6,
                    maxChildSize: 0.9,
                    builder: (context, scrollController) => BookmarksPanel(
                      filePath: widget.filePath,
                      currentPage: _currentPage,
                      onPageSelected: (page) {
                        _pdfController.goToPage(pageNumber: page);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ))));
  }
}
