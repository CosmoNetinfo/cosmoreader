import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import '../../theme/cosmonet_colors.dart';
import '../../theme/text_styles.dart';

class ThumbnailDrawer extends StatelessWidget {
  final String filePath;
  final PdfDocument? document;
  final int currentPage;
  final Function(int) onPageSelected;

  const ThumbnailDrawer({
    super.key,
    required this.filePath,
    this.document,
    required this.currentPage,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: CosmonetColors.bgSecondary,
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: document == null
                ? _buildLoadingState()
                : _buildThumbnailGrid(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      decoration: const BoxDecoration(
        color: CosmonetColors.bgElevated,
        border: Border(bottom: BorderSide(color: CosmonetColors.divider, width: 1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.grid_view_rounded, color: CosmonetColors.accentBlue),
          const SizedBox(width: 12),
          Text('Pagine', style: CosmonetTextStyles.titleMedium),
          const Spacer(),
          Text(
            '${document?.pages.length ?? 0} totali',
            style: CosmonetTextStyles.labelSmall.copyWith(color: CosmonetColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: CosmonetColors.accentBlue),
    );
  }

  Widget _buildThumbnailGrid(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
      ),
      itemCount: document!.pages.length,
      itemBuilder: (context, index) {
        final pageNumber = index + 1;
        final bool isCurrent = pageNumber == currentPage;
        
        return _buildThumbnailItem(context, pageNumber, isCurrent);
      },
    );
  }

  Widget _buildThumbnailItem(BuildContext context, int pageNumber, bool isCurrent) {
    return GestureDetector(
      onTap: () {
        onPageSelected(pageNumber);
        Navigator.pop(context);
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCurrent ? CosmonetColors.accentBlue : CosmonetColors.divider,
                  width: isCurrent ? 2.5 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isCurrent 
                      ? CosmonetColors.accentBlue.withValues(alpha: 0.25)
                      : Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  PdfPageView(
                    document: document!,
                    pageNumber: pageNumber,
                  ),
                  if (isCurrent)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: CosmonetColors.accentBlue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, size: 12, color: Colors.white),
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '$pageNumber',
                          style: const TextStyle(
                            color: Colors.white, 
                            fontSize: 11, 
                            fontWeight: FontWeight.bold,
                            shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
