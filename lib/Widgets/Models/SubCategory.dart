import 'package:cloud_firestore/cloud_firestore.dart';

class SubcategoryModel {
  final String cname;
  final String categoryId;

  SubcategoryModel({
    required this.categoryId,
    required this.cname,
  });

  factory SubcategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    return SubcategoryModel(
      // id: snapshot.id,
      cname: snapshot['cname'],
      categoryId: snapshot['categoryId'],
    );
  }
}