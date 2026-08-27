import 'package:flutter/material.dart';
import '../../../core/theme/bikini_theme.dart';
import '../../../core/widgets/bikini_button.dart';
import 'service_card.dart';

/// Responsive Bento Service Grid containing active and locked Bikini Bottom municipal services
class ServiceGrid extends StatelessWidget {
  final Function(int tabIndex) onNavigateToTab;

  const ServiceGrid({
    super.key,
    required this.onNavigateToTab,
  });

  static const List<BikiniServiceItem> defaultServices = [
    BikiniServiceItem(
      id: 'restaurants',
      title: 'مطاعم القاع 🍔',
      subtitle: 'اطلب برجر سلطع الطازج ومقرمشات شمشون المشبوهة دليفري للأعماق',
      emoji: '🍔',
      backgroundColor: BikiniColors.card,
      isLocked: false,
      targetTabIndex: 0,
    ),
    BikiniServiceItem(
      id: 'civil_registry',
      title: 'السجل المدني 🏛️',
      subtitle: 'إصدار بطاقة الرقم القومي المائي وتحديد شجرة عائلة قاع الهامور',
      emoji: '🏛️',
      backgroundColor: BikiniColors.card,
      isLocked: false,
      targetTabIndex: 1,
    ),
    BikiniServiceItem(
      id: 'newspaper',
      title: 'جريدة القاع 📰',
      subtitle: 'فيديوهات وفضائح وحكايات قاع الهامور الحصرية لحظة بلحظة',
      emoji: '📰',
      backgroundColor: BikiniColors.card,
      isLocked: false,
      targetTabIndex: 2,
    ),
    BikiniServiceItem(
      id: 'fish_cafe',
      title: 'قهوة العم فيش ☕',
      subtitle: 'شات حي وساوند بورد أصوات سبونج بوب ونكت مع المعلمين',
      emoji: '☕',
      backgroundColor: BikiniColors.card,
      isLocked: false,
      targetTabIndex: 3,
    ),
    BikiniServiceItem(
      id: 'hospitals',
      title: 'مستشفيات القاع 🏥',
      subtitle: 'طوارئ لسعات قنديل البحر وعلاج التسمم من وجبات دلو الصدا',
      emoji: '🏥',
      backgroundColor: BikiniColors.card,
      isLocked: true,
      lockReason: 'المستشفى مقفولة عشان الدكاترة عندهم إضراب ومستر سلطع رافض يدفع التأمين!',
    ),
    BikiniServiceItem(
      id: 'festivals',
      title: 'حفلات الأعماق 🎤',
      subtitle: 'حفلات مستر سلطع مع أوكا وأورتيجا وعزف كلارينيت شفيق المزعج',
      emoji: '🎤',
      backgroundColor: BikiniColors.card,
      isLocked: true,
      lockReason: 'الحفلة اتلغت عشان شفيق كسر الكلارينيت في دماغ واحد من المعازيم!',
    ),
    BikiniServiceItem(
      id: 'court',
      title: 'محكمة الجنايات ⚖️',
      subtitle: 'جلسات محاكمة شمشون بتهمة سرقة سر الخلطة وقضايا التفحيط المائي',
      emoji: '⚖️',
      backgroundColor: BikiniColors.card,
      isLocked: true,
      lockReason: 'القاضي راح يصطاد قناديل بحر والجلسة اتأجلت لسبتمبر الجاي!',
    ),
    BikiniServiceItem(
      id: 'real_estate',
      title: 'عقارات القاع 🪸',
      subtitle: 'أناناسات وبيوت صخرية للإيجار المفروش والتمويل العقاري البحري',
      emoji: '🪸',
      backgroundColor: BikiniColors.card,
      isLocked: true,
      lockReason: 'كل الأناناسات محجوزة لسبونج بوب وبسيط رهن صخرته للبنك!',
    ),
  ];

  void _handleServiceTap(BuildContext context, BikiniServiceItem item) {
    if (item.isLocked) {
      _showLockedDialog(context, item);
    } else {
      if (item.targetTabIndex != null && item.targetTabIndex! > 0) {
        onNavigateToTab(item.targetTabIndex!);
      } else {
        _showActiveServiceModal(context, item);
      }
    }
  }

  void _showLockedDialog(BuildContext context, BikiniServiceItem item) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: BikiniRadius.screenMargin),
          child: Container(
            padding: const EdgeInsets.all(BikiniSpacing.space24),
            decoration: BikiniDecorations.interactiveCard(
              backgroundColor: BikiniColors.card,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cartoon lock icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: BikiniColors.paper,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: BikiniColors.ink,
                      width: BikiniRadius.borderWidth,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      item.emoji,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                const SizedBox(height: BikiniSpacing.space12),

                Text(
                  'يا ريس الخدمة دي مقفولة حالياً! 🔒',
                  style: BikiniTypography.h2(
                    color: BikiniColors.alert,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: BikiniSpacing.space8),

                Text(
                  item.lockReason ??
                      'عمال بلدية قاع الهامور شغالين صيانة وغواصين المقاولين سارقين السلوك! ارجع بعد شوية يا غالي.',
                  style: BikiniTypography.body(
                    color: BikiniColors.muted,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: BikiniSpacing.space16),

                BikiniButton.secondary(
                  onPressed: () => Navigator.of(ctx).pop(),
                  text: 'فهمت يا ريس، رجوع 👋',
                  isFullWidth: true,
                  height: 48,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showActiveServiceModal(BuildContext context, BikiniServiceItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.all(BikiniSpacing.space24),
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
                Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: BikiniColors.ink,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: BikiniSpacing.space16),
                Text(
                  item.title,
                  style: BikiniTypography.h1(color: BikiniColors.deep),
                ),
                const SizedBox(height: BikiniSpacing.space8),
                Text(
                  'قريباً هتقدر تطلب أوردرات دليفري من مقرمشات سلطع وتدفع بعملة "دولار قاع الهامور" المائي! 🦀🍔',
                  style: BikiniTypography.body(color: BikiniColors.muted),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: BikiniSpacing.space24),
                BikiniButton.secondary(
                  onPressed: () => Navigator.of(ctx).pop(),
                  text: 'تسلم يا كابتن ✨',
                  isFullWidth: true,
                  height: 48,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 900
        ? 4
        : screenWidth > 600
            ? 3
            : 2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Text('🌊', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'خدمات ديوان قاع الهامور',
                          style: BikiniTypography.h2(
                            color: BikiniColors.deep,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: BikiniSpacing.space8),
                Text(
                  '${defaultServices.length} خدمات',
                  style: BikiniTypography.caption(
                    color: BikiniColors.muted,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // Bento Grid of Services
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: defaultServices.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: screenWidth > 600 ? 1.25 : 0.98,
            ),
            itemBuilder: (context, index) {
              final service = defaultServices[index];
              return ServiceCard(
                item: service,
                onTap: (item) => _handleServiceTap(context, item),
              );
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
