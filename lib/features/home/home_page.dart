import 'dart:async';

import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:waku/app/theme.dart';
import 'package:waku/features/home/sections/activities_section.dart';
import 'package:waku/features/home/sections/events_section.dart';
import 'package:waku/features/home/sections/hero_section.dart';
import 'package:waku/features/home/sections/intro_section.dart';
import 'package:waku/features/home/sections/join_section.dart';
import 'package:waku/features/home/sections/picks_section.dart';
import 'package:waku/features/home/sections/site_footer.dart';
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
  final GlobalKey _joinKey = GlobalKey();

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
    final navItems = <(String, GlobalKey)>[
      ('소개', _introKey),
      ('활동', _activitiesKey),
      ('모임 일정', _eventsKey),
      ('이달의 추천', _picksKey),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        shadowColor: Colors.black12,
        titleSpacing: 24,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🌸 와쿠와쿠',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.navy,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'ワクワク',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.sakura,
              ),
            ),
          ],
        ),
        actions: [
          if (wide)
            for (final (label, key) in navItems)
              TextButton(
                onPressed: () => _scrollTo(key),
                style: TextButton.styleFrom(foregroundColor: AppColors.navy),
                child: Text(label),
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
      body: SingleChildScrollView(
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
              key: _joinKey,
              child: const RevealOnScroll(child: JoinSection()),
            ),
            const SiteFooter(),
          ],
        ),
      ),
    );
  }
}
