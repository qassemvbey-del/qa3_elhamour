import 'package:flutter/material.dart';
import '../services/citizen_service.dart';
import '../theme/bikini_theme.dart';

/// Nautical Wooden Top Bar with Cartoon Planks, Rivets, and Glowing Jellyfish Notification Bell
class WoodenTopBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onNotificationTap;
  final int unreadCount;

  const WoodenTopBar({
    super.key,
    this.title = 'جمهورية قاع الهامور',
    this.onNotificationTap,
    this.unreadCount = 3,
  });

  @override
  Size get preferredSize => const Size.fromHeight(78.0);

  @override
  State<WoodenTopBar> createState() => _WoodenTopBarState();
}

class _WoodenTopBarState extends State<WoodenTopBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _jellyfishController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _jellyfishController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(
        parent: _jellyfishController,
        curve: Curves.easeInOutSine,
      ),
    );
  }

  @override
  void dispose() {
    _jellyfishController.dispose();
    super.dispose();
  }

  Widget _buildWoodBolt() {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: BikiniColors.goldNail,
        shape: BoxShape.circle,
        border: Border.all(
          color: BikiniColors.cartoonBlack,
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: BikiniColors.cartoonBlack,
            offset: Offset(1, 1),
            blurRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 5,
          height: 1.5,
          color: BikiniColors.cartoonBlack,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(
        top: topPadding + 8,
        left: 14,
        right: 14,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF6F3B1A),
        border: const Border(
          bottom: BorderSide(
            color: BikiniColors.cartoonBlack,
            width: 3.5,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            offset: Offset(0, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFB57038),
              Color(0xFF8B4B22),
              Color(0xFF6E3614),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: BikiniColors.cartoonBlack,
            width: 2.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: BikiniColors.cartoonBlack,
              offset: Offset(2, 2),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Bolt & Decorative Citizen / Pineapple Avatar
            Row(
              children: [
                _buildWoodBolt(),
                const SizedBox(width: 8),
                ValueListenableBuilder<CitizenProfile?>(
                  valueListenable: CitizenService.instance.currentProfile,
                  builder: (context, profile, _) {
                    final emoji = profile?.speciesEmoji ?? '🍍';
                    return Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: BikiniColors.spongeYellow,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: BikiniColors.cartoonBlack,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  },
                ),
              ],
            ),

            // Title in bold cartoon style (GoogleFonts.lalezar())
            Expanded(
              child: Center(
                child: Text(
                  widget.title,
                  style: BikiniTypography.displaySmall(
                    color: BikiniColors.spongeYellow,
                  ).copyWith(
                    fontSize: 21,
                    letterSpacing: 0.5,
                    shadows: const [
                      Shadow(
                        color: BikiniColors.cartoonBlack,
                        offset: Offset(2, 2),
                        blurRadius: 0,
                      ),
                      Shadow(
                        color: BikiniColors.cartoonBlack,
                        offset: Offset(-1, -1),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // Right: Glowing Jellyfish Notification Bell & Right Bolt
            Row(
              children: [
                GestureDetector(
                  onTap: widget.onNotificationTap,
                  child: AnimatedBuilder(
                    animation: _glowAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _glowAnimation.value,
                        child: child,
                      );
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: BikiniColors.neonPink,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: BikiniColors.cartoonBlack,
                              width: 2.2,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: BikiniColors.cartoonBlack,
                                offset: Offset(2, 2),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          child: const Text(
                            '🪼',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        if (widget.unreadCount > 0)
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: BikiniColors.krabsRed,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: BikiniColors.pureWhite,
                                  width: 1.5,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: BikiniColors.cartoonBlack,
                                    offset: Offset(1, 1),
                                    blurRadius: 0,
                                  ),
                                ],
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Center(
                                child: Text(
                                  '${widget.unreadCount}',
                                  style: BikiniTypography.captionBold(
                                    color: BikiniColors.pureWhite,
                                  ).copyWith(
                                    fontSize: 10,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _buildWoodBolt(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
