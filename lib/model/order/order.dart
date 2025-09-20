class Order {
  final String id;
  final String userId; // <-- new field
  final String address;
  final String customer;
  final String dateTime;
  final String item;
  final String phone;
  final String price;
  final String transactionId;
  final String status;

  Order({
    required this.id,
    required this.userId, // <-- required
    required this.address,
    required this.customer,
    required this.dateTime,
    required this.item,
    required this.phone,
    required this.price,
    required this.transactionId,
    required this.status,
  });

  factory Order.fromFirestore(String id, Map<String, dynamic> data) {
    return Order(
      id: id,
      userId: data['userId'] ?? '', // <-- read userId from firestore
      address: data['address'] ?? '',
      customer: data['customer'] ?? '',
      dateTime: data['dateTime'] ?? '', // corrected key
      item: data['item'] ?? '',
      phone: data['phone'] ?? '',
      price: data['price'] ?? '',
      transactionId: data['transactionId'] ?? '',
      status: data['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId, // <-- save userId
      'address': address,
      'customer': customer,
      'dateTime': dateTime, // corrected key
      'item': item,
      'phone': phone,
      'price': price,
      'transactionId': transactionId,
      'status': status,
    };
  }
}
