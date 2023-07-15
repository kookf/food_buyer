import 'package:flutter/material.dart';

import '../models/ChatMessage.dart';
import 'constants.dart';

class VideoMessage extends StatelessWidget {
  const VideoMessage({super.key, required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.45,
        child: AspectRatio(
          aspectRatio: 1.6,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset('images/Video_Place_Here.png'),
              ),

              // Container(
              //   height: 25,
              //   width: 25,
              //   decoration: const BoxDecoration(
              //     shape: BoxShape.circle,
              //     color: kPrimaryColor,
              //   ),
              //   child: Icon(
              //     Icons.play_arrow,
              //     size: 16,
              //     color: Colors.white,
              //   ),
              // ),
            ],
          ),
        ));
  }
}
