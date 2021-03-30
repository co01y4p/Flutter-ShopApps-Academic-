import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_apps/providers/auth.dart';
import 'package:shop_apps/providers/cart.dart';
import 'package:shop_apps/providers/orders.dart';
import 'package:shop_apps/screens/cart_screen.dart';
import 'package:shop_apps/screens/order_screen.dart';
import 'package:shop_apps/screens/product_detail_screen.dart';
import 'package:shop_apps/screens/products_overview_screen.dart';
import 'package:shop_apps/screens/users_products_screen.dart';
import 'package:shop_apps/providers/products_provider.dart';
import 'screens/edit_products_screen.dart';
import 'screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: null,
          update: (ctx, auth, previousProducts) => ProductsProvider(auth.token),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Order(),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'My Shop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
