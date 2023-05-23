import 'package:flutter/material.dart';

// ************* set profile *******************
class BottomMenu extends StatefulWidget {
  Function image;
  Function camera;
  BottomMenu({required this.image, required this.camera});

  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  // const BottomMenu({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 227, 225, 225),
      height: 150,
      padding: const EdgeInsets.all(15),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black12,
                  radius: 35,
                  child: IconButton(
                    onPressed: () => widget.camera(),
                    icon: const Icon(
                      Icons.camera,
                      color: Color.fromARGB(255, 239, 44, 44),
                    ),
                    color: Colors.black,
                    iconSize: 25,
                  ),
                ),
                const Text(
                  'Camera',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black12,
                  radius: 35,
                  child: IconButton(
                    onPressed: () => widget.image(),
                    icon: const Icon(
                      Icons.photo,
                      color: Color.fromARGB(255, 239, 44, 44),
                    ),
                    color: Colors.black,
                    iconSize: 25,
                  ),
                ),
                const Text(
                  'Gallery',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        )
      ]),
    );
  }
}
