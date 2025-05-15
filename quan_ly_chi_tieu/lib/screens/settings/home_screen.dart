import 'package:flutter/cupertino.dart';
import 'package:quan_ly_chi_tieu/screens/expenses/add_expense_screen.dart';
import 'package:quan_ly_chi_tieu/screens/settings/settings_screen.dart';
import 'package:quan_ly_chi_tieu/widgets/expense_list.dart';
import 'package:quan_ly_chi_tieu/screens/expenses/statistics_screen.dart';
import 'package:quan_ly_chi_tieu/screens/calendar/calendar_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Thêm SettingsScreen vào danh sách các tùy chọn
  static final List<Widget> _widgetOptions = <Widget>[
    ExpenseList(),
    StatisticsScreen(),
    CalendarScreen(),
    SettingsScreen(), // Thêm màn hình Settings
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: CupertinoColors.systemGrey6,
        activeColor: CupertinoColors.systemTeal,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet),
            label: 'Chi tiêu',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.graph_square),
            label: 'Thống kê',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.calendar),
            label: 'Lịch',
          ),
          BottomNavigationBarItem( // Thêm tab Cài đặt
            icon: Icon(CupertinoIcons.settings),
            label: 'Cài đặt',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            Widget content = _widgetOptions.elementAt(index);

            if (index == 0) {
              return SafeArea(
                child: Stack(
                  children: [
                    content,
                    Positioned(
                      bottom: 16.0,
                      right: 16.0,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const AddExpenseScreen()),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: CupertinoColors.activeBlue,
                            boxShadow: [
                              BoxShadow(
                                color: CupertinoColors.systemGrey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: const Icon(
                            CupertinoIcons.add,
                            color: CupertinoColors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return SafeArea(child: content);
            }
          },
        );
      },
    );
  }
}