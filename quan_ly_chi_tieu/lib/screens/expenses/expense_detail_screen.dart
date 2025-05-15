
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/models/expense.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_chi_tieu/widgets/edit_expense_form.dart';

class ExpenseDetailScreen extends StatelessWidget {
  final Expense expense;

  const ExpenseDetailScreen({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final isIncome = expense.type.trim().toLowerCase() == 'income' || 
                 expense.type.trim().toLowerCase() == 'thu nhập';
    final amountColor = isIncome ? Colors.green : Colors.red;
    final icon = isIncome ? CupertinoIcons.arrow_down_circle_fill : CupertinoIcons.arrow_up_circle_fill;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Chi tiết giao dịch',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        border: null,
        previousPageTitle: "Trở về",
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Header Section
              _buildHeader(context, amountColor, icon, isIncome),
              const SizedBox(height: 32),
              _buildDetailsSection(context),
              const SizedBox(height: 32),
              _buildEditButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color amountColor, IconData icon, bool isIncome) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [amountColor.withOpacity(0.2), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            expense.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            '${NumberFormat("#,##0", "vi_VN").format(expense.amount)}₫',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: amountColor,
            ),
          ),
          const SizedBox(height: 16),
          Icon(
            icon,
            color: amountColor,
            size: 50,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          _buildDetailTile(CupertinoIcons.tag_fill, 'Phân loại', expense.category),
          _buildDivider(),
          _buildDetailTile(CupertinoIcons.calendar, 'Ngày thực hiện', DateFormat('dd/MM/yyyy - HH:mm').format(expense.date)),
        ],
      ),
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
      borderRadius: BorderRadius.circular(20),
      color: CupertinoColors.activeBlue,
      onPressed: () async {
        final updatedExpense = await Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => EditExpenseForm(expense: expense),
          ),
        );
        if (updatedExpense != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cập nhật giao dịch thành công!'),
              duration: Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(CupertinoIcons.pencil, size: 24, color: CupertinoColors.white),
          const SizedBox(width: 8),
          Text(
            'Chỉnh sửa',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: CupertinoColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Divider(
        height: 1,
        thickness: 0.8,
        color: Colors.grey.withOpacity(0.2),
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Icon(icon, size: 28, color: CupertinoColors.systemGrey),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: CupertinoColors.secondaryLabel, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: CupertinoColors.label),
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
