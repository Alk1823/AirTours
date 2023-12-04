import 'package:AirTours/views/Manage_booking/one_way_details.dart';
import 'package:AirTours/views/Manage_booking/round_trip_details.dart';
import 'package:flutter/material.dart';
import '../../services/cloud/cloud_booking.dart';
import '../../services/cloud/cloud_flight.dart';

import '../../services/cloud/firestore_booking.dart';
import '../../services/cloud/firestore_flight.dart';
import '../../services_auth/firebase_auth_provider.dart';
import '../Global/global_var.dart';

class ViewBookings extends StatefulWidget {
  const ViewBookings({super.key});

  @override
  State<ViewBookings> createState() => _ViewBookingsState();
}

class _ViewBookingsState extends State<ViewBookings> {
  late final BookingFirestore _bookingService;
  late final FlightFirestore _flightsService;
  late final List<CloudFlight> allFlights;

  CloudFlight? returnFlight;
  CloudFlight? departureFlight;
  @override
  void initState() {
    super.initState();
    _bookingService = BookingFirestore();
    _flightsService = FlightFirestore();
  }

  Future<List<CloudBooking>> filterCurrentBookings(
      Iterable<CloudBooking> bookings) async {
    final List<CloudBooking> currentBookings = [];

    for (final booking in bookings) {
      final isCurrent = await _flightsService.isCurrentFlight(
        booking.departureFlight,
        booking.returnFlight,
      );

      if (isCurrent) {
        currentBookings.add(booking);
      }
    }

    return currentBookings;
  }

  void toNext(
      CloudFlight retFlight, CloudFlight depFlight, CloudBooking booking) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RoundTripDetails(
                booking: booking, depFlight: depFlight, retFlight: retFlight)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 13, 213, 130),
        title: const Text('Current Bookings'),
      ),
      body: StreamBuilder<Iterable<CloudBooking>>(
        stream: _bookingService.allBookings(
            bookingUserId: FirebaseAuthProvider.authService().currentUser!.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              final allBookings = snapshot.data as Iterable<CloudBooking>;

              return FutureBuilder<List<CloudBooking>>(
                future: filterCurrentBookings(allBookings),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    final currentBookings = snapshot.data!;
                    if (currentBookings.isEmpty) {
                      return const Center(
                        child: Text(
                          "No Bookings Yet",
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: currentBookings.length,
                      itemBuilder: (context, index) {
                        final booking = currentBookings[index];

                        return FutureBuilder<List<CloudFlight>>(
                          future: _flightsService.getFlights(
                              booking.departureFlight, booking.returnFlight),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasData) {
                              final flights = snapshot.data!;

                              final departureFlight = flights[0];
                              if (flights.length > 1) {
                                returnFlight = flights[1];
                              }

                              return GestureDetector(
                                onTap: () {
                                  if (booking.returnFlight == 'none') {
                                    whichBooking = booking.documentId;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OneWayDetails(
                                            booking: booking,
                                            depFlight: departureFlight),
                                      ),
                                    );
                                  } else {
                                    whichBooking = booking.documentId;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RoundTripDetails(
                                            booking: booking,
                                            depFlight: departureFlight,
                                            retFlight: returnFlight!),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  //width: double.infinity,
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                            blurRadius: 2, offset: Offset(0, 0))
                                      ],
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Referance:",
                                              style: TextStyle(fontSize: 24),
                                            ),
                                            Text(
                                              "Booking Time",
                                              style: TextStyle(fontSize: 24),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(booking.documentId),
                                            Row(
                                              children: [
                                                Text(
                                                    date1(booking.bookingTime)),
                                                Text(
                                                    ' , ${_flightsService.formatTime(booking.bookingTime)}'),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          child: Divider(
                                            color: Colors.black,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    departureFlight.fromCity,
                                                    style: const TextStyle(
                                                        fontSize: 19),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                    child: Image.asset(
                                                        'images/flight-Icon.png'),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    departureFlight.toCity,
                                                    style: const TextStyle(
                                                        fontSize: 19),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    _flightsService.formatTime(
                                                        departureFlight
                                                            .depTime),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  const SizedBox(
                                                    width: 20,
                                                    child: Text("-"),
                                                  ),
                                                  Text(
                                                    _flightsService.formatTime(
                                                        departureFlight
                                                            .arrTime),
                                                  ),
                                                ],
                                              )
                                            ]),
                                            if (booking.returnFlight != 'none')
                                              Column(children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      returnFlight!.fromCity,
                                                      style: const TextStyle(
                                                          fontSize: 19),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                      child: Image.asset(
                                                          'images/flight-Icon.png'),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      returnFlight!.toCity,
                                                      style: const TextStyle(
                                                          fontSize: 19),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      _flightsService
                                                          .formatTime(
                                                              returnFlight!
                                                                  .depTime),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                      child: Text("-"),
                                                    ),
                                                    Text(
                                                      _flightsService
                                                          .formatTime(
                                                              returnFlight!
                                                                  .arrTime),
                                                    ),
                                                  ],
                                                )
                                              ]),
                                          ],
                                        ),
                                        const SizedBox(
                                          child: Divider(
                                            color: Colors.black,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Text("Price: ",
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87,
                                                    )),
                                                Text(
                                                  "${booking.bookingPrice}",
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text("Passenger: ",
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87,
                                                    )),
                                                Text("${booking.numOfSeats}",
                                                    style: const TextStyle(
                                                        fontSize: 15))
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text("class: ",
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black87,
                                                    )),
                                                Text(
                                                  booking.bookingClass,
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                )
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return const Text('No data');
                            }
                          },
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const Text('No data');
                  }
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
