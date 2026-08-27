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

                // Table Header
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
                              child: Text(widget.emoji, style: const TextStyle(fontSize: 20)),
                            ),
                            const SizedBox(width: BikiniSpacing.space8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.title,
                                    style: BikiniTypography.h3(color: BikiniColors.deep),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'شات حي ومباشر على الترابيزة 🪑',
                                    style: BikiniTypography.caption(color: BikiniColors.muted),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: BikiniSpacing.space8),
                      BikiniBadge(
                        text: widget.temperatureBadgeText,
                        backgroundColor: widget.temperatureColor,
                        textColor: BikiniColors.card,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: BikiniSpacing.space8),

                // Sitting Citizens Avatars Row
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: BikiniRadius.screenMargin),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: BikiniColors.card,
                    borderRadius: BorderRadius.circular(BikiniRadius.button),
                    border: Border.all(color: BikiniColors.ink, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'قاعدين على الترابيزة:',
                        style: BikiniTypography.caption(color: BikiniColors.deep),
                      ),
                      const SizedBox(width: BikiniSpacing.space8),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: widget.activeAvatars.map((av) {
                              return Container(
                                margin: const EdgeInsets.only(left: 4),
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: BikiniColors.paper,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: BikiniColors.ink, width: 1),
                                ),
                                child: Text(av, style: const TextStyle(fontSize: 13)),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Text(
                        '🟢 لايف',
                        style: BikiniTypography.caption(color: BikiniColors.support),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: BikiniSpacing.space8),
                const Divider(color: BikiniColors.line, thickness: 1.5),

                // Live Messages List
                Flexible(
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: BikiniRadius.screenMargin,
                      vertical: BikiniSpacing.space8,
                    ),
                    itemCount: _messages.length,
                    separatorBuilder: (ctx, i) => const SizedBox(height: BikiniSpacing.space8),
                    itemBuilder: (ctx, i) {
                      final m = _messages[i];
                      return Container(
                        padding: const EdgeInsets.all(BikiniSpacing.space12),
                        decoration: BikiniDecorations.staticCard(
                          backgroundColor: BikiniColors.card,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: BikiniColors.paper,
                                shape: BoxShape.circle,
                                border: Border.all(color: BikiniColors.ink, width: 1.5),
                              ),
                              child: Center(
                                child: Text(m['avatar'] ?? '🧽', style: const TextStyle(fontSize: 16)),
                              ),
                            ),
                            const SizedBox(width: BikiniSpacing.space8),
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
                                          style: BikiniTypography.label(color: BikiniColors.deep),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        m['time'] ?? 'الآن',
                                        style: BikiniTypography.caption(color: BikiniColors.muted),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: BikiniSpacing.space4),
                                  Text(
                                    m['text'] ?? '',
                                    style: BikiniTypography.body(color: BikiniColors.ink),
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
                  padding: const EdgeInsets.symmetric(horizontal: BikiniRadius.screenMargin),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _quickPunchlines.length,
                    separatorBuilder: (ctx, i) => const SizedBox(width: BikiniSpacing.space8),
                    itemBuilder: (ctx, i) {
                      final p = _quickPunchlines[i];
                      return GestureDetector(
                        onTap: () => _sendMessage(p['text']!),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: BikiniColors.paper,
                            borderRadius: BorderRadius.circular(BikiniRadius.pill),
                            border: Border.all(color: BikiniColors.ink, width: 1.2),
                          ),
                          child: Center(
                            child: Text(
                              p['label']!,
                              style: BikiniTypography.caption(color: BikiniColors.ink),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: BikiniSpacing.space8),

                // Bottom Message Input Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    BikiniRadius.screenMargin,
                    4,
                    BikiniRadius.screenMargin,
                    BikiniSpacing.space12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: BikiniColors.card,
                            borderRadius: BorderRadius.circular(BikiniRadius.button),
                            border: Border.all(color: BikiniColors.ink, width: 1.5),
                          ),
                          child: TextField(
                            controller: _textController,
                            style: BikiniTypography.body(color: BikiniColors.ink),
                            onSubmitted: (val) => _sendMessage(val),
                            decoration: InputDecoration(
                              hintText: 'ارمي كلمتين على الترابيزة...',
                              hintStyle: BikiniTypography.inputHint(),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: BikiniSpacing.space8),
                      BikiniButton.primary(
                        onPressed: () => _sendMessage(_textController.text),
                        text: 'إرسال 🚀',
                        height: 48,
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
