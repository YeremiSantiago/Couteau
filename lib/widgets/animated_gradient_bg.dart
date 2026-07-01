import 'package:flutter/material.dart';

class AnimatedGradientBg extends StatefulWidget {
  final List<Color> colors;
  final Widget child;

  const AnimatedGradientBg({super.key, required this.colors, required this.child});

  @override
  State<AnimatedGradientBg> createState() => _AnimatedGradientBgState();
}

class _AnimatedGradientBgState extends State<AnimatedGradientBg>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Alignment> _topAlign;
  late Animation<Alignment> _botAlign;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 6))
      ..repeat(reverse: true);

    _topAlign = TweenSequence<Alignment>([
      TweenSequenceItem(tween: Tween(begin: Alignment.topLeft, end: Alignment.topRight), weight: 1),
      TweenSequenceItem(tween: Tween(begin: Alignment.topRight, end: Alignment.topLeft), weight: 1),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

    _botAlign = TweenSequence<Alignment>([
      TweenSequenceItem(tween: Tween(begin: Alignment.bottomRight, end: Alignment.bottomLeft), weight: 1),
      TweenSequenceItem(tween: Tween(begin: Alignment.bottomLeft, end: Alignment.bottomRight), weight: 1),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: _topAlign.value,
            end: _botAlign.value,
            colors: [
              widget.colors[0].withOpacity(0.15),
              const Color(0xFF060818),
              widget.colors[1].withOpacity(0.12),
            ],
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
