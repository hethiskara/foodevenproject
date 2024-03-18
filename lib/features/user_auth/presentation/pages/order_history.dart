import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodevenproject/features/user_auth/presentation/pages/user_order_details.dart';

class OrderHistoryPage extends StatelessWidget {
  final String? userId;

  const OrderHistoryPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('User ID: $userId');
    if (userId == null) {
      // Handle null userId gracefully, such as showing an error message or navigating back
      return Scaffold(
        body: Center(
          child: Text('User ID is null'),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "ORDER HISTORY",
            style: TextStyle(
              color: Color(0xFFff5c30),
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          centerTitle: true, // Center the title
          elevation: 0.0, // Set elevation to 0.0 to remove the shadow
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 1, // Height of the transparent line
              color: Color.fromARGB(255, 46, 46, 46), // Transparent color
            ),
            Expanded(
              child: OrderList(userId: userId!),
            ),
          ],
        ),
      );
    }
  }
}

class OrderList extends StatelessWidget {
  final String userId;

  const OrderList({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('order_History')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          print("No orders found");
          return Center(
            child: Text(
              "No orders found",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          print("Number of orders: ${snapshot.data!.docs.length}");
          // Get the list of documents
          List<DocumentSnapshot> orders = snapshot.data!.docs;

          // Sort the list of documents based on their IDs in ascending order
          orders.sort((a, b) => a.id.compareTo(b.id));

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index].data() as Map<String, dynamic>;
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          UserOrderDetails(orderDetails: order),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(
                      'Token: ${order['token'] ?? 'N/A'}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          'Total: ${order['total'] ?? 'N/A'}',
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
