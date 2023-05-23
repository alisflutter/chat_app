import 'package:flutter/material.dart';

import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:ph_login/screen/qr_scanner_overlay.dart';

class QrScanner extends StatelessWidget {
  const QrScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.normal,
              facing: CameraFacing.back,
              // torchEnabled: true,
            ),
            fit: BoxFit.contain,
            onDetect: (barcodes) {
              final List<Barcode> barcod = barcodes.barcodes;
              final String name;
              final String phoneNo;
              final String uid;
              var info;
              for (final barcode in barcod) {
                // debugPrint('Barcode found! ${barcode}');
                debugPrint('Barcode  ${barcode.rawValue}');
                info = barcode.rawValue?.split('+');

                // print(barcode.rawValue?.split('+')[0]);
              }
              name = info[0];
              phoneNo = info[2];
              uid = info[3];
              // print(name);
              // print(phoneNo);
              // print(uid + '+++++++++++++++++');
              Navigator.pushReplacementNamed(context, '/chatsScreen',
                  arguments: {
                    'name': name,
                    'uid': uid,
                    'isGroup': false,
                  });
            },
          ),
          const QRScannerOverlay(
            overlayColour: Color.fromARGB(255, 192, 193, 194),
          )
        ],
      ),
    );
  }
}
