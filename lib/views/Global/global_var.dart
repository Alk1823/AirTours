import 'package:flutter/material.dart';

import 'flight_class_for_search.dart';

List<String> fNameList = [];
List<String> lNameList = [];
List<String> mNameList = [];
List<int> ssnNumberList = [];
List<DateTime> d = [];

int? length1;

List<String> monthNames = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec",
];
int count = 1;
int baggageCount = 1;
int baggagePrice = 0;

List<String> passengerType = ['Economy', 'Business'];
String currentPassenger = passengerType[0];
DateTimeRange dateRange = DateTimeRange(start: dateTime, end: dateTime);

DateTime dateTime =
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

String? fromName;
String? toName;
List<String> flightName = [
  'Abha',
  'Al Baha',
  'AlUla',
  'Arar',
  'Bisha',
  'Dammam',
  'Dawadmi',
  'Gassim',
  'Gizan',
  'Gurayat',
  'Hail',
  'Hofuf',
  'Jeddah',
  'Jouf',
  'Madinah',
  'Nejran',
  'Neom',
  'Qaisumah',
  'Rafha',
  'Riyadh',
  'Sharurah',
  'Tabuk',
  'Taif',
  'Turaif',
  'Wadi Al Dawaser',
  'Wedjh',
  'Yanbu Al Bahr'
];
final From = TextEditingController();

Map<String, String> shortCutFlightName = {
  'Abha': "AHB",
  'Al Baha': "ABT",
  'AlUla': "ULH",
  'Arar': "RAE",
  'Bisha': "BHH",
  'Dammam': "DMM",
  'Dawadmi': "DWD",
  'Gassim': "ELQ",
  'Gizan': "GIZ",
  'Gurayat': "URY",
  'Hail': "HAS",
  'Hofuf': "HOF",
  'Jeddah': "JED",
  'Jouf': "AJF",
  'Madinah': "MED",
  'Nejran': "EAM",
  'Neom': "NUM",
  'Qaisumah': "AQI",
  'Rafha': "RAH",
  'Riyadh': "RUH",
  'Sharurah': "SHW",
  'Tabuk': "TUU",
  'Taif': "TIF",
  'Turaif': "TUI",
  'Wadi Al Dawaser': "WAE",
  'Wedjh': "EJH",
  'Yanbu Al Bahr': "YNB",
};
List<flightInformation> flightNameTest = [
  flightInformation('Abha', "AHB"),
  flightInformation('Al Baha', "ABT"),
  flightInformation('AlUla', "ULH"),
  flightInformation('Arar', "RAE"),
  flightInformation('Bisha', "BHH"),
  flightInformation('Dammam', "DMM"),
  flightInformation('Dawadmi', "DWD"),
  flightInformation('Gassim', "ELQ"),
  flightInformation('Gizan', "GIZ"),
  flightInformation('Gurayat', "URY"),
  flightInformation('Hail', "HAS"),
  flightInformation('Hofuf', "HOF"),
  flightInformation('Jeddah', "JED"),
  flightInformation('Jouf', "AJF"),
  flightInformation('Madinah', "MED"),
  flightInformation('Nejran', "EAM"),
  flightInformation('Neom', "NUM"),
  flightInformation('Qaisumah', "AQI"),
  flightInformation('Rafha', "RAH"),
  flightInformation('Riyadh', "RUH"),
  flightInformation('Sharurah', "SHW"),
  flightInformation('Tabuk', "TUU"),
  flightInformation('Taif', "TIF"),
  flightInformation('Turaif', "TUI"),
  flightInformation('Wadi Al Dawaser', "WAE"),
  flightInformation('Wedjh', "EJH"),
  flightInformation('Yanbu Al Bahr', "YNB"),
];
String whichBooking = "";

List<flightInformation> forSave = [
  flightInformation('Abha', "AHB"),
  flightInformation('Al Baha', "ABT"),
  flightInformation('AlUla', "ULH"),
  flightInformation('Arar', "RAE"),
  flightInformation('Bisha', "BHH"),
  flightInformation('Dammam', "DMM"),
  flightInformation('Dawadmi', "DWD"),
  flightInformation('Gassim', "ELQ"),
  flightInformation('Gizan', "GIZ"),
  flightInformation('Gurayat', "URY"),
  flightInformation('Hail', "HAS"),
  flightInformation('Hofuf', "HOF"),
  flightInformation('Jeddah', "JED"),
  flightInformation('Jouf', "AJF"),
  flightInformation('Madinah', "MED"),
  flightInformation('Nejran', "EAM"),
  flightInformation('Neom', "NUM"),
  flightInformation('Qaisumah', "AQI"),
  flightInformation('Rafha', "RAH"),
  flightInformation('Riyadh', "RUH"),
  flightInformation('Sharurah', "SHW"),
  flightInformation('Tabuk', "TUU"),
  flightInformation('Taif', "TIF"),
  flightInformation('Turaif', "TUI"),
  flightInformation('Wadi Al Dawaser', "WAE"),
  flightInformation('Wedjh', "EJH"),
  flightInformation('Yanbu Al Bahr', "YNB"),
];

//for one way search
String? cityNameDel;
String? cityNameDel2;

int? indexToUpdate; //new line
int? indexToUpdate2; //new line
