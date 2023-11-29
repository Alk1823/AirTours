import 'package:AirTours/constants/flight_constants.dart';
import 'package:AirTours/services/cloud/firestore_flight.dart';
import 'package:AirTours/services/cloud/firestore_ticket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AirTours/services/cloud/cloud_booking.dart';
import 'package:AirTours/constants/booking_constants.dart';
import 'package:intl/intl.dart';

import '../../views/Global/global_var.dart';

class BookingFirestore {
  final bookings = FirebaseFirestore.instance.collection('bookings');
  final FlightFirestore flightFirestore;
  final TicketFirestore ticketFirestore;

  static final BookingFirestore _shared = BookingFirestore._sharedInstance();
  BookingFirestore._sharedInstance()
      : ticketFirestore = TicketFirestore(),
        flightFirestore = FlightFirestore();
  factory BookingFirestore() => _shared;

  Future<bool> upgradeOneWay({
    required String bookingId,
    required String departureFlightId,
    required int numOfPas,
  }) async {
    try {
      bool flag = false;
      final depFlight = flightFirestore.flights.doc(departureFlightId);
      final fetchedDep = await depFlight.get();

      if (fetchedDep.exists) {
        DateTime flightDate = fetchedDep.data()![depDateField].toDate();
        DateTime flightTime = fetchedDep.data()![depTimeField].toDate();
        DateTime totalTime = DateTime(
          flightDate.year,
          flightDate.month,
          flightDate.day,
          flightTime.hour,
          flightTime.minute,
        );

        if (DateTime.now().isBefore(totalTime)) {
          int currentBus1 = fetchedDep.data()![numOfAvabusField];
          double busSeatPrice1 = fetchedDep.data()![busPriceField];
          if (currentBus1 >= numOfPas) {
            flightFirestore.decreaseNumberOfSeats(
                departureFlightId, numOfPas, 'Business');

            flightFirestore.increaseNumberOfSeats(
                departureFlightId, numOfPas, 'Economy');

            double totalPrice = await ticketFirestore.updateRelatedTickets(
              flightId: departureFlightId,
              bookingId: bookingId,
              ticketPrice: busSeatPrice1,
            );

            bookings.doc(bookingId).update({
              bookingPriceField: totalPrice,
              bookingClassField: 'Business',
            });

            flag = true;
            return flag;
          } else {
            return flag; // no seats
          }
        }
      }
      return flag;
    } catch (_) {
      return false;
    }
  }

