import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/borrow_service.dart';

class ItemCard extends StatefulWidget {
  final Item item;

  const ItemCard({super.key, required this.item});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  final BorrowService borrowService = BorrowService();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: Text(
                widget.item.itemName,
                style: TextStyle(
                  color: widget.item.status == "Available"
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text("${widget.item.brand} • ${widget.item.category}"),
        trailing: ElevatedButton(
          onPressed: (widget.item.status == "Available" && !isLoading)
              ? () {
                  _showConfirmDialog(context);
                }
              : null,
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text("Borrow"),
        ),
      ),
    );
  }

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Borrow"),
          content: Text("Do you want to borrow '${widget.item.itemName}'?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _borrowItem();
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _borrowItem() async {
    setState(() {
      isLoading = true;
    });

    bool success = await borrowService.borrowItem(widget.item.id);

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: success
            ? const Color.fromARGB(255, 0, 87, 3)
            : const Color.fromARGB(255, 71, 5, 0),
        content: Text(
          success
              ? "Borrow request succesfully sent..."
              : "Borrow request already exists...",
        ),
      ),
    );
  }
}
