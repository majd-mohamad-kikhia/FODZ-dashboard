import 'dart:math' as math;

import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FavoriteHeartButton extends StatefulWidget {
  const FavoriteHeartButton({
    super.key,
    required this.isFavorite,
    required this.onToggle,
    this.size = 42,
    this.backgroundColor,
    this.borderColor,
  });

  final bool isFavorite;
  final VoidCallback onToggle;
  final double size;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  State<FavoriteHeartButton> createState() => _FavoriteHeartButtonState();
}

class _FavoriteHeartButtonState extends State<FavoriteHeartButton> with TickerProviderStateMixin {
  late bool _isFavorite;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    if (_isFavorite) {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant FavoriteHeartButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFavorite != oldWidget.isFavorite) {
      _syncFavorite(widget.isFavorite, animate: true);
    }
  }

  void _syncFavorite(bool next, {bool animate = false}) {
    if (!mounted) return;
    setState(() => _isFavorite = next);
    if (animate) {
      if (next) {
        _controller.forward(from: 0);
      } else {
        _controller.reverse(from: 1);
      }
    } else {
      _controller.value = next ? 1 : 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double buttonSize = widget.size;
    final Color activeColor = AppColors.primaryRed;
    final Color baseFillColor = widget.backgroundColor ?? Colors.white;
    final Color baseStrokeColor = widget.borderColor ?? activeColor.withOpacity(0.6);

    final Widget heartShape = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double t = _controller.value;
        final double rotation = t * 2 * math.pi;
        final double scale = 0.9 + (t * 0.15);
        final double progress = Curves.easeInOut.transform(t);
        final Color fill = Color.lerp(baseFillColor, activeColor, progress)!;
        final Color stroke = Color.lerp(baseStrokeColor, activeColor, progress * 0.6)!;
        final double innerSize = buttonSize * 0.66;
        final double outerSize = innerSize + buttonSize * 0.16;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(rotation)
            ..scale(scale, scale, 1),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.favorite,
                color: stroke,
                size: outerSize,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: buttonSize * 0.18,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              Icon(
                Icons.favorite,
                color: fill,
                size: innerSize,
              ),
            ],
          ),
        );
      },
    );

    return GestureDetector(
      onTap: () {
        final bool next = !_isFavorite;
        _syncFavorite(next, animate: true);
        widget.onToggle();
      },
      child: SizedBox(
        height: buttonSize,
        width: buttonSize,
        child: heartShape.animate().scale(
              begin: const Offset(1, 1),
              end: const Offset(1.1, 1.1),
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
            ),
      ),
    );
  }
}