  Future<bool> upgradeRoundTrip({
    required String bookingId,
    required String departureFlightId,
    required String returnFlightId,
    required int numOfPas,
  }) async {
    try {
      bool flag = false;
      final depFlight = flightFirestore.flights.doc(departureFlightId);
      final fetchedDep = await depFlight.get();
      final retFlight = flightFirestore.flights.doc(returnFlightId);
      final fetchedRet = await retFlight.get();

      if (fetchedDep.exists) {
        if (fetchedRet.exists) {
          DateTime flightDate = fetchedDep.data()![depDateField].toDate();
          DateTime flightTime = fetchedDep.data()![depTimeField].toDate();
          DateTime totalTime = DateTime(flightDate.year, flightDate.month,
              flightDate.day, flightTime.hour, flightTime.minute);

          if (DateTime.now().isBefore(totalTime)) {
            int currentBus1 = fetchedDep.data()![numOfAvabusField];
            int currentBus2 = fetchedRet.data()![numOfAvabusField];
            double busSeatPrice1 = fetchedDep.data()![busPriceField];
            double busSeatPrice2 = fetchedRet.data()![busPriceField];
            if (currentBus1 >= numOfPas && currentBus2 >= numOfPas) {
              flightFirestore.decreaseNumberOfSeats(
                  departureFlightId, numOfPas, 'Business');
              flightFirestore.decreaseNumberOfSeats(
                  returnFlightId, numOfPas, 'Business');
              flightFirestore.increaseNumberOfSeats(
                  departureFlightId, numOfPas, 'Economy');
              flightFirestore.increaseNumberOfSeats(
                  returnFlightId, numOfPas, 'Economy');
              double totalPrice1 = await ticketFirestore.updateRelatedTickets(
                  flightId: departureFlightId,
                  bookingId: bookingId,
                  ticketPrice: busSeatPrice1);
              double totalPrice2 = await ticketFirestore.updateRelatedTickets(
                  flightId: returnFlightId,
                  bookingId: bookingId,
                  ticketPrice: busSeatPrice2);
              double totalPrice = totalPrice1 + totalPrice2;

              bookings.doc(bookingId).update({
                bookingPriceField: totalPrice,
                bookingClassField: 'Business'
              });

              flag = true;
              return flag;
            } else {
              return flag; //no seats
            }
          }
        }
      }
      return flag;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteBooking({
    required String bookingId,
    required String flightId1,
    required String flightId2,
    required String flightClass,
    required int numOfPas,
  }) async {
    try {
      bool flag = false;
      DateTime now = DateTime.now();
      final tmpBooking = bookings.doc(bookingId);
      final tempFlight = flightFirestore.flights.doc(flightId1);
      final fetchedFlight = await tempFlight.get();
      DateTime flightDate = fetchedFlight.data()![depDateField].toDate();
      DateTime flightTime = fetchedFlight.data()![depTimeField].toDate();
      DateTime totalTime = DateTime(flightDate.year, flightDate.month,
          flightDate.day, flightTime.hour, flightTime.minute);

      if (now.isBefore(totalTime)) {
        if (fetchedFlight.exists) {
          Duration timeDifference = totalTime.difference(now);

          if (timeDifference.inHours >= 24) {
            await tmpBooking.delete();
            flightFirestore.increaseNumberOfSeats(
                flightId1, numOfPas, flightClass);

            flag = true;
            await ticketFirestore.deleteRelatedTickets(bookingId: bookingId);
            //roundtrip
            if (flightId2 != 'none') {
              flightFirestore.increaseNumberOfSeats(
                  flightId2, numOfPas, flightClass);
            }
          }
        }
      }
      return flag;
    } catch (e) {
      return false;
    }
  }

  Stream<Iterable<CloudBooking>> allBookings({required String bookingUserId}) {
    final allBookings = bookings
        .where(bookingUserIdField, isEqualTo: bookingUserId)
        .snapshots()
        .map(
            (event) => event.docs.map((doc) => CloudBooking.fromSnapshot(doc)));
    return allBookings;
  }

  Future<CloudBooking> createNewBooking(
      {required String bookingClass,
      required double bookingPrice,
      required String departureFlight,
      required String returnFlight,
      required int numOfSeats,
      required DateTime bookingTime,
      required String bookingUserId}) async {
    Timestamp bookingTimestamp = Timestamp.fromDate(bookingTime);

    final document = await bookings.add({
      bookingClassField: bookingClass,
      bookingPriceField: bookingPrice,
      departureFlightField: departureFlight,
      returnFlightField: returnFlight,
      bookingUserIdField: bookingUserId,
      numOfSeatsField: numOfSeats,
      bookingTimeField: bookingTimestamp
    });
    flightFirestore.decreaseNumberOfSeats(
        departureFlight, numOfSeats, bookingClass);
    if (returnFlight != 'none') {
      flightFirestore.decreaseNumberOfSeats(
          returnFlight, numOfSeats, bookingClass);
    }

    final fetchedBooking = await document.get();
    return CloudBooking(
        documentId: fetchedBooking.id,
        bookingPrice: bookingPrice,
        bookingClass: bookingClass,
        departureFlight: departureFlight,
        returnFlight: returnFlight,
        bookingUserId: bookingUserId,
        numOfSeats: numOfSeats,
        bookingTime: bookingTimestamp);
  }
}

String date1(Timestamp date) {
  DateTime departureDate = date.toDate();
  DateFormat formatter = DateFormat('MM dd yyyy');
  String formattedDate = formatter.format(departureDate);
  List<String> parts = formattedDate.split(' ');
  int month = int.parse(parts[0]);
  String monthName = monthNames[month - 1];
  String day = parts[1];
  String year = parts[2];
  return '$day $monthName $year';
}

String date2(Timestamp date) {
  DateTime departureDate = date.toDate();
  DateFormat formatter = DateFormat('MM dd yyyy');
  String formattedDate = formatter.format(departureDate);
  List<String> parts = formattedDate.split(' ');
  int month = int.parse(parts[0]);
  int monthName = month;
  String day = parts[1];
  String year = parts[2];
  return '$day/$monthName/$year';
}

String boardingTime(Timestamp departureTime) {
  DateTime departureDateTime = departureTime.toDate();
  DateTime boardingDateTime =
      departureDateTime.subtract(const Duration(minutes: 30));
  int hour = boardingDateTime.hour % 12;
  if (hour == 0) {
    hour = 12;
  }
  String formattedHour = hour.toString();
  if (formattedHour.length == 1) {
    formattedHour = ' $formattedHour';
  }
  String formattedBoardingTime =
      '$formattedHour:${boardingDateTime.minute.toString().padLeft(2, '0')} ${boardingDateTime.hour >= 12 ? 'PM' : 'AM'}';

  return formattedBoardingTime;
}