import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gemicates_test/controller/auth_controller.dart';
import 'package:gemicates_test/controller/product_controller.dart';
import 'package:gemicates_test/controller/remote_config_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductsPage extends HookConsumerWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productVm = ref.watch(productController);
    final remoteConfigVm = ref.watch(remoteConfigController);
    final authVm = ref.watch(authController);
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await remoteConfigVm.initialize();
        await productVm.fetchProducts();
      });
      return null;
    }, const []);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Product List"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              await authVm.signOut();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: productVm.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : productVm.products.isEmpty
              ? const Center(child: Text("No Data Found"))
              : GridView.builder(
                  itemCount: productVm.products.length,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
                  itemBuilder: (ctx, index) {
                    final product = productVm.products[index];
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.indigo),
                      ),
                      child: Column(
                        children: [
                          (product.images?.isEmpty ?? false)
                              ? const Text("No Img")
                              : Image.network(
                                  product.images?.first ?? "",
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Text("IMG");
                                  },
                                ),
                          const Spacer(),
                          Text(
                            "${product.price} \$",
                            style: TextStyle(decoration: remoteConfigVm.showDiscountedPrice ? TextDecoration.lineThrough : null, fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          if (remoteConfigVm.showDiscountedPrice) ...[Text("${productVm.getDisplayPrice(product).toStringAsFixed(2)} \$")],
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
