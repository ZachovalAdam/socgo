import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:async/async.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

final FirebaseFirestore db = FirebaseFirestore.instance;

final CollectionReference dbUsers = FirebaseFirestore.instance.collection('users');

var snapshot = db.collection('users').doc(auth.currentUser.uid);

getLocation() async {}

Future getCurrentUserData() async {
  DocumentReference documentRefCurrentUser = db.collection('users').doc(auth.currentUser.uid);
  DocumentSnapshot userSnap = await documentRefCurrentUser.get();
  return userSnap;
}

Stream<QuerySnapshot> getUsersData() {
  Stream<QuerySnapshot> querySnapUsers = db.collection('users').orderBy('lastName').snapshots();
  return querySnapUsers;
}

Stream<QuerySnapshot> getSightsData() {
  Stream<QuerySnapshot> querySnapSights = db.collection('sights').orderBy('name').snapshots();
  return querySnapSights;
}

Stream<QuerySnapshot> getSightData(String sightId) {
  Stream<QuerySnapshot> querySnapSight = db.collection('sights').where("id", isEqualTo: sightId).snapshots();
  return querySnapSight;
}

Stream<QuerySnapshot> getTripsData(String sightId) {
  Stream<QuerySnapshot> querySnapTrips = db.collection('trips').where("sight", isEqualTo: sightId).snapshots();
  return querySnapTrips;
}

/*Stream<QuerySnapshot> getTripParticipantsData(List participantArray) {
  List<Stream> streams = [];
  for (var i = 0; i >= participantArray.length; i++) {
    streams.add(LazyStream(() async => await db.collection('users').where("id", isEqualTo: participantArray[i]).snapshots()));
  }
  return StreamGroup.merge(streams).asBroadcastStream();
}*/

Stream<QuerySnapshot> getTripParticipantsData(List participantArray) {
  Stream<QuerySnapshot> querySnapTripParticipants = db.collection('users').where("id", whereIn: participantArray).snapshots();
  return querySnapTripParticipants;
}
