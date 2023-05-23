import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DoumentDisplay extends StatelessWidget {
  String message;
  DoumentDisplay({required this.message});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.file_copy,
      ),
      title: Text('document'),
    );
  }
}
