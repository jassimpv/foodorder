import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:foodorder/Screen/Sucessfull/sucess.dart';
import 'package:foodorder/controller/auth.dart';
import 'package:foodorder/controller/cart_Controller.dart';
import 'package:foodorder/Screen/dashboard/dashboard.dart';
import 'package:get/get.dart';

class Cartscreen extends StatelessWidget {
  Cartscreen({Key? key}) : super(key: key);

  final Cart cart = Get.find();
  Authentication authController = Get.find();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 2,
          title: const Text("Order Summary"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black54),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: const Color(0xff1b4014),
                    borderRadius: BorderRadius.circular(6)),
                height: 60,
                child: Obx(() => Center(
                      child: Text(
                        cart.total.toString() +
                            " Dishes - " +
                            cart.totalQty().toString() +
                            " items",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    )),
              ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Obx(() => ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => const Divider(
                              color: Colors.black,
                            ),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cart.cartproducts.length,
                        itemBuilder: (context, index) {
                          var dish = cart.cartproducts[index];

                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Icon(
                                                Icons.crop_square_sharp,
                                                color: dish['dish_Type'] == 2
                                                    ? Colors.green
                                                    : Colors.red,
                                                size: 36,
                                              ),
                                              Icon(Icons.circle,
                                                  color: dish['dish_Type'] == 2
                                                      ? Colors.green
                                                      : Colors.red,
                                                  size: 14),
                                            ],
                                          ),
                                          // Padding(
                                          //   padding: const EdgeInsets.all(8.0),
                                          //   child: Text(
                                          //      ),
                                          // ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 5.0),
                                            child: SizedBox(
                                              width: width * 0.25,
                                              child: Text(
                                                dish['dish_name'],
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                          Container(
                                              width: 120,
                                              height: 40,
                                              decoration: const BoxDecoration(
                                                color: Color(0xff1b4014),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Ink(
                                                      decoration:
                                                          const ShapeDecoration(
                                                        shape: CircleBorder(),
                                                      ),
                                                      child: IconButton(
                                                        icon: const Icon(
                                                          Icons.remove,
                                                        ),
                                                        iconSize: 20,
                                                        color: Colors.white,
                                                        onPressed: () {
                                                          cart.removeProduct(
                                                              dish);
                                                        },
                                                      )),
                                                  Obx(() => Text(
                                                      cart
                                                          .singleProductCount(
                                                              dish['dish_id'])
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                      ))),
                                                  Ink(
                                                      decoration:
                                                          const ShapeDecoration(
                                                        shape: CircleBorder(),
                                                      ),
                                                      child: IconButton(
                                                        icon: const Icon(
                                                          Icons.add,
                                                        ),
                                                        color: Colors.white,
                                                        iconSize: 20,
                                                        onPressed: () {
                                                          cart.addProduct(dish);
                                                        },
                                                      )),
                                                ],
                                              )),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Obx(() => Text(
                                                "₹ " +
                                                    cart
                                                        .singleProductTotal(
                                                            dish['dish_id'])
                                                        .toString(),
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              )),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30.0),
                                        child: Text(
                                          "₹ " + dish['dish_price'].toString(),
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30.0),
                                        child: Text(dish['dish_calories']
                                                .toInt()
                                                .toString() +
                                            " calories"),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        })),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Amount",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Obx(() => Text(
                              '₹ ' + cart.totalCartValue.toString(),
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 70,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () async {
          if (cart.total != 0) {
            cart.clearCart();
            Get.offAll(() => const SuccessPage());
            Future.delayed(const Duration(seconds: 3), () {
              if (authController.userdata != null) {
                Get.offAll(
                    () => Dashboard(user: authController.userdata.value));
              }
            });
          } else {
            Get.snackbar("No Product in Cart", "",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.black,
                colorText: Colors.white);
          }
        },
        child: Container(
          child: const Center(
              child: Text(
            "Place Order",
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w400),
          )),
          height: 45,
          width: width - 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: const Color(0xff1b4014),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
