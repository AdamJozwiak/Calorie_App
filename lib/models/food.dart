import 'package:flutter/cupertino.dart';

class Food {
  final String name;
  final String imageUrl;
  final double kcal;
  final double fat;
  int amount;

  Food({this.imageUrl, this.name, this.kcal, this.fat, this.amount});
}
