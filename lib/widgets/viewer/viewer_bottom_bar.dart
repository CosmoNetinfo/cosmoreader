import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/cosmonet_colors.dart';
import '../../theme/text_styles.dart';

class ViewerBottomBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;
  final VoidCallback onThumbnails;
  final VoidCallback onBookmarksList;

  const ViewerBottomBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    required this.onThumbnails,
    required this.onBookmarksList,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 8),
          decoration: BoxDecoration(
            color: CosmonetColors.bgElevated.withValues(alpha: 0.85),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
            border: const Border(top: BorderSide(color: CosmonetColors.divider, width: 0.5)),
          ),
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              height: 64,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.grid_view_rounded, color: CosmonetColors.textSecondary),
                      onPressed: onThumbnails,
                      tooltip: 'Anteprime',
                    ),
                    IconButton(
                      icon: const Icon(Icons.bookmarks_outlined, color: CosmonetColors.textSecondary),
                      onPressed: onBookmarksList,
                      tooltip: 'Segnalibri',
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: CosmonetColors.textPrimary),
                      onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: CosmonetColors.accentBlue,
                          inactiveTrackColor: CosmonetColors.bgSurface,
                          thumbColor: CosmonetColors.accentBlue,
                          overlayColor: CosmonetColors.accentBlue.withValues(alpha: 0.2),
                          trackHeight: 4,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        ),
                        child: Slider(
                          value: currentPage.toDouble().clamp(1.0, totalPages.toDouble()),
                          min: 1,
                          max: totalPages > 1 ? totalPages.toDouble() : 1.1,
                          onChanged: (value) => onPageChanged(value.toInt()),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, color: CosmonetColors.textPrimary),
                      onPressed: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: CosmonetColors.bgSurface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: CosmonetColors.divider, width: 1),
                      ),
                      child: Text(
                        '$currentPage / $totalPages',
                        style: CosmonetTextStyles.codeStyle.copyWith(
                          fontSize: 11,
                          color: CosmonetColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
