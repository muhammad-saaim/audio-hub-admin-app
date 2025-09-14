import 'package:audio_hub_admin/model/product/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigoAccent, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // 🔹 Top AppBar with back button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Get.back(),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Product Details',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 Product Image
                Hero(
                  tag: product.id!,
                  child: product.image != null && product.image!.isNotEmpty
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      product.image!,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20)),
                    child: const Icon(Icons.audiotrack,
                        size: 80, color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 Product Info Card
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, -5),
                        )
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name ?? '',
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Colors.indigoAccent),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Chip(
                                label: Text(product.category ?? 'General'),
                                backgroundColor: Colors.indigoAccent.shade100,
                              ),
                              const SizedBox(width: 10),
                              Chip(
                                label: Text(product.brand ?? 'Unbranded'),
                                backgroundColor: Colors.blueAccent.shade100,
                              ),
                              const SizedBox(width: 10),
                              if (product.offer ?? false)
                                const Chip(
                                  label: Text('Offer'),
                                  backgroundColor: Colors.pinkAccent,
                                  labelStyle: TextStyle(color: Colors.white),
                                ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Description',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            product.description ?? 'No description available',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
