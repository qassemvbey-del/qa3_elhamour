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
    this.cardColor = BikiniColors.card,
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
      cardColor: BikiniColors.card,
      humorServeText: 'العم فيش نزلّك واحد شاي طحالب مغلية يعدل زعانفك! 🫖',
    ),
    BeverageItem(
      id: 'coffee',
      name: 'قهوة زعانف محوجة ☕',
      emoji: '☕',
      price: 25,
      description: 'بن برازيلي مائي محوج مع رشة حبهان وقواقع بحرية مطحونة على الريحة',
      cardColor: BikiniColors.card,
      humorServeText: 'واحد قهوة زعانف محوجة في الخمسينة وصحة وعافية يا معلم! ☕',
    ),
    BeverageItem(
      id: 'jelly_juice',
      name: 'عصير قنديل لسّاع 🍹',
      emoji: '🍹',
      price: 30,
      description: 'عصير كهربي منعش بيلسع في اللسان ويديك طاقة تسبح بيها للمحيط الأطلنطي',
      cardColor: BikiniColors.card,
      humorServeText: 'عصير قنديل كهربي لسّاع على طربيزتك، ابلع واهرب من الصعقة! ⚡🍹',
    ),
    BeverageItem(
      id: 'coral_shisha',
      name: 'شيشة أعشاب مرجانية 💨',
      emoji: '💨',
      price: 50,
      description: 'حجر تفاحتين طحالب مع معسل قاع البحر الفاخر لزوم القعدة الرايقة',
      cardColor: BikiniColors.card,
      humorServeText: 'حجر شيشة أعشاب مرجانية ولع الطربيزة، انزل بالدخان في الأعماق! 💨',
    ),
    BeverageItem(
      id: 'krabs_cola',
      name: 'سلطع كولا مثلج 🥤',
      emoji: '🥤',
      price: 20,
      description: 'مشروب غازي سري مثلج بطعم مقرمشات سلطع وسكر القصب المائي',
      cardColor: BikiniColors.card,
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
          backgroundColor: BikiniColors.deep,
          duration: const Duration(seconds: 3),
          content: Row(
            children: [
              Text(item.emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: BikiniSpacing.space8),
              Expanded(
                child: Text(
                  '${item.humorServeText} (-${item.price} 🐚)',
                  style: BikiniTypography.body(color: BikiniColors.card),
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
            insetPadding: const EdgeInsets.symmetric(horizontal: BikiniRadius.screenMargin),
            child: Container(
              padding: const EdgeInsets.all(BikiniSpacing.space24),
              decoration: BikiniDecorations.interactiveCard(
                backgroundColor: BikiniColors.card,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: BikiniColors.paper,
                      shape: BoxShape.circle,
                      border: Border.all(color: BikiniColors.ink, width: BikiniRadius.borderWidth),
                    ),
                    child: const Center(child: Text('🦀', style: TextStyle(fontSize: 30))),
                  ),
                  const SizedBox(height: BikiniSpacing.space12),
                  Text(
                    'مستر سلطع طردك من القهوة! 💸',
                    style: BikiniTypography.h2(color: BikiniColors.alert),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: BikiniSpacing.space8),
                  Text(
                    'معكش صدف كفاية تطلب ${item.name}!\nرصيدك الحالي: $current صدفة 🐚 ومطلوب ${item.price} صدفة.',
                    style: BikiniTypography.body(color: BikiniColors.muted),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: BikiniSpacing.space16),
                  BikiniButton.primary(
                    onPressed: () {
                      CitizenService.instance.addShells(50);
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: BikiniColors.deep,
                          content: Text(
                            'مستر سلطع سلفك 50 صدفة 🐚 بفوائد مائية مركبة 100%! 💰',
                            style: BikiniTypography.body(color: BikiniColors.card),
                          ),
                        ),
                      );
                    },
                    text: 'استلف 50 صدفة من سلطع 💰',
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
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: BikiniColors.paper,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(BikiniRadius.sheet)),
          border: Border.all(color: BikiniColors.ink, width: BikiniRadius.borderWidth),
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

              // Header & Balance Row
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
                              border: Border.all(color: BikiniColors.ink, width: 1.5),
                            ),
                            child: const Text('☕', style: TextStyle(fontSize: 18)),
                          ),
                          const SizedBox(width: BikiniSpacing.space8),
                          Flexible(
                            child: Text(
                              'منيو طلبات العم فيش',
                              style: BikiniTypography.h2(color: BikiniColors.deep),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: BikiniSpacing.space8),
                    ValueListenableBuilder<int>(
                      valueListenable: CitizenService.instance.shellsBalance,
                      builder: (context, balance, _) {
                        return BikiniBadge(
                          text: '$balance صدفة 🐚',
                          backgroundColor: BikiniColors.coin,
                          textColor: BikiniColors.card,
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: BikiniSpacing.space12),
              const Divider(color: BikiniColors.line, thickness: 1.5),

              // Beverages List
              Flexible(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: BikiniRadius.screenMargin,
                    vertical: BikiniSpacing.space8,
                  ),
                  itemCount: menuItems.length,
                  separatorBuilder: (ctx, i) => const SizedBox(height: BikiniSpacing.space8),
                  itemBuilder: (ctx, i) {
                    final item = menuItems[i];
                    return Container(
                      padding: const EdgeInsets.all(BikiniSpacing.space12),
                      decoration: BikiniDecorations.staticCard(
                        backgroundColor: item.cardColor,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: BikiniColors.paper,
                              borderRadius: BorderRadius.circular(BikiniRadius.button),
                              border: Border.all(color: BikiniColors.ink, width: 1.5),
                            ),
                            child: Center(
                              child: Text(item.emoji, style: const TextStyle(fontSize: 22)),
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
                                    Expanded(
                                      child: Text(
                                        item.name,
                                        style: BikiniTypography.h3(color: BikiniColors.deep),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: BikiniSpacing.space4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: BikiniColors.paper,
                                        borderRadius: BorderRadius.circular(BikiniRadius.pill),
                                        border: Border.all(color: BikiniColors.ink, width: 1),
                                      ),
                                      child: Text(
                                        '${item.price} صدفة 🐚',
                                        style: BikiniTypography.caption(color: BikiniColors.coin),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: BikiniSpacing.space4),
                                Text(
                                  item.description,
                                  style: BikiniTypography.caption(color: BikiniColors.muted),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: BikiniSpacing.space8),
                          BikiniButton.secondary(
                            onPressed: () => _handleOrder(context, item),
                            text: 'اطلب 🫖',
                            height: 40,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Bottom Close Button & Free Loan CTA
              Padding(
                padding: const EdgeInsets.all(BikiniSpacing.space16),
                child: Row(
                  children: [
                    Expanded(
                      child: BikiniButton.secondary(
                        onPressed: () {
                          CitizenService.instance.addShells(50);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: BikiniColors.deep,
                              content: Text(
                                'تمت إضافة 50 صدفة 🐚 إلى رصيدك المائي!',
                                style: BikiniTypography.body(color: BikiniColors.card),
                              ),
                            ),
                          );
                        },
                        text: '+ 50 صدفة سلفة 💰',
                        height: 48,
                      ),
                    ),
                    const SizedBox(width: BikiniSpacing.space8),
                    Expanded(
                      child: BikiniButton.primary(
                        onPressed: () => Navigator.of(context).pop(),
                        text: 'إغلاق المنيو 👋',
                        height: 48,
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
