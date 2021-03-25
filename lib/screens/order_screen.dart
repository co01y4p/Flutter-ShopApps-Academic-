import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_apps/providers/orders.dart' show Order;
import 'package:shop_apps/widgets/order_item.dart';
import 'package:shop_apps/widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then(
      (_) {
        Provider.of<Order>(context,listen: false).fetchAndSetOrders();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, i) => OrderItem(ordersData.orders[i]),
        itemCount: ordersData.orders.length,
      ),
    );
  }
}
