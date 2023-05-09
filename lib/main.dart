
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(new MaterialApp(
      home: new MyTextInput()
  ));
}
String cityString='';
String city = "";
String rise = '';
String set = '';
String sunsetResultString = '';

late Map mapResponse;
late Map sunsetMapResponse;
late List firstdata;
late Map sunsetString;
String longitude = '';
String latitude = '';
String btnResponse ='';


class MyTextInput extends StatefulWidget {
  @override
  MyTextInputState createState() => new MyTextInputState();
}

class MyTextInputState extends State<MyTextInput>{

  final fieldText = TextEditingController();

  Future apicall() async {
    http.Response response;
    response = await http.get(Uri.parse("http://api.positionstack.com/v1/forward?access_key=7a007716d1f042279f90a014398d4bb3&query=$city"));

    if(response.statusCode == 200){
      setState(() {
        mapResponse = json.decode(response.body);
        firstdata = mapResponse['data'];
        longitude = firstdata[0]['longitude'].toString();
        latitude = firstdata[0]['latitude'].toString();

        cityString = 'longitude: $longitude   latitude: $latitude';
      });
    }

  }

  Future sunset() async {
    showDialog(
      context: context,
      builder: (context){
        return Center(child: CircularProgressIndicator());
      },
    );
    http.Response sunsetResponse;
    sunsetResponse = await http.get(Uri.parse(
        "https://api.sunrise-sunset.org/json?lat=$latitude.996620&lng=$longitude.369110&formatted=0"));

    Navigator.of(context).pop();

    if (sunsetResponse.statusCode == 200) {
      setState(() {
        sunsetMapResponse = json.decode(sunsetResponse.body);
        sunsetString = sunsetMapResponse['results'];
        rise = sunsetString['sunrise'].toString();
        set = sunsetString['sunset'].toString();

        sunsetResultString = '\nsunrise: $rise \nsunset: $set';
      });
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: new AppBar(title: new Text("Pro Muslim"), backgroundColor: Colors.deepOrange),
        body: new Container(
            child: new Center(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new TextField(
                          decoration: new InputDecoration(
                              hintText: "Type in here"
                          ),
                          onChanged: (value)=> city = value,
                          //onChanged is called whenever we add or delete something on Text Field
                          // onSubmitted: (String str){
                          //   setState((){
                          //     result = btnResponse;
                          //   });
                          // }
                      ),
                      new Container(
                        child: TextButton(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all(Colors.deepOrange)
                          ),
                          onPressed: () {
                            sunset();
                            apicall();
                            // setState(() {
                            //   btnResponse = '$cityString\n$sunsetResultString ';
                            // });
                          },
                          child: Text('Go'),
                        ),
                      ),
                      //displaying input text
                      Text(cityString),
                      Center(child: new Text(sunsetResultString)),
                    ]
                )
            ),
        )
    );
  }
}
