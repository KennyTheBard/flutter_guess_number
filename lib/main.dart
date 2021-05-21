import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guess the number',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(title: 'Guess the number'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _max_value = 20;
  Random _gen;
  int _secret_number = 0;
  int _guessed_number;

  _MyHomePageState() {
    _gen = new Random(DateTime
        .now()
        .millisecondsSinceEpoch);
    _random_secret();
  }

  void _random_secret() {
    setState(() {
      _secret_number = _gen.nextInt(_max_value) + 1;
    });
  }

  void _onChangeGuessedNumber(String value) {
    var guess = int.tryParse(value);
    if (guess != null) {
      setState(() {
        _guessed_number = guess;
      });
    }
  }

  Widget _buildPopupDialog(BuildContext context) {
    if (_guessed_number == _secret_number) {
      var prev_secret_number = _secret_number;
      setState(() {
        _max_value *= 2;
      });
      _random_secret();
      return new AlertDialog(
        title: new Text("You guessed it!"),
        content: new Text("The number what indeed $prev_secret_number. Now try again, but a bit harder!"),
      );
    } else if (_guessed_number == null) {
      return new AlertDialog(
        title: new Text("Invalid number"),
        content: new Text("You have to provide a number in the input field before guessing!"),
      );
    } else if (_guessed_number > _secret_number) {
      return new AlertDialog(
        title: new Text("Not quite so!"),
        content: new Text("Try a bit lower."),
      );
    } else {
      return new AlertDialog(
        title: new Text("Not quite so!"),
        content: new Text("Try a bit higher."),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Try to guess my secret number (1 - $_max_value)',
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: _onChangeGuessedNumber,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+(?:\.\d+)?$')),
                ],
              ),
              TextButton.icon(
                  label: Text("Reset"),
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {
                      _max_value = 20;
                    });
                    _random_secret();
                  },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => _buildPopupDialog(context)
          );
        },
        tooltip: 'Guess',
        child: Icon(Icons.auto_awesome),
      ),
    );
  }
}
