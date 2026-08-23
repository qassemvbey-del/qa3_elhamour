import 'package:flutter/material.dart';
import '../../core/services/citizen_service.dart';
import '../../core/theme/bikini_theme.dart';
import '../../core/widgets/bikini_badge.dart';
import '../../core/widgets/bikini_button.dart';
import '../../core/widgets/wooden_top_bar.dart';

/// Multi-reaction definition model
class BikiniReaction {
  final String emoji;
  final String label;
  final Color color;

  const BikiniReaction({
    required this.emoji,
    required this.label,
    required this.color,
  });
}

/// Newsfeed for Bikini Bottom Gazette (جريدة قاع الهامور) - Facebook-Style
class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  static const List<BikiniReaction> reactionOptions = [
    BikiniReaction(emoji: '👍', label: 'عاش', color: BikiniColors.marineCyan),
    BikiniReaction(emoji: '❤️', label: 'حب', color: BikiniColors.neonPink),
    BikiniReaction(emoji: '😂', label: 'مسخرة', color: BikiniColors.spongeYellow),
    BikiniReaction(emoji: '🪑', label: 'كرسي خناقة', color: Color(0xFFFFCCD5)),
    BikiniReaction(emoji: '🐟', label: 'سمكة دايخة', color: Color(0xFFD0E1FD)),
    BikiniReaction(emoji: '😡', label: 'غضب سلطعي', color: BikiniColors.krabsRed),
  ];

  // Active open reaction tray post ID
  String? _activeReactionTrayPostId;

  late List<Map<String, dynamic>> _posts;

  @override
  void initState() {
    super.initState();
    _initPosts();
  }

  void _initPosts() {
    _posts = [
      {
        'id': '1',
        'author': 'شفيق المكتئب 🎺',
        'avatar': '🎺',
        'clan': 'حلف الرخويات',
        'time': 'منذ نصف ساعة',
        'content': 'يا جماعة اللي بيرمي صابون فقاعات قدام الباب بتاعي يلم حاجته بدل ما أعمل محضر في قسم شرطة الأعماق! أنا راجل فنان وعايز هدوء! @مواطن_0001 بلغ صديقك الكسلان!',
        'badge': '🔥 تريند',
        'userReaction': '😂',
        'reactionCounts': {
          '😂': 142,
          '👍': 56,
          '🪑': 34,
          '😡': 18,
          '❤️': 12,
          '🐟': 8,
        },
        'reactors': [
          {'name': 'سبونج بوب سكوير بانتس', 'avatar': '🧽', 'citizenId': '#0001', 'reaction': '😂'},
          {'name': 'بسيط نجم النجوم', 'avatar': '⭐', 'citizenId': '#0002', 'reaction': '😂'},
          {'name': 'مستر سلطع', 'avatar': '🦀', 'citizenId': '#0003', 'reaction': '🪑'},
          {'name': 'المعلم عضلات', 'avatar': '🦞', 'citizenId': '#0004', 'reaction': '👍'},
          {'name': 'ساندي أمور', 'avatar': '🐿️', 'citizenId': '#0005', 'reaction': '❤️'},
          {'name': 'شمشون العبقري', 'avatar': '🧆', 'citizenId': '#0006', 'reaction': '😡'},
        ],
        'comments': [
          {
            'id': 'c1',
            'author': 'سبونج بوب 🍍',
            'avatar': '🧽',
            'citizenId': '#0001',
            'time': 'منذ 20 دقيقة',
            'text': 'أنا وبسيط كنا بنعمل مسابقة أكبر فقاعة على شكل كلارينيت يا شفيق! هيه هيه هيه! 🫧',
          },
          {
            'id': 'c2',
            'author': 'بسيط نجم ⭐',
            'avatar': '⭐',
            'citizenId': '#0002',
            'time': 'منذ 15 دقيقة',
            'text': 'أنا افتكرت الصابون دا غسول لصخرتي.. آسف يا أستاذ شفيق @مواطن_0003 سلفني 5 قروش.',
          },
        ],
      },
      {
        'id': '2',
        'author': 'مستر سلطع 🦀',
        'avatar': '🦀',
        'clan': 'قبيلة القشريات أصحاب الفلوس',
        'time': 'منذ ساعتين',
        'content': 'تنويه هام: دخول مطعم مقرمشات سلطع مجاني، لكن النفس والفرجة على المنيو بـ 5 قروش مائية! ممنوع إحضار أكل من برة خصوصاً طعمية شمشون المشبوهة! @مواطن_0006 خليك بعيد عن الخزنة!',
        'badge': '🍔 إعلان رسمي',
        'userReaction': '🪑',
        'reactionCounts': {
          '🪑': 310,
          '😂': 150,
          '😡': 45,
          '👍': 30,
          '❤️': 15,
          '🐟': 5,
        },
        'reactors': [
          {'name': 'شمشون العبقري', 'avatar': '🧆', 'citizenId': '#0006', 'reaction': '😡'},
          {'name': 'شفيق المكتئب', 'avatar': '🎺', 'citizenId': '#0007', 'reaction': '🪑'},
          {'name': 'المعلم عضلات', 'avatar': '🦞', 'citizenId': '#0004', 'reaction': '😂'},
          {'name': 'مدام نفيخة', 'avatar': '🐡', 'citizenId': '#0008', 'reaction': '🐟'},
        ],
        'comments': [
          {
            'id': 'c3',
            'author': 'شمشون الشريرة 🧆',
            'avatar': '🧆',
            'citizenId': '#0006',
            'time': 'منذ ساعة',
            'text': 'هسرق سر الخلطة يا سلطع لو حطيت عليها ضريبة مبيعات وقيمة مضافة! 😈',
          },
        ],
      },
      {
        'id': '3',
        'author': 'بسيط نجم النجوم ⭐',
        'avatar': '⭐',
        'clan': 'عشيرة النجوم الكسلانة',
        'time': 'منذ 4 ساعات',
        'content': 'حد شاف مفتاح بيتي؟ أنا دورت تحت الصخرة وفوق الصخرة وجوة بطني ومش لاقيه.. يا ريت اللي يلاقيه يعزمني على غدا عند @مواطن_0001 عشان جعان جداً.',
        'badge': '🔑 مفقودات',
        'userReaction': null,
        'reactionCounts': {
          '❤️': 45,
          '😂': 35,
          '🐟': 20,
          '👍': 15,
        },
        'reactors': [
          {'name': 'سبونج بوب سكوير بانتس', 'avatar': '🧽', 'citizenId': '#0001', 'reaction': '❤️'},
          {'name': 'مدام نفيخة', 'avatar': '🐡', 'citizenId': '#0008', 'reaction': '🐟'},
        ],
        'comments': [
          {
            'id': 'c4',
            'author': 'سبونج بوب 🍍',
            'avatar': '🧽',
            'citizenId': '#0001',
            'time': 'منذ 3 ساعات',
            'text': 'الصخرة معندهاش باب ولا مفتاح يا بسيط! تعالى كول سلطع برجر عندي في الأناناسة! 🍍',
          },
        ],
      },
    ];
  }

  /// Show Admin-Only Posting Restriction AlertDialog
  void _showAdminOnlyDialog() {
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
                // Warning badge icon
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
                  child: const Center(
                    child: Text('📜', style: TextStyle(fontSize: 32)),
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  '⚠️ تصريح نشر مفقود!',
                  style: BikiniTypography.displaySmall(
                    color: BikiniColors.krabsRed,
                  ).copyWith(fontSize: 19),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),

                Text(
                  'يا مواطن يا محترم، النشر حالياً مقتصر على مراسلي ديوان الإعلام الرسمي في قاع الهامور.. ريح زعانفك لحد ما تصريح النشر يطلعلك من البلدية! 📜🪪',
                  style: BikiniTypography.bodyMedium(
                    color: BikiniColors.cartoonBlack,
                  ).copyWith(fontSize: 13, height: 1.45),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),

                BikiniButton.primary(
                  onPressed: () => Navigator.of(ctx).pop(),
                  text: 'علم وينفذ يا باشا 🫡',
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

  /// Toggle or set reaction on a post
  void _handleSelectReaction(Map<String, dynamic> post, String emoji) {
    setState(() {
      final currentReaction = post['userReaction'] as String?;
      final counts = post['reactionCounts'] as Map<String, int>;
      final reactors = post['reactors'] as List<Map<String, String>>;
      final profile = CitizenService.instance.currentProfile.value;
      final userName = profile?.name ?? 'مواطن صالح';
      final userAvatar = profile?.speciesEmoji ?? '🧽';
      final userCitizenId = profile?.id ?? '#0001';

      if (currentReaction == emoji) {
        // Remove reaction
        post['userReaction'] = null;
        counts[emoji] = (counts[emoji] ?? 1) - 1;
        if (counts[emoji]! <= 0) counts.remove(emoji);
        reactors.removeWhere((r) => r['citizenId'] == userCitizenId);
      } else {
        // Deduct previous reaction if any
        if (currentReaction != null) {
          counts[currentReaction] = (counts[currentReaction] ?? 1) - 1;
          if (counts[currentReaction]! <= 0) counts.remove(currentReaction);
          reactors.removeWhere((r) => r['citizenId'] == userCitizenId);
        }
        // Add new reaction
        post['userReaction'] = emoji;
        counts[emoji] = (counts[emoji] ?? 0) + 1;
        reactors.insert(0, {
          'name': userName,
          'avatar': userAvatar,
          'citizenId': userCitizenId,
          'reaction': emoji,
        });
      }
      _activeReactionTrayPostId = null;
    });
  }

  int _getTotalReactions(Map<String, dynamic> post) {
    final counts = post['reactionCounts'] as Map<String, int>? ?? {};
    return counts.values.fold<int>(0, (sum, count) => sum + count);
  }

  List<String> _getTopReactionEmojis(Map<String, dynamic> post) {
    final counts = post['reactionCounts'] as Map<String, int>? ?? {};
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(3).map((e) => e.key).toList();
  }

  /// Show BottomSheet for who reacted to the post
  void _showReactorsBottomSheet(Map<String, dynamic> post) {
    final reactors = post['reactors'] as List<Map<String, String>>? ?? [];
    final total = _getTotalReactions(post);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.75,
              ),
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

                    // Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                    'تفاعلات المواطنين',
                                    style: BikiniTypography.displaySmall().copyWith(fontSize: 17),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          BikiniBadge(
                            text: '$total تفاعل',
                            backgroundColor: BikiniColors.spongeYellow,
                            textColor: BikiniColors.cartoonBlack,
                            fontSize: 10.5,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                    const Divider(color: BikiniColors.cartoonBlack, thickness: 2),

                    // List of reactors
                    Flexible(
                      child: reactors.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Text(
                                  'لسة مفيش مواطنين تفاعلوا مع البوست دا!',
                                  style: BikiniTypography.bodyMedium(color: const Color(0xFF666666)),
                                ),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              itemCount: reactors.length,
                              separatorBuilder: (ctx, i) => const SizedBox(height: 8),
                              itemBuilder: (ctx, i) {
                                final r = reactors[i];
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: BikiniColors.pureWhite,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: BikiniColors.cartoonBlack, width: 2),
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
                                      // Avatar
                                      Container(
                                        width: 38,
                                        height: 38,
                                        decoration: BoxDecoration(
                                          color: BikiniColors.spongeYellow,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: BikiniColors.cartoonBlack, width: 1.8),
                                        ),
                                        child: Center(
                                          child: Text(r['avatar'] ?? '🧽', style: const TextStyle(fontSize: 18)),
                                        ),
                                      ),
                                      const SizedBox(width: 10),

                                      // Name and Citizen ID
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              r['name'] ?? 'مواطن',
                                              style: BikiniTypography.titleBold().copyWith(fontSize: 13.5),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              'رقم القيد: ${r['citizenId'] ?? '#0001'}',
                                              style: BikiniTypography.caption(color: const Color(0xFF666666))
                                                  .copyWith(fontSize: 10.5),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Reaction Emoji Badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: BikiniColors.warmSand,
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: BikiniColors.cartoonBlack, width: 1.5),
                                        ),
                                        child: Text(
                                          r['reaction'] ?? '👍',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),

                    // Close button
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: BikiniButton.secondary(
                        onPressed: () => Navigator.of(ctx).pop(),
                        text: 'إغلاق القائمة 👋',
                        isFullWidth: true,
                        height: 44,
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

  /// Show Comments BottomSheet Modal
  void _showCommentsBottomSheet(Map<String, dynamic> post) {
    final commentController = TextEditingController();
    final comments = post['comments'] as List<Map<String, dynamic>>? ?? [];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          void addNewComment(String text) {
            if (text.trim().isEmpty) return;
            final profile = CitizenService.instance.currentProfile.value;
            final authorName = profile?.name ?? 'مواطن صالح';
            final authorAvatar = profile?.speciesEmoji ?? '🧽';
            final authorId = profile?.id ?? '#0001';

            final newComment = {
              'id': DateTime.now().millisecondsSinceEpoch.toString(),
              'author': authorName,
              'avatar': authorAvatar,
              'citizenId': authorId,
              'time': 'الآن',
              'text': text.trim(),
            };

            setModalState(() {
              comments.add(newComment);
            });
            setState(() {
              // trigger rebuild on main feed
            });
            commentController.clear();
          }

          return Directionality(
            textDirection: TextDirection.rtl,
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 150),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
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
                      // Handle
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

                      // Header
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Text('💬', style: TextStyle(fontSize: 18)),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      'التعليقات والمناقشات',
                                      style: BikiniTypography.displaySmall().copyWith(fontSize: 17),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            BikiniBadge(
                              text: '${comments.length} تعليق',
                              backgroundColor: BikiniColors.marineCyan,
                              textColor: BikiniColors.cartoonBlack,
                              fontSize: 10.5,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),
                      const Divider(color: BikiniColors.cartoonBlack, thickness: 2),

                      // Comments List
                      Flexible(
                        child: comments.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Text(
                                  'كن أول مواطن يعلق على المنشور! 🌊',
                                  style: BikiniTypography.bodyMedium(color: const Color(0xFF666666)),
                                ),
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              itemCount: comments.length,
                              separatorBuilder: (ctx, i) => const SizedBox(height: 10),
                              itemBuilder: (ctx, i) {
                                final c = comments[i];
                                return Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: BikiniColors.pureWhite,
                                    borderRadius: BorderRadius.circular(16),
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Comment Author Row with Expanded protection
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: BikiniColors.spongeYellow,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: BikiniColors.cartoonBlack, width: 1.5),
                                                  ),
                                                  child: Center(
                                                    child: Text(c['avatar'] ?? '🧽', style: const TextStyle(fontSize: 15)),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Flexible(
                                                  child: Text(
                                                    c['author'] ?? 'مواطن',
                                                    style: BikiniTypography.titleBold().copyWith(fontSize: 12.5),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                                  decoration: BoxDecoration(
                                                    color: BikiniColors.warmSand,
                                                    borderRadius: BorderRadius.circular(6),
                                                    border: Border.all(color: BikiniColors.cartoonBlack, width: 1),
                                                  ),
                                                  child: Text(
                                                    c['citizenId'] ?? '#0001',
                                                    style: BikiniTypography.caption(color: BikiniColors.cartoonBlack)
                                                        .copyWith(fontSize: 9.5),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            c['time'] ?? 'الآن',
                                            style: BikiniTypography.caption(color: const Color(0xFF777777))
                                                .copyWith(fontSize: 10),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 6),

                                      // Comment Text with @مواطن_ Highlight
                                      _buildMentionRichText(c['text'] ?? ''),
                                    ],
                                  ),
                                );
                              },
                            ),
                      ),

                      // Quick Mention Chips Bar
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        height: 38,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildQuickMentionChip('@مواطن_0001', commentController),
                            const SizedBox(width: 6),
                            _buildQuickMentionChip('@مواطن_سلطع', commentController),
                            const SizedBox(width: 6),
                            _buildQuickMentionChip('@مواطن_شفيق', commentController),
                            const SizedBox(width: 6),
                            _buildQuickMentionChip('@مواطن_بسيط', commentController),
                            const SizedBox(width: 6),
                            _buildQuickMentionChip('@مواطن_شمشون', commentController),
                          ],
                        ),
                      ),

                      // Input Bar
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
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
                                  controller: commentController,
                                  style: BikiniTypography.bodyMedium().copyWith(fontSize: 13),
                                  onSubmitted: (val) => addNewComment(val),
                                  decoration: InputDecoration(
                                    hintText: 'اكتب تعليقك المائي... (استخدم @مواطن_)',
                                    hintStyle: BikiniTypography.inputHint().copyWith(fontSize: 11.5),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            BikiniButton.primary(
                              onPressed: () => addNewComment(commentController.text),
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
        },
      ),
    );
  }

  Widget _buildQuickMentionChip(String mentionText, TextEditingController controller) {
    return GestureDetector(
      onTap: () {
        controller.text = '${controller.text} $mentionText '.trimLeft();
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: BikiniColors.marineCyan,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: BikiniColors.cartoonBlack, width: 1.2),
        ),
        child: Center(
          child: Text(
            mentionText,
            style: BikiniTypography.captionBold(color: BikiniColors.cartoonBlack).copyWith(fontSize: 10.5),
          ),
        ),
      ),
    );
  }

  /// Renders text with @مواطن_ highlights
  Widget _buildMentionRichText(String text) {
    final words = text.split(' ');
    return Text.rich(
      TextSpan(
        children: words.map((word) {
          if (word.startsWith('@مواطن_') || word.startsWith('@مواطن')) {
            return TextSpan(
              text: '$word ',
              style: BikiniTypography.bodyBold(color: const Color(0xFF007A78)).copyWith(
                fontSize: 12.5,
                backgroundColor: BikiniColors.marineCyan.withValues(alpha: 0.3),
              ),
            );
          }
          return TextSpan(
            text: '$word ',
            style: BikiniTypography.bodyMedium(color: BikiniColors.cartoonBlack).copyWith(
              fontSize: 12.5,
              height: 1.35,
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = CitizenService.instance.currentProfile.value;
    final userAvatar = profile?.speciesEmoji ?? '🧽';

    return Scaffold(
      backgroundColor: BikiniColors.warmSand,
      appBar: const WoodenTopBar(
        title: 'جريدة قاع الهامور 📰',
        unreadCount: 1,
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 120),
          children: [
            // Create Post Bar (Tapping triggers Admin-Only Dialog)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: BikiniColors.pureWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: BikiniColors.cartoonBlack, width: 2.8),
                boxShadow: const [
                  BoxShadow(
                    color: BikiniColors.cartoonBlack,
                    offset: Offset(3.5, 3.5),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: BikiniColors.spongeYellow,
                      shape: BoxShape.circle,
                      border: Border.all(color: BikiniColors.cartoonBlack, width: 2),
                    ),
                    child: Center(
                      child: Text(userAvatar, style: const TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: _showAdminOnlyDialog,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: BikiniColors.warmSand,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: BikiniColors.cartoonBlack, width: 1.5),
                        ),
                        child: Text(
                          'شارك فضيحة أو خبر مائي جديد...',
                          style: BikiniTypography.bodyMedium(color: const Color(0xFF666666))
                              .copyWith(fontSize: 12.5),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    onPressed: _showAdminOnlyDialog,
                    icon: const Icon(Icons.add_photo_alternate_rounded, color: BikiniColors.krabsRed, size: 22),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Newsfeed Posts
            ..._posts.map((post) => _buildPostCard(post)),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    final postId = post['id'] as String;
    final isTrayOpen = _activeReactionTrayPostId == postId;
    final userReaction = post['userReaction'] as String?;
    final totalReactions = _getTotalReactions(post);
    final topEmojis = _getTopReactionEmojis(post);
    final commentsList = post['comments'] as List<Map<String, dynamic>>? ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BikiniColors.pureWhite,
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
          // Author Row with Expanded protection
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: BikiniColors.spongeYellow,
                        shape: BoxShape.circle,
                        border: Border.all(color: BikiniColors.cartoonBlack, width: 2),
                      ),
                      child: Center(
                        child: Text(post['avatar'], style: const TextStyle(fontSize: 18)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post['author'],
                            style: BikiniTypography.titleBold().copyWith(fontSize: 13.5),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${post['clan']} • ${post['time']}',
                            style: BikiniTypography.caption(color: const Color(0xFF777777))
                                .copyWith(fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              BikiniBadge(
                text: post['badge'],
                backgroundColor: BikiniColors.neonPink,
                textColor: BikiniColors.pureWhite,
                fontSize: 10.5,
              ),
            ],
          ),

          const SizedBox(height: 8),
          const Divider(color: BikiniColors.cartoonBlack, thickness: 1.5),
          const SizedBox(height: 4),

          // Post Content with clean Cairo line height & Mention Highlighting
          _buildMentionRichText(post['content']),

          const SizedBox(height: 10),

          // Reaction Stats Row (Stacked Emojis + Total Counter)
          GestureDetector(
            onTap: () => _showReactorsBottomSheet(post),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Stacked Emojis + Total
                Row(
                  children: [
                    if (topEmojis.isNotEmpty)
                      Row(
                        children: topEmojis.map((emoji) {
                          return Container(
                            margin: const EdgeInsets.only(left: 2),
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Text(emoji, style: const TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                      ),
                    const SizedBox(width: 4),
                    Text(
                      '$totalReactions تفاعل',
                      style: BikiniTypography.caption(color: const Color(0xFF666666))
                          .copyWith(fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),

                // Comments Counter
                GestureDetector(
                  onTap: () => _showCommentsBottomSheet(post),
                  child: Text(
                    '${commentsList.length} تعليق',
                    style: BikiniTypography.caption(color: const Color(0xFF666666))
                        .copyWith(fontSize: 11),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),
          const Divider(color: BikiniColors.cartoonBlack, thickness: 1),
          const SizedBox(height: 6),

          // Reaction Tray (Visible when active)
          if (isTrayOpen) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: BikiniColors.pureWhite,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: BikiniColors.cartoonBlack, width: 2.2),
                boxShadow: const [
                  BoxShadow(
                    color: BikiniColors.cartoonBlack,
                    offset: Offset(3, 3),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: reactionOptions.map((opt) {
                  final isSelected = userReaction == opt.emoji;
                  return GestureDetector(
                    onTap: () => _handleSelectReaction(post, opt.emoji),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? opt.color : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected
                            ? Border.all(color: BikiniColors.cartoonBlack, width: 1.5)
                            : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(opt.emoji, style: const TextStyle(fontSize: 22)),
                          Text(
                            opt.label,
                            style: BikiniTypography.caption(
                              color: isSelected ? BikiniColors.cartoonBlack : const Color(0xFF666666),
                            ).copyWith(fontSize: 9),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          // Interactive Action Buttons Row (Like, Comment, Share)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Like / React Button (Tap toggles tray or thumbs up, Long Press opens tray)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _activeReactionTrayPostId = isTrayOpen ? null : postId;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: userReaction != null ? BikiniColors.spongeYellow : BikiniColors.warmSand,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: BikiniColors.cartoonBlack, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Text(userReaction ?? '👍', style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      Text(
                        userReaction != null ? 'تفاعلت' : 'تفاعل',
                        style: BikiniTypography.captionBold().copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),

              // Comment Button
              GestureDetector(
                onTap: () => _showCommentsBottomSheet(post),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: BikiniColors.warmSand,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: BikiniColors.cartoonBlack, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      const Text('💬', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      Text(
                        'تعليق (${commentsList.length})',
                        style: BikiniTypography.captionBold().copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),

              // Share Button
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: BikiniColors.cartoonBlack,
                      content: Text('تم نسخ رابط المنشور لنشره في قاع الهامور! 🌊',
                          style: BikiniTypography.bodyMedium(color: BikiniColors.spongeYellow)),
                    ),
                  );
                },
                icon: const Icon(Icons.share_rounded, color: BikiniColors.cartoonBlack, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
