import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodevenproject/features/user_auth/presentation/service/database.dart';
import 'package:foodevenproject/features/user_auth/presentation/service/shared_pref.dart';
import 'package:foodevenproject/features/user_auth/presentation/widgets/widget_support.dart';
import 'package:foodevenproject/global/common/toast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

String generateToken() {
  const String chars = '0123456789'; // Define characters to use in the token
  const int length = 5; // Define the desired length of the token
  Random random = Random();
  String token = '';

  for (int i = 0; i < length; i++) {
    token += chars[random.nextInt(
        chars.length)]; // Select random characters from the defined set
  }

  return token;
}

class Order extends StatefulWidget {
  const Order({Key? key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String? id, wallet;
  int total = 0, amount2 = 0;
  late Razorpay _razorpay;
  late Timer _timer;
  String? token; // Declare a Timer variable

  // Other methods...

  void startTimer() {
    _timer = Timer(Duration(seconds: 3), () {
      amount2 = total;
      if (mounted) {
        setState(() {});
      }
    });
  }

  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    foodStream = await DatabaseMethods().getFoodCart(id!);
    setState(() {
      // Initialize total to 0 when foodStream is first received
      total = 0;
    });
  }

  @override
  void initState() {
    ontheload();
    startTimer();
    super.initState();
    // Initialize Razorpay
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _getCartItems();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
    // Dispose Razorpay instance
    _razorpay.clear();
  }

  // Method to handle payment success event
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Handle payment success here
    print("Payment successful");

    // Generate unique token for the order
    String generatedToken = generateToken();

    setState(() {
      token = generatedToken; // Update the token state variable
    });

    // Display centered toast message with token and tick animation
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CenteredToast(message: "Payment successful\nToken: $token");
      },
    );

    try {
      // Send order details to Firestore
      await placeOrder(id!, token!, total);
      // Clear the cart
      await DatabaseMethods().clearCart(id!);
      setState(() {
        total = 0; // Reset the total to 0
      });
    } catch (e) {
      print("Error sending order: $e");
    }
  }

  // Method to handle payment error event
  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure here
    print("Payment error: ${response.message}");
  }

  // Method to handle external wallet event
  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet payment here
    print("External wallet selected: ${response.walletName}");
  }

  // Method to get cart items from Firestore
  void _getCartItems() async {
    id = await SharedPreferenceHelper().getUserId();
    int cartTotal = await DatabaseMethods().getCartTotal(id!);
    setState(() {
      total = cartTotal;
    });
  }

  // Method to open Razorpay checkout
  void _openCheckout() {
    var options = {
      'key':
          'rzp_test_iOag5AqvlVRHrB', // Replace with your actual Razorpay Key ID
      'amount': total * 100, // Amount should be in paise
      'name': 'Food Order',
      'description': 'Payment for food order',
      'prefill': {'contact': 'YOUR_CONTACT_NUMBER', 'email': 'YOUR_EMAIL'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error during payment: $e");
    }
  }

  Stream? foodStream;

  Widget foodCart() {
    return StreamBuilder(
      stream: foodStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return Center(
            child: Text(
              "No items in the cart",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          );
        } else {
          // Calculate the total by iterating through each item in the cart
          int newTotal = 0;
          for (var doc in snapshot.data.docs) {
            newTotal += int.parse(doc["Total"]);
          }

          // Update the total with the new calculated total
          total = newTotal;

          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: snapshot.data.docs.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.docs[index];
              return Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          height: 90,
                          width: 40,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(child: Text(ds["Quantity"])),
                        ),
                        SizedBox(width: 20.0),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.network(
                            ds["Image"],
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ds["Name"],
                              style: AppWidget.semiBoldTextFeildStyle(),
                            ),
                            Text(
                              "\Rs" + ds["Total"],
                              style: AppWidget.semiBoldTextFeildStyle(),
                            ),
                          ],
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () async {
                            // Remove the item from the cart
                            await DatabaseMethods().removeItemFromCart(
                              id!,
                              snapshot.data.docs[index].id,
                            );

                            // Fetch the updated total from the database
                            int updatedTotal =
                                await DatabaseMethods().getCartTotal(id!);

                            // Update the total with the fetched value
                            setState(() {
                              total = updatedTotal;
                            });
                          },
                          child: Icon(
                            Icons.delete,
                            color: Color(0xFFff5c30),
                          ),
                        ),
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

  Future<void> placeOrder(
    String userId,
    String token,
    int total,
  ) async {
    try {
      // Get a reference to the user's cart collection
      CollectionReference cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('Cart');

      // Get all documents in the cart collection
      QuerySnapshot cartSnapshot = await cartRef.get();

      // List to store items from the cart
      List<Map<String, dynamic>> cartItems = [];

      // Iterate through each document in the cart collection
      cartSnapshot.docs.forEach((doc) {
        // Add item details to the list if doc.data() is not null
        Map<String, dynamic>? itemData = doc.data() as Map<String, dynamic>?;
        if (itemData != null) {
          cartItems.add(itemData);
        }
      });

      // Reference to the Firestore collection where orders will be stored
      CollectionReference orders =
          FirebaseFirestore.instance.collection('orders');

      // Add the order to Firestore
      await orders.add({
        'userId': userId,
        'token': token,
        'total': total,
        'items': cartItems, // Store only items from the cart
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Add the order to user's order history
      CollectionReference orderHistoryRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('order_History');

      await orderHistoryRef.add({
        'token': token,
        'total': total,
        'items': cartItems,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('Order added to Firestore successfully');
    } catch (e) {
      print('Error adding order: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 2.0,
              child: Container(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "Food Cart",
                        style: TextStyle(
                          color: Color(0xFFff5c30),
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      if (token != null)
                        Text(
                          "Token: $token",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: foodCart(),
            ),
            Spacer(),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Price",
                    style: AppWidget.boldTextFeildStyle(),
                  ),
                  Text(
                    "\Rs" + total.toString(),
                    style: AppWidget.semiBoldTextFeildStyle(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            GestureDetector(
              onTap: _openCheckout,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFff5c30),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: Center(
                  child: Text(
                    "PAY NOW",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
