import 'package:call_app/models/food.dart';
import 'package:call_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:call_app/shared/functions.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference foodCollection =
      Firestore.instance.collection('food');

  Future updateUserData(Food food) async {
    return await foodCollection
        .document(uid)
        .collection(getCurrentDate())
        .document(food.name)
        .setData({
      'name': food.name ?? '',
      'kcal': food.kcal ?? '0',
      'fat': food.fat ?? '0',
      'image': food.imageUrl ?? null,
      'amount': food.amount ?? 0
    });
  }

  List<Food> _foodListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Food(
        name: doc.data['name'] ?? '',
        kcal: doc.data['kcal'] ?? '0',
        fat: doc.data['fat'] ?? '0',
        imageUrl: doc.data['image'] ?? null,
        amount: doc.data['amount'] ?? 0,
      );
    }).toList();
  }

  // get food stream
  Stream<List<Food>> get foods {
    return foodCollection
        .document(uid)
        .collection(getCurrentDate())
        .snapshots()
        .map(_foodListFromSnapshot);
  }
}
