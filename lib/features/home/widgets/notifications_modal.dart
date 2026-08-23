import 'package:flutter/material.dart';
import '../../../core/theme/bikini_theme.dart';
import '../../../core/widgets/bikini_badge.dart';
import '../../../core/widgets/bikini_button.dart';

/// Satirical Underwater Notifications Modal Sheet
class NotificationsModal extends StatelessWidget {
  const NotificationsModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => const NotificationsModal(),
    );
  }

  static const List<Map<String, String>> notifications = [
    {
      'icon': '🪼',
      'tag': 'تحذير أمني',
      'title': 'موسم لسعات قناديل البحر المائية',
      'body': 'بلدية قاع الهامور تحذر: اللي هينزل حقول القناديل من غير خوذة هيتلسع على مسؤوليته الشخصية ومفيش تعويضات!',
      'time': 'منذ 10 دقائق',
      'color': '0xFFFFB3C6',
    },
    {
      'icon': '🍔',
      'tag': 'عرض سلطع',
      'title': 'خصم خاص بمناسبة عيد ميلاد مستر سلطع',
      'body': 'اشترِ 5 سندوتشات سلطع برجر وادفع تمن 6 سندوتشات عشان مستر سلطع بيحب المكسب!',
      'time': 'منذ ساعة',
      'color': '0xFFFEE12B',
    },
    {
      'icon': '🎺',
      'tag': 'شكوى رسمية',
      'title': 'بلاغ إزعاج ضد سبونج بوب وبسيط',
      'body': 'شفيق حرر محضر بسبب الضحك بصوت عالي أثناء صيد الفقاعات الصابونية أمام منزله!',
      'time': 'منذ 3 ساعات',
      'color': '0xFF00F5D4',
    },
    {
      'icon': '🧆',
      'tag': 'إعلان تجاري',
      'title': 'افتتاح بوفيه شمشون المفتوح',
      'body': 'دلو الصدا يرحب بالمغامرين! وجبة سموم بحرية مجانية مع كل تأمين على الحياة.',
      'time': 'أمس',
      'color': '0xFFE2D4F0',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: BikiniColors.warmSand,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(
            color: BikiniColors.cartoonBlack,
            width: 3.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: BikiniColors.cartoonBlack,
              offset: Offset(0, -6),
              blurRadius: 0,
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle Bar
              const SizedBox(height: 10),
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: BikiniColors.cartoonBlack,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 12),

              // Header Row with Expanded protection
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: BikiniColors.neonPink,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: BikiniColors.cartoonBlack,
                                width: 2.0,
                              ),
                            ),
                            child: const Text('🪼', style: TextStyle(fontSize: 18)),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'تنبيهات ديوان القاع',
                              style: BikiniTypography.displaySmall().copyWith(fontSize: 18),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    BikiniBadge.breaking(text: '3 غير مقروءة'),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              const Divider(color: BikiniColors.cartoonBlack, thickness: 2),

              // Notifications List
              Flexible(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  itemCount: notifications.length,
                  separatorBuilder: (ctx, i) => const SizedBox(height: 10),
                  itemBuilder: (ctx, i) {
                    final item = notifications[i];
                    final colorHex = int.parse(item['color']!);
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(colorHex),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: BikiniColors.cartoonBlack,
                          width: 2.2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: BikiniColors.cartoonBlack,
                            offset: Offset(2.5, 2.5),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: BikiniColors.pureWhite,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: BikiniColors.cartoonBlack,
                                width: 1.8,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                item['icon']!,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: BikiniColors.pureWhite,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: BikiniColors.cartoonBlack,
                                          width: 1.2,
                                        ),
                                      ),
                                      child: Text(
                                        item['tag']!,
                                        style: BikiniTypography.captionBold().copyWith(
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        item['time']!,
                                        style: BikiniTypography.caption(
                                          color: const Color(0xFF555555),
                                        ).copyWith(fontSize: 10.5),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['title']!,
                                  style: BikiniTypography.titleBold().copyWith(
                                    fontSize: 14,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  item['body']!,
                                  style: BikiniTypography.bodyMedium(
                                    color: const Color(0xFF222222),
                                  ).copyWith(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(14),
                child: BikiniButton.primary(
                  onPressed: () => Navigator.of(context).pop(),
                  text: 'قريت كل التنبيهات خلاص 👍',
                  isFullWidth: true,
                  height: 46,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
