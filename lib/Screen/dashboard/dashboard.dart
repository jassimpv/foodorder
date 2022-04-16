import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodorder/controller/auth.dart';
import 'package:foodorder/controller/cart_Controller.dart';
import 'package:foodorder/Screen/cart/cart_screen.dart';
import 'package:foodorder/controller/datafecth.dart';
import 'package:get/get.dart';

class Dashboard extends StatelessWidget {
  Dashboard({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;
  final Cart cart = Get.put(Cart());
  Authentication authController = Get.find();
  @override
  Widget build(BuildContext context) {
    log(_user.toString());
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey,
          elevation: 0,
          actions: <Widget>[
            Obx(() => GestureDetector(
                  onTap: () {
                    if (cart.total != 0) {
                      Get.to(Cartscreen());
                    } else {
                      Get.snackbar("No Product in Cart", "",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.black,
                          colorText: Colors.white);
                    }
                  },
                  child: Stack(
                    children: <Widget>[
                      const IconButton(
                        icon: Icon(
                          Icons.shopping_cart,
                          color: Colors.grey,
                        ),
                        iconSize: 20,
                        onPressed: null,
                      ),
                      Positioned(
                          top: 10.0,
                          right: 0.0,
                          child: Stack(
                            children: <Widget>[
                              const Icon(Icons.brightness_1,
                                  size: 20.0, color: Colors.red),
                              Positioned(
                                  top: 3.0,
                                  right: 4.0,
                                  child: Center(
                                      child: Text(
                                    cart.total.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ))),
                            ],
                          )),
                    ],
                  ),
                )),
          ],
        ),
        drawer: Drawer(
          child: ListView(
              // physics: BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height: 250,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(_user.photoURL ??
                            "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
                      ),
                      const SizedBox(height: 20),
                      Text(_user.displayName ?? _user.phoneNumber.toString()),
                      const SizedBox(height: 10),
                      Text("ID: " + _user.uid)
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Log Out"),
                  onTap: () {
                    authController.signOut(context: context);
                  },
                ),
              ]),
        ),
        body: FutureBuilder(
          future: DataFetch.getfooddata(), // async work
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                    child: Image(
                  image: AssetImage("assets/loader.gif"),
                ));
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return DefaultTabController(
                      length: snapshot.data.length, // length of tabs
                      initialIndex: 0,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Material(
                              elevation: 2,
                              color: Colors.white,
                              child: SizedBox(
                                width: 100,
                                height: 50,
                                child: TabBar(
                                  labelColor: const Color.fromARGB(
                                      255, 236, 34, 81), //E27890
                                  indicatorColor:
                                      const Color.fromARGB(255, 236, 34, 81),
                                  unselectedLabelColor: Colors.black,
                                  isScrollable: true,
                                  tabs: [
                                    for (var item in snapshot.data)
                                      Text(
                                        item['menu_category'],
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600),
                                      )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: TabBarView(children: <Widget>[
                                for (var item in snapshot.data)
                                  ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          const Divider(
                                            color: Colors.black,
                                          ),
                                      itemCount: item['category_dishes'].length,
                                      itemBuilder: (context, index) {
                                        var dish =
                                            item['category_dishes'][index];

                                        return productlist(dish);
                                      })
                              ]),
                            )
                          ]));
                }
            }
          },
        ));
  }

  Padding productlist(dish) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, top: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                    Flexible(
                        child: Text(
                      dish['dish_name'],
                      style: const TextStyle(
                          fontSize: 19, fontWeight: FontWeight.w600),
                    )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₹  " + dish['dish_price'].toString(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        dish['dish_calories'].toInt().toString() + " calories",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    dish['dish_description'].toString(),
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Container(
                    width: 120,
                    height: 35,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Ink(
                            decoration: const ShapeDecoration(
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.remove,
                              ),
                              iconSize: 20,
                              color: Colors.white,
                              onPressed: () {
                                cart.removeProduct(dish);
                              },
                            )),
                        Obx(() => Text(
                            cart.singleProductCount(dish['dish_id']).toString(),
                            style: const TextStyle(
                              color: Colors.white,
                            ))),
                        Ink(
                            decoration: const ShapeDecoration(
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
                if (dish['addonCat'].isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Customizations available',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FadeInImage(
                  width: 100,
                  height: 100,
                  image: NetworkImage(
                    dish['dish_image'],
                  ),
                  placeholder: const AssetImage(
                    'assets/no_image.jpg',
                  ),
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/no_image.jpg',
                        width: 100, height: 100, fit: BoxFit.fitWidth);
                  },
                  fit: BoxFit.fitWidth,
                ),
                Text('')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
