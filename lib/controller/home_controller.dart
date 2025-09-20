import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/product/product.dart';
import '../model/order/order.dart' as my_order;

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference productCollection;
  late CollectionReference orderCollection; // admin global orders

  TextEditingController productNameCtrl = TextEditingController();
  TextEditingController productDescriptionCtrl = TextEditingController();
  TextEditingController productImgCtrl = TextEditingController();
  TextEditingController productPriceCtrl = TextEditingController();

  String category = 'general';
  String brand = 'un branded';
  bool offer = false;

  List<Product> products = [];
  List<my_order.Order> orders = []; // admin sees all orders

  bool isFormReset = false;

  @override
  Future<void> onInit() async {
    productCollection = firestore.collection('products');
    orderCollection = firestore.collection('orders'); // admin global orders
    await fetchProducts();
    await fetchOrders();
    super.onInit();
  }

  // -----------------------------
  // Product CRUD
  // -----------------------------
  addProduct() {
    try {
      double price = double.tryParse(productPriceCtrl.text) ?? 0;
      DocumentReference doc = productCollection.doc();
      Product product = Product(
        id: doc.id,
        name: productNameCtrl.text,
        category: category,
        description: productDescriptionCtrl.text,
        price: price,
        brand: brand,
        image: productImgCtrl.text,
        offer: offer,
      );
      doc.set(product.toJson());
      Get.snackbar('Success', 'Product added successfully', colorText: Colors.green);
      setValuesDefault();
      fetchProducts();
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      print(e);
    }
  }

  updateProduct(String id) async {
    try {
      double price = double.tryParse(productPriceCtrl.text) ?? 0;
      await productCollection.doc(id).update({
        'name': productNameCtrl.text,
        'description': productDescriptionCtrl.text,
        'image': productImgCtrl.text,
        'price': price,
        'category': category,
        'brand': brand,
        'offer': offer,
      });
      Get.snackbar('Success', 'Product updated successfully', colorText: Colors.green);
      setValuesDefault();
      fetchProducts();
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      print(e);
    }
  }

  fetchProducts() async {
    try {
      QuerySnapshot productSnapshot = await productCollection.get();
      final List<Product> retrievedProducts = productSnapshot.docs
          .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      products.clear();
      products.assignAll(retrievedProducts);
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      print(e);
    } finally {
      update();
    }
  }

  deleteProduct(String id) async {
    try {
      await productCollection.doc(id).delete();
      fetchProducts();
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      print(e);
    }
  }

  setValuesDefault() {
    productNameCtrl.clear();
    productDescriptionCtrl.clear();
    productImgCtrl.clear();
    productPriceCtrl.clear();
    category = 'general';
    brand = 'un branded';
    offer = false;
    isFormReset = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      update();
    });
  }

  // -----------------------------
  // Orders CRUD
  // -----------------------------
  fetchOrders() async {
    try {
      QuerySnapshot orderSnapshot =
      await orderCollection.orderBy('dateTime', descending: true).get();
      final List<my_order.Order> retrievedOrders = orderSnapshot.docs
          .map((doc) =>
          my_order.Order.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
      orders.clear();
      orders.assignAll(retrievedOrders);
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      print(e);
    } finally {
      update();
    }
  }

  /// Update order status: Pending → Approved / Rejected
  updateOrderStatus(String id, String status) async {
    if (status.isEmpty) return;

    // normalize to lowercase
    status = status.toLowerCase();

    if (!(status == 'approved' || status == 'rejected' || status == 'pending')) {
      Get.snackbar('Error', 'Invalid status: $status', colorText: Colors.red);
      return;
    }

    try {
      // 1️⃣ Update global orders collection
      await orderCollection.doc(id).update({'status': status});

      // 2️⃣ Update user's subcollection order
      final my_order.Order? order = orders.firstWhereOrNull((o) => o.id == id);

      if (order != null && order.userId.isNotEmpty) {
        await firestore
            .collection('users')
            .doc(order.userId)
            .collection('orders')
            .doc(id)
            .update({'status': status});
      }

      Get.snackbar('Success', 'Order status updated to $status', colorText: Colors.green);
      fetchOrders(); // refresh list
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      print(e);
    }
  }
}
