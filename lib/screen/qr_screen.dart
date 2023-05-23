import 'package:flutter/material.dart';

import 'package:ph_login/screen/qr_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrScreen extends StatefulWidget {
  final String userName;
  final String userPhone;
  final String uid;

  const QrScreen(
      {super.key,
      required this.userName,
      required this.userPhone,
      required this.uid});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: ((context) {
                  return const QrScanner();
                })));
              },
              icon: const Icon(Icons.qr_code_scanner_sharp)),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              // width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              color: Colors.white,
              child: Text(
                widget.userName,
                style: const TextStyle(fontSize: 25, color: Colors.black),
              ),
            ),
            //{'name': widget.userName, 'phone': widget.userPhone}
            Container(
              // margin: EdgeInsets.only(top: 12),
              color: Colors.white,
              child: QrImage(
                data: '${widget.userName} +${widget.userPhone} +${widget.uid}',
                version: QrVersions.auto,
                size: 200,
              ),
            )
          ],
        ),
      ),
    );
  }
}
