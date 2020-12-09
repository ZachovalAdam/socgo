import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

final FirebaseFirestore db = FirebaseFirestore.instance;

final CollectionReference dbUsers =
    FirebaseFirestore.instance.collection('users');

var snapshot = db.collection('users').doc(auth.currentUser.uid);

Future getCurrentUserData() async {
  DocumentReference documentRefCurrentUser =
      db.collection('users').doc(auth.currentUser.uid);
  DocumentSnapshot userSnap = await documentRefCurrentUser.get();
  return userSnap;
}

Stream<QuerySnapshot> getSightsData() {
  Stream<QuerySnapshot> querySnapSights =
      db.collection('sights').orderBy('name').snapshots();
  return querySnapSights;
}
