import 'package:flutter/material.dart';
import '../../core/services/citizen_service.dart';
import '../../core/theme/bikini_theme.dart';
import '../../core/widgets/bikini_badge.dart';
import '../../core/widgets/bikini_button.dart';
import '../../core/widgets/wooden_top_bar.dart';
import 'game_room_screen.dart';
import 'models/game_cafe_models.dart';
import 'services/cafe_room_service.dart';
import 'widgets/beverage_menu_sheet.dart';

/// Uncle Fish Café Screen - Virtual Thematic Tables, 6-Digit Search & Live Games
class FishCafeScreen extends StatefulWidget {
  final Function(int tabIndex)? onNavigateToTab;

  const FishCafeScreen({
    super.key,
    this.onNavigateToTab,
  });

  @override
  State<FishCafeScreen> createState() => _FishCafeScreenState();
}

class _FishCafeScreenState extends State<FishCafeScreen> {
  final TextEditingController _searchController = TextEditingController();

  static const List<Map<String, String>> _sounds = [
    {'name': 'ضحكة سبونج بوب', 'emoji': '🧽', 'subtitle': 'هيه هيه هيه!'},
    {'name': 'عزف شفيق المزعج', 'emoji': '🎺', 'subtitle': 'توت توووت فاشل'},
    {'name': 'كاشات مستر سلطع', 'emoji': '🦀', 'subtitle': 'صوت الفلوس الحلال'},
    {'name': 'ضحكة شمشون الشريرة', 'emoji': '🧆', 'subtitle': 'هاهاها سر الخلطة!'},
    {'name': 'صوت فقاعة بسيط', 'emoji': '⭐', 'subtitle': 'بلووب بلووب'},
    {'name': 'لسعة قنديل بحر', 'emoji': '🪼', 'subtitle': 'بزززززز!'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchAndJoinRoom() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    final room = await CafeRoomService.instance.findOrFetchRoomByCode(query);
    if (!mounted) return;

    if (room != null) {
      _joinRoom(room);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: BikiniColors.deep,
          duration: const Duration(seconds: 2),
          content: Row(
            children: [
              const Text('⚠️', style: TextStyle(fontSize: 20)),
              const SizedBox(width: BikiniSpacing.space8),
              Expanded(
                child: Text(
                  'مفيش ترابيزة بالكود دا ($query) في القاع! اتأكد من الـ ٦ أرقام 🪑',
                  style: BikiniTypography.body(color: BikiniColors.card),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _joinRoom(CafeRoom room) {
    final profile = CitizenService.instance.currentProfile.value;
    if (profile != null) {
      CafeRoomService.instance.joinRoom(room.id, profile, asPlayer: true);
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GameRoomScreen(roomId: room.id),
      ),
    );
  }

  void _showCreateRoomSheet() {
    final titleController = TextEditingController();
    CafeGameType selectedGame = CafeGameType.dominoes;
    bool isPrivate = false;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.75,
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
                    children: [
                      // Handle
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text('👑', style: TextStyle(fontSize: 22)),
                              const SizedBox(width: BikiniSpacing.space8),
                              Text(
                                'حجز ترابيزة ألعاب خاصة',
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
                        child: ListView(
                          children: [
                            // Room Title
                            Text(
                              'اسم الترابيزة:',
                              style: BikiniTypography.label(color: BikiniColors.deep),
                            ),
                            const SizedBox(height: BikiniSpacing.space8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: BikiniColors.card,
                                borderRadius: BorderRadius.circular(BikiniRadius.button),
                                border: Border.all(color: BikiniColors.ink, width: 1.5),
                              ),
                              child: TextField(
                                controller: titleController,
                                style: BikiniTypography.body(color: BikiniColors.ink),
                                decoration: InputDecoration(
                                  hintText: 'مثال: ترابيزة المعلمين الكبار 🁓',
                                  hintStyle: BikiniTypography.inputHint(),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: BikiniSpacing.space12),

                            // Game Selection
                            Text(
                              'اختر اللعبة الافتتاحية:',
                              style: BikiniTypography.label(color: BikiniColors.deep),
                            ),
                            const SizedBox(height: BikiniSpacing.space8),
                            ...CafeGameType.values.map((g) {
                              final isSelected = selectedGame == g;
                              return GestureDetector(
                                onTap: () => setModalState(() => selectedGame = g),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: BikiniSpacing.space8),
                                  padding: const EdgeInsets.all(BikiniSpacing.space12),
                                  decoration: BoxDecoration(
                                    color: isSelected ? BikiniColors.paper : BikiniColors.card,
                                    borderRadius: BorderRadius.circular(BikiniRadius.button),
                                    border: Border.all(
                                      color: isSelected ? BikiniColors.deep : BikiniColors.line,
                                      width: isSelected ? 2.0 : 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(g.emoji, style: const TextStyle(fontSize: 22)),
                                      const SizedBox(width: BikiniSpacing.space8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              g.title,
                                              style: BikiniTypography.label(color: BikiniColors.deep),
                                            ),
                                            Text(
                                              '(${g.minPlayers}-${g.maxPlayers} لاعبين) • ${g.description}',
                                              style: BikiniTypography.caption(color: BikiniColors.muted),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isSelected)
                                        const Icon(Icons.check_circle_rounded,
                                            color: BikiniColors.support, size: 20),
                                    ],
                                  ),
                                ),
                              );
                            }),

                            // Privacy Checkbox
                            Row(
                              children: [
                                Checkbox(
                                  value: isPrivate,
                                  activeColor: BikiniColors.deep,
                                  onChanged: (val) => setModalState(() => isPrivate = val ?? false),
                                ),
                                Text(
                                  'ترابيزة خاصة (الدخول بكود الـ ٦ أرقام فقط) 🔒',
                                  style: BikiniTypography.caption(color: BikiniColors.deep),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Submit Button
                      BikiniButton.primary(
                        onPressed: () {
                          final profile = CitizenService.instance.currentProfile.value;
                          if (profile == null) return;

                          final room = CafeRoomService.instance.createRoom(
                            title: titleController.text,
                            initialGame: selectedGame,
                            owner: profile,
                            isPrivate: isPrivate,
                          );

                          Navigator.of(ctx).pop();
                          _joinRoom(room);
                        },
                        text: 'تأكيد حجز الترابيزة 🚀👑',
                        isFullWidth: true,
                        height: 48,
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

  void _playSoundEffect(String name, String subtitle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: BikiniColors.deep,
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            const Text('🔊', style: TextStyle(fontSize: 20)),
            const SizedBox(width: BikiniSpacing.space8),
            Expanded(
              child: Text(
                'شغال صوت: $name ($subtitle) 🎶',
                style: BikiniTypography.body(color: BikiniColors.card),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BikiniColors.paper,
      appBar: const WoodenTopBar(
        title: 'قهوة العم فيش ☕',
        unreadCount: 2,
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.only(
            left: BikiniRadius.screenMargin,
            right: BikiniRadius.screenMargin,
            top: BikiniSpacing.space12,
            bottom: BikiniRadius.navBarClearance,
          ),
          children: [
            // Café Welcome & Shells Balance Card
            _buildCafeHeroCard(),

            const SizedBox(height: BikiniSpacing.space12),

            // Top 6-Digit Fast Search & Create Room Bar
            _buildSearchAndCreateBar(),

            const SizedBox(height: BikiniSpacing.space12),

            // Uncle Fish Beverage Quick Scroller
            _buildBeverageQuickBar(),

            const SizedBox(height: BikiniSpacing.space16),

            // Thematic Tables Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Text('🪑', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: BikiniSpacing.space8),
                      Flexible(
                        child: Text(
                          'ترابيزات القهوة والألعاب الحية',
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
                  text: 'ألعاب مباشرة 🟢',
                  backgroundColor: BikiniColors.support,
                  textColor: BikiniColors.ink,
                ),
              ],
            ),

            const SizedBox(height: BikiniSpacing.space8),

            // Live Game Rooms Feed from CafeRoomService
            ValueListenableBuilder<List<CafeRoom>>(
              valueListenable: CafeRoomService.instance.rooms,
              builder: (context, rooms, _) {
                if (rooms.isEmpty) {
                  return const Center(child: Text('مفيش ترابيزات مفتوحة حالياً!'));
                }
                return Column(
                  children: rooms.map((r) => _buildRoomCard(r)).toList(),
                );
              },
            ),

            const SizedBox(height: BikiniSpacing.space16),

            // Soundboard Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Text('🔊', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: BikiniSpacing.space8),
                      Flexible(
                        child: Text(
                          'ساوند بورد أصوات قاع الهامور',
                          style: BikiniTypography.h2(color: BikiniColors.deep),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: BikiniSpacing.space8),
                BikiniBadge.active(text: 'اضغط للتشغيل'),
              ],
            ),

            const SizedBox(height: BikiniSpacing.space8),

            // Soundboard Grid Horizontal
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _sounds.length,
                separatorBuilder: (ctx, i) => const SizedBox(width: BikiniSpacing.space8),
                itemBuilder: (ctx, i) {
                  final s = _sounds[i];
                  return GestureDetector(
                    onTap: () => _playSoundEffect(s['name']!, s['subtitle']!),
                    child: Container(
                      width: 120,
                      padding: const EdgeInsets.all(BikiniSpacing.space8),
                      decoration: BikiniDecorations.interactiveCard(
                        backgroundColor: BikiniColors.card,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(s['emoji']!, style: const TextStyle(fontSize: 22)),
                          const SizedBox(height: 2),
                          Text(
                            s['name']!,
                            style: BikiniTypography.label(color: BikiniColors.deep),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            s['subtitle']!,
                            style: BikiniTypography.caption(color: BikiniColors.muted),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCafeHeroCard() {
    return Container(
      padding: const EdgeInsets.all(BikiniSpacing.space16),
      decoration: BikiniDecorations.interactiveCard(
        backgroundColor: BikiniColors.card,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: BikiniColors.paper,
                  shape: BoxShape.circle,
                  border: Border.all(color: BikiniColors.ink, width: 1.5),
                ),
                child: const Center(
                  child: Text('☕', style: TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: BikiniSpacing.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'قهوة العم فيش (صالة الألعاب الحية)',
                      style: BikiniTypography.h2(color: BikiniColors.deep),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'العب دومينو، طاولة، شطرنج، وبصرة.. واقعد مع الحبيبة!',
                      style: BikiniTypography.caption(color: BikiniColors.muted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: BikiniSpacing.space12),
          const Divider(color: BikiniColors.line, thickness: 1.5),
          const SizedBox(height: BikiniSpacing.space8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Shells balance indicator
              Flexible(
                child: ValueListenableBuilder<int>(
                  valueListenable: CitizenService.instance.shellsBalance,
                  builder: (context, balance, _) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: BikiniColors.paper,
                        borderRadius: BorderRadius.circular(BikiniRadius.button),
                        border: Border.all(color: BikiniColors.ink, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🐚', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'رصيدك: $balance صدفة',
                              style: BikiniTypography.caption(color: BikiniColors.coin),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: BikiniSpacing.space8),
              // Menu Button CTA
              BikiniButton.secondary(
                onPressed: () => BeverageMenuSheet.show(context),
                text: 'منيو المشاريب 🫖',
                height: 40,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndCreateBar() {
    return Column(
      children: [
        // 6-digit Search Field
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BikiniDecorations.interactiveCard(
            backgroundColor: BikiniColors.card,
          ),
          child: Row(
            children: [
              const SizedBox(width: 8),
              const Text('🔍', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  style: BikiniTypography.mono(color: BikiniColors.ink),
                  onSubmitted: (_) => _searchAndJoinRoom(),
                  decoration: InputDecoration(
                    hintText: 'ادخل كود الترابيزة الـ ٦ أرقام (مثال 492015)...',
                    hintStyle: BikiniTypography.inputHint(),
                    counterText: '',
                    border: InputBorder.none,
                  ),
                ),
              ),
              BikiniButton.primary(
                onPressed: _searchAndJoinRoom,
                text: 'دخول 🚀',
                height: 40,
              ),
            ],
          ),
        ),

        const SizedBox(height: BikiniSpacing.space8),

        // "+ احجز ترابيزة خاصة" Button
        BikiniButton.secondary(
          onPressed: _showCreateRoomSheet,
          text: '+ احجز ترابيزة خاصة بكود ٦ أرقام 👑',
          isFullWidth: true,
          height: 48,
        ),
      ],
    );
  }

  Widget _buildBeverageQuickBar() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: BeverageMenuSheet.menuItems.length,
        separatorBuilder: (ctx, i) => const SizedBox(width: BikiniSpacing.space8),
        itemBuilder: (ctx, i) {
          final item = BeverageMenuSheet.menuItems[i];
          return GestureDetector(
            onTap: () => BeverageMenuSheet.show(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BikiniDecorations.interactiveCard(
                backgroundColor: item.cardColor,
              ),
              child: Row(
                children: [
                  Text(item.emoji, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    item.name,
                    style: BikiniTypography.caption(color: BikiniColors.deep),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${item.price} 🐚)',
                    style: BikiniTypography.caption(color: BikiniColors.coin),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRoomCard(CafeRoom room) {
    return Container(
      margin: const EdgeInsets.only(bottom: BikiniSpacing.space12),
      padding: const EdgeInsets.all(BikiniSpacing.space12),
      decoration: BikiniDecorations.interactiveCard(
        backgroundColor: room.activeGame.themeColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Top Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: BikiniColors.paper,
                        shape: BoxShape.circle,
                        border: Border.all(color: BikiniColors.ink, width: 1.5),
                      ),
                      child: Text(room.activeGame.emoji, style: const TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(width: BikiniSpacing.space8),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room.title,
                            style: BikiniTypography.h3(color: BikiniColors.deep),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: BikiniColors.paper,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: BikiniColors.ink, width: 1),
                                ),
                                child: Text(
                                  '#${room.id}',
                                  style: BikiniTypography.mono(color: BikiniColors.ink),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  'المنظم: ${room.ownerName}',
                                  style: BikiniTypography.caption(color: BikiniColors.muted),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: BikiniSpacing.space8),
              BikiniBadge(
                text: room.activeGame.shortName,
                backgroundColor: BikiniColors.support,
                textColor: BikiniColors.ink,
              ),
            ],
          ),

          const SizedBox(height: BikiniSpacing.space8),

          // Table Description
          Text(
            room.activeGame.description,
            style: BikiniTypography.caption(color: BikiniColors.muted),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: BikiniSpacing.space8),
          const Divider(color: BikiniColors.line, thickness: 1.5),
          const SizedBox(height: BikiniSpacing.space4),

          // Avatars & Join Button Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Participant Avatars
              Expanded(
                child: Row(
                  children: [
                    for (int i = 0; i < room.participants.length && i < 2; i++)
                      Container(
                        margin: const EdgeInsets.only(left: 2),
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: BikiniColors.paper,
                          shape: BoxShape.circle,
                          border: Border.all(color: BikiniColors.ink, width: 1),
                        ),
                        child: Text(room.participants[i].avatar, style: const TextStyle(fontSize: 11)),
                      ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '${room.players.length} لاعب • ${room.spectators.length} مشاهد',
                        style: BikiniTypography.caption(color: BikiniColors.muted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: BikiniSpacing.space8),

              // Join Action Button
              BikiniButton.primary(
                onPressed: () => _joinRoom(room),
                text: 'شد كرسي 🪑',
                height: 38,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
