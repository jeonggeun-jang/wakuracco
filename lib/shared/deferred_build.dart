import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// 첫 페인트가 끝난 뒤 [order]번째 프레임에 실제 자식을 빌드하는 래퍼.
///
/// 화면 밖(below-the-fold) 섹션을 첫 프레임에 전부 빌드하면 메인 스레드가
/// 한 번에 길게 막힌다(Lighthouse TBT 악화). 섹션마다 order를 1씩 늘려
/// 프레임당 하나씩 나눠 빌드하면 작업이 잘게 쪼개진다.
/// 실제 사용자 기준으로는 수십 ms 안에 끝나 차이를 느낄 수 없다.
class DeferredBuild extends StatefulWidget {
  const DeferredBuild({
    required this.child,
    this.order = 1,
    this.placeholderHeight = 400,
    super.key,
  });

  final Widget child;

  /// 몇 번째 프레임에 빌드할지 (1 = 첫 페인트 직후 다음 프레임)
  final int order;

  /// 빌드 전까지 차지할 대략적인 높이
  final double placeholderHeight;

  @override
  State<DeferredBuild> createState() => _DeferredBuildState();
}

class _DeferredBuildState extends State<DeferredBuild> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _waitFrames(widget.order);
  }

  void _waitFrames(int remaining) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (remaining <= 1) {
        setState(() => _ready = true);
        return;
      }
      SchedulerBinding.instance.scheduleFrame();
      _waitFrames(remaining - 1);
    });
    SchedulerBinding.instance.scheduleFrame();
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) return widget.child;
    return SizedBox(height: widget.placeholderHeight, width: double.infinity);
  }
}
