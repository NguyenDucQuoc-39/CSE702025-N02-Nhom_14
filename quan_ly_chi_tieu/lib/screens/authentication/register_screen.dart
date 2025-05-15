
import 'package:flutter/cupertino.dart';
import 'package:quan_ly_chi_tieu/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text(
          'Đăng Ký',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: CupertinoColors.systemBackground,
        automaticallyImplyLeading: false,
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isLandscape = constraints.maxWidth > constraints.maxHeight;
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: isLandscape
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: _buildForm(),
                            flex: 2,
                          ),
                          const SizedBox(width: 20),
                          Flexible(
                            child: _buildImage(isLandscape: true),
                            flex: 1,
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _buildImage(isLandscape: false),
                          _buildForm(),
                        ],
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImage({required bool isLandscape}) {
    return Image.asset(
      'assets/images/logo.png',
      height: isLandscape ? 300 : 250, // Tăng kích thước khi xoay ngang
      width: isLandscape ? 300 : null, // Đặt chiều rộng khi xoay ngang
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          const Text(
            'Tạo tài khoản mới',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.label,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Điền thông tin để đăng ký',
            style: TextStyle(
              fontSize: 16,
              color: CupertinoColors.secondaryLabel,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          // Email Field
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.systemGrey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CupertinoTextField(
              controller: _emailController,
              placeholder: 'Email',
              prefix: const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(CupertinoIcons.mail,
                    color: CupertinoColors.systemGrey),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground,
                border: Border.all(color: CupertinoColors.systemGrey4),
                borderRadius: BorderRadius.circular(12),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          const SizedBox(height: 16),
          // Username Field
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.systemGrey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CupertinoTextField(
              controller: _usernameController,
              placeholder: 'Username',
              prefix: const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(CupertinoIcons.person,
                    color: CupertinoColors.systemGrey),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground,
                border: Border.all(color: CupertinoColors.systemGrey4),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Password Field
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.systemGrey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CupertinoTextField(
              controller: _passwordController,
              placeholder: 'Mật khẩu',
              prefix: const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(CupertinoIcons.lock,
                    color: CupertinoColors.systemGrey),
              ),
              suffix: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Icon(
                  _obscureText ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                  color: CupertinoColors.systemGrey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              obscureText: _obscureText,
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground,
                border: Border.all(color: CupertinoColors.systemGrey4),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Confirm Password Field
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.systemGrey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CupertinoTextField(
              controller: _confirmPasswordController,
              placeholder: 'Nhập Lại Mật khẩu',
              prefix: const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(CupertinoIcons.lock,
                    color: CupertinoColors.systemGrey),
              ),
              suffix: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Icon(
                  _obscureText ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                  color: CupertinoColors.systemGrey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              obscureText: _obscureText,
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground,
                border: Border.all(color: CupertinoColors.systemGrey4),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Register Button
          SizedBox(
            width: double.infinity,
            child: CupertinoButton.filled(
              padding: const EdgeInsets.symmetric(vertical: 16),
              borderRadius: BorderRadius.circular(12),
              child: _isLoading
                  ? const CupertinoActivityIndicator()
                  : const Text(
                      'Đăng ký',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  if (_passwordController.text !=
                      _confirmPasswordController.text) {
                    _showErrorDialog(context, 'Mật khẩu nhập lại không khớp');
                    return;
                  }
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    await AuthService().register(
                      _emailController.text,
                      _passwordController.text,
                      _usernameController.text,
                    );
                    // Show success dialog
                    _showSuccessDialog(context);
                  } catch (e) {
                    _showErrorDialog(context, e.toString());
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 24),
          // Login Section
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Đã có tài khoản? ',
                style: TextStyle(color: CupertinoColors.secondaryLabel),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text(
                  'Đăng nhập ngay',
                  style: TextStyle(color: CupertinoColors.systemBlue),
                ),
                onPressed: () {
                  Navigator.pop(context); // Quay lại màn hình đăng nhập
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Hàm hiển thị dialog thành công
  void _showSuccessDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Thành công'),
          content: const Text('Đăng ký thành công!'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
                Navigator.pop(context); // Quay lại màn hình đăng nhập
              },
            ),
          ],
        );
      },
    );
  }

  // Hàm hiển thị dialog lỗi
  void _showErrorDialog(BuildContext context, String errorMessage) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Lỗi'),
          content: Text(errorMessage),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
