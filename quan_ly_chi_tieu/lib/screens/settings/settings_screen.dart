// screens/settings/settings_screen.dart

import 'package:flutter/cupertino.dart';
import 'package:quan_ly_chi_tieu/screens/settings/profile_screen.dart'; // Import ProfileScreen
import 'package:quan_ly_chi_tieu/screens/authentication/login_screen.dart'; // Import trang login

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showLogoutConfirmation(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Đăng xuất'),
              onPressed: () {
                // TODO: Xử lý đăng xuất (xóa token, dữ liệu người dùng, v.v.)
                // Sau khi đăng xuất, chuyển hướng về màn hình đăng nhập
                Navigator.of(context).pop(); // Đóng hộp thoại
                Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) =>
                      false, // Xóa tất cả các màn hình trước đó
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Cài đặt'),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            CupertinoListTile(
              title: const Text('Thông tin cá nhân'),
              leading: const Icon(CupertinoIcons.person_circle),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              },
            ),
            CupertinoListTile(
              title: const Text(
                'Đăng xuất',
                style: TextStyle(color: CupertinoColors.destructiveRed),
              ),
              leading: const Icon(
                CupertinoIcons.square_arrow_left,
                color: CupertinoColors.destructiveRed,
              ),
              onTap: () =>
                  _showLogoutConfirmation(context), // Gọi hàm hiển thị xác nhận
            ),
            // Các tùy chọn cài đặt khác (nếu có)
          ],
        ),
      ),
    );
  }
}
