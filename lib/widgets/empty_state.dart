import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/cosmonet_colors.dart';
import '../theme/text_styles.dart';

class EmptyState extends StatelessWidget {
  final VoidCallback onOpenPressed;

  const EmptyState({super.key, required this.onOpenPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.picture_as_pdf_outlined,
            size: 80,
            color: CosmonetColors.textDisabled,
          ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.8, 0.8)),
          const SizedBox(height: 24),
          Text(
            'Nessun file recente',
            style: CosmonetTextStyles.titleMedium.copyWith(
              color: CosmonetColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Apri il tuo primo PDF per iniziare',
            style: CosmonetTextStyles.bodyMedium,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: onOpenPressed,
            icon: const Icon(Icons.file_open),
            label: const Text('Apri PDF'),
            style: ElevatedButton.styleFrom(
              backgroundColor: CosmonetColors.accentBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
