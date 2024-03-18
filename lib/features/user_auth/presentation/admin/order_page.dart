import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodevenproject/features/user_auth/presentation/admin/order_detail.dart';

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        backgroundColor: Color.fromARGB(
            255, 189, 45, 45), // Customizing app bar background color
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No orders available.',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot orderDoc = snapshot.data!.docs[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  elevation: 5.0,
                  child: ListTile(
                    title: Text(
                      'Token: ${orderDoc['token']}',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Total: ${orderDoc['total']}',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      onPressed: () {
                        _markOrderAsCompleted(orderDoc, context);
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<void> markOrderAsCompleted(DocumentSnapshot orderDoc) async {
    try {
      CollectionReference completedOrders =
          FirebaseFirestore.instance.collection('completedOrders');
      await completedOrders.add(orderDoc.data());
      await orderDoc.reference.delete();
      print('Order marked as completed and moved to completedOrders');
    } catch (e) {
      print('Error marking order as completed: $e');
    }
  }

  void _markOrderAsCompleted(DocumentSnapshot orderDoc, BuildContext context) {
    Map<String, dynamic>? data = orderDoc.data() as Map<String, dynamic>?;

    if (data != null && data.containsKey('items')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderDetailsPage(orderDoc: orderDoc),
        ),
      );
    } else {
      // Handle case where 'items' field does not exist
      print('Error: Items field does not exist in order document.');
    }
  }
}
