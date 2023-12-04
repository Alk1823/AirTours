import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AirTours/services/cloud/cloud_ticket.dart';

import '../../constants/flight_constants.dart';
import '../../constants/ticket_constants.dart';
import 'firestore_flight.dart';

class TicketFirestore {
  final tickets = FirebaseFirestore.instance.collection('tickets');
  final FlightFirestore flightFirestore;

  static final TicketFirestore _shared = TicketFirestore._sharedInstance();

  TicketFirestore._sharedInstance() : flightFirestore = FlightFirestore();

  factory TicketFirestore() => _shared;

  Stream<Iterable<CloudTicket>> allTickets(
      {required String bookingId, required String flightId}) {
    final allTickets = tickets
        .where(bookingReferenceField, isEqualTo: bookingId)
        .where(flightRefField, isEqualTo: flightId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudTicket.fromSnapshot(doc)));

    return allTickets;
  }

  Future<CloudTicket> createNewTicket(
      {required String firstName,
      required String middleName,
      required bool checkInStatus,
      required int bagQuantity,
      required String mealType,
      required String lastName,
      required double ticketPrice,
      required String bookingReference,
      required String ticketUserId,
      required DateTime birthDate,
      required String flightReference,
      required String ticketClass}) async {
    Timestamp birthdateStamp = Timestamp.fromDate(birthDate);

    final document = await tickets.add({
      ticketClassField: ticketClass,
      ticketPriceField: ticketPrice,
      checkInStatusField: checkInStatus,
      flightRefField: flightReference,
      firstNameField: firstName,
      middleNameField: middleName,
      lastNameField: lastName,
      bagQuantityField: bagQuantity,
      mealTypeField: mealType,
      ticketUserIdField: ticketUserId,
      birthDateField: birthdateStamp,
      bookingReferenceField: bookingReference
    });
    final fetchedTicket = await document.get();
    return CloudTicket(
        documentId: fetchedTicket.id,
        firstName: firstName,
        middleName: middleName,
        checkInStatus: checkInStatus,
        bagQuantity: bagQuantity,
        mealType: mealType,
        lastName: lastName,
        ticketPrice: ticketPrice,
        bookingReference: bookingReference,
        ticketUserId: ticketUserId,
        birthDate: birthdateStamp,
        flightReference: flightReference,
        ticketClass: ticketClass);
  }

  Future<bool> checkInUpdating(String ticketId, String flightId) async {
    try {
      DateTime now = DateTime.now();

      final tempFlight = flightFirestore.flights.doc(flightId);
      final fetchedFlight = await tempFlight.get();
      final tempTicket = tickets.doc(ticketId);

      if (fetchedFlight.exists) {
        DateTime flightDate = fetchedFlight.data()![depDateField].toDate();
        DateTime flightTime = fetchedFlight.data()![depTimeField].toDate();
        DateTime totalTime = DateTime(flightDate.year, flightDate.month,
            flightDate.day, flightTime.hour, flightTime.minute);

        Duration timeDifference = totalTime.difference(now);

        if (timeDifference.inHours <= 24) {
          await tempTicket.update({checkInStatusField: true});

          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteRelatedTickets({required String bookingId}) async {
    try {
      final allTickets = await tickets
          .where(bookingReferenceField, isEqualTo: bookingId)
          .get();

      final List<QueryDocumentSnapshot> documents = allTickets.docs;

      for (QueryDocumentSnapshot document in documents) {
        await document.reference.delete();
      }
    } catch (_) {}
  }

  Future<double> updateRelatedTickets({
    required String bookingId,
    required String flightId,
    required double ticketPrice,
  }) async {
    double totalbookingPrice = 0;
    try {
      final allTickets = await tickets
          .where(bookingReferenceField, isEqualTo: bookingId)
          .where(flightRefField, isEqualTo: flightId)
          .get();

      final List<QueryDocumentSnapshot> documents = allTickets.docs;

      for (QueryDocumentSnapshot document in documents) {
        int numOfBaggage = document[bagQuantityField];

        double updatedTicketPrice =
            ticketPrice + (numOfBaggage.toDouble() * 251);

        totalbookingPrice = totalbookingPrice + updatedTicketPrice;

        await document.reference.update({
          ticketClassField: 'Business',
          ticketPriceField: updatedTicketPrice,
        });
      }
    } catch (_) {}
    return totalbookingPrice;
  }
}
