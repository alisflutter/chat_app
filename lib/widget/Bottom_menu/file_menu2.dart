import 'package:flutter/material.dart';

//  **************** send file menu ****************
class Menu2 extends StatefulWidget {
  // var file;
  Function file;
  Function image;
  Function video;
  Menu2({required this.file, required this.image, required this.video});

  @override
  State<Menu2> createState() => _Menu2State();
}

class _Menu2State extends State<Menu2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(border: Border.all(width: 2)),
      height: 220,
      // margin: EdgeInsets.only(bottom: 20),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black12,
                  radius: 35,
                  child: IconButton(
                    onPressed: () {
                      widget.image();
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.photo,
                      color: Color.fromARGB(255, 239, 44, 44),
                    ),
                    color: Colors.black,
                    iconSize: 35,
                  ),
                ),
                const Text(
                  'Photos',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            // Column(
            //   children: [
            //     CircleAvatar(
            //       backgroundColor: Colors.black12,
            //       radius: 35,
            //       child: IconButton(
            //         onPressed: () => widget.file(),
            //         icon: Icon(Icons.insert_drive_file),
            //         color: Color.fromARGB(255, 250, 173, 6),
            //         iconSize: 35,
            //       ),
            //     ),
            //     const Text(
            //       'Douments',
            //       style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            //     ),
            //   ],
            // ),
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black12,
                  radius: 35,
                  child: IconButton(
                    onPressed: () {
                      widget.video();
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.video_camera_back),
                    color: Color.fromARGB(255, 84, 57, 239),
                    iconSize: 35,
                  ),
                ),
                const Text(
                  'Videos',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ],
            ),

            //
            // iconCreation(
            //   Icon(Icons.insert_drive_file),
            //   Colors.black,
            //   'Douments',
            //   widget.file(),
            // ),
            // iconCreation(
            //   Icon(Icons.photo),
            //   Colors.black,
            //   'Photos',
            //   widget.image(),
            // ),
            // iconCreation(
            //   Icon(Icons.video_camera_back),
            //   Colors.black,
            //   'Videos',
            //   widget.video(),
            // ),
            //     iconCreation(Icons.insert_drive_file, Colors.black, 'Doument'),
          ],
        ),
      ]),
    );
  }
}

// Widget iconCreation(
//     Icon icons, Color color, String title, Function() function) {
//   return Column(
//     children: [
//       CircleAvatar(
//         radius: 35,
//         child: IconButton(
//           onPressed: function(),
//           icon: icons,
//           color: color,
//           iconSize: 40,
//         ),
//       ),
//       Text(
//         title,
//         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//       ),
//     ],
//   );
// }
