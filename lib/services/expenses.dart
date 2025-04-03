// services/expenses.dart

import 'package:fintrackerapp/db/db_helper.dart'; // Import database helper

class ExpensesService {
  final DBHelper _dbHelper = DBHelper(); // Database helper untuk CRUD

  // Fungsi untuk menambahkan pengeluaran
  Future<int> addExpense(double amount, String category, String date) async {
    final db = await _dbHelper.database;
    return await db.insert('expenses', {
      'amount': amount,
      'category': category,
      'date': date,
    });
  }

  // Fungsi untuk mendapatkan semua pengeluaran
  Future<List<Map<String, dynamic>>> getExpenses() async {
    final db = await _dbHelper.database;
    return await db.query('expenses');
  }

  Future<List<Map<String, dynamic>>> getRecentExpenses() async {
    final List<Map<String, dynamic>> expenses =
        await _dbHelper.getExpenses(); // Mengambil semua pengeluaran
    return expenses.take(5).toList(); // Mengambil 5 pengeluaran terbaru
  }

  // Fungsi untuk menghapus pengeluaran berdasarkan ID
  Future<int> deleteExpense(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  // Fungsi untuk mengupdate pengeluaran
  Future<int> updateExpense(
    int id,
    double amount,
    String category,
    String date,
  ) async {
    final db = await _dbHelper.database;
    return await db.update(
      'expenses',
      {'amount': amount, 'category': category, 'date': date},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
