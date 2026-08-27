import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/services/citizen_service.dart';
import '../../core/theme/bikini_theme.dart';
import '../../core/widgets/bikini_badge.dart';
import '../../core/widgets/bikini_button.dart';
import 'games/basra_game_canvas.dart';
import 'games/chess_game_canvas.dart';
import 'games/dominoes_game_canvas.dart';
import 'games/tawla_game_canvas.dart';
import 'models/game_cafe_models.dart';
import 'services/cafe_room_service.dart';
import 'widgets/beverage_menu_sheet.dart';

/// Interactive Game Room Arena Screen
class GameRoomScreen extends StatefulWidget {
  final String roomId;

  const GameRoomScreen({
    super.key,
    required this.roomId,
  });

  @override
  State<GameRoomScreen> createState() => _GameRoomScreenState();
}

class _GameRoomScreenState extends State<GameRoomScreen> {
  Offset _fabPosition = const Offset(20, 520);
  Key _gameKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    CafeRoomService.instance.subscribeToRoomRealtime(widget.roomId);
  }

  @override
  void dispose() {
    CafeRoomService.instance.unsubscribeFromRoomRealtime(widget.roomId);
    super.dispose();
  }

  static const List<Map<String, String>> _quickChatPresets = [
    {'label': '🧽 هيه هيه! 🍍', 'text': 'أنا جاهز ومبسوط يا رجالة! هيه هيه! 🍍'},
    {'label': '🦀 فلوسي!', 'text': 'المشاريب دي على حساب مين؟ مفيش حاجة ببلاش! 💰'},
    {'label': '☕ نزل شاي يا عم فيش', 'text': 'يا عم فيش نزل واحد شاي طحالب على حساب الطربيزة! 🫖'},
    {'label': '🁓 كتمت يا معلم!', 'text': 'كتمت والدور قفل خلاص! مين معاه أقل نقط؟ 🁓'},
    {'label': '🃏 قش الطربيزة!', 'text': 'معايا الولد وهقش الطربيزة كلها بصرة في عين الحسود! 🃏🔥'},
    {'label': '♟️ كش ملك يا شفيق!', 'text': 'كش ملك ومات يا فنان! سلم الدور واطلب قهوة! 🎺'},
    {'label': '💥 وسع للخناقة!', 'text': 'وسع يا ابني هكسر الكرسي دا في دماغ اللي مش عاجبه! 🪑💥'},
  ];

  CafeRoom? _getRoom() {
    final list = CafeRoomService.instance.rooms.value;
    try {
      return list.firstWhere((r) => r.id == widget.roomId);
    } catch (_) {
      return null;
    }
  }

  void _copyRoomCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: BikiniColors.deep,
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            const Text('📋', style: TextStyle(fontSize: 18)),
            const SizedBox(width: BikiniSpacing.space8),
            Expanded(
              child: Text(
                'تم نسخ كود الترابيزة #$code! ابعته لأصحابك في القاع 🌊',
                style: BikiniTypography.body(color: BikiniColors.card),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGameSwitchModal(CafeRoom room) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.all(BikiniSpacing.space16),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text('🎮', style: TextStyle(fontSize: 22)),
                        const SizedBox(width: BikiniSpacing.space8),
                        Text(
                          'تغيير اللعبة النشطة على الترابيزة',
                          style: BikiniTypography.h2(color: BikiniColors.deep),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: BikiniColors.ink),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const Divider(color: BikiniColors.line, thickness: 1.5),
                const SizedBox(height: BikiniSpacing.space8),
                ...CafeGameType.values.map((game) {
                  final isSelected = room.activeGame == game;
                  return Container(
                    margin: const EdgeInsets.only(bottom: BikiniSpacing.space8),
                    decoration: BoxDecoration(
                      color: BikiniColors.card,
                      borderRadius: BorderRadius.circular(BikiniRadius.button),
                      border: Border.all(
                        color: isSelected ? BikiniColors.deep : BikiniColors.line,
                        width: isSelected ? 2.0 : 1.5,
                      ),
                    ),
                    child: ListTile(
                      leading: Text(game.emoji, style: const TextStyle(fontSize: 24)),
                      title: Text(
                        game.title,
                        style: BikiniTypography.label(color: BikiniColors.deep),
                      ),
                      subtitle: Text(
                        game.description,
                        style: BikiniTypography.caption(color: BikiniColors.muted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: isSelected
                          ? const BikiniBadge(
                              text: 'نشطة الآن 🟢',
                              backgroundColor: BikiniColors.support,
                              textColor: BikiniColors.ink,
                            )
                          : BikiniButton.secondary(
                              onPressed: () {
                                CafeRoomService.instance.switchGame(room.id, game);
                                setState(() {
                                  _gameKey = UniqueKey();
                                });
                                Navigator.of(ctx).pop();
                              },
                              text: 'اختيار 🕹️',
                              height: 36,
                            ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSeatManagementModal(CafeRoom room) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final currentRoom = _getRoom() ?? room;
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(BikiniSpacing.space16),
              decoration: BoxDecoration(
                color: BikiniColors.paper,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(BikiniRadius.sheet)),
                border: Border.all(color: BikiniColors.ink, width: BikiniRadius.borderWidth),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('🪑', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: BikiniSpacing.space8),
                            Text(
                              'إدارة كراسي الترابيزة والمشاهدين',
                              style: BikiniTypography.h2(color: BikiniColors.deep),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: BikiniColors.ink),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                    const Divider(color: BikiniColors.line, thickness: 1.5),
                    Expanded(
                      child: ListView.separated(
                        itemCount: currentRoom.participants.length,
                        separatorBuilder: (ctx, i) => const SizedBox(height: BikiniSpacing.space8),
                        itemBuilder: (ctx, i) {
                          final p = currentRoom.participants[i];
                          final isPlayer = p.role == CafePlayerRole.player;
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: BikiniSpacing.space12,
                              vertical: BikiniSpacing.space8,
                            ),
                            decoration: BikiniDecorations.staticCard(
                              backgroundColor: BikiniColors.card,
                            ),
                            child: Row(
                              children: [
                                Text(p.avatar, style: const TextStyle(fontSize: 20)),
                                const SizedBox(width: BikiniSpacing.space8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            p.name,
                                            style: BikiniTypography.label(color: BikiniColors.deep),
                                          ),
                                          if (p.isOwner) ...[
                                            const SizedBox(width: 4),
                                            const Text('👑', style: TextStyle(fontSize: 12)),
                                          ],
                                        ],
                                      ),
                                      Text(
                                        isPlayer ? 'لاعب نشط على الترابيزة 🤿' : 'في وضع المشاهدين 👁️',
                                        style: BikiniTypography.caption(color: BikiniColors.muted),
                                      ),
                                    ],
                                  ),
                                ),
                                if (!p.isOwner)
                                  BikiniButton.secondary(
                                    onPressed: () {
                                      final newRole = isPlayer
                                          ? CafePlayerRole.spectator
                                          : CafePlayerRole.player;
                                      CafeRoomService.instance.assignRole(
                                        currentRoom.id,
                                        p.id,
                                        newRole,
                                        seatIndex: newRole == CafePlayerRole.player
                                            ? currentRoom.players.length
                                            : -1,
                                      );
                                      setModalState(() {});
                                      setState(() {});
                                    },
                                    text: isPlayer ? 'تحويل لمشاهد 👁️' : 'شد كرسي للعب 🪑',
                                    height: 36,
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showRoomChatModal(CafeRoom room) {
    final textController = TextEditingController();
    final scrollController = ScrollController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final currentRoom = _getRoom() ?? room;

          void sendMessage(String text) {
            if (text.trim().isEmpty) return;
            final profile = CitizenService.instance.currentProfile.value;
            final name = profile?.name ?? 'مواطن القاع';
            final avatar = profile?.speciesEmoji ?? '🤿';

            CafeRoomService.instance.addChatMessage(widget.roomId, {
              'sender': '$name $avatar',
              'avatar': avatar,
              'text': text.trim(),
              'time': 'الآن',
            });

            textController.clear();
            setModalState(() {});
            setState(() {});

            Future.delayed(const Duration(milliseconds: 100), () {
              if (scrollController.hasClients) {
                scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutQuad,
                );
              }
            });
          }

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
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
                    children: [
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

                      // Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: BikiniRadius.screenMargin),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Text('💬', style: TextStyle(fontSize: 18)),
                                  const SizedBox(width: BikiniSpacing.space8),
                                  Flexible(
                                    child: Text(
                                      'شات الترابيزة المباشر',
                                      style: BikiniTypography.h2(color: BikiniColors.deep),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: BikiniSpacing.space8),
                            BikiniButton.secondary(
                              onPressed: () => BeverageMenuSheet.show(context),
                              text: 'طلب مشروب 🫖',
                              height: 36,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: BikiniSpacing.space8),
                      const Divider(color: BikiniColors.line, thickness: 1.5),

                      // Messages List
                      Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: BikiniRadius.screenMargin,
                            vertical: BikiniSpacing.space8,
                          ),
                          itemCount: currentRoom.chatMessages.length,
                          separatorBuilder: (ctx, i) => const SizedBox(height: BikiniSpacing.space8),
                          itemBuilder: (ctx, i) {
                            final m = currentRoom.chatMessages[i];
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

                      // Quick Preset Chips
                      Container(
                        height: 38,
                        padding: const EdgeInsets.symmetric(horizontal: BikiniRadius.screenMargin),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _quickChatPresets.length,
                          separatorBuilder: (ctx, i) => const SizedBox(width: BikiniSpacing.space8),
                          itemBuilder: (ctx, i) {
                            final preset = _quickChatPresets[i];
                            return GestureDetector(
                              onTap: () => sendMessage(preset['text']!),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: BikiniColors.paper,
                                  borderRadius: BorderRadius.circular(BikiniRadius.pill),
                                  border: Border.all(color: BikiniColors.ink, width: 1.2),
                                ),
                                child: Center(
                                  child: Text(
                                    preset['label']!,
                                    style: BikiniTypography.caption(color: BikiniColors.ink),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: BikiniSpacing.space8),

                      // Input Bar
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
                                  controller: textController,
                                  style: BikiniTypography.body(color: BikiniColors.ink),
                                  onSubmitted: (val) => sendMessage(val),
                                  decoration: InputDecoration(
                                    hintText: 'ارمي نكتة أو علّق على اللعبة...',
                                    hintStyle: BikiniTypography.inputHint(),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: BikiniSpacing.space8),
                            BikiniButton.primary(
                              onPressed: () => sendMessage(textController.text),
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
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CafeRoom>>(
      valueListenable: CafeRoomService.instance.rooms,
      builder: (context, roomList, _) {
        final room = _getRoom();
        if (room == null) {
          return Scaffold(
            backgroundColor: BikiniColors.paper,
            appBar: AppBar(title: const Text('الترابيزة غير موجودة')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('الترابيزة دي اتقفلت أو مش موجودة! 🪑'),
                  const SizedBox(height: BikiniSpacing.space12),
                  BikiniButton.primary(
                    onPressed: () => Navigator.of(context).pop(),
                    text: 'الرجوع للقهوة 🔙',
                  ),
                ],
              ),
            ),
          );
        }

        final currentCitizen = CitizenService.instance.currentProfile.value;
        final myId = currentCitizen?.id ?? '#0001';
        final isOwner = room.isUserOwner(myId);
        final isPlayer = room.isUserPlayer(myId);

        return Scaffold(
          backgroundColor: BikiniColors.paper,
          appBar: _buildRoomAppBar(room, isOwner),
          body: Stack(
            children: [
              // Main Game Canvas & Controls
              ListView(
                padding: const EdgeInsets.fromLTRB(
                  BikiniRadius.screenMargin,
                  BikiniSpacing.space8,
                  BikiniRadius.screenMargin,
                  BikiniRadius.navBarClearance,
                ),
                children: [
                  // Role Badge & Admin Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BikiniDecorations.interactiveCard(
                      backgroundColor: BikiniColors.card,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              isPlayer ? '🤿 لاعب نشط' : '👁️ وضع المشاهدين',
                              style: BikiniTypography.caption(
                                color: isPlayer ? BikiniColors.deep : BikiniColors.muted,
                              ),
                            ),
                            const SizedBox(width: BikiniSpacing.space8),
                            if (isOwner)
                              const BikiniBadge(
                                text: 'صاحب الترابيزة 👑',
                                backgroundColor: BikiniColors.coin,
                                textColor: BikiniColors.card,
                              ),
                          ],
                        ),
                        if (isOwner)
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => _showGameSwitchModal(room),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: BikiniColors.paper,
                                    borderRadius: BorderRadius.circular(BikiniRadius.button),
                                    border: Border.all(color: BikiniColors.ink, width: 1.2),
                                  ),
                                  child: Text(
                                    '🎮 غيّر اللعبة',
                                    style: BikiniTypography.caption(color: BikiniColors.deep),
                                  ),
                                ),
                              ),
                              const SizedBox(width: BikiniSpacing.space8),
                              GestureDetector(
                                onTap: () => _showSeatManagementModal(room),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: BikiniColors.paper,
                                    borderRadius: BorderRadius.circular(BikiniRadius.button),
                                    border: Border.all(color: BikiniColors.ink, width: 1.2),
                                  ),
                                  child: Text(
                                    '🪑 الكراسي',
                                    style: BikiniTypography.caption(color: BikiniColors.deep),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: BikiniSpacing.space12),

                  // Dynamic Game Canvas
                  KeyedSubtree(
                    key: _gameKey,
                    child: _buildActiveGameCanvas(room, isPlayer: isPlayer),
                  ),
                ],
              ),

              // Draggable Floating Cafe Chat Button
              Positioned(
                left: _fabPosition.dx,
                top: _fabPosition.dy,
                child: Draggable(
                  feedback: _buildChatBubbleIcon(isDragging: true),
                  childWhenDragging: const SizedBox.shrink(),
                  onDragEnd: (details) {
                    setState(() {
                      final size = MediaQuery.of(context).size;
                      final dx = details.offset.dx.clamp(10.0, size.width - 70.0);
                      final dy = details.offset.dy.clamp(60.0, size.height - 120.0);
                      _fabPosition = Offset(dx, dy);
                    });
                  },
                  child: GestureDetector(
                    onTap: () => _showRoomChatModal(room),
                    child: _buildChatBubbleIcon(isDragging: false),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildRoomAppBar(CafeRoom room, bool isOwner) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(62),
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 4,
          left: 10,
          right: 10,
          bottom: 6,
        ),
        decoration: const BoxDecoration(
          color: BikiniColors.deep,
          border: Border(
            bottom: BorderSide(color: BikiniColors.ink, width: BikiniRadius.borderWidth),
          ),
        ),
        child: Row(
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              icon: const Icon(Icons.arrow_back_rounded, color: BikiniColors.card),
              onPressed: () => Navigator.of(context).pop(),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.title,
                    style: BikiniTypography.h3(color: BikiniColors.card),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _copyRoomCode(room.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: BikiniColors.deep2,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: BikiniColors.ink, width: 1),
                          ),
                          child: Text(
                            '#${room.id} 📋',
                            style: BikiniTypography.mono(color: BikiniColors.card),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '👁️ ${room.spectators.length} مشاهدين',
                          style: BikiniTypography.caption(color: BikiniColors.paper),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            BikiniBadge(
              text: room.activeGame.title,
              backgroundColor: BikiniColors.support,
              textColor: BikiniColors.ink,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveGameCanvas(CafeRoom room, {required bool isPlayer}) {
    final p1 = room.players.isNotEmpty ? room.players[0] : null;
    final p2 = room.players.length > 1 ? room.players[1] : null;

    final p1Name = p1?.name ?? 'المواطن ١';
    final p2Name = p2?.name ?? 'المواطن ٢';
    final p1Avatar = p1?.avatar ?? '🤿';
    final p2Avatar = p2?.avatar ?? '🦀';

    switch (room.activeGame) {
      case CafeGameType.dominoes:
        return DominoesGameCanvas(
          isSpectator: !isPlayer,
          player1Name: p1Name,
          player2Name: p2Name,
          player1Avatar: p1Avatar,
          player2Avatar: p2Avatar,
        );
      case CafeGameType.tawla:
        return TawlaGameCanvas(
          isSpectator: !isPlayer,
          player1Name: p1Name,
          player2Name: p2Name,
          player1Avatar: p1Avatar,
          player2Avatar: p2Avatar,
        );
      case CafeGameType.chess:
        return ChessGameCanvas(
          isSpectator: !isPlayer,
          player1Name: p1Name,
          player2Name: p2Name,
          player1Avatar: p1Avatar,
          player2Avatar: p2Avatar,
        );
      case CafeGameType.basra:
        return BasraGameCanvas(
          isSpectator: !isPlayer,
          player1Name: p1Name,
          player2Name: p2Name,
          player1Avatar: p1Avatar,
          player2Avatar: p2Avatar,
        );
    }
  }

  Widget _buildChatBubbleIcon({required bool isDragging}) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: BikiniColors.support,
        shape: BoxShape.circle,
        border: Border.all(color: BikiniColors.ink, width: BikiniRadius.borderWidth),
        boxShadow: isDragging
            ? const [
                BoxShadow(
                  color: BikiniColors.ink,
                  offset: Offset(4, 4),
                  blurRadius: 0,
                ),
              ]
            : const [
                BoxShadow(
                  color: BikiniColors.ink,
                  offset: Offset(3, 3),
                  blurRadius: 0,
                ),
              ],
      ),
      child: const Center(
        child: Text('💬', style: TextStyle(fontSize: 26)),
      ),
    );
  }
}
