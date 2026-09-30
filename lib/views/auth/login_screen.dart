import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../models/models.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);\n
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;
  bool _isTestMode = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// 테스트 모드: 역할별 직접 입장
  void _enterTestMode(String role) {
    final testUser = User(
      uid: 'test-user-${role}',
      email: 'test.${role}@example.com',
      name: role == 'center_admin' 
        ? '테스트 센터' 
        : role == 'therapist'
          ? '테스트 선생님'
          : '테스트 보호자',
      role: role,
      centerId: 'test-center-001',
      createdAt: DateTime.now(),
    );

    // AuthProvider에 테스트 사용자 설정
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.setTestUser(testUser);

    // 홈 화면으로 이동
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),

              // 로고
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radius16),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  size: 48,
                  color: AppTheme.primary,
                ),
              ),

              const SizedBox(height: AppTheme.spacing24),

              // 제목
              Text(
                '또봐',
                style: AppTheme.headingLarge.copyWith(
                  color: AppTheme.primary,
                ),
              ),

              const SizedBox(height: AppTheme.spacing8),

              Text(
                '센터와 선생님, 보호자가 또 만나는 곳',
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppTheme.spacing32),

              // 테스트 모드 토글
              if (!_isTestMode) ...[
                // 이메일 입력
                _buildTextField(
                  controller: _emailController,
                  label: '이메일',
                  hint: 'example@email.com',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: AppTheme.spacing16),

                // 비밀번호 입력
                _buildTextField(
                  controller: _passwordController,
                  label: '비밀번호',
                  hint: '비밀번호를 입력하세요',
                  prefixIcon: Icons.lock_outlined,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),

                const SizedBox(height: AppTheme.spacing32),

                // 로그인 버튼
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      final authProvider = Provider.of<AuthProvider>(context, listen: false);
                      await authProvider.signIn(
                        _emailController.text,
                        _passwordController.text,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radius12),
                      ),
                    ),
                    child: const Text(
                      '로그인',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppTheme.spacing16),

                // 회원가입 버튼
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '계정이 없으신가요? ',
                      style: AppTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/signup');
                      },
                      child: Text(
                        '회원가입',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppTheme.spacing24),

                // 테스트 모드 시작 버튼
                Divider(color: Colors.grey[300], thickness: 1),
                const SizedBox(height: AppTheme.spacing16),
                Text(
                  '테스트하고 싶으신가요?',
                  style: AppTheme.bodySmall.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: AppTheme.spacing8),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _isTestMode = true;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radius12),
                      ),
                    ),
                    child: const Text(
                      '테스트 모드 시작',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                // 테스트 모드: 역할 선택
                Text(
                  '역할을 선택하세요',
                  style: AppTheme.headingMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppTheme.spacing32),

                // 센터 관리자
                _buildRoleButton(
                  icon: Icons.business,
                  title: '센터 관리자',
                  subtitle: '센터 운영 및 관리',
                  color: Colors.blue,
                  onTap: () => _enterTestMode('center_admin'),
                ),

                const SizedBox(height: AppTheme.spacing16),

                // 선생님
                _buildRoleButton(
                  icon: Icons.person,
                  title: '선생님',
                  subtitle: '치료/교육 진행',
                  color: Colors.green,
                  onTap: () => _enterTestMode('therapist'),
                ),

                const SizedBox(height: AppTheme.spacing16),

                // 보호자
                _buildRoleButton(
                  icon: Icons.family_restroom,
                  title: '보호자',
                  subtitle: '아이 정보 확인',
                  color: Colors.purple,
                  onTap: () => _enterTestMode('parent'),
                ),

                const SizedBox(height: AppTheme.spacing32),

                // 뒤로 가기
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _isTestMode = false;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radius12),
                      ),
                    ),
                    child: const Text(
                      '뒤로 가기',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(prefixIcon, color: AppTheme.primary),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radius12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radius12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radius12),
              borderSide: const BorderSide(color: AppTheme.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(AppTheme.radius12),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radius12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: AppTheme.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTheme.bodySmall.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }
}
