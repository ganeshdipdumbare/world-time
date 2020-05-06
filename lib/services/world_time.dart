import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String location; // location name on the UI
  String time; // time on the UI
  String flag; // url to asset flag icon
  String url; // location url for api endpoint
  bool isDayTime; // true if day time, false otherwise

  WorldTime({this.location, this.flag, this.url});

  Future<void> getTime() async {
    try {
      Response resp = await get('http://worldtimeapi.org/api/timezone/$url');
      Map data = jsonDecode(resp.body);
      String datetime = data['datetime'];
      String utcOffset = data['utc_offset'].toString().substring(1, 3);
      String sign = data['utc_offset'].toString().substring(0, 1);

      DateTime now = DateTime.parse(datetime);
      if (sign == '+') {
        now = now.add(Duration(hours: int.parse(utcOffset)));
      } else {
        now = now.subtract(Duration(hours: int.parse(utcOffset)));
      }
      // set time property
      isDayTime = now.hour > 6 && now.hour < 20 ? true : false;
      time = DateFormat.jm().format(now);
    } catch (e) {
      print('error occurred: $e');
      time = 'could not get time data';
    }
  }
}
