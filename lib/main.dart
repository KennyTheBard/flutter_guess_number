import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guess the number',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const MyHomePage(title: 'Guess the number'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  _MyHomePageState() {
    _gen = Random(DateTime
        .now()
        .millisecondsSinceEpoch);
    _randomSecret();
  }

  late Random? _gen;
  int _maxValue = 20;
  int _secretNumber = 0;
  int _guessedNumber = -1;

  void _randomSecret() {
    setState(() {
      _secretNumber = _gen!.nextInt(_maxValue) + 1;
    });
  }

  void _onChangeGuessedNumber(String value) {
    final int? guess = int.tryParse(value);
    if (guess != null) {
      setState(() {
        _guessedNumber = guess;
      });
    }
  }

  Widget _buildPopupDialog(BuildContext context) {
    if (_guessedNumber == _secretNumber) {
      final int prevSecretNumber = _secretNumber;
      setState(() {
        _maxValue *= 2;
      });
      _randomSecret();
      return AlertDialog(
        title: const Text('You guessed it!'),
        content: Text('The number what indeed $prevSecretNumber. Now try again, but a bit harder!'),
      );
    } else if (_guessedNumber == null) {
      return const AlertDialog(
        title: Text('Invalid number'),
        content: Text('You have to provide a number in the input field before guessing!'),
      );
    } else if (_guessedNumber > _secretNumber) {
      return const AlertDialog(
        title: Text('Not quite so!'),
        content: Text('Try a bit lower.'),
      );
    } else {
      return const AlertDialog(
        title: Text('Not quite so!'),
        content: Text('Try a bit higher.'),
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
                'Try to guess my secret number (1 - $_maxValue)',
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: _onChangeGuessedNumber,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+(?:\.\d+)?$')),
                ],
              ),
              TextButton.icon(
                  label: const Text('Reset'),
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {
                      _maxValue = 20;
                    });
                    _randomSecret();
                  },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog<AlertDialog>(
              context: context,
              builder: (BuildContext context) => _buildPopupDialog(context)
          );
        },
        tooltip: 'Guess',
        child: const Icon(Icons.auto_awesome),
      ),
    );
  }
}
