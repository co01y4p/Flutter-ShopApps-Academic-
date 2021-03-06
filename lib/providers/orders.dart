import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_apps/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  final String authToken;

  Order(this.authToken,this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  //fetch orders from server
  Future<void> fetchAndSetOrders() async {
    final url = 'https://shop-apps-4c62d.firebaseio.com/orders.json?auth=$authToken';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if(extractedData==null){
      return;
    }
    extractedData.forEach(
      (orderID, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderID,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>).map(
              (item) => CartItem(
                id: item['id'],
                title: item['title'],
                price: item['price'],
                quantity: item['quantity'],
              ),
            ).toList(),
          ),
        );
      },
    );
    _orders=loadedOrders.reversed.toList();
    notifyListeners();
  }

  //add order to server
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://shop-apps-4c62d.firebaseio.com/orders.json?auth=$authToken';
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode(
        {
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map(
                (cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                },
              )
              .toList(),
        },
      ),
    );

    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timestamp,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
