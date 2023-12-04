import 'package:flutter/material.dart';
import '../../services/cloud/cloud_booking.dart';
import '../../services/cloud/cloud_flight.dart';
import '../../services/cloud/firestore_booking.dart';
import '../../services/cloud/firestore_flight.dart';
import '../../services_auth/firebase_auth_provider.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 13, 213, 130),
        title: const Text('Booking History'),
      ),
      body: StreamBuilder<Iterable<CloudBooking>>(
        stream: _bookingService.allBookings(
            bookingUserId: FirebaseAuthProvider.authService().currentUser!.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              final allBookings = snapshot.data as Iterable<CloudBooking>;
              if (allBookings.isEmpty) {
                return const Center(
                  child: Text(
                    "No Bookings Yet",
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              return ListView.builder(
                itemCount: allBookings.length,
                itemBuilder: (context, index) {
                  final booking = allBookings.elementAt(index);

                  return FutureBuilder<List<CloudFlight>>(
                    future: _flightsService.getFlights(
                        booking.departureFlight, booking.returnFlight),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        final flights = snapshot.data!;

                        final departureFlight = flights[0];
                        if (flights.length > 1) {
                          returnFlight = flights[1];
                        }

                        return Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                              ],
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                        Text(date1(booking.bookingTime)),
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
                                            style:
                                                const TextStyle(fontSize: 19),
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
                                            style:
                                                const TextStyle(fontSize: 19),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            _flightsService.formatTime(
                                                departureFlight.depTime),
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
                                                departureFlight.arrTime),
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
                                              style:
                                                  const TextStyle(fontSize: 19),
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
                                              style:
                                                  const TextStyle(fontSize: 19),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              _flightsService.formatTime(
                                                  returnFlight!.depTime),
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
                                                  returnFlight!.arrTime),
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
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            )),
                                        Text(
                                          "${booking.bookingPrice}",
                                          style: const TextStyle(fontSize: 15),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text("Passenger: ",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            )),
                                        Text("${booking.numOfSeats}",
                                            style:
                                                const TextStyle(fontSize: 15))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text("class: ",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            )),
                                        Text(
                                          booking.bookingClass,
                                          style: const TextStyle(fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              ],
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
            } else {
              return const Text('Not Available');
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
