import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:quan_ly_chi_tieu/providers/expense_provider.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  // Creates the pie chart section data.  No changes needed here.
  List<PieChartSectionData> _getSections(Map<String, double> data) {
    final List<Color> colors = [
      CupertinoColors.activeBlue,
      CupertinoColors.systemRed,
      CupertinoColors.activeGreen,
      CupertinoColors.systemOrange,
      CupertinoColors.systemYellow,
      CupertinoColors.systemPurple,
      CupertinoColors.systemTeal, // Add more colors if you have more categories
      CupertinoColors.systemPink,
      CupertinoColors.systemIndigo,
      CupertinoColors.secondarySystemBackground,
      CupertinoColors.extraLightBackgroundGray,
      CupertinoColors.systemBlue,
      CupertinoColors.black,
      CupertinoColors.systemBrown,
      CupertinoColors.systemGrey,
      CupertinoColors.systemMint,

    ];
    return data.entries.map((entry) {
      final index = data.keys.toList().indexOf(entry.key);
      final color = colors[index % colors.length]; // Cycle through colors
      return PieChartSectionData(
        color: color,
        value: entry.value.abs(),
        title: '',  // REMOVE title from the section itself
        radius: 80, // Adjust radius as needed, smaller for more space
        // titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: CupertinoColors.white), // No title style needed
        showTitle: false, // Hide the title *inside* the pie chart
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);

    double totalExpenses = expenseProvider.expenses.fold(
        0, (sum, item) => sum + item.amount);

    Map<String, double> categoryExpenses = {};

    for (var expense in expenseProvider.expenses) {
      // Accumulate expenses per category, taking absolute value
      categoryExpenses[expense.category] =
          (categoryExpenses[expense.category] ?? 0) + expense.amount.abs();
    }

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Thống kê Chi tiêu'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade50, Colors.white],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Tổng chi tiêu: ${NumberFormat("#,##0", "vi_VN").format(totalExpenses.abs())} VNĐ', //Format
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Chi tiêu theo danh mục:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 400,  
                    child: PieChart(
                      PieChartData(
                        sections: _getSections(categoryExpenses),
                        centerSpaceRadius: 0,  // Make it a full pie chart, not a donut
                        sectionsSpace: 2,     // khoảng các giữa vùng
                        pieTouchData: PieTouchData(
                            touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          if (event is FlTapUpEvent &&
                              pieTouchResponse != null &&
                              pieTouchResponse.touchedSection != null) {
                            final touchedSectionIndex =
                                pieTouchResponse.touchedSection!.touchedSectionIndex;
                            final touchedCategory = categoryExpenses.keys
                                .elementAt(touchedSectionIndex);
                            _showCategoryDetails(
                                context,
                                touchedCategory,
                                categoryExpenses[
                                    touchedCategory]!); // Show details on tap
                          }
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Add spacing

                  // Legend (Category and Color)
                  Wrap( // Use Wrap for legend items
                      spacing: 8.0, // Horizontal spacing
                      runSpacing: 8.0, // Vertical spacing
                      alignment: WrapAlignment.center, // Center the legend items
                      children: categoryExpenses.keys.map((category) {
                      final index = categoryExpenses.keys.toList().indexOf(category);
                      final color = _getSections(categoryExpenses)[index].color; // Get color from sections
                        return Row(
                          mainAxisSize: MainAxisSize.min, // Important for Wrap
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(category, style: const TextStyle(fontSize: 16, color: Colors.blue)),
                          ],
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Dialog for category details (no changes needed here)
  void _showCategoryDetails(BuildContext context, String category, double amount) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(category, style: const TextStyle(color: Colors.blue)),
          content: Text(
              'Tổng chi tiêu: ${NumberFormat("#,##0", "vi_VN").format(amount)} VNĐ', style: const TextStyle(color: Colors.blue)), // Format
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Đóng', style: TextStyle(color: Colors.blue)),
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