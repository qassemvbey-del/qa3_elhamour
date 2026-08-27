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
            backgroundColor: BikiniColors.danger,
            content: Text(
              'عطل في بوابة الجمارك: $errorMsg',
              style: BikiniTypography.body(color: BikiniColors.card),
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
      backgroundColor: BikiniColors.paper,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: BikiniRadius.screenMargin,
                vertical: BikiniSpacing.space24,
              ),
              child: Column(
                children: [
                  // Customs Header Card
                  _buildHeaderCard(),

                  const SizedBox(height: BikiniSpacing.space16),

                  // Main Google Auth Container
                  Container(
                    padding: const EdgeInsets.all(BikiniSpacing.space16),
                    decoration: BikiniDecorations.interactiveCard(
                      backgroundColor: BikiniColors.card,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: BikiniSpacing.space8),

                        Text(
                          'تسجيل الدخول الرسمي 🌐',
                          style: BikiniTypography.h1(color: BikiniColors.deep),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: BikiniSpacing.space8),
                        Text(
                          'جمهورية قاع الهامور تعتمد المصادقة عبر Google OAuth فقط لحماية بيانات المواطنين وسجل الممتلكات.',
                          style: BikiniTypography.body(color: BikiniColors.muted),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: BikiniSpacing.space24),

                        // The ONLY primary yellow button on screen as required by 02-ui-system.md
                        BikiniButton.primary(
                          onPressed: _isLoading ? null : _handleGoogleSignIn,
                          text: _isLoading
                              ? 'جاري التحويل لبوابة Google... ⏳'
                              : 'المتابعة بواسطة Google 🌐',
                          isFullWidth: true,
                          height: 50,
                        ),

                        const SizedBox(height: BikiniSpacing.space16),
                      ],
                    ),
                  ),

                  const SizedBox(height: BikiniSpacing.space16),

                  // Bottom Satirical Notice
                  Text(
                    '⚠️ تحذير رسمي: محاولة الدخول ببيانات مزورة تعرضك للتنظيف الإجباري في مطبخ سلطع برجر!',
                    style: BikiniTypography.caption(color: BikiniColors.muted),
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
      padding: const EdgeInsets.all(BikiniSpacing.space16),
      decoration: BikiniDecorations.interactiveCard(
        backgroundColor: BikiniColors.card,
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: BikiniColors.paper,
              shape: BoxShape.circle,
              border: Border.all(
                color: BikiniColors.ink,
                width: BikiniRadius.borderWidth,
              ),
            ),
            child: const Center(
              child: Text('🛂', style: TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: BikiniSpacing.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'بوابة جمارك قاع الهامور',
                        style: BikiniTypography.h2(color: BikiniColors.deep),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: BikiniSpacing.space8),
                    const BikiniBadge(
                      text: 'نقطة تفتيش 🚨',
                      backgroundColor: BikiniColors.alert,
                      textColor: BikiniColors.card,
                    ),
                  ],
                ),
                const SizedBox(height: BikiniSpacing.space4),
                Text(
                  'سجل دخولك بـ Google للدخول إلى الجمهورية!',
                  style: BikiniTypography.caption(color: BikiniColors.muted),
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


