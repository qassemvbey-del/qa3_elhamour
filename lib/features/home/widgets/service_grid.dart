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
      backgroundColor: Color(0xFFFFE6A7),
      isLocked: false,
      targetTabIndex: 0,
    ),
    BikiniServiceItem(
      id: 'civil_registry',
      title: 'السجل المدني 🏛️',
      subtitle: 'إصدار بطاقة الرقم القومي المائي وتحديد شجرة عائلة قاع الهامور',
      emoji: '🏛️',
      backgroundColor: BikiniColors.marineCyan,
      isLocked: false,
      targetTabIndex: 1,
    ),
    BikiniServiceItem(
      id: 'newspaper',
      title: 'جريدة القاع 📰',
      subtitle: 'فيديوهات وفضائح وحكايات قاع الهامور الحصرية لحظة بلحظة',
      emoji: '📰',
      backgroundColor: Color(0xFFFFB3C6),
      isLocked: false,
      targetTabIndex: 2,
    ),
    BikiniServiceItem(
      id: 'fish_cafe',
      title: 'قهوة العم فيش ☕',
      subtitle: 'شات حي وساوند بورد أصوات سبونج بوب ونكت مع المعلمين',
      emoji: '☕',
      backgroundColor: Color(0xFFD8F3DC),
      isLocked: false,
      targetTabIndex: 3,
    ),
    BikiniServiceItem(
      id: 'hospitals',
      title: 'مستشفيات القاع 🏥',
      subtitle: 'طوارئ لسعات قنديل البحر وعلاج التسمم من وجبات دلو الصدا',
      emoji: '🏥',
      backgroundColor: Color(0xFFFFCCD5),
      isLocked: true,
      lockReason: 'المستشفى مقفولة عشان الدكاترة عندهم إضراب ومستر سلطع رافض يدفع التأمين!',
    ),
    BikiniServiceItem(
      id: 'festivals',
      title: 'حفلات الأعماق 🎤',
      subtitle: 'حفلات مستر سلطع مع أوكا وأورتيجا وعزف كلارينيت شفيق المزعج',
      emoji: '🎤',
      backgroundColor: Color(0xFFE2D4F0),
      isLocked: true,
      lockReason: 'الحفلة اتلغت عشان شفيق كسر الكلارينيت في دماغ واحد من المعازيم!',
    ),
    BikiniServiceItem(
      id: 'court',
      title: 'محكمة الجنايات ⚖️',
      subtitle: 'جلسات محاكمة شمشون بتهمة سرقة سر الخلطة وقضايا التفحيط المائي',
      emoji: '⚖️',
      backgroundColor: Color(0xFFD0E1FD),
      isLocked: true,
      lockReason: 'القاضي راح يصطاد قناديل بحر والجلسة اتأجلت لسبتمبر الجاي!',
    ),
    BikiniServiceItem(
      id: 'real_estate',
      title: 'عقارات القاع 🪸',
      subtitle: 'أناناسات وبيوت صخرية للإيجار المفروش والتمويل العقاري البحري',
      emoji: '🪸',
      backgroundColor: Color(0xFFFFF1C5),
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
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: BikiniColors.pureWhite,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: BikiniColors.cartoonBlack,
                width: 3.5,
              ),
              boxShadow: const [
                BoxShadow(
                  color: BikiniColors.cartoonBlack,
                  offset: Offset(5, 5),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Cartoon lock icon
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: BikiniColors.spongeYellow,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: BikiniColors.cartoonBlack,
                      width: 2.8,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: BikiniColors.cartoonBlack,
                        offset: Offset(2.5, 2.5),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      item.emoji,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  'يا ريس الخدمة دي مقفولة حالياً! 🔒',
                  style: BikiniTypography.displaySmall(
                    color: BikiniColors.krabsRed,
                  ).copyWith(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                Text(
                  item.lockReason ??
                      'عمال بلدية قاع الهامور شغالين صيانة وغواصين المقاولين سارقين السلوك! ارجع بعد شوية يا غالي.',
                  style: BikiniTypography.bodyMedium(
                    color: BikiniColors.cartoonBlack,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),

                BikiniButton.primary(
                  onPressed: () => Navigator.of(ctx).pop(),
                  text: 'فهمت يا ريس، رجوع 👋',
                  isFullWidth: true,
                  height: 46,
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
          padding: const EdgeInsets.all(20),
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
                Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: BikiniColors.cartoonBlack,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  item.title,
                  style: BikiniTypography.displayMedium().copyWith(fontSize: 22),
                ),
                const SizedBox(height: 8),
                Text(
                  'قريباً هتقدر تطلب أوردرات دليفري من مقرمشات سلطع وتدفع بعملة "دولار قاع الهامور" المائي! 🦀🍔',
                  style: BikiniTypography.bodyMedium(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                BikiniButton.secondary(
                  onPressed: () => Navigator.of(ctx).pop(),
                  text: 'تسلم يا كابتن ✨',
                  isFullWidth: true,
                  height: 46,
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
                          style: BikiniTypography.displaySmall(
                            color: BikiniColors.deepNavy,
                          ).copyWith(fontSize: 18),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${defaultServices.length} خدمات',
                  style: BikiniTypography.caption(
                    color: const Color(0xFF666666),
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
