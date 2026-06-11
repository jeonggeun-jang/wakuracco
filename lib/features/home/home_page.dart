import 'dart:async';

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:waku/app/theme.dart';
import 'package:waku/features/home/sections/activities_section.dart';
import 'package:waku/features/home/sections/chat_section.dart';
import 'package:waku/features/home/sections/events_section.dart';
import 'package:waku/features/home/sections/hero_section.dart';
import 'package:waku/features/home/sections/intro_section.dart';
import 'package:waku/features/home/sections/join_section.dart';
import 'package:waku/features/home/sections/picks_section.dart';
import 'package:waku/features/home/sections/site_footer.dart';
import 'package:waku/shared/interaction_gate.dart';
import 'package:waku/shared/reveal_on_scroll.dart';
import 'package:waku/shared/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey _introKey = GlobalKey();
  final GlobalKey _activitiesKey = GlobalKey();
  final GlobalKey _eventsKey = GlobalKey();
  final GlobalKey _picksKey = GlobalKey();
  final GlobalKey _chatKey = GlobalKey();
  final GlobalKey _joinKey = GlobalKey();

  final ScrollController _scrollController = ScrollController();
  int _activeStation = 0;

  /// (역 이름, 노선 색, 섹션 키) — 노선도 내비게이션용
  late final List<(String, Color, GlobalKey)> _stations = [
    ('소개', AppColors.lineGreen, _introKey),
    ('활동', AppColors.sakura, _activitiesKey),
    ('일정', AppColors.lineBlue, _eventsKey),
    ('추천', AppColors.linePurple, _picksKey),
    ('수다', AppColors.lineTeal, _chatKey),
    ('가입', AppColors.lineOrange, _joinKey),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateActiveStation);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_updateActiveStation)
      ..dispose();
    super.dispose();
  }

  void _updateActiveStation() {
    if (!mounted) return;
    final threshold = MediaQuery.sizeOf(context).height * 0.45;
    var active = 0;
    for (var i = 0; i < _stations.length; i++) {
      final ctx = _stations[i].$3.currentContext;
      if (ctx == null) continue;
      final render = ctx.findRenderObject();
      if (render is! RenderBox || !render.attached) continue;
      if (render.localToGlobal(Offset.zero).dy < threshold) active = i;
    }
    if (active != _activeStation) {
      setState(() => _activeStation = active);
    }
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    unawaited(
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = ResponsiveBreakpoints.of(context).largerThan(TABLET);
    // 콘텐츠(1080px) 양옆 여백이 충분할 때만 노선 레일을 띄운다
    final showRail = MediaQuery.sizeOf(context).width >= 1320;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        shadowColor: Colors.black12,
        titleSpacing: 24,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🌸 와쿠와쿠', style: AppTextStyles.display(fontSize: 21)),
            const SizedBox(width: 8),
            const Text(
              'ワクワク線',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.sakura,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        actions: [
          if (wide)
            for (final (label, color, key) in _stations.take(5))
              TextButton(
                onPressed: () => _scrollTo(key),
                style: TextButton.styleFrom(foregroundColor: AppColors.navy),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(label),
                  ],
                ),
              ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: () => _scrollTo(_joinKey),
            style: FilledButton.styleFrom(backgroundColor: AppColors.sakura),
            child: const Text('가입하기'),
          ),
          const SizedBox(width: 24),
        ],
      ),
      // 첫 입력(호버/클릭/스크롤)을 감지해 장식 애니메이션을 깨운다
      body: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => InteractionGate.markInteracted(),
        onPointerHover: (_) => InteractionGate.markInteracted(),
        onPointerSignal: (_) => InteractionGate.markInteracted(),
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  HeroSection(
                    onExplore: () => _scrollTo(_activitiesKey),
                    onJoin: () => _scrollTo(_joinKey),
                  ),
                  Section(
                    key: _introKey,
                    child: const RevealOnScroll(child: IntroSection()),
                  ),
                  Section(
                    key: _activitiesKey,
                    background: Colors.white,
                    child: const RevealOnScroll(child: ActivitiesSection()),
                  ),
                  Section(
                    key: _eventsKey,
                    child: const RevealOnScroll(child: EventsSection()),
                  ),
                  Section(
                    key: _picksKey,
                    background: Colors.white,
                    child: const RevealOnScroll(child: PicksSection()),
                  ),
                  Section(
                    key: _chatKey,
                    child: const ChatSection(),
                  ),
                  Section(
                    key: _joinKey,
                    background: Colors.white,
                    child: const RevealOnScroll(child: JoinSection()),
                  ),
                  const SiteFooter(),
                ],
              ),
            ),
            if (showRail)
              Positioned(
                right: 18,
                top: 0,
                bottom: 0,
                child: Center(
                  child: _StationRail(
                    stations: _stations,
                    active: _activeStation,
                    onTap: _scrollTo,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 우측에 고정된 노선도 내비게이션.
/// 스크롤 위치에 따라 🚃 마커가 현재 역으로 미끄러져 이동한다.
class _StationRail extends StatelessWidget {
  const _StationRail({
    required this.stations,
    required this.active,
    required this.onTap,
  });

  static const double _spacing = 52;

  final List<(String, Color, GlobalKey)> stations;
  final int active;
  final void Function(GlobalKey) onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      height: stations.length * _spacing,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 노선 (세로 선)
          Positioned(
            right: 12,
            top: _spacing / 2,
            bottom: _spacing / 2,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                color: AppColors.navy.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // 역 (라벨 + 점)
          Column(
            children: [
              for (final (i, station) in stations.indexed)
                SizedBox(
                  height: _spacing,
                  child: InkWell(
                    onTap: () => onTap(station.$3),
                    borderRadius: BorderRadius.circular(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 250),
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: i == active
                                ? station.$2
                                : AppColors.navy.withValues(alpha: 0.4),
                          ),
                          child: Text(station.$1),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 28,
                          child: Center(
                            child: Container(
                              width: 11,
                              height: 11,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: station.$2,
                                  width: 2.5,
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
          // 달리는 기차 마커
          AnimatedPositioned(
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOutBack,
            right: 1,
            top: active * _spacing + _spacing / 2 - 13,
            child: IgnorePointer(
              child: Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: stations[active].$2,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: const Text('🚃', style: TextStyle(fontSize: 13)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
