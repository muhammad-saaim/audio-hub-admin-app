import 'dart:io';
import 'package:audio_hub_admin/controller/home_controller.dart';
import 'package:audio_hub_admin/model/product/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:image_picker/image_picker.dart';
import '../services/cloudinary_service.dart';
import '../widgets/drop_down_btn.dart';

class AddProductPage extends StatelessWidget {
  final Product? product; // Optional for edit mode
  const AddProductPage({super.key, this.product});

  Future<void> pickAndUploadImage(HomeController ctrl, BuildContext context) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final file = File(image.path);
      final url = await uploadToCloudinary(file);

      if (url != null) {
        ctrl.productImgCtrl.text = url;
        ctrl.update();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image uploaded successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image upload failed")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {

      // Initialize form safely after first frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (product == null && !ctrl.isFormReset) {
          ctrl.setValuesDefault();
          ctrl.isFormReset = true;
        }

        if (product != null && !ctrl.isFormReset) {
          ctrl.productNameCtrl.text = product!.name ?? '';
          ctrl.productDescriptionCtrl.text = product!.description ?? '';
          ctrl.productImgCtrl.text = product!.image ?? '';
          ctrl.productPriceCtrl.text = product!.price?.toString() ?? '';
          ctrl.category = product!.category ?? 'general';
          ctrl.brand = product!.brand ?? 'un branded';
          ctrl.offer = product!.offer ?? false;
          ctrl.isFormReset = true;
        }
      });

      return Scaffold(
        appBar: AppBar(
          title: Text(product == null ? 'Add Product' : 'Edit Product'),
          backgroundColor: Colors.indigoAccent,
          elevation: 4,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigoAccent, Colors.pinkAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white.withOpacity(0.95),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        product == null ? 'Add New Product' : 'Edit Product',
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.indigoAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(ctrl.productNameCtrl, 'Product Name'),
                      const SizedBox(height: 15),
                      _buildTextField(ctrl.productDescriptionCtrl, 'Product Description', maxLines: 4),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(ctrl.productImgCtrl, 'Image URL', readOnly: true),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () => pickAndUploadImage(ctrl, context),
                            icon: const Icon(Icons.upload_file),
                            label: const Text('Upload'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pinkAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(ctrl.productPriceCtrl, 'Product Price', keyboardType: TextInputType.number),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Flexible(
                            child: DropDownBtn(
                              items: ['Headphones', 'Airbuds', 'Speakers', 'Peripherals','Handsfree'],
                              selectedItemText: ctrl.category,
                              onSelected: (selectedValue) {
                                ctrl.category = selectedValue ?? 'general';
                                ctrl.update();
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Flexible(
                            child: DropDownBtn(
                              items: ['Apple', 'Audionic', 'Samsung', 'Gaming', 'SONY','Chinese'],
                              selectedItemText: ctrl.brand,
                              onSelected: (selectedValue) {
                                ctrl.brand = selectedValue ?? 'un branded';
                                ctrl.update();
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text('Offer Product?', style: TextStyle(fontWeight: FontWeight.bold)),
                      DropDownBtn(
                        items: ['true', 'false'],
                        selectedItemText: ctrl.offer.toString(),
                        onSelected: (selectedValue) {
                          ctrl.offer = selectedValue == 'true';
                          ctrl.update();
                        },
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigoAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            if (product == null) {
                              ctrl.addProduct();
                            } else {
                              ctrl.updateProduct(product!.id!);
                            }
                          },
                          child: Text(product == null ? 'Add Product' : 'Update Product', style: const TextStyle(fontSize: 18)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  // Helper to reduce boilerplate
  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1, bool readOnly = false, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
