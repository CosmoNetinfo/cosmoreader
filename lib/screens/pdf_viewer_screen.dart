import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import '../theme/app_theme.dart';

class PdfViewerScreen extends StatefulWidget {
  final String path;
  final String name;

  const PdfViewerScreen({super.key, required this.path, required this.name});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  // Use dynamic to avoid ambiguous class resolution during build across drives
  dynamic _controller;
  
  int _currentPage = 1;
  int _totalPages = 0;
  bool _showToolbar = true;

  bool get _isDesktop => !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);

  @override
  void initState() {
    super.initState();
    try {
      final document = PdfDocument.openFile(widget.path);
      if (_isDesktop) {
        _controller = PdfController(document: document);
      } else {
        _controller = PdfControllerPinch(
          document: document,
          initialPage: 1,
        );
      }
    } catch (e) {
      debugPrint("Error initializing PDF document: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _toggleToolbar() {
    setState(() => _showToolbar = !_showToolbar);
  }

  void _prevPage() {
    if (_currentPage > 1) {
      _controller?.previousPage(
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 250),
      );
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages) {
      _controller?.nextPage(
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 250),
      );
    }
  }

  void _goToPage() {
    final tc = TextEditingController(text: _currentPage.toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        title: const Text('Vai a pagina'),
        content: TextField(
          controller: tc,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: InputDecoration(
            hintText: '1 – $_totalPages',
            hintStyle: const TextStyle(color: AppTheme.textMuted),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppTheme.divider),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppTheme.accent),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          style: const TextStyle(color: AppTheme.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annulla', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              final n = int.tryParse(tc.text);
              if (n != null && n >= 1 && n <= _totalPages) {
                _controller?.animateToPage(
                  pageNumber: n,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 400),
                );
              }
              Navigator.pop(ctx);
            },
            child: const Text('Vai'),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext _, dynamic err) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded,
              color: Colors.redAccent, size: 48),
          const SizedBox(height: 12),
          const Text('Impossibile aprire il PDF',
              style: TextStyle(color: AppTheme.textPrimary, fontSize: 16)),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(err.toString(),
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                textAlign: TextAlign.center),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Torna indietro'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return Scaffold(
        backgroundColor: AppTheme.bgDeep,
        body: _buildError(context, "Errore caricamento controller"),
      );
    }

    final shortName = widget.name.length > 28
        ? '${widget.name.substring(0, 25)}...'
        : widget.name;
        
    final loadBuilder = (_) => const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppTheme.accent, strokeWidth: 2),
          SizedBox(height: 16),
          Text('Caricamento PDF...',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
        ],
      ),
    );

    final pageLoadBuilder = (_) => const Center(
      child: CircularProgressIndicator(color: AppTheme.accent, strokeWidth: 2),
    );

    return Scaffold(
      backgroundColor: AppTheme.bgDeep,
      body: SafeArea(
        child: GestureDetector(
          onTap: _toggleToolbar,
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
              // ── PDF View ────────────────────────────────────────
              if (_isDesktop)
                PdfView(
                  controller: _controller as PdfController,
                  onDocumentLoaded: (doc) {
                    setState(() => _totalPages = doc.pagesCount);
                  },
                  onPageChanged: (page) {
                    setState(() => _currentPage = page);
                  },
                  builders: PdfViewBuilders<DefaultBuilderOptions>(
                    options: const DefaultBuilderOptions(),
                    documentLoaderBuilder: loadBuilder,
                    pageLoaderBuilder: pageLoadBuilder,
                    errorBuilder: _buildError,
                  ),
                )
              else
                PdfViewPinch(
                  controller: _controller as PdfControllerPinch,
                  onDocumentLoaded: (doc) {
                    setState(() => _totalPages = doc.pagesCount);
                  },
                  onPageChanged: (page) {
                    setState(() => _currentPage = page);
                  },
                  builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
                    options: const DefaultBuilderOptions(),
                    documentLoaderBuilder: loadBuilder,
                    pageLoaderBuilder: pageLoadBuilder,
                    errorBuilder: _buildError,
                  ),
                  // Fix zoom stuck issue on mobile: allow returning to 1.0 scale
                  minScale: 1.0, 
                ),

              // ── Top Toolbar ─────────────────────────────────────
              AnimatedPositioned(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                top: _showToolbar ? 0 : -100,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.bgSurface.withOpacity(0.95),
                    border: const Border(
                      bottom: BorderSide(color: AppTheme.divider),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        color: AppTheme.textPrimary,
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          shortName,
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Page indicator tappable
                      if (_totalPages > 0)
                        GestureDetector(
                          onTap: _goToPage,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.accentDim,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$_currentPage / $_totalPages',
                              style: const TextStyle(
                                color: AppTheme.accent,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
              ),

              // ── Bottom Toolbar ───────────────────────────────────
              if (_totalPages > 0)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  bottom: _showToolbar ? 0 : -80,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.bgSurface.withOpacity(0.95),
                      border: const Border(
                        top: BorderSide(color: AppTheme.divider),
                      ),
                    ),
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 4,
                      top: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Prev
                        IconButton(
                          icon: const Icon(Icons.navigate_before_rounded),
                          iconSize: 28,
                          color: _currentPage > 1
                              ? AppTheme.textPrimary
                              : AppTheme.textMuted,
                          onPressed: _currentPage > 1 ? _prevPage : null,
                        ),
                        // Progress bar
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: GestureDetector(
                              onTapDown: (details) {
                                final RenderBox box =
                                    context.findRenderObject() as RenderBox;
                                final localPos = box.globalToLocal(
                                    details.globalPosition);
                                // calculate page from tap position
                                final progress =
                                    localPos.dx / box.size.width;
                                final targetPage =
                                    (progress * _totalPages).clamp(1, _totalPages).round();
                                
                                _controller?.animateToPage(
                                  pageNumber: targetPage,
                                  curve: Curves.easeOut,
                                  duration: const Duration(milliseconds: 300),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: _totalPages > 0
                                      ? (_currentPage - 1) / (_totalPages - 1).clamp(1, _totalPages)
                                      : 0,
                                  backgroundColor: AppTheme.divider,
                                  color: AppTheme.accent,
                                  minHeight: 4,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Next
                        IconButton(
                          icon: const Icon(Icons.navigate_next_rounded),
                          iconSize: 28,
                          color: _currentPage < _totalPages
                              ? AppTheme.textPrimary
                              : AppTheme.textMuted,
                          onPressed: _currentPage < _totalPages ? _nextPage : null,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
