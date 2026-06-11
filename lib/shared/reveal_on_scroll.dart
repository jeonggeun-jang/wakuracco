import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// 화면에 처음 보이는 순간 페이드인 + 위로 떠오르는 등장 효과를 주는 래퍼.
/// 한 번 등장한 뒤에는 다시 사라지지 않는다.
class RevealOnScroll extends StatefulWidget {
  const RevealOnScroll({required this.child, super.key});

  final Widget child;

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll> {
  final _detectorKey = UniqueKey();
  bool _revealed = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _detectorKey,
      onVisibilityChanged: (info) {
        if (!_revealed && info.visibleFraction > 0.1) {
          setState(() => _revealed = true);
        }
      },
      child: widget.child
          .animate(target: _revealed ? 1 : 0)
          .fadeIn(duration: 500.ms, curve: Curves.easeOut)
          .moveY(
            begin: 24,
            end: 0,
            duration: 500.ms,
            curve: Curves.easeOutCubic,
          ),
    );
  }
}
