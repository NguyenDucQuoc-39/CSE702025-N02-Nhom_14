import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_chi_tieu/screens/authentication/login_screen.dart';
import 'package:quan_ly_chi_tieu/screens/home_screen.dart';
import 'package:quan_ly_chi_tieu/providers/expense_provider.dart';
import 'package:quan_ly_chi_tieu/providers/user_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExpenseProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: CupertinoApp(
        debugShowCheckedModeBanner: false, // Tắt chữ "DEBUG"
        theme: const CupertinoThemeData(
          primaryColor: CupertinoColors.systemTeal,
          brightness: Brightness.light,
        ),
        home: const LoginScreen(),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/login': (context) => const LoginScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/home') {
            return CupertinoPageRoute(builder: (context) => const HomeScreen());
          } else if (settings.name == '/login') {
            return CupertinoPageRoute(
                builder: (context) => const LoginScreen());
          }
          return null;
        },
      ),
    );
  }
}