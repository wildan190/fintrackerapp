import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fintrackerapp/services/income.dart'; // Assuming you have this service

class IncomePage extends StatefulWidget {
  @override
  _IncomePageState createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  final IncomeService _incomeService = IncomeService();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  String _selectedDate = 'Pick a date';
  List<Map<String, dynamic>> _incomes = [];

  @override
  void initState() {
    super.initState();
    _loadIncomes();
  }

  // Fetch all incomes from the database
  void _loadIncomes() async {
    final incomes = await _incomeService.getIncomes();
    setState(() {
      _incomes = incomes;
    });
  }

  // Date picker to select a date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        _selectedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  // Add new income
  void _addIncome() {
    final double amount = double.tryParse(_amountController.text) ?? 0.0;
    final String category = _categoryController.text;

    if (amount > 0 && category.isNotEmpty && _selectedDate != 'Pick a date') {
      _incomeService.addIncome(amount, category, _selectedDate);
      _loadIncomes(); // Reload incomes after adding
      _clearForm();
    }
  }

  // Clear the form fields
  void _clearForm() {
    _amountController.clear();
    _categoryController.clear();
    setState(() {
      _selectedDate = 'Pick a date';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Income Form
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // Date Picker Button
            GestureDetector(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                child: Text(_selectedDate),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addIncome,
              child: Text('Add Income'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor:
                    Colors
                        .blueAccent, // Use 'backgroundColor' instead of 'primary'
              ),
            ),
            SizedBox(height: 32),
            // Income List
            Expanded(
              child: ListView.builder(
                itemCount: _incomes.length,
                itemBuilder: (context, index) {
                  final income = _incomes[index];
                  return Card(
                    child: ListTile(
                      title: Text('${income['category']}'),
                      subtitle: Text(
                        'Amount: ${income['amount']} \nDate: ${income['date']}',
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Handle delete action
                          _incomeService.deleteIncome(income['id']);
                          _loadIncomes(); // Reload incomes after deleting
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
