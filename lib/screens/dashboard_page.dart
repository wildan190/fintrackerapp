import 'package:flutter/material.dart';
import 'package:fintrackerapp/components/sidebar.dart';
import 'package:fintrackerapp/services/budget.dart'; // Import service budget
import 'package:fintrackerapp/services/income.dart'; // Import service income
import 'package:fintrackerapp/services/expenses.dart'; // Import service expenses
import 'budget_page.dart';
import 'income_page.dart';
import 'expenses_page.dart';
import 'monthly_budget_plan_page.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  double totalBudget = 0.0;
  double totalIncome = 0.0;
  double totalExpenses = 0.0;
  List<Map<String, dynamic>> recentIncomes = [];
  List<Map<String, dynamic>> recentExpenses = [];

  // To track the page selection
  static List<Widget> _pages = [
    Center(child: Text('Welcome to the Dashboard!')),
    BudgetPage(),
    IncomePage(),
    ExpensesPage(),
    MonthlyBudgetPlanPage(),
  ];

  static List<String> _titles = [
    'Dashboard',
    'Budget',
    'Income',
    'Expenses',
    'Monthly Plan',
  ];

  // Initialize services
  final BudgetService _budgetService = BudgetService();
  final IncomeService _incomeService = IncomeService();
  final ExpensesService _expensesService = ExpensesService();

  // Load Total Budget
  // Future<void> _loadTotalBudget() async {
  //   try {
  //     final List<Map<String, dynamic>> budgets =
  //         await _budgetService.getBudgets();
  //     double sum = 0.0;
  //     if (budgets.isNotEmpty) {
  //       for (var budget in budgets) {
  //         sum += budget['amount'];
  //       }
  //     }
  //     setState(() {
  //       totalBudget = sum;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       totalBudget = 0.0;
  //     });
  //   }
  // }

  // Load Total Income
  Future<void> _loadTotalIncome() async {
    try {
      final List<Map<String, dynamic>> incomes =
          await _incomeService.getIncomes();
      double sum = 0.0;
      if (incomes.isNotEmpty) {
        for (var income in incomes) {
          sum += income['amount'];
        }
      }
      setState(() {
        totalIncome = sum;
      });
    } catch (e) {
      setState(() {
        totalIncome = 0.0;
      });
    }
  }

  // Load Recent Incomes
  Future<void> _loadRecentIncomes() async {
    try {
      final List<Map<String, dynamic>> incomes =
          await _incomeService.getRecentIncomes();
      setState(() {
        recentIncomes = incomes;
      });
    } catch (e) {
      setState(() {
        recentIncomes = [];
      });
    }
  }

  // Load Total Expenses
  Future<void> _loadTotalExpenses() async {
    try {
      final List<Map<String, dynamic>> expenses =
          await _expensesService.getExpenses();
      double sum = 0.0;
      if (expenses.isNotEmpty) {
        for (var expense in expenses) {
          sum += expense['amount'];
        }
      }
      setState(() {
        totalExpenses = sum;
      });
    } catch (e) {
      setState(() {
        totalExpenses = 0.0;
      });
    }
  }

  // Load Recent Expenses
  Future<void> _loadRecentExpenses() async {
    try {
      final List<Map<String, dynamic>> expenses =
          await _expensesService.getRecentExpenses();
      setState(() {
        recentExpenses = expenses;
      });
    } catch (e) {
      setState(() {
        recentExpenses = [];
      });
    }
  }

  // Pull-to-refresh handler
  Future<void> _onRefresh() async {
    // Show loading indicator during refresh
    await Future.wait([
      // _loadTotalBudget(),
      _loadTotalIncome(),
      _loadRecentIncomes(),
      _loadTotalExpenses(),
      _loadRecentExpenses(),
    ]);
  }

  @override
  void initState() {
    super.initState();
    // Load initial data
    Future.microtask(() async {
      // await _loadTotalBudget();
      await _loadTotalIncome();
      await _loadRecentIncomes();
      await _loadTotalExpenses();
      await _loadRecentExpenses();
    });
  }

  // Method to format Rupiah currency
  String _formatRupiah(double amount) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatCurrency.format(amount);
  }

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Colors.blueAccent,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
        ),
      ),
      drawer: Sidebar(onItemSelected: _onItemSelected),
      body:
          _selectedIndex == 0
              ? RefreshIndicator(
                onRefresh: _onRefresh, // This is the pull-to-refresh callback
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to Your Dashboard',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Budget Card
                      // Card(
                      //   elevation: 4.0,
                      //   child: Padding(
                      //     padding: EdgeInsets.all(16.0),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Text(
                      //               'Total Budget',
                      //               style: TextStyle(
                      //                 fontSize: 18,
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //             SizedBox(height: 8),
                      //             Text(
                      //               _formatRupiah(totalBudget),
                      //               style: TextStyle(
                      //                 fontSize: 20,
                      //                 color: Colors.green,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //         Icon(
                      //           Icons.attach_money,
                      //           size: 40,
                      //           color: Colors.green,
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: 20),

                      // Total Income Card
                      Card(
                        elevation: 4.0,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Income',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    _formatRupiah(totalIncome),
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.trending_up,
                                size: 40,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Total Expenses Card
                      Card(
                        elevation: 4.0,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total Expenses',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    _formatRupiah(totalExpenses),
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.money_off,
                                size: 40,
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Recent Income Card
                      if (recentIncomes.isNotEmpty)
                        Card(
                          elevation: 4.0,
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Recent Income',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Column(
                                  children:
                                      recentIncomes
                                          .map(
                                            (income) => ListTile(
                                              title: Text(
                                                'Income: ${_formatRupiah(income['amount'])}',
                                              ),
                                              subtitle: Text(
                                                'Category: ${income['category']} | Date: ${income['date']}',
                                              ),
                                            ),
                                          )
                                          .toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      SizedBox(height: 20),

                      // Recent Expenses Card
                      if (recentExpenses.isNotEmpty)
                        Card(
                          elevation: 4.0,
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Recent Expenses',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Column(
                                  children:
                                      recentExpenses
                                          .map(
                                            (expense) => ListTile(
                                              title: Text(
                                                'Expense: ${_formatRupiah(expense['amount'])}',
                                              ),
                                              subtitle: Text(
                                                'Category: ${expense['category']} | Date: ${expense['date']}',
                                              ),
                                            ),
                                          )
                                          .toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              )
              : _pages[_selectedIndex], // Show the selected page content
    );
  }
}
