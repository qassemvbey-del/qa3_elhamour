import 'package:flutter/material.dart';
import '../../../core/services/citizen_service.dart';
import '../../../core/theme/bikini_theme.dart';
import '../../../core/widgets/bikini_badge.dart';
import '../../../core/widgets/bikini_button.dart';

/// Beverage item data model
class BeverageItem {
  final String id;
  final String name;
  final String emoji;
  final int price;
  final String description;
  final Color cardColor;
  final String humorServeText;

  const BeverageItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.price,
    required this.description,
    required this.cardColor,
    required this.humorServeText,
  });
}

/// Uncle Fish Interactive Beverage Menu Sheet
class BeverageMenuSheet extends StatelessWidget {
  const BeverageMenuSheet({super.key});

  static const List<BeverageItem> menuItems = [
    BeverageItem(
      id: 'tea',
      name: 'شاي طحالب مغلية 🫖',
      emoji: '🫖',
      price: 15,
      description: 'شاي كشري في الخمسينة مع طحالب بحرية دافية تعدل الزعانف والمزاج',
      cardColor: Color(0xFFFFE6A7),
      humorServeText: 'العم فيش نزلّك واحد شاي طحالب مغلية يعدل زعانفك! 🫖',
    ),
    BeverageItem(
      id: 'coffee',
      name: 'قهوة زعانف محوجة ☕',
      emoji: '☕',
      price: 25,
      description: 'بن برازيلي مائي محوج مع رشة حبهان وقواقع بحرية مطحونة على الريحة',
      cardColor: Color(0xFFD8F3DC),
      humorServeText: 'واحد قهوة زعانف محوجة في الخمسينة وصحة وعافية يا معلم! ☕',
    ),
    BeverageItem(
      id: 'jelly_juice',
      name: 'عصير قنديل لسّاع 🍹',
      emoji: '🍹',
      price: 30,
      description: 'عصير كهربي منعش بيلسع في اللسان ويديك طاقة تسبح بيها للمحيط الأطلنطي',
      cardColor: Color(0xFFFFCCD5),
      humorServeText: 'عصير قنديل كهربي لسّاع على طربيزتك، ابلع واهرب من الصعقة! ⚡🍹',
    ),
    BeverageItem(
      id: 'coral_shisha',
      name: 'شيشة أعشاب مرجانية 💨',
      emoji: '💨',
      price: 50,
      description: 'حجر تفاحتين طحالب مع معسل قاع البحر الفاخر لزوم القعدة الرايقة',
      cardColor: Color(0xFFE2D4F0),
      humorServeText: 'حجر شيشة أعشاب مرجانية ولع الطربيزة، انزل بالدخان في الأعماق! 💨',
    ),
    BeverageItem(
      id: 'krabs_cola',
      name: 'سلطع كولا مثلج 🥤',
      emoji: '🥤',
      price: 20,
      description: 'مشروب غازي سري مثلج بطعم مقرمشات سلطع وسكر القصب المائي',
      cardColor: Color(0xFFD0E1FD),
      humorServeText: 'سلطع كولا مثلج مشبر ومستر سلطع حسبه عليك بـ 20 صدفة كاش! 🦀🥤',
    ),
  ];

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => const BeverageMenuSheet(),
    );
  }

  void _handleOrder(BuildContext context, BeverageItem item) {
    final success = CitizenService.instance.spendShells(item.price);
    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: BikiniColors.cartoonBlack,
          duration: const Duration(seconds: 3),
          content: Row(
            children: [
              Text(item.emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${item.humorServeText} (-${item.price} 🐚)',
                  style: BikiniTypography.bodyMedium(color: BikiniColors.spongeYellow),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      final current = CitizenService.instance.shellsBalance.value;
      showDialog(
        context: context,
        builder: (ctx) => Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: BikiniColors.pureWhite,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: BikiniColors.cartoonBlack, width: 3.5),
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
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: BikiniColors.krabsRed,
                      shape: BoxShape.circle,
                      border: Border.all(color: BikiniColors.cartoonBlack, width: 2.5),
                    ),
                    child: const Center(child: Text('🦀', style: TextStyle(fontSize: 30))),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'مستر سلطع طردك من القهوة! 💸',
                    style: BikiniTypography.displaySmall(color: BikiniColors.krabsRed).copyWith(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'معكش صدف كفاية تطلب ${item.name}!\nرصيدك الحالي: $current صدفة 🐚 ومطلوب ${item.price} صدفة.',
                    style: BikiniTypography.bodyMedium().copyWith(fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  BikiniButton.primary(
                    onPressed: () {
                      CitizenService.instance.addShells(50);
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: BikiniColors.cartoonBlack,
                          content: Text(
                            'مستر سلطع سلفك 50 صدفة 🐚 بفوائد مائية مركبة 100%! 💰',
                            style: BikiniTypography.bodyMedium(color: BikiniColors.spongeYellow),
                          ),
                        ),
                      );
                    },
                    text: 'استلف 50 صدفة من سلطع 💰',
                    isFullWidth: true,
                    height: 44,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: BikiniColors.warmSand,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: BikiniColors.cartoonBlack, width: 3.5),
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

              // Header & Balance Row
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
                              color: BikiniColors.spongeYellow,
                              shape: BoxShape.circle,
                              border: Border.all(color: BikiniColors.cartoonBlack, width: 2),
                            ),
                            child: const Text('☕', style: TextStyle(fontSize: 18)),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'منيو طلبات العم فيش',
                              style: BikiniTypography.displaySmall().copyWith(fontSize: 18),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ValueListenableBuilder<int>(
                      valueListenable: CitizenService.instance.shellsBalance,
                      builder: (context, balance, _) {
                        return BikiniBadge(
                          text: '$balance صدفة 🐚',
                          backgroundColor: BikiniColors.marineCyan,
                          textColor: BikiniColors.cartoonBlack,
                          fontSize: 11,
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              const Divider(color: BikiniColors.cartoonBlack, thickness: 1.8),

              // Beverages List
              Flexible(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  itemCount: menuItems.length,
                  separatorBuilder: (ctx, i) => const SizedBox(height: 10),
                  itemBuilder: (ctx, i) {
                    final item = menuItems[i];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: item.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: BikiniColors.cartoonBlack, width: 2.5),
                        boxShadow: const [
                          BoxShadow(
                            color: BikiniColors.cartoonBlack,
                            offset: Offset(3, 3),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: BikiniColors.pureWhite,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: BikiniColors.cartoonBlack, width: 2),
                              boxShadow: const [
                                BoxShadow(
                                  color: BikiniColors.cartoonBlack,
                                  offset: Offset(1.5, 1.5),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(item.emoji, style: const TextStyle(fontSize: 22)),
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
                                    Expanded(
                                      child: Text(
                                        item.name,
                                        style: BikiniTypography.titleBold().copyWith(fontSize: 13.5),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: BikiniColors.pureWhite,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: BikiniColors.cartoonBlack, width: 1.2),
                                      ),
                                      child: Text(
                                        '${item.price} صدفة 🐚',
                                        style: BikiniTypography.captionBold(color: BikiniColors.krabsRed)
                                            .copyWith(fontSize: 10.5),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  item.description,
                                  style: BikiniTypography.bodyMedium(color: const Color(0xFF333333))
                                      .copyWith(fontSize: 11.5),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          BikiniButton.primary(
                            onPressed: () => _handleOrder(context, item),
                            text: 'اطلب 🫖',
                            height: 38,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Bottom Close Button & Free Loan CTA
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 6, 14, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: BikiniButton.secondary(
                        onPressed: () {
                          CitizenService.instance.addShells(50);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: BikiniColors.cartoonBlack,
                              content: Text(
                                'تمت إضافة 50 صدفة 🐚 إلى رصيدك المائي!',
                                style: BikiniTypography.bodyMedium(color: BikiniColors.spongeYellow),
                              ),
                            ),
                          );
                        },
                        text: '+ 50 صدفة سلفة 💰',
                        height: 44,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: BikiniButton.primary(
                        onPressed: () => Navigator.of(context).pop(),
                        text: 'إغلاق المنيو 👋',
                        height: 44,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
