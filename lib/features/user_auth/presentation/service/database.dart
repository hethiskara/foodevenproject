import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userInfoMap);
  }

  UpdateUserwallet(String id, String amount) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({"Wallet": amount});
  }

  Future addFoodItem(Map<String, dynamic> userInfoMap, String name) async {
    return await FirebaseFirestore.instance.collection(name).add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getFoodItems(String name) async {
    return await FirebaseFirestore.instance.collection(name).snapshots();
  }

  Future addFoodToCart(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection("Cart")
        .add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getFoodCart(String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Cart")
        .snapshots();
  }

  Future<void> removeItemFromCart(String userId, String itemId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection("Cart")
          .doc(itemId)
          .delete();
    } catch (e) {
      print("Error removing item from cart: $e");
    }
  }

  Future<int> getCartTotal(String userId) async {
    int total = 0;

    try {
      // Get a reference to the user's cart collection
      CollectionReference cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('Cart');

      // Get all documents in the cart collection
      QuerySnapshot cartSnapshot = await cartRef.get();

      // Iterate through each document in the cart collection
      cartSnapshot.docs.forEach((doc) {
        // Parse the 'Total' value from String to int before adding it to the total
        int? itemTotal = int.tryParse(doc['Total']);
        if (itemTotal != null) {
          total += itemTotal;
        }
      });
    } catch (e) {
      print("Error getting cart total: $e");
    }

    return total;
  }

  Future<void> clearCart(String userId) async {
    try {
      // Get a reference to the user's cart collection
      CollectionReference cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('Cart');

      // Get all documents in the cart collection
      QuerySnapshot cartSnapshot = await cartRef.get();

      // Iterate through each document in the cart collection and delete it
      for (QueryDocumentSnapshot doc in cartSnapshot.docs) {
        await cartRef.doc(doc.id).delete();
      }
    } catch (e) {
      print("Error clearing cart: $e");
    }
  }

  Future<void> saveOrderToHistory(
      String userId, Map<String, dynamic> orderDetails) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('orderHistory')
          .add(orderDetails);
      print('Order added to order history successfully');
    } catch (e) {
      print('Error adding order to order history: $e');
    }
  }
}
