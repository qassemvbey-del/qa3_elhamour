import 'package:flutter/material.dart';
import '../../core/services/supabase_service.dart';
import '../../core/theme/bikini_theme.dart';
import '../../core/widgets/bikini_badge.dart';
import '../../core/widgets/bikini_button.dart';

/// Customs & Authentication Screen for "جمهورية قاع الهامور"
/// Google OAuth ONLY as per 00-context.md & 01-database.md
class AuthScreen extends StatefulWidget {
  final VoidCallback? onAuthSuccess;

  const AuthScreen({
    super.key,
    this.onAuthSuccess,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;

  void _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await SupabaseService.instance.signInWithGoogle();
      widget.onAuthSuccess?.call();
    } catch (e) {
      if (mounted) {
        final errorMsg = e.toString().replaceAll('Exception:', '').trim();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: BikiniColors.krabsRed,
            content: Text(
              'عطل في بوابة الجمارك: $errorMsg',
              style: BikiniTypography.bodyMedium(color: BikiniColors.pureWhite),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BikiniColors.warmSand,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  // Customs Header Card
                  _buildHeaderCard(),

                  const SizedBox(height: 20),

                  // Main Google Auth Container
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: BikiniColors.pureWhite,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: BikiniColors.cartoonBlack, width: 3.2),
                      boxShadow: const [
                        BoxShadow(
                          color: BikiniColors.cartoonBlack,
                          offset: Offset(4, 4),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),

                        Text(
                          'تسجيل الدخول الرسمي 🌐',
                          style: BikiniTypography.titleBold(color: BikiniColors.deepNavy).copyWith(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'جمهورية قاع الهامور تعتمد المصادقة عبر Google OAuth فقط لحماية بيانات المواطنين وسجل الممتلكات.',
                          style: BikiniTypography.bodyMedium(color: const Color(0xFF444444)).copyWith(fontSize: 13),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 24),

                        // The ONLY primary yellow button on screen as required by 02-ui-system.md
                        BikiniButton.primary(
                          onPressed: _isLoading ? null : _handleGoogleSignIn,
                          text: _isLoading
                              ? 'جاري التحويل لبوابة Google... ⏳'
                              : 'المتابعة بواسطة Google 🌐',
                          isFullWidth: true,
                          height: 50,
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Bottom Satirical Notice
                  Text(
                    '⚠️ تحذير رسمى: محاولة الدخول ببيانات مزورة تعرضك للتنظيف الإجباري في مطبخ سلطع برجر!',
                    style: BikiniTypography.caption(color: const Color(0xFF666666)).copyWith(fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BikiniColors.warmSand,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BikiniColors.cartoonBlack, width: 3.2),
        boxShadow: const [
          BoxShadow(
            color: BikiniColors.cartoonBlack,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: BikiniColors.pureWhite,
              shape: BoxShape.circle,
              border: Border.all(color: BikiniColors.cartoonBlack, width: 2.2),
            ),
            child: const Center(
              child: Text('🛂', style: TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'بوابة جمارك قاع الهامور',
                        style: BikiniTypography.displaySmall().copyWith(fontSize: 17),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    BikiniBadge(
                      text: 'نقطة تفتيش 🚨',
                      backgroundColor: BikiniColors.krabsRed,
                      textColor: BikiniColors.pureWhite,
                      fontSize: 9,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'سجل دخولك بـ Google للدخول إلى الجمهورية!',
                  style: BikiniTypography.bodyMedium(color: const Color(0xFF333333)).copyWith(fontSize: 11.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

