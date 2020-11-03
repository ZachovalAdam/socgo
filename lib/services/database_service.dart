import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(
      String firstName, String lastName, DateTime birthDate) async {
    return await usersCollection.doc(uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate,
    });
  }
}
