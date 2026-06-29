import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpenseTile extends StatelessWidget {
  final String name;
  final String amount;
  final DateTime dateTime;
  final void Function(BuildContext)? deleteTapped;
  final bool isIncome;
  final String category;

  const ExpenseTile({
    super.key,
    required this.amount,
    required this.dateTime,
    required this.name,
    required this.deleteTapped,
    this.isIncome = false,
    this.category = 'Other',
  });

  IconData getCategoryIcon(String category) {
    switch (category) {
      // Expense Icons
      case 'Food':
        return Icons.fastfood_outlined;
      case 'Travel':
        return Icons.directions_bus_outlined;
      case 'Shopping':
        return Icons.shopping_cart_outlined;
      case 'Bills':
        return Icons.receipt_outlined;
      case 'Entertainment':
        return Icons.movie_outlined;
      case 'Health':
        return Icons.medical_services_outlined;
      
      // Income Icons
      case 'Salary':
        return Icons.monetization_on_outlined;
      case 'Freelancing':
        return Icons.laptop_outlined;
      case 'Business':
        return Icons.storefront_outlined;
      case 'Investment':
        return Icons.trending_up_outlined;
      case 'Gift':
        return Icons.card_giftcard_outlined;
      case 'Pocket Money':
        return Icons.savings_outlined;
        
      default:
        return Icons.category_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: deleteTapped,
            icon: Icons.delete,
            backgroundColor: Colors.red.shade400,
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          onLongPress: () {
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
                      deleteTapped!(context);
                      Navigator.pop(context);
                    },
                    child: const Text("Delete", style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isIncome
                    ? Colors.green.withOpacity(0.1)
                    : Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                getCategoryIcon(category),
                color: isIncome
                    ? Colors.green.shade700
                    : Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            title: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${dateTime.day}/${dateTime.month}/${dateTime.year}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${isIncome ? '+' : '-'}₹$amount',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: isIncome ? Colors.green.shade700 : Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => deleteTapped!(context),
                  icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
