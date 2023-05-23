// // import 'package:flutter/material.dart';
// // import 'package:flutter/src/widgets/container.dart';
// // import 'package:flutter/src/widgets/framework.dart';
// // import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// // class PDFView extends StatefulWidget {
// //   String message;
// //   PDFView(this.message);

// //   @override
// //   State<PDFView> createState() => _PDFViewState();
// // }

// // class _PDFViewState extends State<PDFView> {
// //   late PdfViewerController _pdfViewerController;

// //   @override
// //   void initState() {
// //     // TODO: implement initState
// //     _pdfViewerController = PdfViewerController();
// //     super.initState();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Pdf '),
// //       ),
// //       body: SfPdfViewer.network(
// //         widget.message,
// //         controller: _pdfViewerController,
// //       ),
// //     );
// //   }
// // }

// //

// import 'package:flutter/material.dart';
// // import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// // void main() {
// //   runApp(MaterialApp(
// //     title: 'Syncfusion PDF Viewer Demo',
// //     home: HomePage(),
// //   ));
// // }

// /// Represents Homepage for Navigation
// class HomePage extends StatefulWidget {
//   String message;
//   HomePage(this.message);
//   @override
//   _HomePage createState() => _HomePage();
// }

// class _HomePage extends State<HomePage> {
//   final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Syncfusion Flutter PDF Viewer'),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(
//               Icons.bookmark,
//               color: Colors.white,
//               semanticLabel: 'Bookmark',
//             ),
//             onPressed: () {
//               _pdfViewerKey.currentState?.openBookmarkView();
//             },
//           ),
//         ],
//       ),
//       body: SfPdfViewer.network(
//         widget.message,
//         // 'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
//         key: _pdfViewerKey,
//       ),
//     );
//   }
// }
