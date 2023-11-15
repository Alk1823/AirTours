import 'package:AirTours/constants/booking_constants.dart';
import 'package:AirTours/constants/flight_constants.dart';
import 'package:AirTours/constants/ticket_constants.dart';
import 'package:AirTours/services/cloud/cloud_storage_exceptions.dart';
import 'package:AirTours/services/cloud/firestore_flight.dart';
import 'package:AirTours/utilities/show_balance.dart';
import 'package:AirTours/views/Global/global_var.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services_auth/firebase_auth_provider.dart';

class FirebaseCloudStorage {
  final user = FirebaseFirestore.instance.collection('user');
  final admins = FirebaseFirestore.instance.collection('admins');
  final bookings = FirebaseFirestore.instance.collection('bookings');
  final tickets = FirebaseFirestore.instance.collection('tickets');
  final flight = FirebaseFirestore.instance.collection('flights');
  final FlightFirestore flights = FlightFirestore();

  static final FirebaseCloudStorage _shared =
  FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;


  Future<bool> isCurrentBooking({required ownerUserId}) async { //checks for current bookings
    final booking = await bookings.where(
      bookingUserIdField, isEqualTo: ownerUserId
    ).get();
    final documents = booking.docs;
    if (documents.isNotEmpty) {
      for (final document in documents) {
        final docRef = document.reference;
        final docSnap = await docRef.get();
        final returnId = docSnap.data()![returnFlightField];
        final depId = docSnap.data()![departureFlightField];

        final bool isCurrent = await flights.isCurrentFlight(depId, returnId);

        if (isCurrent) {
          return true;
        }
      }
      return false;
    } else {
      return false; //list is empty (no bookings)
    }
  }

  Future<void> deleteUser({required ownerUserId}) async { //delete account
    try {
      final userDocRef = user.doc(ownerUserId); //user document that will be deleted

      final booking = await bookings
          .where(bookingUserIdField, isEqualTo: ownerUserId)
          .get();
      final documents = booking.docs;
      if (documents.isNotEmpty) {
        for (final document in documents) {
          final docRef = document.reference;
          final docSnap = await docRef.get();
          final String returnId = docSnap.data()![returnFlightField];
          final String depId = docSnap.data()![departureFlightField];

          final bool isCurrent = await flights.isCurrentFlight(depId, returnId);

        if (!isCurrent) {
          await userDocRef.delete();
          await FirebaseAuthProvider.authService().deleteAccount();
          break;
        } 
        }
        
      } else {
        await userDocRef.delete();
        await FirebaseAuthProvider.authService().deleteAccount();
      }
      
    } catch (_) {
      throw CouldNotDeleteUserException();
    }
  }

 

  Future<bool> isUser({required ownerUserId}) async {
    final docRef = user.doc(ownerUserId);
    final docSnap = await docRef.get();
    return docSnap.exists;
  }

  Future<void> updateUser(
      {required String ownerUserId,
      required String email,
      required String phoneNum}) async {
    try {
      DocumentReference docRef = user.doc(ownerUserId);
      await docRef.update({"email": email, "phoneNum": phoneNum});
    } catch (_) {
      throw CouldNotUpdateInformationException();
    }
  }

  Future<void> createNewAdmin(
      {required String email, required String phoneNum}) async {
    try {
      await admins.add({"email": email, "phoneNum": phoneNum});
    } catch (_) {
      throw CouldNotCreateAdminException();
    }
  }

  Future<void> createNewUser(
      {required String ownerUserId,
      required String email,
      required String phoneNum,
      required double balance}) async {
    try {
      DocumentReference docRef = user.doc(ownerUserId);
      await docRef
          .set({"email": email, "phoneNum": phoneNum, "balance": balance});
    } catch (_) {
      throw CouldNotCreateUserException();
    }
  }

  Future<double> canceledBookingPrice(
    bookingId) async {
    try {
      final docRef = bookings.doc(bookingId);
  
      final docSnap = await docRef.get();
      final bookingPrice = docSnap.data()![bookingPriceField];
      return bookingPrice + 0.0;
    } catch (_) {
      throw CouldNotRetrieveInformationException();
    }
  }  

  Future<void> retrievePreviousBalance(
    ownerUserId,
    bookingPrice) async {
      try {
        final userDocReference = user.doc(ownerUserId);
        final currentBalance = await showUserBalance();
        final previousBalance = bookingPrice + currentBalance;
        userDocReference.update(
          {'balance':previousBalance}
       );
      } catch (_) {
        throw CouldNotUpdateInformationException();
      }
  }

  Future<double> upgradePrice() async {
    final doc = bookings.doc(whichBooking);
    final docSnap = await doc.get();
    final bookingClass = docSnap.data()![bookingClassField];
    final depFlight = docSnap.data()![departureFlightField];
    final doc2 = flight.doc(depFlight); //this document for flight
    final doc2Snap = await doc2.get();
    final busFlightPrice = doc2Snap.data()![busPriceField] + 0.0;
    if (bookingClass != 'business') {
      final ticket = await tickets.where(
        bookingReferenceField, isEqualTo: whichBooking
      ).get();
      final documents = ticket.docs;
      int counter = 0;
      double ticketsPrice = 0;
      for(final document in documents) {
        ticketsPrice += document[ticketPriceField]; //what passengers already payed
        counter += 1;
      }
      final totBusPrice = busFlightPrice * counter;
      print(totBusPrice);
      final upgradePrice = totBusPrice - ticketsPrice;
      print(upgradePrice);
      return upgradePrice + 0.0;
    } else {
      return 0; //if already business
    }
    
  }
}

