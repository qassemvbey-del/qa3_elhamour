import 'package:flutter/material.dart';
import '../../core/theme/bikini_theme.dart';
import '../cafe/fish_cafe_screen.dart';
import '../civil_id/civil_id_screen.dart';
import '../home/home_screen.dart';
import '../news/news_feed_screen.dart';

/// Main navigation shell hosting the full-width bottom navigation bar
/// Strictly conforming to 02-ui-system.md
class MainShell extends StatefulWidget {
  final int initialIndex;

  const MainShell({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabSelected(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(onNavigateToTab: _onTabSelected),
      const CivilIdScreen(),
      const NewsFeedScreen(),
      const FishCafeScreen(),
    ];

    return Scaffold(
      backgroundColor: BikiniColors.paper,
      body: Stack(
        children: [
          // Active Screen with clearance for bottom navbar
          Positioned.fill(
            child: IndexedStack(
              index: _currentIndex,
              children: screens,
            ),
          ),

          // Bottom Attached Full-Width Navbar as mandated by 02-ui-system.md
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BottomNavBar(
              currentIndex: _currentIndex,
              onTabSelected: _onTabSelected,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const _BottomNavBar({
    required this.currentIndex,
    required this.onTabSelected,
  });

  static const List<_NavTabItem> _tabs = [
    _NavTabItem(
      title: 'الرئيسية',
      emoji: '🍍',
    ),
    _NavTabItem(
      title: 'السجل المدني',
      emoji: '🪪',
    ),
    _NavTabItem(
      title: 'جريدة القاع',
      emoji: '📰',
    ),
    _NavTabItem(
      title: 'قهوة العم فيش',
      emoji: '☕',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: BikiniColors.deep,
        border: Border(
          top: BorderSide(
            color: BikiniColors.ink,
            width: BikiniRadius.borderWidth,
          ),
        ),
      ),
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: SizedBox(
        height: 64,
        child: Row(
          children: List.generate(_tabs.length, (index) {
            final tab = _tabs[index];
            final isSelected = index == currentIndex;

            return Expanded(
              child: GestureDetector(
                onTap: () => onTabSelected(index),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  children: [
                    // Active top indicator (yellow line on top of active item)
                    Container(
                      height: 3.5,
                      width: double.infinity,
                      color: isSelected ? BikiniColors.action : Colors.transparent,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tab.emoji,
                            style: TextStyle(
                              fontSize: isSelected ? 20 : 18,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tab.title,
                            style: BikiniTypography.caption(
                              color: isSelected
                                  ? BikiniColors.card
                                  : BikiniColors.muted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavTabItem {
  final String title;
  final String emoji;

  const _NavTabItem({
    required this.title,
    required this.emoji,
  });
}
