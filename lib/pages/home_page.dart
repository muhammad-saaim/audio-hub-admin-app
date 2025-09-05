import 'package:audio_hub_admin/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audio_hub_admin/pages/add_product_page.dart';
import 'package:get/route_manager.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (ctrl) {
      return Scaffold(
      appBar: AppBar(title: Text('AudioHub Admin'),),
      body:ListView.builder(
        itemCount: ctrl.products.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(title: Text(ctrl.products[index].name ?? ''),
              subtitle: Text((ctrl.products[index].price ?? 0).toString()),
              trailing: IconButton(icon: Icon(Icons.delete),
                onPressed: () {
                ctrl.deleteProduct(ctrl.products[index].id ?? '');
                },));
        },),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(AddProductPage()), child: Icon(Icons.add),),
      );
    });
  }
}
