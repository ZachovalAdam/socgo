import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:async/async.dart';
import 'package:geocoder/geocoder.dart';

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

Future<List<Address>> getAddress(Coordinates coordinates) async {
  return await Geocoder.local.findAddressesFromCoordinates(coordinates);
}

Stream<QuerySnapshot> getUserTripRequest(String userId, String tripHostId, String tripId) {
  Stream<QuerySnapshot> queryUserTripReq = db
      .collection('requests')
      .where("from", isEqualTo: userId)
      .where("to", isEqualTo: tripHostId)
      .where("type", isEqualTo: "trip")
      .where("tripId", isEqualTo: tripId)
      .snapshots();
  return queryUserTripReq;
}

Future createTripRequest(String requestToId, String tripId) async {
  return await db.collection("requests").add({
    'from': auth.currentUser.uid,
    'to': requestToId,
    'type': 'trip',
    'tripId': tripId,
  });
}

Future createTrip(String sightId, String description, Timestamp tripDate, int participantLimit) async {
  return await db.collection("trips").add({
    'date': tripDate,
    'description': description,
    'host': auth.currentUser.uid,
    'open': true,
    'participants': [auth.currentUser.uid],
    'sight': sightId,
    'participantLimit': participantLimit,
  }).then((t) async => {
        await db.collection("chats").doc(t.id).set({
          'trip': t.id,
          'participants': [auth.currentUser.uid],
          'messages': [],
        }).then((c) async => {
              await db.collection("chats").doc(t.id).update({
                'id': t.id,
              })
            })
      });
}

Future forceJoinTrip(String tripId) async {
  return await db.collection("trips").doc(tripId).update({
    "participants": FieldValue.arrayUnion([auth.currentUser.uid])
  });
}

Future deleteTripParticipant(String tripId, String participantId) async {
  await db.collection("trips").doc(tripId).update({
    "participants": FieldValue.arrayRemove([participantId])
  });
}

Future deleteTrip(String tripId) async {
  var requestsQuery = db.collection("requests").where("tripId", isEqualTo: tripId);
  requestsQuery.get().then((querySnapshot) {
    querySnapshot.docs.forEach((req) async {
      await req.reference.delete();
    });
  });
  return await db.collection("trips").doc(tripId).delete().then((a) async => {await db.collection("chats").doc(tripId).delete()});
}

Future approveRequest(var request) async {
  if (request["type"] == "trip") {
    await db.collection("trips").doc(request["tripId"]).update({
      "participants": FieldValue.arrayUnion([request["from"]])
    }).then((t) async => {
          await db.collection("chats").doc(request["tripId"]).update({
            "participants": FieldValue.arrayUnion([request["from"]])
          })
        });
    return await deleteRequest(request.id);
  }
}

Future deleteRequest(String requestId) async {
  return await db.collection("requests").doc(requestId).delete();
}

Future deleteAccount(String userId) async {
  await db.collection("users").doc(userId).delete();
}

Future createReview(String userId, String sightId, String review, double stars) async {
  return await db.collection("sights").doc(sightId).update({
    "reviews": FieldValue.arrayUnion([
      {"date": new DateTime.now(), "rating": stars, "reviewer": userId, "text": review}
    ])
  });
}

Future deleteReview(String sightId, Map review) async {
  await db.collection("sights").doc(sightId).update({
    "reviews": FieldValue.arrayRemove([review])
  });
}

Stream<QuerySnapshot> getPersonalRequests() {
  Stream<QuerySnapshot> querySnapPersonalReqs = db.collection('requests').where('to', isEqualTo: auth.currentUser.uid).snapshots();
  return querySnapPersonalReqs;
}

Stream<QuerySnapshot> getTripJoinRequests(String tripId) {
  Stream<QuerySnapshot> querySnapTripJoinReqs = db.collection('requests').where('tripId', isEqualTo: tripId).snapshots();
  return querySnapTripJoinReqs;
}

Stream<QuerySnapshot> getUsersData() {
  Stream<QuerySnapshot> querySnapUsers = db.collection('users').orderBy('lastName').snapshots();
  return querySnapUsers;
}

Stream<QuerySnapshot> getUserData(String userId) {
  Stream<QuerySnapshot> querySnapUser = db.collection('users').where("id", isEqualTo: userId).snapshots();
  return querySnapUser;
}

Stream<QuerySnapshot> getSightsData() {
  Stream<QuerySnapshot> querySnapSights = db.collection('sights').orderBy('name').snapshots();
  return querySnapSights;
}

Stream<QuerySnapshot> getNearSightsData(location) {
  Stream<QuerySnapshot> querySnapSights = db
      .collection('sights')
      .where("location", isGreaterThan: GeoPoint(location.latitude - 0.26997, location.longitude - 0.53994)) // roughly 30km away from location on -lat
      .where("location", isLessThan: GeoPoint(location.latitude + 0.26997, location.longitude + 0.53994)) // roughly 30km away from location on +lat
      .limit(20)
      .snapshots();
  return querySnapSights;
}

Stream<QuerySnapshot> getSightData(String sightId) {
  Stream<QuerySnapshot> querySnapSight = db.collection('sights').where("id", isEqualTo: sightId).snapshots();
  return querySnapSight;
}

Future getSearchData(String searchText) async {
  return await db
      .collection('sights')
      .where("name", isGreaterThanOrEqualTo: searchText)
      .where("name", isLessThanOrEqualTo: searchText + '\uf8ff') // have to include escape char for this firestore query to work as startsWith
      .limit(20)
      .get();
}

Stream<QuerySnapshot> getTripsData(String sightId) {
  Stream<QuerySnapshot> querySnapTrips = db.collection('trips').where("sight", isEqualTo: sightId).snapshots();
  return querySnapTrips;
}

Stream<DocumentSnapshot> getTripData(String tripId) {
  Stream<DocumentSnapshot> documentSnapTrips = db.collection('trips').doc(tripId).snapshots();
  return documentSnapTrips;
}

Stream<QuerySnapshot> getRandomSight() {
  Stream<QuerySnapshot> querySnapSight = db.collection('sights').snapshots();
  return querySnapSight;
}

Stream<QuerySnapshot> getUsersTrips(String userId) {
  Stream<QuerySnapshot> querySnapTrips = db.collection('trips').where("participants", arrayContains: userId).snapshots();
  return querySnapTrips;
}

Stream<QuerySnapshot> getSightFromTrip(QueryDocumentSnapshot tripId) {
  Stream<QuerySnapshot> querySnapTrips = db.collection('sights').where("id", isEqualTo: tripId["sight"]).snapshots();
  return querySnapTrips;
}

Stream<QuerySnapshot> getTripParticipantsData(List participantArray) {
  Stream<QuerySnapshot> querySnapTripParticipants = db.collection('users').where("id", whereIn: participantArray).snapshots();
  return querySnapTripParticipants;
}
