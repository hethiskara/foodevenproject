import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompletedOrdersPage extends StatelessWidget {
  void _deleteOrder(DocumentSnapshot orderDoc, BuildContext context) {
    FirebaseFirestore.instance
        .collection('completedOrders')
        .doc(orderDoc.id)
        .delete()
        .then((value) {
      // Optional: Show a snackbar to indicate successful deletion
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Order deleted successfully'),
        duration: Duration(seconds: 1),
      ));
    }).catchError((error) {
      // Handle errors if any
      print('Failed to delete order: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Completed Orders',
          style:
              TextStyle(color: Colors.white), // Customizing app bar text color
        ),
        backgroundColor: Color.fromRGBO(
            31, 122, 23, 1), // Customizing app bar background color
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('completedOrders')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No completed orders.',
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
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteOrder(orderDoc, context);
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
}
