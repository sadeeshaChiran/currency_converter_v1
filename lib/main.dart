import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color mainColor = Color(0x949398FF);
  Color secendColor = Color(0xF4DF4EFF);

  double amount = 0.0;
  double convertedAmount = 0.0;
  String convertedAmountString = "0.00";
  bool isLoadingCurrency = false;
  bool isLoadingPage = false;

  bool isCadToLkr = false;
  bool isLkrToCad = true;

  String to = "CAD";
  String from = "LKR";

  void convertCurrency() async {
    setState(() {
      isLoadingCurrency = true;
    });

    // Fetch exchange rates from API
    final Uri uri = Uri.parse('https://api.exchangerate-api.com/v4/latest/CAD');
    final response = await http.get(uri); // Example API endpoint for CAD rates
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);

      // Extract exchange rates
      double cadToLkrRate = data['rates']['LKR'];
      double lkrToCadRate = 1 / cadToLkrRate;

      // Perform conversion
      if (isCadToLkr) {
        convertedAmount = amount * cadToLkrRate;
      } else if (isLkrToCad) {
        convertedAmount = amount * lkrToCadRate;
      }
      convertedAmountString = convertedAmount.toStringAsFixed(2);
    } else {
      // Handle error
      print('Failed to load exchange rates');
    }

    setState(() {
      isLoadingCurrency = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Currency Convertor",
                    style: TextStyle(
                      color: Color.fromARGB(255, 227, 210, 231),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              isLoadingPage
                  ? const CircularProgressIndicator()
                  : Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: from,
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16.0,
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                amount = double.tryParse(value) ?? 0.0;
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right:
                                          8.0), // Adjust the amount of space as needed
                                  child: Container(
                                    child: Text(
                                      from,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromARGB(54, 156, 7, 255)),
                                  child: IconButton(
                                    icon: const Icon(Icons.swap_horiz),
                                    onPressed: () {
                                      setState(() {
                                        isLoadingPage = true;
                                        if (isCadToLkr) {
                                          from = "LKR";
                                          to = "CAD";
                                          convertedAmountString = '0.00';
                                          isLkrToCad = true;
                                          isCadToLkr = false;
                                        } else if (isLkrToCad) {
                                          from = "CAD";
                                          to = "LKR";
                                          convertedAmountString = "0.00";
                                          isLkrToCad = false;
                                          isCadToLkr = true;
                                        }
                                        isLoadingPage = false;
                                      });
                                    },
                                    color: Colors.white,
                                  ),
                                ),
                                // ignore: avoid_unnecessary_containers
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left:
                                          8.0), // Adjust the amount of space as needed
                                  child: Container(
                                    child: Text(
                                      to,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            ElevatedButton(
                              onPressed: () {
                                convertCurrency();
                              },
                              child: const Text('Convert'),
                            ),
                            const SizedBox(height: 40.0),
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0)),
                              child: isLoadingCurrency
                                  ? const CircularProgressIndicator()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              to,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              convertedAmountString,
                                              style: const TextStyle(
                                                  color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
