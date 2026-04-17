import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late final PdfControllerPinch _controller;
  int _currentPage = 1;
  int _totalPages = 0;
  bool _showToolbar = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _controller = PdfControllerPinch(
      document: PdfDocument.openFile(widget.path),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  void _toggleToolbar() {
    setState(() => _showToolbar = !_showToolbar);
  }

  void _prevPage() {
    if (_currentPage > 1) {
      _controller.previousPage(
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 250),
      );
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages) {
      _controller.nextPage(
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
            hintStyle: TextStyle(color: AppTheme.textMuted),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.divider),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.accent),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          style: const TextStyle(color: AppTheme.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Annulla', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              final n = int.tryParse(tc.text);
              if (n != null && n >= 1 && n <= _totalPages) {
                _controller.animateToPage(
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

  @override
  Widget build(BuildContext context) {
    final shortName = widget.name.length > 28
        ? '${widget.name.substring(0, 25)}...'
        : widget.name;

    return Scaffold(
      backgroundColor: AppTheme.bgDeep,
      body: GestureDetector(
        onTap: _toggleToolbar,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            // ── PDF View ────────────────────────────────────────
            PdfViewPinch(
              controller: _controller,
              onDocumentLoaded: (doc) {
                setState(() => _totalPages = doc.pagesCount);
              },
              onPageChanged: (page) {
                setState(() => _currentPage = page);
              },
              builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
                options: const DefaultBuilderOptions(),
                documentLoaderBuilder: (_) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: AppTheme.accent, strokeWidth: 2),
                      const SizedBox(height: 16),
                      Text('Caricamento PDF...',
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                    ],
                  ),
                ),
                pageLoaderBuilder: (_) => const Center(
                  child: CircularProgressIndicator(color: AppTheme.accent, strokeWidth: 2),
                ),
                errorBuilder: (_, err) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline_rounded,
                          color: Colors.redAccent, size: 48),
                      const SizedBox(height: 12),
                      Text('Impossibile aprire il PDF',
                          style: TextStyle(color: AppTheme.textPrimary, fontSize: 16)),
                      const SizedBox(height: 6),
                      Text(err.toString(),
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
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
                  border: Border(
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
                            style: TextStyle(
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
                    border: Border(
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
                              _controller.animateToPage(
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
    );
  }
}
