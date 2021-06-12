import 'package:call_app/models/food.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:call_app/shared/functions.dart';

class DatabaseService {
  final String uid;
  String selectedDate = getCurrentDate();
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference foodCollection =
      Firestore.instance.collection('food');

  Future updateRecommendedIntake(List<double> recIntakes) async {
    if (recIntakes.isNotEmpty) {
      return await foodCollection.document(uid).setData({
        'calories': recIntakes[0] ?? 2500.0,
        'fats': recIntakes[1] ?? 50.0,
        'proteins': recIntakes[2] ?? 55.0
      });
    } else {
      throw Exception('Failed updating racommended intakes');
    }
  }

  Future updateUserData(Food food) async {
    if (food != null) {
      return await foodCollection
          .document(uid)
          .collection(selectedDate)
          .document(food.name)
          .setData({
        'name': food.name ?? '',
        'kcal': food.kcal ?? 0,
        'fat': food.fat ?? 0,
        'protein': food.protein ?? 0,
        'image': food.imageUrl ?? null,
        'amount': food.amount ?? 0
      });
    } else {
      throw Exception('No food data transfered to database');
    }
  }

  Future deleteUserData(Food food) async {
    if (food != null) {
      return await foodCollection
          .document(uid)
          .collection(selectedDate)
          .document(food.name)
          .delete();
    } else {
      throw Exception('No food data transfered to database');
    }
  }

  Future<List<Food>> getUserData(String date) async {
    List<Food> foods = new List();
    return await foodCollection
        .document(uid)
        .collection(date)
        .getDocuments()
        .then((value) {
      value.documents.forEach((doc) {
        foods.add(Food(
          name: doc.data['name'] ?? '',
          kcal: doc.data['kcal'] ?? 0,
          fat: doc.data['fat'] ?? 0,
          protein: doc.data['protein'] ?? 0,
          imageUrl: doc.data['image'] ?? null,
          amount: doc.data['amount'] ?? 0,
        ));
      });
      return foods;
    });
  }

  // get food stream
  Stream<List<Food>> get foods {
    return foodCollection
        .document(uid)
        .collection(selectedDate)
        .snapshots()
        .map(_foodListFromSnapshot);
  }

  List<Food> _foodListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Food(
        name: doc.data['name'] ?? '',
        kcal: doc.data['kcal'] ?? 0,
        fat: doc.data['fat'] ?? 0,
        protein: doc.data['protein'] ?? 0,
        imageUrl: doc.data['image'] ?? null,
        amount: doc.data['amount'] ?? 0,
      );
    }).toList();
  }

  Stream<List<double>> get intakes {
    List<double> recIntake = new List(3);
    return foodCollection.document(uid).snapshots().map((doc) {
      recIntake[0] = doc.data['calories'] ?? 2500.0;
      recIntake[1] = doc.data['fats'] ?? 50.0;
      recIntake[2] = doc.data['proteins'] ?? 55.0;
      return recIntake;
    });
  }
}
