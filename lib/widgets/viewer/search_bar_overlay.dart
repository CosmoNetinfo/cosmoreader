import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/cosmonet_colors.dart';
import '../../theme/text_styles.dart';

class SearchBarOverlay extends StatefulWidget {
  final Function(String) onSearch;
  final VoidCallback onClose;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final int currentMatch;
  final int totalMatches;

  const SearchBarOverlay({
    super.key,
    required this.onSearch,
    required this.onClose,
    required this.onNext,
    required this.onPrevious,
    this.currentMatch = 0,
    this.totalMatches = 0,
  });

  @override
  State<SearchBarOverlay> createState() => _SearchBarOverlayState();
}

class _SearchBarOverlayState extends State<SearchBarOverlay> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: CosmonetColors.bgElevated,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: CosmonetColors.divider, width: 1),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: CosmonetColors.textSecondary, size: 20),
            onPressed: widget.onClose,
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              style: CosmonetTextStyles.bodyLarge,
              cursorColor: CosmonetColors.accentBlue,
              decoration: InputDecoration(
                hintText: 'Cerca nel documento...',
                hintStyle: CosmonetTextStyles.bodyMedium.copyWith(color: CosmonetColors.textDisabled),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: widget.onSearch,
              onSubmitted: (_) {
                if (widget.totalMatches > 0) {
                  widget.onNext();
                }
              },
            ),
          ),
          if (widget.totalMatches > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: CosmonetColors.accentCyan.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${widget.currentMatch}/${widget.totalMatches}',
                style: CosmonetTextStyles.labelSmall.copyWith(
                  color: CosmonetColors.accentCyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_up, color: CosmonetColors.textSecondary),
            onPressed: widget.totalMatches > 0 ? widget.onPrevious : null,
            visualDensity: VisualDensity.compact,
          ),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down, color: CosmonetColors.textSecondary),
            onPressed: widget.totalMatches > 0 ? widget.onNext : null,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    ).animate().slideY(begin: -0.5, end: 0, duration: 300.ms, curve: Curves.easeOutCubic).fadeIn();
  }
}
