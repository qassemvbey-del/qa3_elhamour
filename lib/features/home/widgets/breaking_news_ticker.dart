import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/bikini_theme.dart';
import '../../../core/widgets/bikini_badge.dart';

/// Animated satirical Egyptian breaking news ticker
class BreakingNewsTicker extends StatefulWidget {
  final List<String>? newsItems;

  const BreakingNewsTicker({
    super.key,
    this.newsItems,
  });

  @override
  State<BreakingNewsTicker> createState() => _BreakingNewsTickerState();
}

class _BreakingNewsTickerState extends State<BreakingNewsTicker> {
  late final List<String> _items;
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _items = widget.newsItems ?? [
      'عاجل: مستر سلطع يقفل البوابات بعد خناقة الفرح وتكسير الكراسي 💥',
      'إشاعة: شمشون اتنكر في شكل طعمية ووقع في طاسة الزيت المغلي 🧆',
      'تحذير: بسيط ضيع مفتاح شقته للمرة المليون ونايم على الرصيف 🔑',
      'بلدية القاع: ممنوع التفحيط بالقوارب المائية بعد الساعة 12 بالليل 🚤',
      'خناقة في حلقة السمك: شفيق اتخانق مع الزبائن عشان طلبوا منه يبتسم 🎺',
      'عاجل: اختفاء وصفة سلطع برجر وظهورها على جروب طبخ في فيسبوك 🍔',
    ];

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _items.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: BikiniRadius.screenMargin,
        vertical: BikiniSpacing.space8,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BikiniDecorations.staticCard(
        backgroundColor: BikiniColors.card,
      ),
      child: Row(
        children: [
          // Flashing Breaking Badge
          BikiniBadge.breaking(text: '⚡ عاجل القاع'),
          const SizedBox(width: BikiniSpacing.space8),

          // Sliding Ticker Content
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                final inOffset = Tween<Offset>(
                  begin: const Offset(0.0, 0.8),
                  end: Offset.zero,
                ).animate(animation);
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: inOffset,
                    child: child,
                  ),
                );
              },
              child: SizedBox(
                key: ValueKey<int>(_currentIndex),
                width: double.infinity,
                child: Text(
                  _items[_currentIndex],
                  style: BikiniTypography.label(
                    color: BikiniColors.deep,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

