
import 'package:AirTours/constants/user_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services_auth/firebase_auth_provider.dart';

Future<double> showUserBalance() async {
  final userCollectionRef = FirebaseFirestore.instance.collection('user');
  String userId = FirebaseAuthProvider.authService().currentUser!.id;
  final userDocumentRef = userCollectionRef.doc(userId);
  final userDocumentSnap = await userDocumentRef.get();
  final userBalance = userDocumentSnap.data()![balanceFieldName] + 0.0; //to retrieve it as double if it was saved in the DB int
  return userBalance;
}