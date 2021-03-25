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
  Future _ordersFuture;

  Future _obtainOrdersFuture(){
    return Provider.of<Order>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture=_obtainOrdersFuture();  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('building order');
    //final ordersData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('Error occured!'),
              );
            } else {
              return Consumer<Order>(
                builder: (
                  ctx,
                  ordersData,
                  child,
                ) =>
                    ListView.builder(
                  itemBuilder: (ctx, i) => OrderItem(ordersData.orders[i]),
                  itemCount: ordersData.orders.length,
                ),
              );
            }
          }
        },
      ),
    );
  }
}
