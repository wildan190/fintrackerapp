import 'package:sqflite/sqflite.dart';
import '../db/db_helper.dart';

class BudgetService {
  final DBHelper _databaseHelper = DBHelper();

  // 🔹 Insert Budget
  Future<int> addBudget(double amount) async {
    final db = await _databaseHelper.database;
    return await db.insert('budget', {'amount': amount});
  }

  // 🔹 Get All Budgets
  Future<List<Map<String, dynamic>>> getBudgets() async {
    final db = await _databaseHelper.database;
    return await db.query('budget', orderBy: "id DESC");
  }

  // 🔹 Update Budget (Edit)
  Future<int> updateBudget(int id, double amount) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'budget',
      {'amount': amount},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 🔹 Delete Budget
  Future<int> deleteBudget(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete('budget', where: 'id = ?', whereArgs: [id]);
  }
}
