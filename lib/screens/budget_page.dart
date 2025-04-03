import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/budget.dart';

class BudgetPage extends StatefulWidget {
  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final BudgetService _budgetService = BudgetService();
  final TextEditingController _amountController = TextEditingController();
  List<Map<String, dynamic>> _budgetList = [];

  @override
  void initState() {
    super.initState();
    _loadBudgets();
  }

  // 🔹 Load Budget Data
  void _loadBudgets() async {
    final data = await _budgetService.getBudgets();
    setState(() {
      _budgetList = data;
    });
  }

  // 🔹 Add or Update Budget
  void _showBudgetDialog({int? id, double? existingAmount}) {
    _amountController.text =
        existingAmount != null ? existingAmount.toString() : '';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(id == null ? "Tambah Budget" : "Edit Budget"),
            content: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Masukkan Jumlah (Rp)"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final double? amount = double.tryParse(
                    _amountController.text,
                  );
                  if (amount != null) {
                    if (id == null) {
                      await _budgetService.addBudget(amount);
                    } else {
                      await _budgetService.updateBudget(id, amount);
                    }
                    _amountController.clear();
                    _loadBudgets();
                    Navigator.pop(context);
                  }
                },
                child: Text(id == null ? "Tambah" : "Update"),
              ),
            ],
          ),
    );
  }

  // 🔹 Delete Budget
  void _deleteBudget(int id) async {
    await _budgetService.deleteBudget(id);
    _loadBudgets();
  }

  // 🔹 Format ke Rupiah
  String _formatRupiah(double amount) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatCurrency.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Budget",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _showBudgetDialog(),
              child: Text("Tambah Budget"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _budgetList.length,
                itemBuilder: (context, index) {
                  final item = _budgetList[index];
                  return Card(
                    child: ListTile(
                      title: Text(_formatRupiah(item['amount'])),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed:
                                () => _showBudgetDialog(
                                  id: item['id'],
                                  existingAmount: item['amount'],
                                ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteBudget(item['id']),
                          ),
                        ],
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
