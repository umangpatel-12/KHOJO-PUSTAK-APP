import 'package:cloud_firestore/cloud_firestore.dart';

class SubcategoryModel {
  final String cname;
  final String? id;

  SubcategoryModel({
    this.id,
    required this.cname,
  });

  factory SubcategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    return SubcategoryModel(
      // id: snapshot.id,
      cname: snapshot['cname'],
    );
  }
}