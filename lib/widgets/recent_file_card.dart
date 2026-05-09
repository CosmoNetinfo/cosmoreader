import 'package:flutter/material.dart';
import '../models/recent_file.dart';
import '../theme/cosmonet_colors.dart';
import '../theme/text_styles.dart';

class RecentFileCard extends StatelessWidget {
  final RecentFile file;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const RecentFileCard({
    super.key,
    required this.file,
    required this.onTap,
    required this.onDelete,
  });

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Adesso';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min fa';
    if (diff.inHours < 24) return '${diff.inHours} ore fa';
    return '${diff.inDays} giorni fa';
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(file.path),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: CosmonetColors.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.picture_as_pdf, color: CosmonetColors.error, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        file.name,
                        style: CosmonetTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      _formatTimeAgo(file.lastOpened),
                      style: CosmonetTextStyles.labelSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${file.path} • ${file.fileSize.toStringAsFixed(1)} MB',
                  style: CosmonetTextStyles.labelSmall,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: file.progress,
                          backgroundColor: CosmonetColors.bgSurface,
                          valueColor: const AlwaysStoppedAnimation<Color>(CosmonetColors.accentBlue),
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Pag. ${file.currentPage} / ${file.totalPages}',
                      style: CosmonetTextStyles.codeStyle.copyWith(
                        color: CosmonetColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
