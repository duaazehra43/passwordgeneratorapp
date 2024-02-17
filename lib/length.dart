import 'package:flutter/material.dart';

class PasswordLengthDecider extends StatefulWidget {
  const PasswordLengthDecider(
      {Key? key, this.initialLength = 8, this.onSliderChanged})
      : super(key: key);
  final ValueChanged<int>? onSliderChanged;
  final int initialLength;

  @override
  _PasswordLengthDeciderState createState() => _PasswordLengthDeciderState();
}

class _PasswordLengthDeciderState extends State<PasswordLengthDecider> {
  late double _passwordLength;

  @override
  void initState() {
    _passwordLength = widget.initialLength.toDouble();
    super.initState();
  }

  String get _passwordLengthStr => _passwordLength.round().toString();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text('Password Length: $_passwordLengthStr',
                style: Theme.of(context).textTheme.subtitle1),
          ),
          Expanded(
            child: Slider(
              value: _passwordLength,
              onChanged: (double val) {
                if (widget.onSliderChanged != null) {
                  widget.onSliderChanged!(val.round());
                }
                setState(() {
                  _passwordLength = val;
                });
              },
              min: 4,
              max: 32,
              label: _passwordLength.round().toString(),
            ),
          )
        ],
      ),
    );
  }
}
