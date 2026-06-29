import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:trackify/components/empty_state.dart';
import 'package:trackify/components/expense_summary.dart';
import 'package:trackify/components/expense_tile.dart';
import 'package:trackify/data/expense_data.dart';
import 'package:trackify/models/expense_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final expenseNameController = TextEditingController();
  final dollarController = TextEditingController();
  final centController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isIncome = false;
  bool isFabExtended = true;
  String selectedCategory = 'Other';
  DateTime selectedDate = DateTime.now();

  final List<String> expenseCategories = [
    'Food',
    'Travel',
    'Shopping',
    'Bills',
    'Entertainment',
    'Health',
    'Other'
  ];

  final List<String> incomeCategories = [
    'Salary',
    'Freelancing',
    'Business',
    'Investment',
    'Gift',
    'Pocket Money',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    Provider.of<ExpenseData>(context, listen: false).prepareData();

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (isFabExtended) {
          setState(() {
            isFabExtended = false;
          });
        }
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (!isFabExtended) {
          setState(() {
            isFabExtended = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _presentDatePicker(StateSetter setState) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(isIncome ? "Add Income" : "Add Expense"),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Income/Expense Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: const Text("Expense"),
                      selected: !isIncome,
                      onSelected: (val) {
                        setState(() {
                          isIncome = !val;
                          selectedCategory = 'Other';
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text("Income"),
                      selected: isIncome,
                      onSelected: (val) {
                        setState(() {
                          isIncome = val;
                          selectedCategory = 'Other';
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: expenseNameController,
                  decoration: InputDecoration(
                    labelText: isIncome ? "Income Source" : "What did you buy?",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(isIncome ? Icons.account_balance_wallet_outlined : Icons.shopping_bag_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: "Category",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.category_outlined),
                  ),
                  items: (isIncome ? incomeCategories : expenseCategories)
                      .map((String category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                // Date Picker
                InkWell(
                  onTap: () => _presentDatePicker(setState),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_month_outlined, color: Colors.grey),
                        const SizedBox(width: 12),
                        Text(
                          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: dollarController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Rupees",
                          prefixText: "₹",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: centController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Cents",
                          prefixText: "¢",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: cancelExpense, child: const Text("Cancel")),
            ElevatedButton(
              onPressed: saveExpense,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  void saveExpense() {
    if (expenseNameController.text.isNotEmpty &&
        (dollarController.text.isNotEmpty || centController.text.isNotEmpty)) {
      final dollars = int.tryParse(dollarController.text) ?? 0;
      final cents = int.tryParse(centController.text) ?? 0;
      final totalAmount = dollars + (cents / 100);

      ExpenseItem newItem = ExpenseItem(
        name: expenseNameController.text,
        amount: totalAmount.toStringAsFixed(2),
        dateTime: selectedDate,
        isIncome: isIncome,
        category: selectedCategory,
      );

      Provider.of<ExpenseData>(context, listen: false).addNewExpense(newItem);

      Navigator.pop(context);
      clearControllers();
    }
  }

  void cancelExpense() {
    Navigator.pop(context);
    clearControllers();
  }

  void clearControllers() {
    expenseNameController.clear();
    dollarController.clear();
    centController.clear();
    isIncome = false;
    selectedCategory = 'Other';
    selectedDate = DateTime.now();
  }

  void deleteTransaction(ExpenseItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Transaction?"),
        content: const Text("Are you sure you want to delete this entry?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Provider.of<ExpenseData>(context, listen: false).deleteExpense(item);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Transaction deleted"), duration: Duration(seconds: 2)),
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String amount, IconData icon, List<Color> colors, BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colors.last.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Text(amount, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: const Text("Trackify", style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              onPressed: () => value.toggleTheme(),
              icon: Icon(value.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            ),
          ],
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.brown.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            onPressed: addNewExpense,
            isExtended: isFabExtended,
            label: const Text(
              "New Entry",
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
            icon: const Icon(Icons.add_rounded, size: 28),
            backgroundColor: Colors.brown.shade700,
            foregroundColor: Colors.white,
            elevation: 0, // Handled by Container shadow
          ),
        ),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main Balance Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: value.isDarkMode
                            ? [Colors.brown.shade900, Colors.brown.shade600]
                            : [Colors.brown.shade700, Colors.brown.shade400],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          const Text("Total Balance", style: TextStyle(color: Colors.white70, fontSize: 16)),
                          const SizedBox(height: 8),
                          Text(
                            "₹${value.getBalance().toStringAsFixed(2)}",
                            style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Income & Expense Cards
                    Row(
                      children: [
                        _buildStatCard(
                          "Income",
                          "₹${value.getTotalIncome().toStringAsFixed(2)}",
                          Icons.arrow_downward,
                          [Colors.green.shade700, Colors.green.shade400],
                          context,
                        ),
                        const SizedBox(width: 16),
                        _buildStatCard(
                          "Expenses",
                          "₹${value.getTotalExpenses().toStringAsFixed(2)}",
                          Icons.arrow_upward,
                          [Colors.red.shade700, Colors.red.shade400],
                          context,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Weekly Spending",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: ExpenseSummary(startOfWeek: value.startOfWeekDate()),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Recent Transactions",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (value.getAllExpenseData().isEmpty)
              SliverToBoxAdapter(
                child: EmptyState(onActionPressed: addNewExpense),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final items = value.getAllExpenseData().reversed.toList();
                      final item = items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: ExpenseTile(
                          amount: item.amount,
                          dateTime: item.dateTime,
                          name: item.name,
                          deleteTapped: (context) => deleteTransaction(item),
                          isIncome: item.isIncome,
                          category: item.category,
                        ),
                      );
                    },
                    childCount: value.getAllExpenseData().length,
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}
