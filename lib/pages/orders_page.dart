import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../model/order/order.dart' as my_order;

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController ctrl = Get.find();

    return GetBuilder<HomeController>(
      builder: (ctrl) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Admin Orders"),
            backgroundColor: Colors.indigoAccent,
          ),
          body: ctrl.orders.isEmpty
              ? const Center(
            child: Text(
              "No orders found",
              style: TextStyle(fontSize: 18),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: ctrl.orders.length,
            itemBuilder: (context, index) {
              final my_order.Order order = ctrl.orders[index];
              final status = order.status.toLowerCase();

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              order.item,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Chip(
                            label: Text(
                              status.toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: status == 'pending'
                                ? Colors.orange
                                : status == 'approved'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (order.customer.isNotEmpty)
                        Text("Customer: ${order.customer}"),
                      if (order.phone.isNotEmpty)
                        Text("Phone: ${order.phone}"),
                      if (order.address.isNotEmpty)
                        Text("Address: ${order.address}"),
                      Text("Price: ${order.price}"),
                      Text("Transaction ID: ${order.transactionId}"),
                      Text("Date: ${order.dateTime}"),
                      const SizedBox(height: 12),
                      if (status == 'pending')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              onPressed: () {
                                ctrl.updateOrderStatus(
                                    order.id, 'Approved');
                              },
                              child: const Text("Approve"),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              onPressed: () {
                                ctrl.updateOrderStatus(
                                    order.id, 'Rejected');
                              },
                              child: const Text("Reject"),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
