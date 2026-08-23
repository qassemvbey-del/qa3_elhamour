import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qa3_elhamour/core/services/citizen_service.dart';
import 'package:qa3_elhamour/core/services/supabase_service.dart';
import 'package:qa3_elhamour/features/auth/auth_screen.dart';
import 'package:qa3_elhamour/features/cafe/fish_cafe_screen.dart';
import 'package:qa3_elhamour/features/cafe/game_room_screen.dart';
import 'package:qa3_elhamour/features/cafe/services/cafe_room_service.dart';
import 'package:qa3_elhamour/features/civil_id/civil_id_screen.dart';
import 'package:qa3_elhamour/features/home/home_screen.dart';
import 'package:qa3_elhamour/features/home/widgets/notifications_modal.dart';
import 'package:qa3_elhamour/features/navigation/main_shell.dart';
import 'package:qa3_elhamour/features/news/news_feed_screen.dart';
import 'package:qa3_elhamour/features/onboarding/citizen_onboarding_screen.dart';
import 'package:qa3_elhamour/main.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    SupabaseService.instance.enableCloudSync = false;
    await CitizenService.instance.logoutOrReset();
    CafeRoomService.instance.reset();
  });

  testWidgets('App root loads AuthScreen first by default', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 2, 844 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const Qa3ElhamourApp());
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byType(Qa3ElhamourApp), findsOneWidget);
    expect(find.byType(AuthScreen), findsOneWidget);
    expect(find.text('بوابة جمارك قاع الهامور'), findsOneWidget);
  });

  testWidgets('AuthScreen guest bypass opens CitizenOnboardingScreen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400 * 2, 850 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const Qa3ElhamourApp());
    await tester.pump(const Duration(milliseconds: 200));

    // Tap guest bypass button
    final guestBtn = find.text('الدخول السريع كزائر بحري مجهول 🤿');
    expect(guestBtn, findsOneWidget);
    await tester.tap(guestBtn);
    await tester.pump(const Duration(milliseconds: 200));

    // Onboarding screen appears
    expect(find.byType(CitizenOnboardingScreen), findsOneWidget);

    // Scroll down to find the issue button
    final issueBtn = find.text('استخرج بطاقة مواطن قاع الهامور 🌊');
    await tester.scrollUntilVisible(
      issueBtn,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump(const Duration(milliseconds: 200));

    expect(issueBtn, findsOneWidget);
    await tester.tap(issueBtn);
    await tester.pump(const Duration(milliseconds: 200));

    // Dialog appears
    expect(find.text('ادخل الجمهورية دلوقتي 🍍🚀'), findsOneWidget);
    await tester.tap(find.text('ادخل الجمهورية دلوقتي 🍍🚀'));
    await tester.pump(const Duration(milliseconds: 300));

    // MainShell is visible
    expect(find.byType(MainShell), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Session persistence recovers citizen on launch / web refresh', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 2, 844 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    // Register citizen which saves to SharedPreferences
    await CitizenService.instance.registerCitizen(
      name: 'سبونج بوب المصري',
      species: CitizenService.availableSpecies.first,
      job: CitizenService.availableJobs.first,
      crime: CitizenService.availableCrimes.first,
    );

    // Simulate app reload / web refresh F5
    await CitizenService.instance.init();

    await tester.pumpWidget(const Qa3ElhamourApp());
    await tester.pump(const Duration(milliseconds: 200));

    // Should bypass auth and onboarding and directly show MainShell
    expect(find.byType(MainShell), findsOneWidget);
    expect(find.byType(AuthScreen), findsNothing);
    expect(find.byType(CitizenOnboardingScreen), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('All tabs render without layout overflows on 360px width', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360 * 2, 700 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    // Register citizen first
    await CitizenService.instance.registerCitizen(
      name: 'سبونج بوب المصري',
      species: CitizenService.availableSpecies.first,
      job: CitizenService.availableJobs.first,
      crime: CitizenService.availableCrimes.first,
    );

    // Test MainShell
    await tester.pumpWidget(
      const MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: MainShell(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byType(HomeScreen), findsOneWidget);

    // Switch to Civil ID
    await tester.tap(find.text('السجل المدني'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(CivilIdScreen), findsOneWidget);

    // Switch to Newsfeed
    await tester.tap(find.text('جريدة القاع'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(NewsFeedScreen), findsOneWidget);

    // Switch to Fish Cafe
    await tester.tap(find.text('قهوة العم فيش'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(FishCafeScreen), findsOneWidget);
  });

  testWidgets('NewsFeedScreen admin restriction dialog displays correctly', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 2, 844 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: NewsFeedScreen(),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));

    // Tap the create post bar
    final postBar = find.text('شارك فضيحة أو خبر مائي جديد...');
    expect(postBar, findsOneWidget);
    await tester.tap(postBar);
    await tester.pump(const Duration(milliseconds: 200));

    // Dialog appears
    expect(find.text('⚠️ تصريح نشر مفقود!'), findsOneWidget);
    expect(find.text('علم وينفذ يا باشا 🫡'), findsOneWidget);

    // Close dialog
    await tester.tap(find.text('علم وينفذ يا باشا 🫡'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('⚠️ تصريح نشر مفقود!'), findsNothing);
  });

  testWidgets('NewsFeedScreen comments modal and mentions work', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 2, 844 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await CitizenService.instance.registerCitizen(
      name: 'سبونج بوب المصري',
      species: CitizenService.availableSpecies.first,
      job: CitizenService.availableJobs.first,
      crime: CitizenService.availableCrimes.first,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: NewsFeedScreen(),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));

    // Tap comment button on first post
    final commentBtn = find.textContaining('تعليق (').first;
    await tester.tap(commentBtn);
    await tester.pump(const Duration(milliseconds: 200));

    // Modal is open
    expect(find.text('التعليقات والمناقشات'), findsOneWidget);

    // Tap quick mention chip
    final mentionChip = find.text('@مواطن_0001');
    expect(mentionChip, findsOneWidget);
    await tester.tap(mentionChip, warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 100));

    // Send comment
    final sendBtn = find.text('إرسال 🚀');
    expect(sendBtn, findsOneWidget);
    await tester.tap(sendBtn, warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 200));

    // Verify comment is in list
    expect(find.textContaining('@مواطن_0001'), findsWidgets);
  });

  testWidgets('FishCafeScreen 6-digit search, game rooms, and beverage ordering work', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390 * 2, 844 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await CitizenService.instance.registerCitizen(
      name: 'سبونج بوب المصري',
      species: CitizenService.availableSpecies.first,
      job: CitizenService.availableJobs.first,
      crime: CitizenService.availableCrimes.first,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: FishCafeScreen(),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));

    // Check Cafe screen loaded
    expect(find.text('ترابيزات القهوة والألعاب الحية'), findsOneWidget);

    // Open Beverage Menu
    final menuBtn = find.text('منيو المشاريب 🫖');
    expect(menuBtn, findsOneWidget);
    await tester.tap(menuBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify menu items
    expect(find.text('منيو طلبات العم فيش'), findsOneWidget);
    expect(find.text('شاي طحالب مغلية 🫖'), findsWidgets);

    // Order Tea (15 shells)
    final orderTeaBtn = find.text('اطلب 🫖').first;
    await tester.tap(orderTeaBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Balance should be deducted from 100 to 85
    expect(CitizenService.instance.shellsBalance.value, 85);

    // Search 6-digit room code 492015
    final searchInput = find.byType(TextField).first;
    await tester.enterText(searchInput, '492015');
    await tester.pump(const Duration(milliseconds: 100));

    final joinByCodeBtn = find.text('دخول 🚀');
    await tester.tap(joinByCodeBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // GameRoomScreen should be loaded
    expect(find.byType(GameRoomScreen), findsOneWidget);
    expect(find.textContaining('492015'), findsWidgets);

    // Open floating chat 💬
    final chatBubble = find.text('💬');
    expect(chatBubble, findsOneWidget);
    await tester.tap(chatBubble);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Send preset message
    final presetMsg = find.text('🧽 هيه هيه! 🍍');
    expect(presetMsg, findsOneWidget);
    await tester.tap(presetMsg);
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.textContaining('أنا جاهز ومبسوط يا رجالة!'), findsWidgets);
  });

  testWidgets('Notifications modal renders cleanly', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(380 * 2, 800 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: NotificationsModal(),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('تنبيهات ديوان القاع'), findsOneWidget);
  });
}
