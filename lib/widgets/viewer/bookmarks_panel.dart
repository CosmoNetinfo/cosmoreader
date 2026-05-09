import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../models/bookmark.dart';
import '../../services/bookmark_service.dart';
import '../../theme/cosmonet_colors.dart';
import '../../theme/text_styles.dart';

class BookmarksPanel extends StatefulWidget {
  final String filePath;
  final int currentPage;
  final Function(int) onPageSelected;

  const BookmarksPanel({
    super.key,
    required this.filePath,
    required this.currentPage,
    required this.onPageSelected,
  });

  @override
  State<BookmarksPanel> createState() => _BookmarksPanelState();
}

class _BookmarksPanelState extends State<BookmarksPanel> {
  final BookmarkService _bookmarkService = BookmarkService();
  List<Bookmark> _bookmarks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final bookmarks = await _bookmarkService.getBookmarksForFile(widget.filePath);
      if (mounted) {
        setState(() {
          _bookmarks = bookmarks;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _toggleBookmark() async {
    final isBookmarked = await _bookmarkService.isPageBookmarked(widget.filePath, widget.currentPage);
    if (isBookmarked) {
      await _bookmarkService.removeBookmark(widget.filePath, widget.currentPage);
    } else {
      await _bookmarkService.addBookmark(Bookmark(
        filePath: widget.filePath,
        pageNumber: widget.currentPage,
        createdAt: DateTime.now(),
      ));
    }
    _loadBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: const BoxDecoration(
        color: CosmonetColors.bgSecondary,
        border: Border(
          left: BorderSide(color: CosmonetColors.divider, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const Divider(color: CosmonetColors.divider, height: 1),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: CosmonetColors.accentBlue))
                : _bookmarks.isEmpty
                    ? _buildEmptyState()
                    : _buildBookmarksList(),
          ),
          _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Row(
        children: [
          const Icon(Icons.bookmark_outline, color: CosmonetColors.accentBlue),
          const SizedBox(width: 12),
          Text(
            'Segnalibri',
            style: CosmonetTextStyles.titleMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.bookmark_border_rounded,
            size: 64,
            color: CosmonetColors.textDisabled,
          ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.8, 0.8)),
          const SizedBox(height: 16),
          Text(
            'Nessun segnalibro',
            style: CosmonetTextStyles.bodyMedium.copyWith(color: CosmonetColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarksList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _bookmarks.length,
      separatorBuilder: (context, index) => const Divider(color: CosmonetColors.divider, height: 1, indent: 64),
      itemBuilder: (context, index) {
        final bookmark = _bookmarks[index];
        final isCurrent = bookmark.pageNumber == widget.currentPage;

        return Material(
          color: Colors.transparent,
          child: ListTile(
            onTap: () => widget.onPageSelected(bookmark.pageNumber),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isCurrent ? CosmonetColors.accentBlue.withValues(alpha: 0.15) : CosmonetColors.bgSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isCurrent ? CosmonetColors.accentBlue.withValues(alpha: 0.3) : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  '${bookmark.pageNumber}',
                  style: CosmonetTextStyles.labelSmall.copyWith(
                    color: isCurrent ? CosmonetColors.accentBlue : CosmonetColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Text(
              'Pagina ${bookmark.pageNumber}',
              style: CosmonetTextStyles.bodyLarge.copyWith(
                color: isCurrent ? CosmonetColors.accentBlue : CosmonetColors.textPrimary,
                fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            subtitle: Text(
              DateFormat('dd/MM/yyyy HH:mm').format(bookmark.createdAt),
              style: CosmonetTextStyles.labelSmall.copyWith(color: CosmonetColors.textSecondary),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: CosmonetColors.textDisabled, size: 20),
              onPressed: () async {
                if (bookmark.id != null) {
                  await _bookmarkService.deleteBookmark(bookmark.id!);
                  _loadBookmarks();
                }
              },
              tooltip: 'Rimuovi',
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddButton() {
    final bool alreadyBookmarked = _bookmarks.any((b) => b.pageNumber == widget.currentPage);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: CosmonetColors.bgSecondary,
        border: Border(top: BorderSide(color: CosmonetColors.divider, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: _toggleBookmark,
            icon: Icon(alreadyBookmarked ? Icons.bookmark_remove : Icons.bookmark_add),
            label: Text(alreadyBookmarked ? 'Rimuovi segnalibro' : 'Aggiungi qui'),
            style: ElevatedButton.styleFrom(
              backgroundColor: alreadyBookmarked ? CosmonetColors.bgSurface : CosmonetColors.accentBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ),
    );
  }
}
