import 'dart:io'; // 🔁 Added for File conversion
import 'package:audio_hub_admin/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:image_picker/image_picker.dart';
import '../services/cloudinary_service.dart';
import '../widgets/drop_down_btn.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  Future<void> pickAndUploadImage(HomeController ctrl, BuildContext context) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final file = File(image.path); // ✅ Convert XFile to File
      final url = await uploadToCloudinary(file); // ✅ Upload to Cloudinary

      if (url != null) {
        ctrl.productImgCtrl.text = url;
        ctrl.update();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Image uploaded successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Image upload failed")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return Scaffold(
        appBar: AppBar(title: Text('Add Product')),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Add New Product',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.indigoAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: ctrl.productNameCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: Text('Product Name'),
                    hintText: 'Enter Your Product Name',
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: ctrl.productDescriptionCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: Text('Product Description'),
                    hintText: 'Enter Your Product Description',
                  ),
                  maxLines: 4,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: ctrl.productImgCtrl,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          label: Text('Image URL'),
                          hintText: 'Image will appear here after upload',
                        ),
                        readOnly: true,
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => pickAndUploadImage(ctrl, context),
                      child: Text('Upload Image'),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextField(
                  controller: ctrl.productPriceCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: Text('Product Price'),
                    hintText: 'Enter Your Product Price',
                  ),
                ),
                SizedBox(height: 10),
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
                    SizedBox(width: 40),
                    Flexible(
                      child: DropDownBtn(
                        items: ['Apple', 'Audionic', 'Samsung', 'Gaming', 'SONY','Chinese'],
                        selectedItemText: ctrl.brand,
                        onSelected: (selectedValue) {
                          ctrl.brand = selectedValue ?? 'unbranded';
                          ctrl.update();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text('Offer Product?'),
                DropDownBtn(
                  items: ['true', 'false'],
                  selectedItemText: ctrl.offer.toString(),
                  onSelected: (selectedValue) {
                    ctrl.offer = bool.tryParse(selectedValue ?? 'false') ?? false;
                    ctrl.update();
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    ctrl.addProduct();
                  },
                  child: Text('Add Product'),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
