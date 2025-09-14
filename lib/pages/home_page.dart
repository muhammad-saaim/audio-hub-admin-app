import 'package:audio_hub_admin/controller/home_controller.dart';
import 'package:audio_hub_admin/pages/add_product_page.dart';
import 'package:audio_hub_admin/pages/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('AudioHub Admin'),
          backgroundColor: Colors.indigoAccent,
          elevation: 4,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigoAccent, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: ctrl.products.length,
            itemBuilder: (BuildContext context, int index) {
              final product = ctrl.products[index];

              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 500 + index * 100),
                tween: Tween(begin: 0, end: 1),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 50 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => ProductDetailPage(product: product));
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: product.image != null && product.image!.isNotEmpty
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          product.image!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      )
                          : const Icon(Icons.audiotrack, size: 60, color: Colors.grey),
                      title: Text(
                        product.name ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // 🔹 Edit Button
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blueAccent),
                              onPressed: () {
                                Get.to(() => AddProductPage(product: product));
                              },
                            ),
                            // 🔹 Delete Button
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () {
                                ctrl.deleteProduct(product.id ?? '');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pinkAccent,
          onPressed: () => Get.to(() => const AddProductPage()),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      );
    });
  }
}
