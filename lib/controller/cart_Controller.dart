import 'package:get/get.dart';

class Cart extends GetxController {
  var cartproducts = [].obs;
  get totalCartValue => calculateTotal();
  get total => cartproducts.length.obs;

  addProduct(product) {
    int index =
        cartproducts.indexWhere((i) => i['dish_id'] == product['dish_id']);

    if (index != -1) {
      updateProduct(cartproducts[index], cartproducts[index]['qty'] + 1);
    } else {
      product.addAll({"qty": 1});
      cartproducts.add(product);
      calculateTotal();
    }
  }

  removeProduct(product) {
    int index =
        cartproducts.indexWhere((i) => i['dish_id'] == product['dish_id']);

    if (index != -1) {
      if (cartproducts[index]['qty'] == 1) {
        cartproducts
            .removeWhere((item) => item['dish_id'] == product['dish_id']);
      } else {
        updateProduct(product, product['qty'] - 1);
      }
    }

    calculateTotal();
  }

  updateProduct(product, qty) {
    int index =
        cartproducts.indexWhere((i) => i['dish_id'] == product['dish_id']);

    cartproducts[index]['qty'] = qty;
    if (cartproducts[index]['qty'] == 0) removeProduct(product);

    calculateTotal();
    cartproducts.refresh();
  }

  calculateTotal() {
    double value = 0.0;
    for (var f in cartproducts) {
      value += f['dish_price'] * f['qty'];
    }
    return value;
  }

  singleProductCount(id) {
    int index = cartproducts.indexWhere((i) => i['dish_id'] == id);
    if (index != -1) {
      return cartproducts[index]['qty'];
    } else {
      return 0;
    }
  }

  singleProductTotal(id) {
    int index = cartproducts.indexWhere((i) => i['dish_id'] == id);
    if (index != -1) {
      return cartproducts[index]['qty'] * cartproducts[index]['dish_price'];
    } else {
      return 0;
    }
  }

  totalQty() {
    num value = 0;
    for (var f in cartproducts) {
      value += f['qty'];
    }
    return value;
  }

  clearCart() {
    cartproducts = [].obs;
    cartproducts.refresh();
  }
}
