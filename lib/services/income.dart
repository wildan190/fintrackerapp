import 'package:fintrackerapp/db/db_helper.dart'; // Assuming you have DB Helper setup
import 'package:sqflite/sqflite.dart';

class IncomeService {
  final DBHelper _dbHelper = DBHelper();

  // Add Income to the database
  Future<void> addIncome(double amount, String category, String date) async {
    final db = await _dbHelper.database;
    await db.insert('income', {
      'amount': amount,
      'category': category,
      'date': date,
    });
  }

  // Get all income data
  Future<List<Map<String, dynamic>>> getIncomes() async {
    final db = await _dbHelper.database;
    return await db.query('income');
  }

  Future<List<Map<String, dynamic>>> getRecentIncomes() async {
    final List<Map<String, dynamic>> incomes =
        await _dbHelper.getIncomes(); // Mengambil semua pendapatan
    return incomes.take(5).toList(); // Mengambil 5 pendapatan terbaru
  }

  // Update an income record by ID
  Future<void> updateIncome(
    int id,
    double amount,
    String category,
    String date,
  ) async {
    final db = await _dbHelper.database;
    await db.update(
      'income',
      {'amount': amount, 'category': category, 'date': date},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete an income record by ID
  Future<void> deleteIncome(int id) async {
    final db = await _dbHelper.database;
    await db.delete('income', where: 'id = ?', whereArgs: [id]);
  }
}
