import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

import '../model/status.dart';

class StatusScreen extends StatefulWidget {
  static const String routeName = '/statusScreen';
  final Status status;
  StatusScreen({required this.status});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  StoryController controller = StoryController();
  List<StoryItem> storyItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initStoryPageItems();
  }

  void initStoryPageItems() {
    for (int i = 0; i < widget.status.photoUrl.length; i++) {
      storyItems.add(StoryItem.pageImage(
        url: widget.status.photoUrl[i],
        controller: controller,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // final status = ModalRoute.of(context)!.settings.arguments as Status;

    return Scaffold(
      body: storyItems.isEmpty
          ? const CircularProgressIndicator()
          : StoryView(
              storyItems: storyItems,
              controller: controller,
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context);
                }
              },
            ),
    );
  }
}
