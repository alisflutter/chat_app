import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../providers/wallpaper.dart';

class WallPaperColors extends StatefulWidget {
  const WallPaperColors({super.key});

  @override
  State<WallPaperColors> createState() => _WallPaperColorsState();
}

class _WallPaperColorsState extends State<WallPaperColors> {
  int selectedCard = -1;

  @override
  Widget build(BuildContext context) {
    final wall = Provider.of<Wallpaper>(context);
    final List<Color> _colors = [
      Color.fromARGB(244, 255, 255, 255),
      Colors.red.shade100,
      Colors.cyan.shade100,
      Colors.deepOrange.shade100,
      Colors.blueGrey.shade100,
      Colors.orange.shade100,
      Colors.brown.shade100,
      Colors.deepPurple.shade100
    ];

    // final List<Color> _selectedColor = [];
    // bool ischeck = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Wallpaper'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Center(
            child: Container(
                padding: const EdgeInsets.all(25),
                child: const Text(
                  'Choose Color',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                )),
          ),
          SizedBox(
            height: 250,
            child: GridView.builder(
                padding: const EdgeInsets.all(10),
                shrinkWrap: false,
                // scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 20,
                    // childAspectRatio: 1 / 3,
                    crossAxisSpacing: 20),
                itemCount: _colors.length,
                itemBuilder: (BuildContext ctx, int index) {
                  return GestureDetector(
                    onTap: () {
                      // setState(() {
                      //   ischeck = true;
                      // });
                      setState(() {
                        selectedCard = index;
                      });
                      print(_colors[index]);
                      print(index);
                      // if (_colors[index]
                      //     .toString()
                      //     .contains(_selectedColor.toString())) {
                      //   setState(() {
                      //     _selectedColor.remove(_colors[index]);
                      //   });
                      // } else {
                      //   setState(() {
                      //     _selectedColor.add(_colors[index]);
                      //   });
                      // }
                      //  print(_colors[index].toString());
                      //   print(_selectedColor);
                      // print(ischeck);
                    },
                    child: Container(
                      // padding: EdgeInsets.all(15),
                      // height: 80,
                      // width: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: _colors[index],
                          border: Border.all(
                              width: 2,
                              color: selectedCard == index
                                  ? Colors.black
                                  : Colors.white),
                          borderRadius: BorderRadius.circular(15)),
                      child: Text('$index'),
                      // child: Text(colors[index].toString()),
                    ),
                  );
                }),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
            child: ElevatedButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.only(
                            left: 30, right: 30, top: 13, bottom: 13)),
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 143, 188, 143)),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    )), //
                onPressed: (() {
                  wall.backgroundImage(_colors.elementAt(selectedCard).value);
                  print(_colors.elementAt(selectedCard).value);
                  Navigator.pop(context);
                }),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                )),
          ),
        ],
      ),
    );
  }
}
