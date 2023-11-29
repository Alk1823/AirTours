import 'package:flutter/material.dart';
import '../Global/global_var.dart';
import 'flight_class_for_search.dart';

class FromSearch extends StatefulWidget {
  final int fromOrTo;
  const FromSearch({
    super.key,
    required this.fromOrTo,
  });

  @override
  State<FromSearch> createState() => _FromSearchState();
}

class _FromSearchState extends State<FromSearch> {
  List<flightInformation> _filter = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _filter = flightNameTest;
    });
  }

  updateList(String value) {
    setState(() {
      _filter = flightNameTest
          .where((element) =>
              element.cityName.toLowerCase().startsWith(value.toLowerCase()))
          .where((element) => element.cityName != cityNameDel)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '< Back',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              onChanged: (value) => setState(() {
                updateList(value);
              }),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[20],
                  contentPadding: const EdgeInsets.all(0),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey.shade500,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none),
                  hintStyle:
                      TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  hintText: "Search city"),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _filter.length,
                itemBuilder: (context, index) {
                  final city = _filter[index].cityName.toString();
                  return ListTile(
                    onTap: () {
                      Navigator.pop(context, city);
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_filter[index].cityName),
                        Text(_filter[index].shortCutCityName)
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}