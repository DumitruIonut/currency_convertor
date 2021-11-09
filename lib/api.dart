import 'dart:async';
import 'package:http/http.dart' as http;

class Api {
  Future getCurrency() async {
    final String Url = 'https://www.bnr.ro/nbrfxrates.xml';
    var client = http.Client();
    var response = await client.get(Uri.parse(Url));
    List currency = [];
    int iterator = 0;

    try {
      if (response.statusCode == 200) {
        var jsonString = response.body;
        List<String> data = jsonString.split("<Rate currency=");
        data.removeAt(0);
        for (var value in data) {
          var p1 = value.split('"');
          var p2 = value.split('multiplier=');
          var name = p1[1];
          var rate;
          if (p2.length > 1) {
            var multiplier = p2[1].split('"');
            rate = p2[1].split('>')[1].split('<')[0];
            rate = double.parse(rate) / double.parse(multiplier[1]);
          } else {
            rate = p1[2].split('>')[1].split('<')[0];
          }
          var currencyMap = {
            'id' : iterator,
            'name': name,
            'price': rate,
          };
          iterator ++;
          currency.add(currencyMap);
        }
      }
    } catch (Exception) {
      print(Exception);
    }
    return currency;
  }
}
