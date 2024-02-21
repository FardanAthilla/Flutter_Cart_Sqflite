import 'package:flutter/material.dart';
import 'package:flutter_bookmark_sqflite/DBHelper.dart';
import 'package:flutter_bookmark_sqflite/Model/CartModel.dart';
import 'package:get/get.dart';

class CartPage extends StatelessWidget {
  final DbHelper cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang'),
      ),
      body: GetBuilder<DbHelper>(
        builder: (controller) {
          return FutureBuilder(
            future: controller.all(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                List<CartModel> cartItems = controller.CartData;
                if (cartItems.isEmpty) {
                  return Center(
                    child: Text('Keranjang Anda kosong'),
                  );
                } else {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final CartModel cartItem = cartItems[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16.0,
                              ),
                              child: ListTile(
                                title: Text(cartItem.title ?? ''),
                                subtitle:
                                    Text('Harga: \$${cartItem.price ?? 0}'),
                                leading: Image.memory(
                                  cartItem.image!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(
                                      context,
                                      cartItem,
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Total: \$${_calculateTotalPrice(cartItems)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }
            },
          );
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(
  BuildContext context,
  CartModel cartItem,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Konfirmasi'),
        content: Text('Apakah Anda yakin ingin menghapus item ini?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              cartController.delete(cartItem.id);
              cartController.update(); 
              Get.back();
            },
            child: Text('Hapus'),
          ),
        ],
      );
    },
  );
}


  double _calculateTotalPrice(List<CartModel> cartItems) {
    double totalPrice = 0;
    for (var item in cartItems) {
      totalPrice += item.price ?? 0;
    }
    return totalPrice;
  }
}
