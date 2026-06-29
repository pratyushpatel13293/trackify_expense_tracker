import 'package:hive_flutter/adapters.dart';
import 'package:trackify/models/expense_item.dart';

class HiveDataBase {
  // reference our box
  final _mybox = Hive.box("trackify_database");

  // write data
  void saveData(List<ExpenseItem> allExpense) {
    List<List<dynamic>> allExpenseFormatted = [];
    for (var expense in allExpense) {
      List<dynamic> expenseFormatted = [
        expense.name,
        expense.amount,
        expense.dateTime,
        expense.isIncome,
        expense.category,
      ];
      allExpenseFormatted.add(expenseFormatted);
    }
    _mybox.put("ALL_EXPENSES", allExpenseFormatted);
  }

  // read data
  List<ExpenseItem> getAllExpenses() {
    List<dynamic> savedExpenses = _mybox.get("ALL_EXPENSES") ?? [];
    List<ExpenseItem> allExpenses = [];

    for (var expense in savedExpenses) {
      allExpenses.add(
        ExpenseItem(
          name: expense[0],
          amount: expense[1],
          dateTime: expense[2],
          isIncome: expense.length > 3 ? expense[3] : false,
          category: expense.length > 4 ? expense[4] : 'Other',
        ),
      );
    }
    return allExpenses;
  }
}
