import 'dart:io';
import 'package:audio_hub_admin/controller/home_controller.dart';
import 'package:audio_hub_admin/model/product/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../services/cloudinary_service.dart';
import '../widgets/drop_down_btn.dart';

class AddProductPage extends StatefulWidget {
  final Product? product; // Optional for edit mode
  const AddProductPage({super.key, this.product});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final HomeController ctrl = Get.find();

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    // Defer form updates until after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.product != null) {
        // Edit mode: populate form with product data
        ctrl.productNameCtrl.text = widget.product!.name ?? '';
        ctrl.productDescriptionCtrl.text = widget.product!.description ?? '';
        ctrl.productImgCtrl.text = widget.product!.image ?? '';
        ctrl.productPriceCtrl.text = widget.product!.price?.toString() ?? '';
        ctrl.category = widget.product!.category ?? 'general';
        ctrl.brand = widget.product!.brand ?? 'un branded';
        ctrl.offer = widget.product!.offer ?? false;
      } else {
        // New product: reset form
        ctrl.setValuesDefault();
      }
    });
  }

  Future<void> pickAndUploadImage() async {
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
    return GetBuilder<HomeController>(
      builder: (ctrl) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
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
                          widget.product == null ? 'Add New Product' : 'Edit Product',
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
                              onPressed: pickAndUploadImage,
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
                                items: ['Headphones', 'Airbuds', 'Speakers', 'Peripherals', 'Handsfree'],
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
                                items: ['Apple', 'Audionic', 'Samsung', 'Gaming', 'SONY', 'Chinese'],
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
                              if (widget.product == null) {
                                ctrl.addProduct();
                              } else {
                                ctrl.updateProduct(widget.product!.id!);
                              }
                            },
                            child: Text(
                              widget.product == null ? 'Add Product' : 'Update Product',
                              style: const TextStyle(fontSize: 18),
                            ),
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
      },
    );
  }

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
