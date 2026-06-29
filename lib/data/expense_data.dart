import 'package:flutter/material.dart';
import 'package:trackify/data/hive_database.dart';
import 'package:trackify/date_time/date_time_helper.dart';
import 'package:trackify/models/expense_item.dart';

class ExpenseData extends ChangeNotifier {
  // list of all items
  List<ExpenseItem> allExpenseList = [];

  // theme state
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  // get items list
  List<ExpenseItem> getAllExpenseData() {
    return allExpenseList;
  }

  // displaying data from database
  final db = HiveDataBase();
  void prepareData() {
    if (db.getAllExpenses().isNotEmpty) {
      allExpenseList = db.getAllExpenses();
    }
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  // add new Item
  void addNewExpense(ExpenseItem newExpense) {
    allExpenseList.add(newExpense);
    db.saveData(allExpenseList);
    notifyListeners();
  }

  // delete Item
  void deleteExpense(ExpenseItem expense) {
    allExpenseList.remove(expense);
    db.saveData(allExpenseList);
    notifyListeners();
  }

  // Summary calculations
  double getTotalIncome() {
    double total = 0;
    for (var item in allExpenseList) {
      if (item.isIncome) {
        total += double.parse(item.amount);
      }
    }
    return total;
  }

  double getTotalExpenses() {
    double total = 0;
    for (var item in allExpenseList) {
      if (!item.isIncome) {
        total += double.parse(item.amount);
      }
    }
    return total;
  }

  double getBalance() {
    return getTotalIncome() - getTotalExpenses();
  }

  //get weekday from a datetime object
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return "Friday";
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return '';
    }
  }

  //get the date for the start of week (sunday)
  DateTime startOfWeekDate() {
    DateTime today = DateTime.now();
    for (int i = 0; i < 7; i++) {
      DateTime date = today.subtract(Duration(days: i));
      if (date.weekday == DateTime.sunday) {
        return date;
      }
    }
    return today;
  }

  // convert items to a daily summary (only expenses for the graph)
  Map<String, double> calculateDailyExpenseSummary() {
    Map<String, double> dailyExpenseSummary = {};
    for (var item in allExpenseList) {
      if (!item.isIncome) {
        String date = convertDateTimeToString(item.dateTime);
        double amount = double.parse(item.amount);

        if (dailyExpenseSummary.containsKey(date)) {
          dailyExpenseSummary[date] = dailyExpenseSummary[date]! + amount;
        } else {
          dailyExpenseSummary[date] = amount;
        }
      }
    }
    return dailyExpenseSummary;
  }
}
