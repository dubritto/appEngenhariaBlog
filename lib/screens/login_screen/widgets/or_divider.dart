import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Divider(
            color: Colors.white70,
          ),
        ),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('ou', style: TextStyle(color: Colors.white),),
        ),
        Expanded(
          child: Divider(
            color: Colors.white70,
          ),
        )
      ],
    );
  }
}
