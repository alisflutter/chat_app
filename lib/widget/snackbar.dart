import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  try {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        //  margin: const EdgeInsets.all(12),
      ),
    );
  } catch (e) {
    print(e);
  }
}
