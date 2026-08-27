import 'package:flutter/material.dart';
import '../../core/theme/bikini_theme.dart';
import '../../core/widgets/wooden_top_bar.dart';
import 'widgets/breaking_news_ticker.dart';
import 'widgets/hero_bento_card.dart';
import 'widgets/notifications_modal.dart';
import 'widgets/service_grid.dart';

/// Main Home Screen featuring Bento Grid of all Bikini Bottom city services
class HomeScreen extends StatelessWidget {
  final Function(int tabIndex) onNavigateToTab;

  const HomeScreen({
    super.key,
    required this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BikiniColors.paper,
      appBar: WoodenTopBar(
        title: 'جمهورية قاع الهامور',
        unreadCount: 3,
        onNotificationTap: () => NotificationsModal.show(context),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(
            bottom: BikiniRadius.navBarClearance,
            top: BikiniSpacing.space8,
          ),
          children: [
            // Satirical Breaking News Ticker
            const BreakingNewsTicker(),

            // Hero Bento Card (Civil ID CTA / Citizen Profile)
            HeroBentoCard(
              onExtractIdTap: () => onNavigateToTab(1),
            ),

            // Bento Grid of Services (Active & Locked)
            ServiceGrid(
              onNavigateToTab: onNavigateToTab,
            ),
          ],
        ),
      ),
    );
  }
}
