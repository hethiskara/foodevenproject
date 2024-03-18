import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrderDetailsPage extends StatelessWidget {
  final DocumentSnapshot orderDoc;

  const OrderDetailsPage({Key? key, required this.orderDoc}) : super(key: key);

  String _formatDateTime(Timestamp timestamp) {
    var dateTime =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    var formatter = DateFormat(
        'MMMM d, yyyy - hh:mm a'); // Format: Month day, year - hour:minute AM/PM
    return formatter.format(dateTime);
  }

  Future<void> markOrderAsCompleted(BuildContext context) async {
    try {
      // Show circular loading indicator
      showDialog(
        context: context,
        barrierDismissible:
            false, // Prevent dismissing the dialog by tapping outside
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Reference to the Firestore collection where completed orders will be stored
      CollectionReference completedOrders =
          FirebaseFirestore.instance.collection('completedOrders');

      // Add the order to the completed orders collection
      await completedOrders.add(orderDoc.data());

      // Delete the order from the original orders collection
      await orderDoc.reference.delete();

      // Hide the loading indicator
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text('Order marked as completed and moved to completed orders.'),
        duration: Duration(seconds: 1),
      ));

      // Navigate back to the orders page after showing the toast
      Navigator.pop(context);
    } catch (e) {
      print('Error marking order as completed: $e');
      // Hide the loading indicator
      Navigator.pop(context);

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error marking order as completed.'),
      ));
    }
  }

  Widget _buildItemsList(DocumentSnapshot orderDoc) {
    if (orderDoc['items'] != null && orderDoc['items'].isNotEmpty) {
      return ListView.builder(
        itemCount: orderDoc['items'].length,
        itemBuilder: (context, index) {
          var item = orderDoc['items'][index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(item['Image']),
            ),
            title: Text(
              item['Name'],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quantity: ${item['Quantity']}',
                ),
              ],
            ),
          );
        },
      );
    } else {
      return Center(
        child: Text('No items found.'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Token Number: ${orderDoc['token']}',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    inherit: true, // Ensure consistent inherit value
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Date and Time: ${_formatDateTime(orderDoc['timestamp'] as Timestamp)}',
                  style: TextStyle(
                    fontSize: 16.0,
                    inherit: true, // Ensure consistent inherit value
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'User Details:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                inherit: true, // Ensure consistent inherit value
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'User ID: ${orderDoc['userId']}',
              style: TextStyle(
                fontSize: 16.0,
                inherit: true, // Ensure consistent inherit value
              ),
            ),
          ),
          // Add more user details if needed
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Items Ordered:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                inherit: true, // Ensure consistent inherit value
              ),
            ),
          ),
          Expanded(
            child: _buildItemsList(orderDoc),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  markOrderAsCompleted(context);
                },
                child: Text('Mark as Completed'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
