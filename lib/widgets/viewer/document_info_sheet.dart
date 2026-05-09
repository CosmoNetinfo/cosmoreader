import 'package:flutter/material.dart';
import '../../theme/cosmonet_colors.dart';
import '../../theme/text_styles.dart';
import 'package:pdfrx/pdfrx.dart';

class DocumentInfoSheet extends StatelessWidget {
  final PdfDocument document;
  final String filePath;
  final String fileSize;

  const DocumentInfoSheet({
    super.key,
    required this.document,
    required this.filePath,
    required this.fileSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: const BoxDecoration(
        color: CosmonetColors.bgSecondary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: CosmonetColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              const Icon(Icons.info_outline_rounded, color: CosmonetColors.accentBlue),
              const SizedBox(width: 12),
              Text('Informazioni Documento', style: CosmonetTextStyles.titleMedium),
            ],
          ),
          const SizedBox(height: 24),
          _buildInfoRow('Nome File', filePath.split(RegExp(r'[/\\]')).last),
          _buildInfoRow('Percorso', filePath),
          Row(
            children: [
              Expanded(child: _buildInfoRow('Pagine', '${document.pages.length}')),
              Expanded(child: _buildInfoRow('Dimensione', fileSize)),
            ],
          ),
          const Divider(color: CosmonetColors.divider, height: 32),
          const SizedBox(height: 8),
          _buildSecurityInfo(),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: CosmonetTextStyles.labelSmall.copyWith(
              color: CosmonetColors.textSecondary,
              letterSpacing: 1.2,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: CosmonetTextStyles.bodyMedium.copyWith(
              color: CosmonetColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CosmonetColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CosmonetColors.divider, width: 1),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_outline_rounded, color: CosmonetColors.success, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy & Sicurezza',
                  style: CosmonetTextStyles.bodyMedium.copyWith(
                    color: CosmonetColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Questo documento è letto localmente e non viene mai inviato a server esterni.',
                  style: CosmonetTextStyles.labelSmall.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
