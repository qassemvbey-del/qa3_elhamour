import 'package:flutter/material.dart';
import '../../core/services/citizen_service.dart';
import '../../core/services/supabase_service.dart';
import '../../core/theme/bikini_theme.dart';
import '../../core/widgets/bikini_badge.dart';
import '../../core/widgets/bikini_button.dart';

/// Customs & Authentication Screen for "جمهورية قاع الهامور"
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isSignUp = false;
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleEmailAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      setState(() {
        _errorMessage = 'يا مواطن، اكتب بريد إلكتروني صحيح ومعتمد في القاع! 📧';
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        _errorMessage = 'كلمة المرور لازم تكون ٦ خانات على الأقل عشان الجمارك تقبلها! 🔒';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_isSignUp) {
        final res = await SupabaseService.instance.signUpWithEmail(email, password);
        if (res.user != null) {
          CitizenService.instance.setAuthenticatedOrGuest(true);
          widget.onAuthSuccess?.call();
        } else {
          setState(() {
            _errorMessage = 'تم إرسال رابط تأكيد للبريد! راجع بريدك يا معلم 📨';
          });
        }
      } else {
        final res = await SupabaseService.instance.signInWithEmail(email, password);
        if (res.user != null) {
          CitizenService.instance.setAuthenticatedOrGuest(true);
          widget.onAuthSuccess?.call();
        }
      }
    } catch (e) {
      setState(() {
        final err = e.toString().toLowerCase();
        if (err.contains('invalid login credentials') || err.contains('invalid_grant')) {
          _errorMessage = 'بيانات الدخول غلط يا مواطن! اتأكد من الإيميل والباسورد ❌';
        } else if (err.contains('user already registered')) {
          _errorMessage = 'الإيميل دا مسجل عندنا في الجمارك قبل كده! سجل دخول 🔑';
        } else {
          _errorMessage = 'عطل في شبكة الجمارك: ${e.toString().replaceAll('Exception:', '')}';
        }
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await SupabaseService.instance.signInWithGoogle();
      CitizenService.instance.setAuthenticatedOrGuest(true);
      widget.onAuthSuccess?.call();
    } catch (e) {
      setState(() {
        _errorMessage = 'تعذر الاتصال بـ Google! جرب الدخول المباشر بالبريد 🌐';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleGuestBypass() {
    CitizenService.instance.setAuthenticatedOrGuest(true);
    widget.onAuthSuccess?.call();
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  // Customs Header Card
                  _buildHeaderCard(),

                  const SizedBox(height: 14),

                  // Main Neo-Brutalism Auth Form Box
                  Container(
                    padding: const EdgeInsets.all(16),
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
                        // Mode Toggle Tabs
                        _buildTabToggle(),

                        const SizedBox(height: 16),

                        // Error Banner if present
                        if (_errorMessage != null) ...[
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFCCD5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: BikiniColors.krabsRed, width: 2),
                            ),
                            child: Row(
                              children: [
                                const Text('⚠️', style: TextStyle(fontSize: 18)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: BikiniTypography.captionBold(color: BikiniColors.krabsRed)
                                        .copyWith(fontSize: 11.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],

                        // Email Field
                        Text(
                          'البريد الإلكتروني البحري:',
                          style: BikiniTypography.titleBold().copyWith(fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: BikiniColors.pureWhite,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: BikiniColors.cartoonBlack, width: 2),
                          ),
                          child: TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: BikiniTypography.bodyMedium().copyWith(fontSize: 13.5),
                            decoration: InputDecoration(
                              hintText: 'sponge@bikini-bottom.gov',
                              hintStyle: BikiniTypography.inputHint().copyWith(fontSize: 12.5),
                              icon: const Text('📧', style: TextStyle(fontSize: 16)),
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Password Field
                        Text(
                          'كلمة المرور المشفرة:',
                          style: BikiniTypography.titleBold().copyWith(fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: BikiniColors.pureWhite,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: BikiniColors.cartoonBlack, width: 2),
                          ),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: BikiniTypography.bodyMedium().copyWith(fontSize: 13.5),
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              hintStyle: BikiniTypography.inputHint().copyWith(fontSize: 12.5),
                              icon: const Text('🔒', style: TextStyle(fontSize: 16)),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: BikiniColors.cartoonBlack,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Primary Action Button
                        BikiniButton.primary(
                          onPressed: _isLoading ? null : _handleEmailAuth,
                          text: _isLoading
                              ? 'جاري التحقق من الجمارك... ⏳'
                              : _isSignUp
                                  ? 'إنشاء تصريح جديد 📝'
                                  : 'دخول الجمهورية 🚀',
                          isFullWidth: true,
                          height: 46,
                        ),

                        const SizedBox(height: 14),

                        // Divider
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(color: BikiniColors.cartoonBlack, thickness: 1.5),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                'أو الدخول السريع عبر',
                                style: BikiniTypography.caption(color: const Color(0xFF666666))
                                    .copyWith(fontSize: 11),
                              ),
                            ),
                            const Expanded(
                              child: Divider(color: BikiniColors.cartoonBlack, thickness: 1.5),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Google Sign In Button
                        BikiniButton.secondary(
                          onPressed: _isLoading ? null : _handleGoogleSignIn,
                          text: 'الدخول بحساب Google 🌐',
                          isFullWidth: true,
                          height: 44,
                        ),

                        const SizedBox(height: 10),

                        // Guest / Fast Bypass Button
                        BikiniButton.secondary(
                          onPressed: _isLoading ? null : _handleGuestBypass,
                          text: 'الدخول السريع كزائر بحري مجهول 🤿',
                          isFullWidth: true,
                          height: 40,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Bottom Satirical Notice
                  Text(
                    '⚠️ تحذير: الدخول بدون تصريح يعرضك للتنظيف الإجباري في مطبخ مقرمشات سلطع!',
                    style: BikiniTypography.caption(color: const Color(0xFF666666)).copyWith(fontSize: 10.5),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BikiniColors.spongeYellow,
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
      child: Column(
        children: [
          Row(
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
                      'اثبت هويتك البحرية وتصريح الإقامة للدخول!',
                      style: BikiniTypography.bodyMedium(color: const Color(0xFF333333)).copyWith(fontSize: 11.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: BikiniColors.warmSand,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BikiniColors.cartoonBlack, width: 2),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isSignUp = false;
                  _errorMessage = null;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: !_isSignUp ? BikiniColors.marineCyan : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: !_isSignUp
                      ? Border.all(color: BikiniColors.cartoonBlack, width: 1.8)
                      : Border.all(color: Colors.transparent, width: 1.8),
                ),
                child: Center(
                  child: Text(
                    'تسجيل الدخول 🔑',
                    style: BikiniTypography.captionBold(
                      color: !_isSignUp ? BikiniColors.cartoonBlack : const Color(0xFF555555),
                    ).copyWith(fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isSignUp = true;
                  _errorMessage = null;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: _isSignUp ? BikiniColors.spongeYellow : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: _isSignUp
                      ? Border.all(color: BikiniColors.cartoonBlack, width: 1.8)
                      : Border.all(color: Colors.transparent, width: 1.8),
                ),
                child: Center(
                  child: Text(
                    'مواطن جديد 📝',
                    style: BikiniTypography.captionBold(
                      color: _isSignUp ? BikiniColors.cartoonBlack : const Color(0xFF555555),
                    ).copyWith(fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
