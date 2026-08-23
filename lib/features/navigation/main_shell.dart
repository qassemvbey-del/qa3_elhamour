import 'package:flutter/material.dart';
import '../../core/theme/bikini_theme.dart';
import '../cafe/fish_cafe_screen.dart';
import '../civil_id/civil_id_screen.dart';
import '../home/home_screen.dart';
import '../news/news_feed_screen.dart';

/// Main navigation shell hosting the floating cartoon bottom navigation dock
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
      backgroundColor: BikiniColors.warmSand,
      body: Stack(
        children: [
          // Current Active Screen
          Positioned.fill(
            child: IndexedStack(
              index: _currentIndex,
              children: screens,
            ),
          ),

          // Floating Cartoon Bottom Navigation Bar Dock
          Positioned(
            left: 12,
            right: 12,
            bottom: MediaQuery.of(context).padding.bottom + 10,
            child: _CartoonBottomDock(
              currentIndex: _currentIndex,
              onTabSelected: _onTabSelected,
            ),
          ),
        ],
      ),
    );
  }
}

class _CartoonBottomDock extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const _CartoonBottomDock({
    required this.currentIndex,
    required this.onTabSelected,
  });

  static const List<_NavTabItem> _tabs = [
    _NavTabItem(
      title: 'الرئيسية',
      emoji: '🍍',
      activeColor: BikiniColors.spongeYellow,
    ),
    _NavTabItem(
      title: 'السجل المدني',
      emoji: '🪪',
      activeColor: BikiniColors.marineCyan,
    ),
    _NavTabItem(
      title: 'جريدة القاع',
      emoji: '📰',
      activeColor: Color(0xFFFFB3C6),
    ),
    _NavTabItem(
      title: 'قهوة العم فيش',
      emoji: '☕',
      activeColor: Color(0xFFD8F3DC),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: BikiniColors.pureWhite,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: BikiniColors.cartoonBlack,
          width: 3.0,
        ),
        boxShadow: const [
          BoxShadow(
            color: BikiniColors.cartoonBlack,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_tabs.length, (index) {
          final tab = _tabs[index];
          final isSelected = index == currentIndex;

          return Flexible(
            child: GestureDetector(
              onTap: () => onTabSelected(index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(
                  horizontal: isSelected ? 8 : 4,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? tab.activeColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  border: isSelected
                      ? Border.all(
                          color: BikiniColors.cartoonBlack,
                          width: 2.0,
                        )
                      : Border.all(
                          color: Colors.transparent,
                          width: 2.0,
                        ),
                  boxShadow: isSelected
                      ? const [
                          BoxShadow(
                            color: BikiniColors.cartoonBlack,
                            offset: Offset(2, 2),
                            blurRadius: 0,
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                      style: BikiniTypography.caption().copyWith(
                        fontSize: isSelected ? 11 : 10,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? BikiniColors.cartoonBlack
                            : const Color(0xFF666666),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavTabItem {
  final String title;
  final String emoji;
  final Color activeColor;

  const _NavTabItem({
    required this.title,
    required this.emoji,
    required this.activeColor,
  });
}
