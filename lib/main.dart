import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passwordgenerator/length.dart';
import 'package:passwordgenerator/service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Generator',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        hintColor: Colors.deepPurpleAccent,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      debugShowCheckedModeBanner: false,
      home: const PasswordGeneratorPage(),
    );
  }
}

class PasswordGeneratorPage extends StatefulWidget {
  const PasswordGeneratorPage({Key? key}) : super(key: key);

  @override
  _PasswordGeneratorPageState createState() => _PasswordGeneratorPageState();
}

class _PasswordGeneratorPageState extends State<PasswordGeneratorPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textEditingController = TextEditingController();
  bool _includeSymbols = true;
  bool _includeNumbers = true;
  int _passwordLength = 8;
  String _password = '';

  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // Adjust duration as needed
    )..repeat();
    _colorAnimation = ColorTween(
      begin: Colors.deepPurple,
      end: Colors.purple, // Adjust colors as needed
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Password Generator',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _colorAnimation.value ?? Colors.deepPurple,
                  _colorAnimation.value ?? Colors.purple,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      PasswordLengthDecider(
                        initialLength: _passwordLength,
                        onSliderChanged: (int val) {
                          setState(() {
                            _passwordLength = val;
                          });
                        },
                      ),
                      const SizedBox(height: 16.0),
                      ListTile(
                        leading: const Icon(Icons.lock),
                        title: const Text(
                          'Include Symbols',
                          style: TextStyle(color: Colors.black87),
                        ),
                        trailing: Switch(
                          value: _includeSymbols,
                          onChanged: (bool? val) {
                            setState(() {
                              _includeSymbols = val ?? false;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.dialpad),
                        title: const Text(
                          'Include Numbers',
                          style: TextStyle(color: Colors.black87),
                        ),
                        trailing: Switch(
                          value: _includeNumbers,
                          onChanged: (bool? val) {
                            setState(() {
                              _includeNumbers = val ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _textEditingController.text =
                                PasswordGeneratorService.generate(
                              length: _passwordLength,
                              symbols: _includeSymbols,
                              numbers: _includeNumbers,
                            );
                          });
                        },
                        icon: const Icon(Icons.lock_open),
                        label: const Text('Generate Password'),
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          onPrimary: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      TextField(
                        controller: _textEditingController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Generated Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              _password = _textEditingController.text;
                              Clipboard.setData(
                                ClipboardData(text: _password),
                              ).then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Password copied to clipboard',
                                    ),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
