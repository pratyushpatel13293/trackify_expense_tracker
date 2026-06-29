import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackify/bar_graph/bar_graph.dart';
import 'package:trackify/data/expense_data.dart';
import 'package:trackify/date_time/date_time_helper.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const ExpenseSummary({super.key, required this.startOfWeek});

  double calculateMaxY(
    Map<String, double> dailySummary,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ) {
    List<double> values = [
      dailySummary[sunday] ?? 0,
      dailySummary[monday] ?? 0,
      dailySummary[tuesday] ?? 0,
      dailySummary[wednesday] ?? 0,
      dailySummary[thursday] ?? 0,
      dailySummary[friday] ?? 0,
      dailySummary[saturday] ?? 0,
    ];

    values.sort();
    double max = values.last * 1.1;

    return max == 0 ? 100 : max;
  }

  @override
  Widget build(BuildContext context) {
    String sunday = convertDateTimeToString(startOfWeek.add(const Duration(days: 0)));
    String monday = convertDateTimeToString(startOfWeek.add(const Duration(days: 1)));
    String tuesday = convertDateTimeToString(startOfWeek.add(const Duration(days: 2)));
    String wednesday = convertDateTimeToString(startOfWeek.add(const Duration(days: 3)));
    String thursday = convertDateTimeToString(startOfWeek.add(const Duration(days: 4)));
    String friday = convertDateTimeToString(startOfWeek.add(const Duration(days: 5)));
    String saturday = convertDateTimeToString(startOfWeek.add(const Duration(days: 6)));

    return Consumer<ExpenseData>(
      builder: (context, value, child) {
        final dailySummary = value.calculateDailyExpenseSummary();

        // calculate weekly total
        double weeklyTotal = 0;
        dailySummary.forEach((key, val) => weeklyTotal += val);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  const Text(
                    "Weekly Total: ",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  Text(
                    "₹${weeklyTotal.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: MyBarGraph(
                maxY: calculateMaxY(dailySummary, sunday, monday, tuesday,
                    wednesday, thursday, friday, saturday),
                sunAmount: dailySummary[sunday] ?? 0,
                monAmount: dailySummary[monday] ?? 0,
                tuesAmount: dailySummary[tuesday] ?? 0,
                wedAmount: dailySummary[wednesday] ?? 0,
                thusAmount: dailySummary[thursday] ?? 0,
                friAmount: dailySummary[friday] ?? 0,
                satAmount: dailySummary[saturday] ?? 0,
              ),
            ),
          ],
        );
      },
    );
  }
}
