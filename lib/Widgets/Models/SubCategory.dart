import 'package:cloud_firestore/cloud_firestore.dart';

class SubcategoryModel {
  final String cname;
  final String categoryId;
  final String subcategoryId;

  SubcategoryModel({
    required this.categoryId,
    required this.cname,
    required this.subcategoryId,
  });

  factory SubcategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    return SubcategoryModel(
      // id: snapshot.id,
      cname: snapshot['cname'],
      categoryId: snapshot['categoryId'],
      subcategoryId: snapshot['subcategoryId'],
    );
  }
}