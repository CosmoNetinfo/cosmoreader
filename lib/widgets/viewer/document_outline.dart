import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import '../../theme/cosmonet_colors.dart';
import '../../theme/text_styles.dart';

class DocumentOutline extends StatelessWidget {
  final PdfDocument? document;
  final Function(int) onPageSelected;

  const DocumentOutline({
    super.key,
    required this.document,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (document == null) {
      return const Center(child: CircularProgressIndicator(color: CosmonetColors.accentBlue));
    }

    return FutureBuilder<List<PdfOutlineNode>>(
      future: document!.loadOutline(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: CosmonetColors.accentBlue));
        }
        
        final outline = snapshot.data ?? [];
        
        if (outline.isEmpty) {
          return _buildEmptyState();
        }

        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: outline.map((node) => _buildOutlineNode(context, node)).toList(),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.format_list_bulleted_rounded, 
            size: 64, 
            color: CosmonetColors.textDisabled
          ),
          const SizedBox(height: 16),
          Text(
            'Nessun indice disponibile',
            style: CosmonetTextStyles.bodyMedium.copyWith(color: CosmonetColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildOutlineNode(BuildContext context, PdfOutlineNode node, {int depth = 0}) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: ListTile(
            contentPadding: EdgeInsets.only(left: 16.0 + (16.0 * depth), right: 16),
            dense: true,
            title: Text(
              node.title,
              style: CosmonetTextStyles.bodyLarge.copyWith(
                color: CosmonetColors.textPrimary,
                fontWeight: depth == 0 ? FontWeight.w600 : FontWeight.normal,
                fontSize: depth == 0 ? 15 : 14,
              ),
            ),
            trailing: node.dest != null
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: CosmonetColors.bgSurface,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${node.dest!.pageNumber}',
                      style: CosmonetTextStyles.labelSmall.copyWith(
                        color: CosmonetColors.accentCyan,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : null,
            onTap: () {
              if (node.dest != null) {
                onPageSelected(node.dest!.pageNumber);
                Navigator.pop(context);
              }
            },
          ),
        ),
        if (node.children.isNotEmpty)
          ...node.children.map((child) => _buildOutlineNode(context, child, depth: depth + 1)),
      ],
    );
  }
}
