import 'package:flutter/material.dart';
import 'api.dart';

void main() {
  runApp(const FlutterApp());
}

class FlutterApp extends StatelessWidget {
  const FlutterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController controller = TextEditingController();
  String? errorText;
  String ronValue = '';
  String e = '';
  int? intIndex;
  List<Map<String, String>> currencyList = <Map<String, String>>[];
  double? currencyPrice;

  @override
  void initState() {
    super.initState();
    loadDataApi();
  }

  Future<List<Map<String, String>>> loadDataApi() async {
    final List<Map<String, String>> items = await Api().getCurrency();
    for (int i = 0; i < items.length; i++) {
      currencyList.add(items[i]);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Center(
                child: Image.network('http://abrevierile.ro/i/bnr-banca-nationala-a-romaniei-logotip.jpg'),
              ),
              TextField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'enter the amount to convert to lei',
                  helperText: 'please enter a number',
                  errorText: errorText,
                  suffix: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      controller.clear();
                    },
                  ),
                ),
                onChanged: (String? value) {
                  final double? doubleValue = double.tryParse(value!);
                  setState(() {
                    if (doubleValue == null) {
                      errorText = 'this is not a number';
                    } else {
                      errorText = null;
                    }
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  DropdownButton<int>(
                    value: intIndex,
                    onChanged: (int? value) {
                      setState(() {
                        intIndex = value;
                        currencyPrice = double.parse(currencyList[value!]['price']!);
                      });
                    },
                    items: currencyList
                        .map((Map<String, String> data) => DropdownMenuItem<int>(
                              value: int.tryParse(data['id'].toString()),
                              child: Text(data['name'].toString()),
                            ))
                        .toList(),
                    hint: const Text('Select currency'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      double? price;
                      setState(() {
                        if (controller.text == '') {
                          e = 'you must enter a numeric value';
                          ronValue = '';
                        } else if (currencyPrice == null) {
                          e = 'you must select currency';
                          ronValue = '';
                        } else {
                          e = '';
                          price = double.tryParse(controller.text)! * currencyPrice!;
                          ronValue = price!.toStringAsFixed(2);
                          ronValue += ' Lei';
                        }
                      });
                    },
                    child: const Text('Convert'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    ronValue,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 32.0,
                    ),
                  ),
                  Text(e,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 22.0,
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
