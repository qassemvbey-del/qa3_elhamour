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
  const FishCafeScreen({super.key});

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
          backgroundColor: BikiniColors.cartoonBlack,
          duration: const Duration(seconds: 2),
          content: Row(
            children: [
              const Text('⚠️', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'مفيش ترابيزة بالكود دا ($query) في القاع! اتأكد من الـ ٦ أرقام 🪑',
                  style: BikiniTypography.bodyMedium(color: BikiniColors.spongeYellow),
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
                padding: const EdgeInsets.all(16),
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
                    children: [
                      // Handle
                      Container(
                        width: 48,
                        height: 5,
                        decoration: BoxDecoration(
                          color: BikiniColors.cartoonBlack,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text('👑', style: TextStyle(fontSize: 22)),
                              const SizedBox(width: 8),
                              Text(
                                'حجز ترابيزة ألعاب خاصة',
                                style: BikiniTypography.displaySmall().copyWith(fontSize: 17),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                        ],
                      ),

                      const Divider(color: BikiniColors.cartoonBlack, thickness: 1.8),

                      Expanded(
                        child: ListView(
                          children: [
                            // Room Title
                            Text(
                              'اسم الترابيزة:',
                              style: BikiniTypography.titleBold().copyWith(fontSize: 13),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: BikiniColors.pureWhite,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: BikiniColors.cartoonBlack, width: 2),
                              ),
                              child: TextField(
                                controller: titleController,
                                style: BikiniTypography.bodyMedium().copyWith(fontSize: 13),
                                decoration: InputDecoration(
                                  hintText: 'مثال: ترابيزة المعلمين الكبار 🁓',
                                  hintStyle: BikiniTypography.inputHint().copyWith(fontSize: 12),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Game Selection
                            Text(
                              'اختر اللعبة الافتتاحية:',
                              style: BikiniTypography.titleBold().copyWith(fontSize: 13),
                            ),
                            const SizedBox(height: 6),
                            ...CafeGameType.values.map((g) {
                              final isSelected = selectedGame == g;
                              return GestureDetector(
                                onTap: () => setModalState(() => selectedGame = g),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isSelected ? g.themeColor : BikiniColors.pureWhite,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected ? BikiniColors.krabsRed : BikiniColors.cartoonBlack,
                                      width: isSelected ? 2.5 : 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(g.emoji, style: const TextStyle(fontSize: 22)),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              g.title,
                                              style: BikiniTypography.titleBold().copyWith(fontSize: 13),
                                            ),
                                            Text(
                                              '(${g.minPlayers}-${g.maxPlayers} لاعبين) • ${g.description}',
                                              style: BikiniTypography.caption(color: const Color(0xFF555555))
                                                  .copyWith(fontSize: 10.5),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isSelected)
                                        const Icon(Icons.check_circle_rounded,
                                            color: BikiniColors.krabsRed, size: 20),
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
                                  activeColor: BikiniColors.cartoonBlack,
                                  onChanged: (val) => setModalState(() => isPrivate = val ?? false),
                                ),
                                Text(
                                  'ترابيزة خاصة (الدخول بكود الـ ٦ أرقام فقط) 🔒',
                                  style: BikiniTypography.bodyMedium().copyWith(fontSize: 12),
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
                        height: 44,
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
        backgroundColor: BikiniColors.cartoonBlack,
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            const Text('🔊', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'شغال صوت: $name ($subtitle) 🎶',
                style: BikiniTypography.bodyMedium(color: BikiniColors.spongeYellow),
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
      backgroundColor: BikiniColors.warmSand,
      appBar: const WoodenTopBar(
        title: 'قهوة العم فيش ☕',
        unreadCount: 2,
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 120),
          children: [
            // Café Welcome & Shells Balance Card
            _buildCafeHeroCard(),

            const SizedBox(height: 12),

            // Top 6-Digit Fast Search & Create Room Bar
            _buildSearchAndCreateBar(),

            const SizedBox(height: 12),

            // Uncle Fish Beverage Quick Scroller
            _buildBeverageQuickBar(),

            const SizedBox(height: 16),

            // Thematic Tables Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Text('🪑', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'ترابيزات القهوة والألعاب الحية',
                          style: BikiniTypography.displaySmall().copyWith(fontSize: 17),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                BikiniBadge(
                  text: 'ألعاب مباشرة 🟢',
                  backgroundColor: BikiniColors.marineCyan,
                  textColor: BikiniColors.cartoonBlack,
                  fontSize: 10,
                ),
              ],
            ),

            const SizedBox(height: 10),

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

            const SizedBox(height: 14),

            // Soundboard Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Text('🔊', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'ساوند بورد أصوات قاع الهامور',
                          style: BikiniTypography.displaySmall().copyWith(fontSize: 17),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                BikiniBadge.active(text: 'اضغط للتشغيل'),
              ],
            ),

            const SizedBox(height: 8),

            // Soundboard Grid Horizontal
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _sounds.length,
                separatorBuilder: (ctx, i) => const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  final s = _sounds[i];
                  return GestureDetector(
                    onTap: () => _playSoundEffect(s['name']!, s['subtitle']!),
                    child: Container(
                      width: 120,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: BikiniColors.spongeYellow,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: BikiniColors.cartoonBlack, width: 2.2),
                        boxShadow: const [
                          BoxShadow(
                            color: BikiniColors.cartoonBlack,
                            offset: Offset(2.5, 2.5),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(s['emoji']!, style: const TextStyle(fontSize: 22)),
                          const SizedBox(height: 2),
                          Text(
                            s['name']!,
                            style: BikiniTypography.captionBold().copyWith(fontSize: 11),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            s['subtitle']!,
                            style: BikiniTypography.caption(color: const Color(0xFF555555))
                                .copyWith(fontSize: 9.5),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: BikiniColors.spongeYellow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: BikiniColors.cartoonBlack, width: 3.0),
        boxShadow: const [
          BoxShadow(
            color: BikiniColors.cartoonBlack,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: BikiniColors.pureWhite,
                  shape: BoxShape.circle,
                  border: Border.all(color: BikiniColors.cartoonBlack, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: BikiniColors.cartoonBlack,
                      offset: Offset(2, 2),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('☕', style: TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'قهوة العم فيش (صالة الألعاب الحية)',
                      style: BikiniTypography.displaySmall(color: BikiniColors.deepNavy).copyWith(fontSize: 16.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'العب دومينو، طاولة، شطرنج، وبصرة.. واقعد مع الحبيبة!',
                      style: BikiniTypography.bodyMedium(color: const Color(0xFF333333)).copyWith(fontSize: 11.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: BikiniColors.cartoonBlack, thickness: 1.5),
          const SizedBox(height: 6),
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
                        color: BikiniColors.pureWhite,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: BikiniColors.cartoonBlack, width: 1.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🐚', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'رصيدك: $balance صدفة',
                              style: BikiniTypography.captionBold(color: BikiniColors.cartoonBlack)
                                  .copyWith(fontSize: 10.5),
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
              const SizedBox(width: 6),
              // Menu Button CTA
              BikiniButton.secondary(
                onPressed: () => BeverageMenuSheet.show(context),
                text: 'منيو المشاريب 🫖',
                height: 36,
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
          decoration: BoxDecoration(
            color: BikiniColors.pureWhite,
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
              const SizedBox(width: 8),
              const Text('🔍', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  style: BikiniTypography.titleBold().copyWith(fontSize: 13),
                  onSubmitted: (_) => _searchAndJoinRoom(),
                  decoration: InputDecoration(
                    hintText: 'ادخل كود الترابيزة الـ ٦ أرقام (مثال 492015)...',
                    hintStyle: BikiniTypography.inputHint().copyWith(fontSize: 11.5),
                    counterText: '',
                    border: InputBorder.none,
                  ),
                ),
              ),
              BikiniButton.primary(
                onPressed: _searchAndJoinRoom,
                text: 'دخول 🚀',
                height: 38,
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // "+ احجز ترابيزة خاصة" Button
        BikiniButton.pink(
          onPressed: _showCreateRoomSheet,
          text: '+ احجز ترابيزة خاصة بكود ٦ أرقام 👑',
          isFullWidth: true,
          height: 42,
        ),
      ],
    );
  }

  Widget _buildBeverageQuickBar() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: BeverageMenuSheet.menuItems.length,
        separatorBuilder: (ctx, i) => const SizedBox(width: 8),
        itemBuilder: (ctx, i) {
          final item = BeverageMenuSheet.menuItems[i];
          return GestureDetector(
            onTap: () => BeverageMenuSheet.show(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: item.cardColor,
                borderRadius: BorderRadius.circular(12),
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
                children: [
                  Text(item.emoji, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(
                    item.name,
                    style: BikiniTypography.captionBold().copyWith(fontSize: 11),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${item.price} 🐚)',
                    style: BikiniTypography.caption(color: BikiniColors.krabsRed)
                        .copyWith(fontSize: 9.5, fontWeight: FontWeight.bold),
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: room.activeGame.themeColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: BikiniColors.cartoonBlack, width: 2.8),
        boxShadow: const [
          BoxShadow(
            color: BikiniColors.cartoonBlack,
            offset: Offset(3.5, 3.5),
            blurRadius: 0,
          ),
        ],
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
                        color: BikiniColors.pureWhite,
                        shape: BoxShape.circle,
                        border: Border.all(color: BikiniColors.cartoonBlack, width: 1.8),
                      ),
                      child: Text(room.activeGame.emoji, style: const TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room.title,
                            style: BikiniTypography.titleBold().copyWith(fontSize: 13.5),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: BikiniColors.spongeYellow,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: BikiniColors.cartoonBlack, width: 1),
                                ),
                                child: Text(
                                  '#${room.id}',
                                  style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  'المنظم: ${room.ownerName}',
                                  style: BikiniTypography.caption(color: const Color(0xFF555555))
                                      .copyWith(fontSize: 9.5),
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
              const SizedBox(width: 6),
              BikiniBadge(
                text: room.activeGame.shortName,
                backgroundColor: BikiniColors.spongeYellow,
                textColor: BikiniColors.cartoonBlack,
                fontSize: 10,
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Table Description
          Text(
            room.activeGame.description,
            style: BikiniTypography.bodyMedium(color: const Color(0xFF333333)).copyWith(fontSize: 11.5),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),
          const Divider(color: BikiniColors.cartoonBlack, thickness: 1.2),
          const SizedBox(height: 4),

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
                          color: BikiniColors.pureWhite,
                          shape: BoxShape.circle,
                          border: Border.all(color: BikiniColors.cartoonBlack, width: 1.2),
                        ),
                        child: Text(room.participants[i].avatar, style: const TextStyle(fontSize: 11)),
                      ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '${room.players.length} لاعب • ${room.spectators.length} مشاهد',
                        style: BikiniTypography.caption(color: const Color(0xFF555555)).copyWith(fontSize: 9.5),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),

              // Join Action Button
              BikiniButton.primary(
                onPressed: () => _joinRoom(room),
                text: 'شد كرسي 🪑',
                height: 34,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
