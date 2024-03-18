import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserOrderDetails extends StatelessWidget {
  final Map<String, dynamic>? orderDetails;

  const UserOrderDetails({Key? key, required this.orderDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        backgroundColor: Colors.orange, // Set app bar background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding for content
        child: orderDetails == null
            ? Center(
                child: Text(
                  'Order details not available',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Token: ${orderDetails!['token'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Total: ${orderDetails!['total'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Date: ${_formatDate(orderDetails!['timestamp'])}', // Display formatted date
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Items:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: orderDetails!['items'].length,
                      itemBuilder: (context, index) {
                        var item = orderDetails!['items'][index];
                        return ListTile(
                          leading: Image.network(
                            item['Image'],
                            width: 50, // Adjust image width as needed
                            height: 50, // Adjust image height as needed
                            fit: BoxFit
                                .cover, // Adjust how the image should be displayed
                          ),
                          title: Text(
                            '${item['Name']}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Quantity: ${item['Quantity']}',
                            style: TextStyle(fontSize: 14),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // Function to format the timestamp to a readable date string with AM/PM
  String _formatDate(dynamic date) {
    if (date == null) {
      return 'N/A';
    } else if (date is Timestamp) {
      var formatter = DateFormat('MMMM d, yyyy - hh:mm a');
      return formatter.format(date.toDate());
    } else {
      return 'Invalid date format';
    }
  }
}
