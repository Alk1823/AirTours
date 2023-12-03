import 'package:AirTours/utilities/search_flight.dart';
import 'package:flutter/material.dart';
import 'package:AirTours/views/Global/global_var.dart';
import '../Global/flight_class_for_search.dart';
import '../Global/show_city_name_search.dart';
import 'available_flights_screen.dart';

class OneWay extends StatefulWidget {
  const OneWay({super.key});

  @override
  State<OneWay> createState() => _OneWayState();
}

class _OneWayState extends State<OneWay> {
  int checkIfSelectCityFrom = 0; 
  int checkIfSelectCityTo = 0; 
  final _formKey = GlobalKey<FormState>();
  String? selectedCity1;
  String? selectedCity2;
  void toNext() {
    DateTime dateOnly = DateTime(dateTime.year, dateTime.month, dateTime.day);

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OneWaySearch(
            numOfPas: count,
            date: dateOnly,
            flightClass: currentPassenger,
            from: selectedCity1!,
            to: selectedCity2!,
          ),
        ));
  }

  void icreaseCount() {
    setState(() {
      if (count == 6) return;
      count++;
    });
  }

  void decreaseCount() {
    setState(() {
      if (count == 1) return;
      count--;
    });
  }

  void updateCurrentPassenger(String currentPa) {
    setState(() {
      currentPassenger = currentPa;
    });
  }

  void _navigateToCitySelectionPage(BuildContext context, int num) async {
    final city = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const FromSearch(
                fromOrTo: 1,
              )),
    );
    if (city != null) {
      setState(() {
        if (num == 1) {
          if (cityNameDel == null) {
            selectedCity1 = city;
            cityNameDel = city;
            flightNameTest.removeWhere(
                (flightInfo) => flightInfo.cityName == cityNameDel);
          } else {
            if (cityNameDel == null) {
              selectedCity1 = city;
              cityNameDel = city;
              List<flightInformation> flightNameTestCopy = List.from(forSave);
              flightNameTest = flightNameTestCopy;
              flightNameTest.removeWhere(
                  (flightInfo) => flightInfo.cityName == cityNameDel);
              selectedCity1 = city;
              cityNameDel = city;
            } else {
              selectedCity1 = city;
              cityNameDel = city;
              List<flightInformation> flightNameTestCopy = List.from(forSave);
              flightNameTest = flightNameTestCopy;
              flightNameTest.removeWhere(
                  (flightInfo) => flightInfo.cityName == cityNameDel2);
              flightNameTest.removeWhere(
                  (flightInfo) => flightInfo.cityName == cityNameDel);
            }
          }
        }
        if (num == 2) {
          if (cityNameDel2 == null) {
            selectedCity2 = city;
            cityNameDel2 = city;
            flightNameTest.removeWhere(
                (flightInfo) => flightInfo.cityName == cityNameDel2);
          } else {
            if (cityNameDel == null) {
              selectedCity2 = city;
              cityNameDel2 = city;
              List<flightInformation> flightNameTestCopy = List.from(forSave);
              flightNameTest = flightNameTestCopy;
              flightNameTest.removeWhere(
                  (flightInfo) => flightInfo.cityName == cityNameDel2);
            } else {
              selectedCity2 = city;
              cityNameDel2 = city;
              List<flightInformation> flightNameTestCopy = List.from(forSave);
              flightNameTest = flightNameTestCopy;
              flightNameTest.removeWhere(
                  (flightInfo) => flightInfo.cityName == cityNameDel2);
              flightNameTest.removeWhere(
                  (flightInfo) => flightInfo.cityName == cityNameDel);
            }
          }
        }
      });
    }
  }

  void showModalBottomSheetWidget() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter myState) {
            return Center(
              child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Icon(Icons.people),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Passenger",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 1,
                              offset: Offset(0, 0),
                            ) //change blurRadius
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Adults",
                              style: TextStyle(fontSize: 15),
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    myState(() {
                                      decreaseCount();
                                    });
                                  },
                                  child: const Icon(
                                      Icons.remove_circle_outlined,
                                      color: Color.fromARGB(255, 13, 213, 130)),
                                ),
                                Text("$count"),
                                TextButton(
                                  onPressed: () {
                                    myState(() {
                                      icreaseCount();
                                    });
                                  },
                                  child: const Icon(
                                    Icons.add_circle_outlined,
                                    color: Color.fromARGB(255, 13, 213, 130),
                                  ),
                                )
                              ],
                            )
                          ],
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    const Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Icon(Icons.flight_class_outlined),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Cabin class",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 1,
                              offset: Offset(0, 0),
                            ) //change blurRadius
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Economy",
                                    style: TextStyle(fontSize: 15)),
                                Radio(
                                  activeColor: const Color.fromARGB(255, 13,
                                      213, 130), //new line(activeColor)
                                  value: passengerType[0],
                                  groupValue: currentPassenger,
                                  onChanged: (value) {
                                    myState(() {
                                      currentPassenger = value.toString();
                                      updateCurrentPassenger(value.toString());
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              child: Divider(color: Colors.black),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Business",
                                      style: TextStyle(fontSize: 15)),
                                  Radio(
                                    activeColor: const Color.fromARGB(255, 13,
                                        213, 130), //new line(activeColor)
                                    value: passengerType[1],
                                    groupValue: currentPassenger,
                                    onChanged: (value) {
                                      myState(() {
                                        currentPassenger = value.toString();
                                        updateCurrentPassenger(
                                            value.toString());
                                      });
                                    },
                                  ),
                                ])
                          ],
                        ))
                  ]),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 20.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: const EdgeInsets.all(2),
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      width: double.infinity,
                      height: 105,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 13, 213,
                              130), 
                        ),
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 1,
                              offset: Offset(0, 0)) 
                        ],
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _navigateToCitySelectionPage(context, 1);
                            },
                            child: SearchFlightFrom(selectedCity1,
                                1), 
                          ),
                          Row(
                            children: [
                              const Expanded(
                                child: SizedBox(
                                  child: Divider(color: Colors.black),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      String? saveCityName;
                                      saveCityName = selectedCity2;
                                      selectedCity2 = selectedCity1;
                                      selectedCity1 = saveCityName;
                                    });
                                  },
                                  child:
                                      const Icon(Icons.swap_vert_circle_sharp))
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              _navigateToCitySelectionPage(context, 2);
                            },
                            child: SearchFlightFrom(selectedCity2,
                                2), 
                          ),
                        ],
                      ),
                    ),
                    if (checkIfSelectCityFrom == 1) 
                      checkSerchValidation(
                          checkIfSelectCityFrom,
                          checkIfSelectCityTo,
                          selectedCity1.toString(),
                          selectedCity2
                              .toString()), 
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          margin: const EdgeInsets.all(2),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 13, 213,
                                    130), 
                              ),
                              boxShadow: const [
                                BoxShadow(
                                    blurRadius: 1,
                                    offset:
                                        Offset(0, 0)) 
                              ],
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 2,
                              ),
                              const Text(" Departure date"),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 1,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.only(
                                            left: 8,
                                            right: 200,
                                            top: 8,
                                            bottom: 8),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        elevation: 0,
                                        backgroundColor: Colors.white),
                                    child: Text(
                                      "${dateTime.day} ${monthNames[dateTime.month - 1]}",
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 17),
                                    ),
                                    onPressed: () async {
                                      DateTime? newDate = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2024));
                                      if (newDate == null) return;
                                      setState(() {
                                        dateTime = newDate;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ))
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ), 
                    GestureDetector(
                        onTap: () {
                          showModalBottomSheetWidget();
                        },
                        child: Container(
                            margin: const EdgeInsets.all(2),
                            padding: const EdgeInsets.all(15),
                            width: double.infinity,
                            height: 70,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 13, 213,
                                    130), 
                              ),
                              boxShadow: const [
                                BoxShadow(
                                    blurRadius: 1,
                                    offset:
                                        Offset(0, 0)) 
                              ],
                              borderRadius:
                                  BorderRadius.circular(10), 
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Text("$count Adult, ",
                                    style: const TextStyle(fontSize: 16)),
                                Text(currentPassenger,
                                    style: const TextStyle(fontSize: 16))
                              ],
                            ))),
                    const SizedBox(
                      height: 5,
                    ), 
                    GestureDetector(
                      onTap: () {
                        if (selectedCity1 == null) {
                          setState(() {
                            checkIfSelectCityFrom = 1; 
                          }); 
                        } else {
                          checkIfSelectCityFrom = 0; 
                        } 
                        if (selectedCity2 == null) {
                          setState(() {
                            checkIfSelectCityTo = 1; 
                          }); 
                        } else {
                          checkIfSelectCityTo = 0; 
                        } 
                        if (selectedCity1 != null && selectedCity2 != null) {
                          setState(() {
                            checkIfSelectCityFrom = 0; 
                            checkIfSelectCityTo = 0; 
                          }); 
                          if (_formKey.currentState!.validate()) {
                            toNext();
                            List<flightInformation> flightNameTestCopy =
                                List.from(forSave);
                            flightNameTest = flightNameTestCopy;
                            cityNameDel = null;
                            cityNameDel2 = null;
                            indexToUpdate = null;
                            indexToUpdate2 = null;
                          }
                        }
                      },
                      child: searchButton(),
                    ),
                  ],
                ),
              ),
            )));
  }
}