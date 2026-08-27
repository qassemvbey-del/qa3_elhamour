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
      'isAlert': 'true',
    },
    {
      'icon': '🍔',
      'tag': 'عرض سلطع',
      'title': 'خصم خاص بمناسبة عيد ميلاد مستر سلطع',
      'body': 'اشترِ 5 سندوتشات سلطع برجر وادفع تمن 6 سندوتشات عشان مستر سلطع بيحب المكسب!',
      'time': 'منذ ساعة',
      'isAlert': 'false',
    },
    {
      'icon': '🎺',
      'tag': 'شكوى رسمية',
      'title': 'بلاغ إزعاج ضد سبونج بوب وبسيط',
      'body': 'شفيق حرر محضر بسبب الضحك بصوت عالي أثناء صيد الفقاعات الصابونية أمام منزله!',
      'time': 'منذ 3 ساعات',
      'isAlert': 'false',
    },
    {
      'icon': '🧆',
      'tag': 'إعلان تجاري',
      'title': 'افتتاح بوفيه شمشون المفتوح',
      'body': 'دلو الصدا يرحب بالمغامرين! وجبة سموم بحرية مجانية مع كل تأمين على الحياة.',
      'time': 'أمس',
      'isAlert': 'false',
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
          color: BikiniColors.paper,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(BikiniRadius.sheet)),
          border: Border.all(
            color: BikiniColors.ink,
            width: BikiniRadius.borderWidth,
          ),
          boxShadow: const [
            BoxShadow(
              color: BikiniColors.ink,
              offset: Offset(0, -4),
              blurRadius: 0,
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle Bar
              const SizedBox(height: BikiniSpacing.space12),
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: BikiniColors.ink,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: BikiniSpacing.space12),

              // Header Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: BikiniRadius.screenMargin),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: BikiniColors.support,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: BikiniColors.ink,
                                width: BikiniRadius.borderWidth,
                              ),
                            ),
                            child: const Text('🔔', style: TextStyle(fontSize: 18)),
                          ),
                          const SizedBox(width: BikiniSpacing.space8),
                          Flexible(
                            child: Text(
                              'تنبيهات ديوان القاع',
                              style: BikiniTypography.h2(color: BikiniColors.deep),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: BikiniSpacing.space8),
                    const BikiniBadge(
                      text: '3 غير مقروءة',
                      backgroundColor: BikiniColors.alert,
                      textColor: BikiniColors.card,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: BikiniSpacing.space12),
              const Divider(color: BikiniColors.line, thickness: 1.5),

              // Notifications List
              Flexible(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: BikiniRadius.screenMargin,
                    vertical: BikiniSpacing.space8,
                  ),
                  itemCount: notifications.length,
                  separatorBuilder: (ctx, i) => const SizedBox(height: BikiniSpacing.space8),
                  itemBuilder: (ctx, i) {
                    final item = notifications[i];
                    final isAlert = item['isAlert'] == 'true';
                    return Container(
                      padding: const EdgeInsets.all(BikiniSpacing.space12),
                      decoration: BikiniDecorations.staticCard(
                        backgroundColor: BikiniColors.card,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: BikiniColors.paper,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: BikiniColors.ink,
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                item['icon']!,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          const SizedBox(width: BikiniSpacing.space12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    BikiniBadge(
                                      text: item['tag']!,
                                      backgroundColor: isAlert ? BikiniColors.alert : BikiniColors.support,
                                      textColor: isAlert ? BikiniColors.card : BikiniColors.ink,
                                      fontSize: 11.5,
                                    ),
                                    const SizedBox(width: BikiniSpacing.space8),
                                    Flexible(
                                      child: Text(
                                        item['time']!,
                                        style: BikiniTypography.caption(
                                          color: BikiniColors.muted,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: BikiniSpacing.space4),
                                Text(
                                  item['title']!,
                                  style: BikiniTypography.h3(color: BikiniColors.deep),
                                ),
                                const SizedBox(height: BikiniSpacing.space4),
                                Text(
                                  item['body']!,
                                  style: BikiniTypography.caption(
                                    color: BikiniColors.ink,
                                  ),
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
                padding: const EdgeInsets.all(BikiniSpacing.space16),
                child: BikiniButton.primary(
                  onPressed: () => Navigator.of(context).pop(),
                  text: 'قريت كل التنبيهات خلاص 👍',
                  isFullWidth: true,
                  height: 48,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

