import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/cosmonet_colors.dart';
import '../../theme/text_styles.dart';

class ViewerToolbar extends StatelessWidget {
  final String fileName;
  final VoidCallback onBack;
  final VoidCallback onSearch;
  final VoidCallback onBookmark;
  final VoidCallback onAnnotations;
  final VoidCallback onOutline;
  final VoidCallback onInfo;

  const ViewerToolbar({
    super.key,
    required this.fileName,
    required this.onBack,
    required this.onSearch,
    required this.onBookmark,
    required this.onAnnotations,
    required this.onOutline,
    required this.onInfo,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: BoxDecoration(
            color: CosmonetColors.bgElevated.withValues(alpha: 0.85),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: const Border(bottom: BorderSide(color: CosmonetColors.divider, width: 0.5)),
          ),
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              height: 56,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: CosmonetColors.textPrimary),
                    onPressed: onBack,
                    tooltip: 'Indietro',
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fileName,
                          style: CosmonetTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: CosmonetColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search_rounded, color: CosmonetColors.textSecondary),
                    onPressed: onSearch,
                    tooltip: 'Cerca',
                  ),
                  IconButton(
                    icon: const Icon(Icons.bookmark_add_outlined, color: CosmonetColors.textSecondary),
                    onPressed: onBookmark,
                    tooltip: 'Aggiungi segnalibro',
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_note_rounded, color: CosmonetColors.textSecondary),
                    onPressed: onAnnotations,
                    tooltip: 'Annotazioni',
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: CosmonetColors.textSecondary),
                    color: CosmonetColors.bgElevated,
                    onSelected: (value) {
                      if (value == 'outline') onOutline();
                      if (value == 'info') onInfo();
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'outline',
                        child: Row(
                          children: [
                            Icon(Icons.list_rounded, color: CosmonetColors.textSecondary, size: 20),
                            SizedBox(width: 12),
                            Text('Indice', style: TextStyle(color: CosmonetColors.textPrimary)),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'info',
                        child: Row(
                          children: [
                            Icon(Icons.info_outline_rounded, color: CosmonetColors.textSecondary, size: 20),
                            SizedBox(width: 12),
                            Text('Informazioni', style: TextStyle(color: CosmonetColors.textPrimary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
