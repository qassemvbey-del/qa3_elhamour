import 'package:flutter/material.dart';
import '../services/citizen_service.dart';
import '../theme/bikini_theme.dart';

/// Nautical Top Bar for "جمهورية قاع الهامور" using deep, deep2, and ink tokens
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

    _glowAnimation = Tween<double>(begin: 0.88, end: 1.12).animate(
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
        color: BikiniColors.coin,
        shape: BoxShape.circle,
        border: Border.all(
          color: BikiniColors.ink,
          width: 1.5,
        ),
      ),
      child: Center(
        child: Container(
          width: 5,
          height: 1.5,
          color: BikiniColors.ink,
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
      decoration: const BoxDecoration(
        color: BikiniColors.deep,
        border: Border(
          bottom: BorderSide(
            color: BikiniColors.ink,
            width: BikiniRadius.borderWidth,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: BikiniColors.deep2,
          borderRadius: BorderRadius.circular(BikiniRadius.card),
          border: Border.all(
            color: BikiniColors.ink,
            width: BikiniRadius.borderWidth,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Bolt & Citizen Avatar
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
                        color: BikiniColors.support,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: BikiniColors.ink,
                          width: BikiniRadius.borderWidth,
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
                  style: BikiniTypography.display(
                    color: BikiniColors.card,
                  ).copyWith(
                    fontSize: 20,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // Right: Notification Bell & Right Bolt
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
                            color: BikiniColors.support,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: BikiniColors.ink,
                              width: BikiniRadius.borderWidth,
                            ),
                          ),
                          child: const Text(
                            '🔔',
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
                                color: BikiniColors.alert,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: BikiniColors.card,
                                  width: 1.5,
                                ),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Center(
                                child: Text(
                                  '${widget.unreadCount}',
                                  style: BikiniTypography.caption(
                                    color: BikiniColors.card,
                                  ).copyWith(
                                    fontSize: 11.5,
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

