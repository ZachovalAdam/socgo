import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  final CollectionReference sightsCollection = FirebaseFirestore.instance.collection('sights');

  Future updateUserData(String firstName, String lastName, DateTime birthDate, bool admin, bool setup, String pictureUrl, String id) async {
    return await usersCollection.doc(uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate,
      'admin': admin,
      'setup': setup,
      'pictureUrl': pictureUrl,
      'id': id,
    });
  }
}
