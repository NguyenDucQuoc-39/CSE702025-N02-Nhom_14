import 'package:flutter/cupertino.dart';
import 'package:quan_ly_chi_tieu/widgets/add_expense_form.dart';

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Thêm giao dịch'),
      ),
      child: SafeArea(  // Add SafeArea
        child: AddExpenseForm(), // Use the form here
    ),
    );
  }
}