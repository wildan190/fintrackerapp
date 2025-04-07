// screens/expenses_page.dart

import 'package:flutter/material.dart';
import 'package:fintrackerapp/services/expenses.dart'; // Import service expenses
import 'package:intl/intl.dart'; // Untuk format tanggal

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  final ExpensesService _expensesService = ExpensesService();
  final TextEditingController _amountController = TextEditingController();
  String _selectedCategory = 'Shopping';
  String _selectedDate = 'Pick a date';

  // Daftar kategori pengeluaran
  final List<String> _categories = [
    'Shopping',
    'Investment',
    'Drink',
    'Food',
    'Transportation',
    'Bill’s',
    'Entertainment',
    'Others',
  ];

  List<Map<String, dynamic>> _expenses = [];

  // Fetch all expenses from the database
  void _loadExpenses() async {
    final expenses = await _expensesService.getExpenses();
    setState(() {
      _expenses = expenses;
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

  // Add new expense
  void _addExpense() {
    final double amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount > 0 &&
        _selectedCategory.isNotEmpty &&
        _selectedDate != 'Pick a date') {
      _expensesService.addExpense(amount, _selectedCategory, _selectedDate);
      _loadExpenses(); // Reload expenses after adding
      _clearForm();
    } else {
      _showMessage('Please fill in all the fields correctly.');
    }
  }

  // Clear the form fields
  void _clearForm() {
    _amountController.clear();
    setState(() {
      _selectedCategory = 'Shopping';
      _selectedDate = 'Pick a date';
    });
  }

  // Menampilkan pesan
  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    _loadExpenses(); // Load expenses saat halaman dimuat
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form untuk menambah pengeluaran
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 10,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Dropdown untuk memilih kategori
            DropdownButton<String>(
              value: _selectedCategory,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
              isExpanded: true,
              items:
                  _categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
            ),
            SizedBox(height: 16),

            // Button untuk memilih tanggal
            GestureDetector(
              onTap: () => _selectDate(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Date',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                child: Text(_selectedDate, style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(height: 16),

            // Button untuk menambah pengeluaran
            ElevatedButton(
              onPressed: _addExpense,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.blueAccent,
              ),
              child: Text('Add Expense'),
            ),
            SizedBox(height: 32),

            // List pengeluaran yang sudah ada
            Expanded(
              child: ListView.builder(
                itemCount: _expenses.length,
                itemBuilder: (context, index) {
                  final expense = _expenses[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 5,
                    child: ListTile(
                      title: Text('Amount: ${expense['amount']}'),
                      subtitle: Text(
                        'Category: ${expense['category']} \nDate: ${expense['date']}',
                        style: TextStyle(color: Colors.black54),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Handle delete action
                          _expensesService.deleteExpense(expense['id']);
                          _loadExpenses(); // Reload expenses after deleting
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
