import 'package:AirTours/views/Profile/balance_credit_card.dart';
import 'package:flutter/material.dart';


class AddBalance extends StatefulWidget {
  const AddBalance({super.key});



  @override
  State<AddBalance> createState() => _AddBalanceState();
}

class _AddBalanceState extends State<AddBalance> {
  late final TextEditingController _amount;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _amount = TextEditingController();
    super.initState();
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 13, 213, 130),
        title: const Text('Adding Balance'),
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  //new line (container and all of it is inside)
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 8, right: 8), //0
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 13, 213,
                            130), //new line(border) and(color) Green color
                      ),
                      boxShadow: const [
                        BoxShadow(blurRadius: 2, offset: Offset(0, 0))
                      ],
                      borderRadius: BorderRadius.circular(13),
                      color: Colors.white),
                  child: TextFormField(
                    controller: _amount,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.attach_money,color: Colors.green,), //new line(prefixIcon)
                      border: InputBorder.none,
                      labelText: 'Amount Required',
                    ),
                    validator: (value) {
                      if (value!.isEmpty || !RegExp(r'^[1-9][0-9]*(\.[0-9]+)?$').hasMatch(value)) {
                        return 'Enter Correct Amount';
                      } else {
                        return null;
                      } 
                    },
                  
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                   bool isSuccessful = false;
                    setState(() {
                      if (formKey.currentState!.validate()) {
                          isSuccessful = true;
                        }
                      });
                      if (isSuccessful) {
                        final balance = _amount.text;
                        Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context) => ChargeBalance(balance: balance), 
                        ));
                            }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    padding: const EdgeInsets.all(15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 1,
                              offset: Offset(0, 0)) //change blurRadius
                        ],
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 13, 213, 130)),
                    child: const Center(
                        child: Text(
                      'Add Amount',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}




