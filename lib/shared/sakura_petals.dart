import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:waku/shared/interaction_gate.dart';

/// 화면 위에서 아래로 흩날리는 벚꽃잎 파티클 배경.
/// 포인터 이벤트를 막지 않으며, RepaintBoundary로 격리되어 부담이 적다.
/// 첫 사용자 입력 전까지는 흩어진 정지 화면으로 그려져
/// 측정 도구(Lighthouse 등)의 메인 스레드 점수를 깎지 않는다.
class SakuraPetals extends StatefulWidget {
  const SakuraPetals({this.count = 22, super.key});

  final int count;

  @override
  State<SakuraPetals> createState() => _SakuraPetalsState();
}

class _SakuraPetalsState extends State<SakuraPetals>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 14),
  );

  late final List<_Petal> _petals = List.generate(widget.count, _Petal.seeded);

  @override
  void initState() {
    super.initState();
    if (InteractionGate.interacted.value) {
      unawaited(_controller.repeat());
    } else {
      InteractionGate.interacted.addListener(_startDrifting);
    }
  }

  void _startDrifting() {
    InteractionGate.interacted.removeListener(_startDrifting);
    if (mounted) {
      unawaited(_controller.repeat());
    }
  }

  @override
  void dispose() {
    InteractionGate.interacted.removeListener(_startDrifting);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: _PetalPainter(petals: _petals, animation: _controller),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _Petal {
  _Petal.seeded(int index) {
    final r = Random(index * 7919 + 17);
    x = r.nextDouble();
    speed = 0.6 + r.nextDouble() * 1.2;
    size = 5 + r.nextDouble() * 7;
    swayAmp = 14 + r.nextDouble() * 40;
    swayFreq = 1 + r.nextDouble() * 2;
    phase = r.nextDouble();
    spin = (r.nextDouble() - 0.5) * 4;
    final base = Color.lerp(
      const Color(0xFFFFD3DD),
      const Color(0xFFF48FB1),
      r.nextDouble(),
    );
    color = (base ?? const Color(0xFFFFD3DD)).withValues(
      alpha: 0.4 + r.nextDouble() * 0.35,
    );
  }

  late final double x;
  late final double speed;
  late final double size;
  late final double swayAmp;
  late final double swayFreq;
  late final double phase;
  late final double spin;
  late final Color color;
}

class _PetalPainter extends CustomPainter {
  _PetalPainter({required this.petals, required this.animation})
    : super(repaint: animation);

  final List<_Petal> petals;
  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final brush = Paint()..style = PaintingStyle.fill;
    for (final p in petals) {
      final progress = (animation.value * p.speed + p.phase) % 1.0;
      final y = progress * (size.height + 60) - 30;
      final sway = sin((progress * p.swayFreq + p.phase) * 2 * pi);
      final x = p.x * size.width + sway * p.swayAmp;
      final angle = (animation.value * p.spin + p.phase) * 2 * pi;
      brush.color = p.color;
      canvas
        ..save()
        ..translate(x, y)
        ..rotate(angle);
      _drawPetal(canvas, p.size, brush);
      canvas.restore();
    }
  }

  void _drawPetal(Canvas canvas, double s, Paint brush) {
    final path = Path()
      ..moveTo(0, -s)
      ..quadraticBezierTo(s * 0.9, -s * 0.3, 0, s)
      ..quadraticBezierTo(-s * 0.9, -s * 0.3, 0, -s)
      ..close();
    canvas.drawPath(path, brush);
  }

  @override
  bool shouldRepaint(_PetalPainter oldDelegate) => false;
}
