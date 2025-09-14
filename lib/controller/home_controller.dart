import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/product/product.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference productCollection;

  TextEditingController productNameCtrl = TextEditingController();
  TextEditingController productDescriptionCtrl = TextEditingController();
  TextEditingController productImgCtrl = TextEditingController();
  TextEditingController productPriceCtrl = TextEditingController();

  String category = 'general';
  String brand = 'un branded';
  bool offer = false;

  List<Product> products = [];

  // Track if form has been reset for new product
  bool isFormReset = false;

  @override
  Future<void> onInit() async {
    productCollection = firestore.collection('products');
    await fetchProducts();
    super.onInit();
  }

  // Add Product
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

  // Update Product
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

  // Fetch Products
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

  // Delete Product
  deleteProduct(String id) async {
    try {
      await productCollection.doc(id).delete();
      fetchProducts();
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      print(e);
    }
  }

  // Reset form controllers
  setValuesDefault() {
    productNameCtrl.clear();
    productDescriptionCtrl.clear();
    productImgCtrl.clear();
    productPriceCtrl.clear();
    category = 'general';
    brand = 'un branded';
    offer = false;
    isFormReset = true;
    update();
  }
}
