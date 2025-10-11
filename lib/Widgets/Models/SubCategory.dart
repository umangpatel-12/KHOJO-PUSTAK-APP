import 'package:cloud_firestore/cloud_firestore.dart';

class SubcategoryModel {
  final String subcname;
  final String? id;

  SubcategoryModel({
    this.id,
    required this.subcname,
  });

  factory SubcategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
    return SubcategoryModel(
      // id: snapshot.id,
      subcname: snapshot['subcname'],
    );
  }
}