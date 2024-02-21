import 'package:flutter/material.dart';
import 'package:flutter_bookmark_sqflite/DBHelper.dart';
import 'package:flutter_bookmark_sqflite/Controller/Controller.dart';
import 'package:flutter_bookmark_sqflite/Model/ProductResponseModel.dart';
import 'package:flutter_bookmark_sqflite/Page/Cart.dart';
import 'package:flutter_bookmark_sqflite/Page/ProductDetail.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

class HomePage extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());
  final DbHelper CartController = Get.put(DbHelper());

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => CartPage());
            },
            icon: Icon(Icons.shopping_cart),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Sidebar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Menu 3'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Menu 4'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Menu 5'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (productController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          List<ProductResponseModel> displayedProducts =
              productController.productList.isEmpty
                  ? []
                  : productController.productList.take(20).toList();
          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: productController.loadData,
                  child: ListView.builder(
                    itemCount: displayedProducts.length,
                    itemBuilder: (context, index) {
                      final product = displayedProducts[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => ProductDetailPage(product: product));
                        },
                        child: Card(
                          elevation: 3,
                          margin: const EdgeInsets.all(8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8),
                            title: Text(
                              product.title.length > 45
                                  ? product.title.substring(0, 30) + '...'
                                  : product.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Price: \$${product.price}',
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product.image,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.shopping_cart),
                              onPressed: () async {
                                var isItemExist =
                                    await CartController.isProductExist(
                                        product.id);
                                if (isItemExist) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Item sudah ada di keranjang'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                } else {
                                  var image =
                                      await get(Uri.parse(product.image));
                                  var bytes = image.bodyBytes;
                                  CartController.insert({
                                    "id": product.id,
                                    "title": product.title,
                                    "image": bytes,
                                    "price": product.price
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Item berhasil ditambahkan ke keranjang'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
