import 'package:flutter/material.dart';
import 'screens/auth/login_page.dart';
import 'screens/auth/register_page.dart';
import 'screens/dashboard_page.dart'; // Halaman Dashboard setelah login
import 'screens/budget_page.dart'; // Halaman Budget
import 'screens/income_page.dart'; // Halaman Income
import 'screens/expenses_page.dart'; // Halaman Expenses
import 'screens/monthly_budget_plan_page.dart'; // Halaman Monthly Plan

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinTracker App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.teal.shade50,
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade900,
          ),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.teal.shade800),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.teal,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      initialRoute: '/login', // Halaman awal aplikasi
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/dashboard': (context) => DashboardPage(),
        '/budget': (context) => BudgetPage(),
        '/income': (context) => IncomePage(),
        '/expenses': (context) => ExpensesPage(),
        '/monthly_plan': (context) => MonthlyBudgetPlanPage(),
      },
    );
  }
}
