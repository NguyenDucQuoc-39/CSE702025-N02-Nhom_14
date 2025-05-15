import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_chi_tieu/providers/expense_provider.dart';
import 'package:quan_ly_chi_tieu/models/expense.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime displayedMonth = DateTime.now();

  // Cupertino-consistent colors
  final Color _primaryColor = CupertinoColors.activeBlue;
  final Color _accentColor = CupertinoColors.activeGreen;
  final Color _selectedColor = CupertinoColors.activeBlue;
  final Color _textColor = CupertinoColors.black;
  final Color _subtextColor = CupertinoColors.inactiveGray;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExpenseProvider>(context, listen: false).fetchExpenses();
    });
  }

  List<int> _daysInMonth(DateTime date) {
    final lastDay = DateTime(date.year, date.month + 1, 0);
    return List.generate(lastDay.day, (index) => index + 1);
  }

  void _changeMonth(int offset) {
    setState(() {
      displayedMonth =
          DateTime(displayedMonth.year, displayedMonth.month + offset, 1);
    });
  }

  void onDaySelected(int day) {
    setState(() {
      selectedDate = DateTime(displayedMonth.year, displayedMonth.month, day);
    });
    _showTransactionDetails(context);
  }

  // No longer needed, we calculate income/expense directly in the UI
  // int calculateDailyTotal(List<Expense> dailyTransactions) { ... }

  List<Expense> getMonthlyTransactions(List<Expense> allExpenses) {
    return allExpenses
        .where((expense) =>
            expense.date.year == displayedMonth.year &&
            expense.date.month == displayedMonth.month)
        .toList();
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Ăn uống':
        return CupertinoIcons.shopping_cart;
      case 'Mua sắm':
        return CupertinoIcons.bag;
      case 'Di chuyển':
        return CupertinoIcons.car;
      case 'Hóa đơn':
        return CupertinoIcons.doc_text;
      case 'Giải trí':
        return CupertinoIcons.film;
      case 'Khác':
        return CupertinoIcons.ellipsis; //Cupertino equivalent
      default:
        return CupertinoIcons.money_dollar_circle; // Default icon
    }
  }

  void _showTransactionDetails(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
    final dayTransactions = expenseProvider.expenses
        .where((expense) =>
            expense.date.year == selectedDate.year &&
            expense.date.month == selectedDate.month &&
            expense.date.day == selectedDate.day)
        .toList();

    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text(
            'Chi tiết giao dịch ngày ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
            style: TextStyle(
                color: _textColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: [
            if (dayTransactions.isEmpty)
              CupertinoActionSheetAction(
                onPressed: () {},
                child: Text('Không có giao dịch nào.',
                    style: TextStyle(color: _subtextColor)),
              )
            else
              ...dayTransactions.map((transaction) => CupertinoActionSheetAction(
                    onPressed: () {
                      // Handle tap on transaction (optional)
                    },
                    child: Row(
                      children: [
                        Icon(_getIconForCategory(transaction.category),
                            color: _primaryColor, size: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                transaction.category,
                                style: TextStyle(
                                    color: _textColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                transaction.title,
                                style: TextStyle(color: _subtextColor),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${NumberFormat("#,##0", "vi_VN").format(transaction.amount)}đ',
                          style: TextStyle(
                            color: transaction.amount < 0
                                ? CupertinoColors.systemRed
                                : _accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('Đóng'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _daysInMonth(displayedMonth);
    final firstDayOfMonth =
        DateTime(displayedMonth.year, displayedMonth.month, 1);
    final prevMonthDaysCount = firstDayOfMonth.weekday % 7;
    final totalDays = daysInMonth.length + prevMonthDaysCount;

    final weekDays = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"];
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    final monthlyTransactions =
        getMonthlyTransactions(expenseProvider.expenses);

    // Calculate total income and expenses *separately*
    int totalIncome = 0;
    int totalExpenses = 0;

    for (var transaction in monthlyTransactions) {
      if (transaction.type == "Thu nhập") { // Check the 'type' property
        totalIncome += transaction.amount.toInt();
      } else {
        totalExpenses += transaction.amount.toInt().abs(); // Use absolute value
      }
    }


    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemBackground,
      navigationBar: CupertinoNavigationBar(
        middle: Text('Lịch', style: TextStyle(color: _primaryColor)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => _changeMonth(-1),
                        child: Icon(CupertinoIcons.left_chevron,
                            color: _primaryColor),
                      ),
                      Text(
                        "${displayedMonth.month}/${displayedMonth.year}",
                        style: TextStyle(
                            color: _primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => _changeMonth(1),
                        child: Icon(CupertinoIcons.right_chevron,
                            color: _primaryColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Weekdays
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: weekDays.map((day) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: TextStyle(
                            color: (day == "T7" || day == "CN")
                                ? CupertinoColors.systemRed
                                : _primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Calendar
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  itemCount: totalDays,
                  itemBuilder: (context, index) {
                    int day = index - prevMonthDaysCount + 1;
                    bool isFromCurrentMonth = index >= prevMonthDaysCount &&
                        day <= daysInMonth.length;

                    final date = isFromCurrentMonth
                        ? DateTime(displayedMonth.year, displayedMonth.month, day)
                        : null;

                    final isSelected = date != null && selectedDate == date;

                    final dailyTransactions = date != null
                        ? expenseProvider.expenses
                            .where((expense) =>
                                expense.date.year == date.year &&
                                expense.date.month == date.month &&
                                expense.date.day == date.day)
                            .toList()
                        : <Expense>[];

                    // Check if the date has transactions
                    final hasTransactions = dailyTransactions.isNotEmpty;

                    return GestureDetector(
                      onTap:
                          isFromCurrentMonth ? () => onDaySelected(day) : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _selectedColor
                              : (hasTransactions
                                  ? _accentColor.withOpacity(0.2)
                                  : CupertinoColors.systemBackground),
                          borderRadius: BorderRadius.circular(10),
                          border: isSelected
                              ? Border.all(
                                  color: CupertinoColors.white, width: 2)
                              : Border.all(
                                  color: CupertinoColors.systemGrey5, width: 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isFromCurrentMonth ? '$day' : '',
                              style: TextStyle(
                                color: isSelected
                                    ? CupertinoColors.white
                                    : _textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (hasTransactions)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? CupertinoColors.white
                                        : _primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),
                // Summary
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummary('Thu Nhập', totalIncome, _accentColor),
                      _buildSummary(
                          'Chi Tiêu', totalExpenses, CupertinoColors.systemRed),

                      // Use totalIncome and totalExpenses directly
                      _buildSummary('Tổng', totalIncome - totalExpenses,
                          _primaryColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummary(String label, int amount, Color color) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('${NumberFormat("#,##0", "vi_VN").format(amount)}đ',
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}