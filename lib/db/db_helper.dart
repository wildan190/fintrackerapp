import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'fintracker.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Membuat tabel Users untuk login/register
        await db.execute('''
          CREATE TABLE Users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE,
            password TEXT,
            remember_token TEXT
          )
        ''');

        // Membuat tabel Budget
        await db.execute('''
          CREATE TABLE Budget (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount REAL
          )
        ''');

        // Membuat tabel Income
        await db.execute('''
          CREATE TABLE Income (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount REAL,
            category TEXT,
            date TEXT
          )
        ''');

        // Membuat tabel Expenses
        await db.execute('''
          CREATE TABLE Expenses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount REAL,
            category TEXT CHECK (category IN 
              ('Shopping', 'Investment', 'Drink', 'Food', 'Transportation', 
               'Bill’s', 'Entertainment', 'Others')),
            date TEXT
          )
        ''');

        // Membuat tabel MonthlyBudgetPlan
        await db.execute('''
          CREATE TABLE MonthlyBudgetPlan (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category TEXT CHECK (category IN 
              ('electricity', 'telephone', 'internet', 'water', 'debt', 
               'investment', 'basic needs', 'education', 'health', 'entertainment')),
            amount REAL,
            payment_date TEXT
          )
        ''');
      },
    );
  }

  // ========================== CRUD Users ==========================
  Future<int> registerUser(String username, String password) async {
    final db = await database;
    return await db.insert('Users', {
      'username': username,
      'password': password,
    });
  }

  Future<Map<String, dynamic>?> loginUser(
    String username,
    String password,
  ) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'Users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // ========================== CRUD Budget ==========================
  Future<int> addBudget(double amount) async {
    final db = await database;
    return await db.insert('Budget', {'amount': amount});
  }

  Future<List<Map<String, dynamic>>> getBudgets() async {
    final db = await database;
    return await db.query('Budget');
  }

  Future<int> updateBudget(int id, double amount) async {
    final db = await database;
    return await db.update(
      'Budget',
      {'amount': amount},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteBudget(int id) async {
    final db = await database;
    return await db.delete('Budget', where: 'id = ?', whereArgs: [id]);
  }

  // ========================== CRUD Income ==========================
  Future<int> addIncome(double amount, String category, String date) async {
    final db = await database;
    return await db.insert('Income', {
      'amount': amount,
      'category': category,
      'date': date,
    });
  }

  Future<List<Map<String, dynamic>>> getIncomes() async {
    final db = await database;
    return await db.query('Income');
  }

  Future<int> updateIncome(
    int id,
    double amount,
    String category,
    String date,
  ) async {
    final db = await database;
    return await db.update(
      'Income',
      {'amount': amount, 'category': category, 'date': date},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteIncome(int id) async {
    final db = await database;
    return await db.delete('Income', where: 'id = ?', whereArgs: [id]);
  }

  // ========================== CRUD Expenses ==========================
  Future<int> addExpense(double amount, String category, String date) async {
    final db = await database;
    return await db.insert('Expenses', {
      'amount': amount,
      'category': category,
      'date': date,
    });
  }

  Future<List<Map<String, dynamic>>> getExpenses() async {
    final db = await database;
    return await db.query('Expenses');
  }

  Future<int> updateExpense(
    int id,
    double amount,
    String category,
    String date,
  ) async {
    final db = await database;
    return await db.update(
      'Expenses',
      {'amount': amount, 'category': category, 'date': date},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete('Expenses', where: 'id = ?', whereArgs: [id]);
  }

  // ========================== CRUD MonthlyBudgetPlan ==========================
  Future<int> addMonthlyBudgetPlan(
    String category,
    double amount,
    String paymentDate,
  ) async {
    final db = await database;
    return await db.insert('MonthlyBudgetPlan', {
      'category': category,
      'amount': amount,
      'payment_date': paymentDate,
    });
  }

  Future<List<Map<String, dynamic>>> getMonthlyBudgetPlans() async {
    final db = await database;
    return await db.query('MonthlyBudgetPlan');
  }

  Future<int> updateMonthlyBudgetPlan(
    int id,
    String category,
    double amount,
    String paymentDate,
  ) async {
    final db = await database;
    return await db.update(
      'MonthlyBudgetPlan',
      {'category': category, 'amount': amount, 'payment_date': paymentDate},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteMonthlyBudgetPlan(int id) async {
    final db = await database;
    return await db.delete(
      'MonthlyBudgetPlan',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
