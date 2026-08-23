import 'package:flutter/material.dart';
import '../../../core/services/citizen_service.dart';
import '../../../core/theme/bikini_theme.dart';
import '../../../core/widgets/bikini_badge.dart';
import '../../../core/widgets/bikini_button.dart';

/// Live Room Conversation Modal Sheet for Uncle Fish Café
class CafeLiveRoomModal extends StatefulWidget {
  final String tableId;
  final String title;
  final String emoji;
  final String temperatureBadgeText;
  final Color temperatureColor;
  final List<String> activeAvatars;
  final List<Map<String, String>> initialMessages;

  const CafeLiveRoomModal({
    super.key,
    required this.tableId,
    required this.title,
    required this.emoji,
    required this.temperatureBadgeText,
    required this.temperatureColor,
    required this.activeAvatars,
    required this.initialMessages,
  });

  static void show(
    BuildContext context, {
    required String tableId,
    required String title,
    required String emoji,
    required String temperatureBadgeText,
    required Color temperatureColor,
    required List<String> activeAvatars,
    required List<Map<String, String>> initialMessages,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => CafeLiveRoomModal(
        tableId: tableId,
        title: title,
        emoji: emoji,
        temperatureBadgeText: temperatureBadgeText,
        temperatureColor: temperatureColor,
        activeAvatars: activeAvatars,
        initialMessages: initialMessages,
      ),
    );
  }

  @override
  State<CafeLiveRoomModal> createState() => _CafeLiveRoomModalState();
}

class _CafeLiveRoomModalState extends State<CafeLiveRoomModal> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<Map<String, String>> _messages;

  static const List<Map<String, String>> _quickPunchlines = [
    {'label': '🧽 هيه هيه!', 'text': 'هيه هيه هيه! أنا جاهز ومبسوط يا رجالة! 🍍'},
    {'label': '🎺 توت توت!', 'text': 'توت توووت! بطلوا دوشة عايز أسمع فني! 🎷'},
    {'label': '🦀 فلوسي!', 'text': 'المشاريب دي على حساب مين؟ مفيش حاجة ببلاش! 💰'},
    {'label': '🪑 خناقة!', 'text': 'وسع يا ابني هكسر الكرسي دا في دماغ اللي مش عاجبه! 💥'},
    {'label': '🧆 سر الخلطة!', 'text': 'هاهاها.. هسرق سر الخلطة النهاردة بالليل! 😈'},
    {'label': '☕ نزل واحد!', 'text': 'يا عم فيش نزل واحد شاي طحالب على حساب الطربيزة! 🫖'},
  ];

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.initialMessages);
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    final profile = CitizenService.instance.currentProfile.value;
    final name = profile?.name ?? 'مواطن صالح';
    final avatar = profile?.speciesEmoji ?? '🤿';

    setState(() {
      _messages.add({
        'sender': '$name $avatar',
        'avatar': avatar,
        'text': text.trim(),
        'time': 'الآن',
        'color': '0xFF00F5D4',
      });
    });
    _textController.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutQuad,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.82,
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

                // Table Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
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
                              child: Text(widget.emoji, style: const TextStyle(fontSize: 20)),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.title,
                                    style: BikiniTypography.displaySmall().copyWith(fontSize: 16),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'شات حي ومباشر على الترابيزة 🪑',
                                    style: BikiniTypography.caption(color: const Color(0xFF666666))
                                        .copyWith(fontSize: 10.5),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      BikiniBadge(
                        text: widget.temperatureBadgeText,
                        backgroundColor: widget.temperatureColor,
                        textColor: widget.temperatureColor == BikiniColors.krabsRed
                            ? BikiniColors.pureWhite
                            : BikiniColors.cartoonBlack,
                        fontSize: 10,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Sitting Citizens Avatars Row
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: BikiniColors.pureWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: BikiniColors.cartoonBlack, width: 1.8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'قاعدين على الترابيزة:',
                        style: BikiniTypography.captionBold().copyWith(fontSize: 11),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: widget.activeAvatars.map((av) {
                              return Container(
                                margin: const EdgeInsets.only(left: 4),
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: BikiniColors.warmSand,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: BikiniColors.cartoonBlack, width: 1.2),
                                ),
                                child: Text(av, style: const TextStyle(fontSize: 13)),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const Text('🟢 لايف', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
                const Divider(color: BikiniColors.cartoonBlack, thickness: 1.8),

                // Live Messages List
                Flexible(
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    itemCount: _messages.length,
                    separatorBuilder: (ctx, i) => const SizedBox(height: 8),
                    itemBuilder: (ctx, i) {
                      final m = _messages[i];
                      final colorHex = int.tryParse(m['color'] ?? '0xFFFFFFFF') ?? 0xFFFFFFFF;
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(colorHex),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: BikiniColors.cartoonBlack, width: 1.8),
                          boxShadow: const [
                            BoxShadow(
                              color: BikiniColors.cartoonBlack,
                              offset: Offset(2, 2),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: BikiniColors.pureWhite,
                                shape: BoxShape.circle,
                                border: Border.all(color: BikiniColors.cartoonBlack, width: 1.5),
                              ),
                              child: Center(
                                child: Text(m['avatar'] ?? '🧽', style: const TextStyle(fontSize: 16)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          m['sender'] ?? 'مواطن',
                                          style: BikiniTypography.bodyLarge().copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        m['time'] ?? 'الآن',
                                        style: BikiniTypography.caption(color: const Color(0xFF666666))
                                            .copyWith(fontSize: 9.5),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    m['text'] ?? '',
                                    style: BikiniTypography.bodyMedium().copyWith(fontSize: 12.5),
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

                // Quick Punchlines Horizontal Tray
                Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _quickPunchlines.length,
                    separatorBuilder: (ctx, i) => const SizedBox(width: 6),
                    itemBuilder: (ctx, i) {
                      final p = _quickPunchlines[i];
                      return GestureDetector(
                        onTap: () => _sendMessage(p['text']!),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: BikiniColors.spongeYellow,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: BikiniColors.cartoonBlack, width: 1.2),
                          ),
                          child: Center(
                            child: Text(
                              p['label']!,
                              style: BikiniTypography.captionBold().copyWith(fontSize: 10.5),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 6),

                // Bottom Message Input Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: BikiniColors.pureWhite,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: BikiniColors.cartoonBlack, width: 2),
                          ),
                          child: TextField(
                            controller: _textController,
                            style: BikiniTypography.bodyMedium().copyWith(fontSize: 13),
                            onSubmitted: (val) => _sendMessage(val),
                            decoration: InputDecoration(
                              hintText: 'ارمي كلمتين على الترابيزة...',
                              hintStyle: BikiniTypography.inputHint().copyWith(fontSize: 12),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      BikiniButton.primary(
                        onPressed: () => _sendMessage(_textController.text),
                        text: 'إرسال 🚀',
                        height: 44,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
