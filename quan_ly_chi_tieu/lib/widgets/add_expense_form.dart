import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quan_ly_chi_tieu/models/expense.dart';
import 'package:quan_ly_chi_tieu/providers/expense_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class AddExpenseForm extends StatefulWidget {
  final Expense? expense;

  const AddExpenseForm({super.key, this.expense});

  @override
  _AddExpenseFormState createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final Uuid uuid = const Uuid();
  String? _selectedCategory;
  String? _selectedType;
  DateTime _selectedDate = DateTime.now();
  final List<String> _categories = [
    'Chọn phân loại',
    'Ăn uống',
    'Nhà cửa',
    'Xe cộ',
    'Làm đẹp',
    'Quần áo',
    'Du lịch',
    'Lương',
    'Học phí',
    'Di chuyển',
    'Giải trí',
    'Sức khỏe',
    'Khác'
  ];
  final List<String> _types = ['Thu nhập', 'Chi tiêu'];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _titleController.text = widget.expense!.title;
      _amountController.text = widget.expense!.amount.abs().toString();
      _selectedCategory = widget.expense!.category;
      _selectedType = widget.expense!.type;
      _selectedDate = widget.expense!.date;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground.resolveFrom(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildInputField(
                      controller: _titleController,
                      icon: CupertinoIcons.pencil_outline,
                      label: 'Tiêu đề',
                      placeholder: 'Nhập tiêu đề giao dịch',
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      controller: _amountController,
                      icon: CupertinoIcons.money_dollar,
                      label: 'Số tiền',
                      placeholder: 'Nhập số tiền',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 25),
                    _buildTypeSelector(),
                    const SizedBox(height: 25),
                    _buildCategorySelector(),
                    const SizedBox(height: 25),
                    _buildDateSelector(),
                    const SizedBox(height: 30),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
            if (_isLoading) _buildLoadingOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    required String placeholder,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 4),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
          ),
        ),
        CupertinoTextField(
          controller: controller,
          prefix: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Icon(icon, size: 20),
          ),
          placeholder: placeholder,
          keyboardType: keyboardType,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
            border: Border.all(color: CupertinoColors.opaqueSeparator),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8),
          child: Text(
            'Loại giao dịch',
            style: TextStyle(
              fontSize: 16,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
          ),
        ),
        Row(
          children: _types
              .map((type) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: CupertinoButton(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        color: _selectedType == type
                            ? (type == 'Thu nhập'
                                ? CupertinoColors.activeGreen
                                : CupertinoColors.systemRed)
                            : CupertinoColors.tertiarySystemFill,
                        borderRadius: BorderRadius.circular(8),
                        child: Text(
                          type,
                          style: TextStyle(
                            color: _selectedType == type
                                ? CupertinoColors.white
                                : CupertinoColors.label.resolveFrom(context),
                          ),
                        ),
                        onPressed: () => setState(() => _selectedType = type),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8),
          child: Text(
            'Phân loại',
            style: TextStyle(
              fontSize: 16,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
          ),
        ),
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _showCategoryPicker,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
              border: Border.all(color: CupertinoColors.opaqueSeparator),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(_getCategoryIcon(_selectedCategory), size: 20),
                const SizedBox(width: 12),
                Text(
                  _selectedCategory ?? 'Chọn phân loại',
                  style: TextStyle(
                    color: _selectedCategory == null
                        ? CupertinoColors.placeholderText.resolveFrom(context)
                        : CupertinoColors.label.resolveFrom(context),
                  ),
                ),
                const Spacer(),
                const Icon(CupertinoIcons.chevron_down, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8),
          child: Text(
            'Ngày giao dịch',
            style: TextStyle(
              fontSize: 16,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
          ),
        ),
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => _showDatePicker(context),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: CupertinoColors.tertiarySystemFill.resolveFrom(context),
              border: Border.all(color: CupertinoColors.opaqueSeparator),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(CupertinoIcons.calendar, size: 20),
                const SizedBox(width: 12),
                Text(
                  DateFormat('dd/MM/yyyy').format(_selectedDate),
                ),
                const Spacer(),
                const Icon(CupertinoIcons.chevron_forward, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return CupertinoButton(
      color: CupertinoColors.activeBlue,
      borderRadius: BorderRadius.circular(10),
      padding: const EdgeInsets.symmetric(vertical: 16),
      onPressed: _submitForm,
      child: Text(
        widget.expense == null ? 'Thêm giao dịch' : 'Cập nhật giao dịch',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: CupertinoColors.systemBackground.withOpacity(0.8),
      child: const Center(
        child: CupertinoActivityIndicator(radius: 14),
      ),
    );
  }

  IconData _getCategoryIcon(String? category) {
    switch (category) {
      case 'Ăn uống':
        return CupertinoIcons.bag_fill;
      case 'Nhà cửa':
        return CupertinoIcons.house_fill;
      case 'Xe cộ':
        return CupertinoIcons.car_detailed;
      case 'Làm đẹp':
        return CupertinoIcons.heart_fill;
      case 'Quần áo':
        return CupertinoIcons.bag_fill;
      case 'Du lịch':
        return CupertinoIcons.airplane;
      case 'Lương':
        return CupertinoIcons.money_dollar_circle_fill;
      case 'Học phí':
        return CupertinoIcons.book_fill;
      case 'Di chuyển':
        return CupertinoIcons.car_detailed;
      case 'Giải trí':
        return CupertinoIcons.game_controller;
      case 'Sức khỏe':
        return CupertinoIcons.heart_fill;
      case 'Khác':
        return CupertinoIcons.question_circle_fill;
      default:
        return CupertinoIcons.tag;
    }
  }

  void _showCategoryPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.4, // Giới hạn chiều cao
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.3, // Chiều cao cho Picker
              child: CupertinoPicker(
                itemExtent: 40,
                onSelectedItemChanged: (index) {
                  setState(() => _selectedCategory = _categories[index]);
                },
                children: _categories
                    .map((category) => Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(_getCategoryIcon(category), size: 20),
                              const SizedBox(width: 8),
                              Text(category),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
            CupertinoButton(
              child: const Text('Xong'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: CupertinoDatePicker(
              initialDateTime: _selectedDate,
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (DateTime newDate) {
                setState(() {
                  _selectedDate = newDate;
                });
              },
            ),
          ),
        );
      },
    );
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedCategory == null) {
        _showErrorDialog(context, 'Vui lòng chọn phân loại');
        return;
      }
      if (_selectedType == null) {
        _showErrorDialog(context, 'Vui lòng chọn loại giao dịch');
        return;
      }
      final expense = Expense(
        id: widget.expense?.id ?? uuid.v4(),
        title: _titleController.text,
        amount: (_selectedType == "Chi tiêu")
            ? -double.parse(_amountController.text)
            : double.parse(_amountController.text),
        date: _selectedDate,
        category: _selectedCategory!,
        type: _selectedType!,
      );
      setState(() => _isLoading = true);
      try {
        if (widget.expense == null) {
          await Provider.of<ExpenseProvider>(context, listen: false)
              .addExpense(expense);
          if (mounted) Navigator.pop(context);
          _showSuccessDialog(context, true);
        } else {
          await Provider.of<ExpenseProvider>(context, listen: false)
              .updateExpense(expense);
          if (mounted) Navigator.pop(context);
          _showSuccessDialog(context, false);
        }
      } catch (e) {
        if (mounted) _showErrorDialog(context, e.toString());
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Lỗi'),
          content: Text(errorMessage),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context, bool isAdd) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Thành công'),
          content: Text(isAdd
              ? 'Thêm giao dịch thành công!'
              : 'Cập nhật giao dịch thành công'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}