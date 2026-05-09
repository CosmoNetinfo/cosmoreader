import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/cosmonet_colors.dart';
import '../../models/annotation.dart';

class AnnotationToolbar extends StatelessWidget {
  final AnnotationType? activeType;
  final Color activeColor;
  final Function(AnnotationType?) onTypeSelected;
  final Function(Color) onColorSelected;
  final VoidCallback onClose;

  const AnnotationToolbar({
    super.key,
    required this.activeType,
    required this.activeColor,
    required this.onTypeSelected,
    required this.onColorSelected,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: CosmonetColors.bgElevated,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: CosmonetColors.divider, width: 1),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildToolButton(
              icon: Icons.highlight_outlined,
              type: AnnotationType.highlight,
              tooltip: 'Evidenziatore',
            ),
            _buildToolButton(
              icon: Icons.edit_note_outlined,
              type: AnnotationType.note,
              tooltip: 'Nota',
            ),
            _buildToolButton(
              icon: Icons.gesture_outlined,
              type: AnnotationType.drawing,
              tooltip: 'Disegno libero',
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: VerticalDivider(color: CosmonetColors.divider, width: 1, indent: 8, endIndent: 8),
            ),
            _buildColorButton(CosmonetColors.highlightYellow),
            _buildColorButton(CosmonetColors.highlightGreen),
            _buildColorButton(CosmonetColors.highlightCyan),
            _buildColorButton(CosmonetColors.highlightPink),
            const SizedBox(width: 8),
            Container(
              width: 1,
              height: 24,
              color: CosmonetColors.divider,
              margin: const EdgeInsets.symmetric(horizontal: 4),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: CosmonetColors.textSecondary, size: 20),
              onPressed: onClose,
              visualDensity: VisualDensity.compact,
              tooltip: 'Chiudi strumenti',
            ),
          ],
        ),
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack);
  }

  Widget _buildToolButton({
    required IconData icon,
    required AnnotationType type,
    required String tooltip,
  }) {
    final bool isActive = activeType == type;
    return Tooltip(
      message: tooltip,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: IconButton(
          icon: Icon(icon),
          iconSize: 22,
          color: isActive ? CosmonetColors.accentBlue : CosmonetColors.textSecondary,
          onPressed: () => onTypeSelected(isActive ? null : type),
          style: IconButton.styleFrom(
            backgroundColor: isActive ? CosmonetColors.accentBlue.withValues(alpha: 0.1) : Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.all(8),
          ),
        ),
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    final bool isActive = activeColor == color;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Tooltip(
        message: 'Cambia colore',
        child: GestureDetector(
          onTap: () => onColorSelected(color),
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.2),
                width: isActive ? 2.5 : 1,
              ),
              boxShadow: isActive ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 10,
                  spreadRadius: 1,
                )
              ] : null,
            ),
            child: isActive 
              ? const Icon(Icons.check, size: 14, color: Colors.black54) 
              : null,
          ),
        ),
      ),
    );
  }
}
