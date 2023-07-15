import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/common/colors.dart';
import 'package:food_buyer/common/foodbuyer_colors.dart';
import 'package:food_buyer/services/address.dart';
import 'package:get/get.dart';
import 'package:simple_audio_player/simple_audio_player.dart';
import '../models/ChatMessage.dart';
import 'constants.dart';

class AudioMessage extends StatelessWidget {
  const AudioMessage({super.key, required this.message});
  final ChatMessage message;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        message.isSender == true
            ? SizedBox()
            : Container(
                width: Get.width / 2 - 5,
                // color: Colors.red,
                child: Text(
                  '${message.nick_name}',
                  style:
                      TextStyle(fontSize: 11, color: kDTCloudGray),
                ),
              ),
        Container(
          // width: MediaQuery.of(context).size.width * 0.55,
          padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding * 0.2,
            vertical: kDefaultPadding / 2.5,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColor.themeColor.withOpacity(message.isSender ? 0 : 0.08),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),

              message.isSender == false
                  ? Container(
                      decoration: BoxDecoration(
                        color: kDTCloud700,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      // width: 100,
                      child: AudioContainer(
                        urlPath: message.text,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: kDTCloud700,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      // width: 100,
                      child: AudioContainer(
                        urlPath: message.text,
                      ),
                    ),

              // VoiceMessage(
              //   contactCircleColor: Colors.grey.shade200,
              //   contactFgColor: Colors.grey,
              //   audioSrc: '${Address.storage}/${message.text}',
              //   meBgColor:message.isSender==true?AppColor.themeColor:
              //   AppColor.themeColor.withOpacity(0.1),
              //   played: false, // To show played badge or not.
              //   me: message.isSender, // Set message side.
              //   onPlay: () {
              //
              //   }, // Do something when voice played.
              // ),
              Container(
                padding: EdgeInsets.only(top: 5),
                alignment: message.isSender
                    ? Alignment.centerRight
                    : Alignment.centerRight,
                width: 200,
                // color: Colors.red,
                child: Text(
                  message.time,
                  style: TextStyle(
                      color: message.isSender ? kDTCloudGray : kDTCloudGray,
                      fontSize: 11),
                ),
              ),

              // Text('0.37', style: TextStyle(fontSize: 12, color: message.isSender ? Colors.white : null))
            ],
          ),
        ),
      ],
    );
  }
}

class AudioContainer extends StatefulWidget {
  String? urlPath;

  AudioContainer({this.urlPath, Key? key}) : super(key: key);

  @override
  State<AudioContainer> createState() => _AudioContainerState();
}

class _AudioContainerState extends State<AudioContainer> {
  late SimpleAudioPlayer simpleAudioPlayer;

  double sliderValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    simpleAudioPlayer = SimpleAudioPlayer();

    simpleAudioPlayer.songStateStream.listen((event) {
      if (event.state == SimpleAudioPlayerSongState.onReady) {
        setState(() {
          sliderValue = 0;
        });
      } else if (event.state == SimpleAudioPlayerSongState.onPositionChange) {
        setState(() {
          sliderValue = event.data[0] / event.data[1];
        });
      } else if (event.state == SimpleAudioPlayerSongState.onPlayEnd) {
        setState(() {
          sliderValue = 1;
          sliderValue = 0;

          simpleAudioPlayer.stop();
          // simpleAudioPlayer.prepare(uri: widget.urlPath!);
        });
      } else if (event.state == SimpleAudioPlayerSongState.onError) {
        BotToast.showText(text: 'Playback error');
      }
      print("song event : $event");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              // simpleAudioPlayer = SimpleAudioPlayer();
              print('${Address.storage}/${widget.urlPath!}');
              simpleAudioPlayer.prepare(
                  uri:
                      '${Address.storage}/${widget.urlPath!}');
              simpleAudioPlayer.setPlaybackRate(rate: 1.0);
              simpleAudioPlayer.play();
            },
            icon: Icon(
              sliderValue == 0 ? Icons.play_arrow : Icons.pause,
              size: 15,color: Colors.white,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 0),
              CupertinoSlider(
                value: sliderValue,
                activeColor:  Colors.white,
                onChanged: (changeValue) {
                  setState(() {
                    sliderValue = changeValue;
                  });
                },

                onChangeEnd: (changeValue) async {
                  simpleAudioPlayer.prepare(
                      uri:
                          '${Address.storage}/${widget.urlPath!}');
                  simpleAudioPlayer.play();
                  final duration = await simpleAudioPlayer.getDuration();
                  simpleAudioPlayer.seekTo(
                      position: (duration * changeValue).toInt());
                },
              ),
            ],
          ),
          // Text('data')
        ],
      ),
    );
  }
}
