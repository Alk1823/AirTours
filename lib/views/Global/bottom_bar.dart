import 'package:AirTours/views/Global/flight_class_for_search.dart';
import 'package:flutter/material.dart';
import '../Manage_booking/view_bookings.dart';
import '../One-Way/one_way.dart';
import '../Profile/profile_view.dart';
import '../Round-Trip/round_trip.dart';
import 'display_history.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'global_var.dart';

class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int indexx = 0;
  final pages = [
    const Center(child: SelectTravelType()),
    const Center(child: History()),
    const Center(child: ViewBookings()),
    const Center(child: ProfileView()),
  ];
  Widget pageNumber(int page) {
    final pages = [
      const Center(child: SelectTravelType()),
      const Center(child: History()),
      const Center(child: ViewBookings()),
      const Center(child: ProfileView()),
    ];
    return pages[page];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[indexx],
      bottomNavigationBar: GNav(
          gap: 8,
          backgroundColor:
              const Color.fromARGB(255, 13, 213, 130), //change color to green
          color: Colors.black,
          activeColor: Colors.white,
          //tabBackgroundColor: Colors.white,
          onTabChange: (value) {
            setState(() {
              indexx = value;
            });
          },
          tabs: [
            GButton(
              onPressed: () {
                List<flightInformation> flightNameTestCopy = List.from(forSave);
                flightNameTest = flightNameTestCopy;
                // print("For save: " " ${forSave.length}");
                // print("flightNameTest: ${flightNameTest.length}");
                cityNameDel = null;
                cityNameDel2 = null;
                indexToUpdate = null;
                indexToUpdate2 = null;
                const SelectTravelType();
              },
              icon: Icons.home,
              text: "Home",
            ),
            GButton(
              onPressed: () {
                List<flightInformation> flightNameTestCopy = List.from(forSave);
                flightNameTest = flightNameTestCopy;
                //print("hellow1");
                cityNameDel = null;
                cityNameDel2 = null;
                indexToUpdate = null;
                indexToUpdate2 = null;
              },
              icon: Icons.history_sharp,
              text: "History",
            ),
            GButton(
              onPressed: () {
                List<flightInformation> flightNameTestCopy = List.from(forSave);
                flightNameTest = flightNameTestCopy;
                //print("hellow2");
                cityNameDel = null;
                cityNameDel2 = null;
                indexToUpdate = null;
                indexToUpdate2 = null;
              },
              icon: Icons.manage_history_sharp,
              text: "Manage",
            ),
            GButton(
              onPressed: () {
                List<flightInformation> flightNameTestCopy = List.from(forSave);
                flightNameTest = flightNameTestCopy;
                //print("hellow4");
                cityNameDel = null;
                cityNameDel2 = null;
                indexToUpdate = null;
                indexToUpdate2 = null;
                const ProfileView();
              },
              icon: Icons.person_2_sharp,
              text: "Profile",
            )
          ]),
    );
  }
}

class SelectTravelType extends StatefulWidget {
  const SelectTravelType({super.key});

  @override
  State<SelectTravelType> createState() => _SelectTravelTypeState();
}

class _SelectTravelTypeState extends State<SelectTravelType> {
  List<String> selectType = ["One Way", "Round Trip"];
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.white,
          // appBar: AppBar(title: Text("Switch")),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 13, 213,
                              130), //new line(border) and(color) Green color
                        ),
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 1,
                              offset: Offset(0, 0)) //change blurRadius to 1
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: TabBar(
                      onTap: (value) {
                        List<flightInformation> flightNameTestCopy =
                            List.from(forSave);
                        flightNameTest = flightNameTestCopy;
                        //print("For save: " " ${forSave.length}");
                        //print("flightNameTest: ${flightNameTest.length}");
                        cityNameDel = null;
                        cityNameDel2 = null;
                        indexToUpdate = null;
                        indexToUpdate2 = null;
                      },
                      indicator: BoxDecoration(
                          color: const Color.fromARGB(
                              255, 13, 213, 130), //change color to green
                          borderRadius: BorderRadius.circular(25)),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: const [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Tab(text: "One way"), //Icon(Icons.flight)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Tab(
                              text: "Round trip",
                            ),
                            //Image.asset('images/RoundTrip.jpeg'),
                          ],
                        )
                      ],
                    ),
                  ),
                  const Expanded(
                      child: TabBarView(children: [OneWay(), RoundTrip()]))
                ],
              ),
            ),
          )),
    );
  }
}