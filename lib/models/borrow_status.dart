class BorrowStatus {
  final String itemName;
  final String status;
  final String? remarks;

  BorrowStatus({required this.itemName, required this.status, this.remarks});

  factory BorrowStatus.fromJson(Map<String, dynamic> json) {
    return BorrowStatus(
      itemName: json['item']['item_name'],
      status: json['status'],
      remarks: json['remarks'],
    );
  }
}
