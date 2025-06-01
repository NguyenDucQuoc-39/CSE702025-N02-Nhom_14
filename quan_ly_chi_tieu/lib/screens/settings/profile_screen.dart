import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_chi_tieu/providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.getUserData();
      final userData = userProvider.currentUser;
      if (userData != null) {
        _usernameController.text = userData.username;
        _emailController.text = userData.email;
      } else {
        _showErrorDialog('Không tìm thấy thông tin người dùng.');
      }
    } catch (e) {
      _showErrorDialog('Lỗi tải thông tin người dùng: $e');
    } finally {
      setState(() {});
    }
  }

  void _showErrorDialog(String errorMessage) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Lỗi'),
          content: Text(errorMessage),
          actions: <Widget>[
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Thông tin cá nhân'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [CupertinoColors.activeBlue, CupertinoColors.systemIndigo],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: CupertinoColors.white,
                child: Icon(CupertinoIcons.person, size: 50, color: CupertinoColors.activeBlue),
              ),
            ),
            // Information fields
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildInfoField('Tên người dùng', _usernameController),
                  const SizedBox(height: 20),
                  _buildInfoField('Email', _emailController),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: CupertinoColors.systemGrey,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        CupertinoTextField(
          controller: controller,
          decoration: BoxDecoration(
            color: CupertinoColors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: CupertinoColors.systemGrey,
            ),
          ),
          padding: const EdgeInsets.all(12),
          readOnly: true, // Chỉ đọc
        ),
      ],
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}