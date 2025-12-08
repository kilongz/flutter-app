import 'package:flutter/material.dart';
import '../../services/borrow_service.dart';
import '../../models/borrow_status.dart';

class BorrowStatusScreen extends StatefulWidget {
  final int studentId;

  const BorrowStatusScreen({super.key, required this.studentId});

  @override
  State<BorrowStatusScreen> createState() => _BorrowStatusScreenState();
}

class _BorrowStatusScreenState extends State<BorrowStatusScreen> {
  final BorrowService service = BorrowService();
  List<BorrowStatus> list = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await service.getBorrowRequests(widget.studentId);
    setState(() {
      list = data;
      loading = false;
    });
  }

  Color statusColor(String status) {
    if (status == "Approved") return const Color.fromARGB(255, 29, 181, 34);
    if (status == "Rejected") return const Color.fromARGB(255, 116, 11, 4);
    return const Color.fromARGB(255, 212, 174, 21);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text("My Borrow Requests"))),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadData,
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final item = list[i];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(item.itemName),
                      subtitle: Text(item.remarks ?? ""),
                      trailing: Text(
                        item.status.toUpperCase(),
                        style: TextStyle(
                          color: statusColor(item.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
