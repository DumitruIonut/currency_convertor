import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Api {
  Future<List<Map<String, String>>> getCurrency() async {
    const String Url = 'https://www.bnr.ro/nbrfxrates.xml';
    final http.Client client = http.Client();
    final http.Response response = await client.get(Uri.parse(Url));
    final List<Map<String, String>> currency = <Map<String, String>>[];
    int iterator = 0;

    try {
      if (response.statusCode == 200) {
        final String jsonString = response.body;
        final List<String> data = jsonString.split('<Rate currency=');
        data.removeAt(0);
        for (final String value in data) {
          final List<String> p1 = value.split('"');
          final List<String> p2 = value.split('multiplier=');
          final String name = p1[1];
          String rateInt;
          double rate;
          if (p2.length > 1) {
            final List<String> multiplier = p2[1].split('"');
            rateInt = p2[1].split('>')[1].split('<')[0];
            rate = double.parse(rateInt) / double.parse(multiplier[1]);
          } else {
            rateInt = p1[2].split('>')[1].split('<')[0];
            rate = double.parse(rateInt);
          }

          final Map<String, String> currencyMap = <String, String>{
            'id': iterator.toString(),
            'name': name,
            'price': rate.toString(),
          };
          iterator++;
          currency.add(currencyMap);
        }
      }
    } catch (exception) {
      AlertDialog(
        title: const Text('Error'),
        content: Text(exception as String),
      );
    }
    return currency;
  }
}
