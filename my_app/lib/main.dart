import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:country_icons/country_icons.dart';

void main() async{
  runApp(const MyApp());
 // var url = Uri.parse('https://calendarific.com/api/v2/holidays?&api_key=ef164850bc4a9dc322d5d3c685759d07a47ac702&country=US&year=2019');
  //var res = await http.get(url);
  //if (res.statusCode != 200) throw Exception('http.get error: statusCode= ${res.statusCode}');
  //print(res.body);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Seleccionador de días festivos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class PageResult extends StatelessWidget {
  final String textofinal;
  const PageResult(this.textofinal) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Text(textofinal),
        ),
        //
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        tooltip: null,
        child: const Icon(Icons.add_to_home_screen),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  String _country = "es";
  var flag = Image.asset('icons/flags/png/es.png', package: 'country_icons');
  String textyear = "Seleccione un año entre 1900 - 2049";
  String finalresult = "Revisa días festivos";
  String title = "Seleccionador de días festivos";

  void _changeCountry() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if (_country == "es") {
        _country = "fr";
        flag = Image.asset('icons/flags/png/fr.png', package: 'country_icons');
        textyear = "Choisissez une année entre 1900 et 2049";
        finalresult = "Vérifier les jours fériés";
        title = "Sélecteur de vacances";
      } else {
        _country = "es";
        flag = Image.asset('icons/flags/png/es.png', package: 'country_icons');
        textyear = "Seleccione un año entre 1900 - 2049";
        finalresult = "Revisa días festivos";
        title = "Seleccionador de días festivos";
      };
    });
  }

  Future<void> _checkYear(value) async {
    print(value);
    var valor = int.parse(value);
    if (valor < 1900 || valor > 2043) {
      print("false");
    } else {
      var url = Uri.parse(('https://calendarific.com/api/v2/holidays?&api_key=ef164850bc4a9dc322d5d3c685759d07a47ac702&country=')+_country+('&year=')+value);
      var res = await http.get(url);
      if (res.statusCode != 200) throw Exception('http.get error: statusCode= ${res.statusCode}');
      Navigator.push(context, MaterialPageRoute(builder: (context) => PageResult(res.body)),);
    }
  }

  //@override
  //Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    final anho = TextEditingController();
    String y = "";
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: flag,
            ),
            TextField(
              controller: anho,
              autofocus: false,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textInputAction: TextInputAction.send,
              decoration: InputDecoration(border: OutlineInputBorder(), labelText: textyear),
          ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 80),
              child: ElevatedButton(
                child: Text(
                  finalresult,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'rbold',
                  )
                ),
                onPressed: (){
                  y = anho.text;
                  _checkYear(y);
                },
              )
            )
          ]
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _changeCountry,
          tooltip: _country,
          child: const Icon(Icons.flag_rounded),
        ),
      );
    }
  //}
}
