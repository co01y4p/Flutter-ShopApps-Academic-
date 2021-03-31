import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageURL;
  bool isFavourite; //notfinal bcoz can always change / simply changable

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageURL,
    this.isFavourite = false,
  });

  void _savFavValue(bool newValue) {
    isFavourite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavouriteStatus(String token) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    try {
      final url = 'https://shop-apps-4c62d.firebaseio.com/products/$id.json?auth=$token';
      final response = await http.patch(
        url,
        body: json.encode(
          {
            'isFavorite': isFavourite,
          },
        ),
      );
      if (response.statusCode >= 400) {
        _savFavValue(oldStatus);
      }
    } catch (error) {}
  }
}
