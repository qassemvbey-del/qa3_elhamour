import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/services/citizen_service.dart';
import 'core/services/supabase_service.dart';
import 'core/theme/bikini_theme.dart';
import 'core/widgets/undersea_background.dart';
import 'features/navigation/main_shell.dart';
import 'features/onboarding/citizen_onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.instance.init();
  await CitizenService.instance.init();
  runApp(const Qa3ElhamourApp());
}

class Qa3ElhamourApp extends StatelessWidget {
  const Qa3ElhamourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'جمهورية قاع الهامور',
      debugShowCheckedModeBanner: false,
      theme: BikiniTheme.themeData,
      // Full RTL Arabic localization
      locale: const Locale('ar', ''),
      supportedLocales: const [
        Locale('ar', ''),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: UnderseaBackground(
          child: ValueListenableBuilder<CitizenProfile?>(
            valueListenable: CitizenService.instance.currentProfile,
            builder: (context, profile, _) {
              if (profile == null) {
                return const CitizenOnboardingScreen();
              }
              return const MainShell();
            },
          ),
        ),
      ),
    );
  }
}
