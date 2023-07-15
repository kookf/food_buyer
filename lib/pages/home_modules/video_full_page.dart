import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
class VideoFullPage extends StatefulWidget {
  
  VideoPlayerController? _controller;
  
  VideoFullPage(this._controller, {Key? key}) : super(key: key);

  @override
  State<VideoFullPage> createState() => _VideoFullPageState();
}

class _VideoFullPageState extends State<VideoFullPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SystemChrome.setPreferredOrientations([
      // 强制竖屏
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child:  Center(
          child: widget._controller!.value.isInitialized
              ? Hero(
            tag: 'hero',
            child: AspectRatio(
              aspectRatio: widget._controller!.value.aspectRatio,
              child: Stack(
                children: [
                  VideoPlayer(widget._controller!),
                  GestureDetector(
                    onTap: () {
                      _togglePlayControl();
                      print('object');
                      // widget._controller.value.isPlaying ?
                      // widget._controller.pause() :
                      // widget._controller.play();
                      // setState(() {
                      //
                      // });
                    },
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 50),
                    reverseDuration: const Duration(milliseconds: 200),
                    child: _playControlOpacity==0 ?
                    const SizedBox.shrink()
                        : Container(
                      color: Colors.black12,
                      child: Center(
                          child:widget._controller!.value.isPlaying?
                          IconButton(onPressed: (){
                            print('sdfsdf');
                            widget._controller!.pause();
                            setState(() {

                            });
                          }, icon: Image.asset('images/v_pause_n.png',
                            width: 50,
                            height: 50,)):
                          IconButton(onPressed: (){
                            widget._controller!.play();
                            setState(() {

                            });
                          }, icon: Image.asset('images/v_play_n.png',
                            width: 50,
                            height: 50,))
                      ),
                    ),
                  ),


                  _hidePlayControl==true?
                  SizedBox():
                  customProgress(),

                  _hidePlayControl==true?
                  SizedBox():
                  progress()
                ],
              ),
            ),
          ) :
          Container(
            width: Get.width,
            height: 200,
            child: Center(child: CupertinoActivityIndicator(),),),
        ),
      ),
    );
  }

  Widget customProgress(){
    return AnimatedSwitcher(duration: Duration(milliseconds: 200,),
      child: _playControlOpacity==0?
      SizedBox():
      Align(alignment:Alignment.bottomCenter,
        child:Container(
          padding: EdgeInsets.only(left: 5,right: 5,top: 5),
          width: Get.width,
          color: Colors.transparent,
          height: 45,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Align(
               alignment: Alignment.topRight,
               child:  GestureDetector(
                 onTap: (){
                   _toggleFullScreen();
                 },
                 child: Image.asset('images/v_nofull_n.png',width: 15,
                   height: 15,),
               ),
             ),
              SizedBox(height: 5,),
              // ValueListenableBuilder(
              //   valueListenable: _controller,
              //   builder: (BuildContext context, value, Widget? child) {
              //     return  Text('${_printDuration(_controller.value.position)}/'
              //         '${_printDuration(_controller.value.duration)}',
              //       style: const TextStyle(
              //         fontSize: 11,color: Colors.white
              //     ),);
              // },
              // ),
              ValueListenableBuilder(
                valueListenable: widget._controller!,
                builder: (BuildContext context, value, Widget? child) {
                  final durationState = widget._controller!.value;
                  final progress = durationState.position ?? Duration.zero;
                  final buffered = durationState.buffered.first.end ?? Duration.zero;
                  final total = durationState.duration ?? Duration.zero;
                  return ProgressBar(
                    progressBarColor: Colors.red,
                    barCapShape: BarCapShape.round,
                    barHeight: 3,
                    thumbColor: Colors.red,
                    thumbRadius: 5,
                    timeLabelTextStyle: TextStyle(
                        fontSize: 11,color: Colors.white
                    ),
                    timeLabelLocation: TimeLabelLocation.sides,
                    progress: progress,
                    bufferedBarColor: Colors.yellowAccent,
                    buffered: buffered,
                    total: total,
                    onSeek: (duration) {
                      widget._controller!.seekTo(duration);
                    },
                  );
                },
              ),
            ],
          ),
        ),),
    );
  }

  Widget progress(){
    return  AnimatedSwitcher(duration: Duration(milliseconds: 200,),
      child: widget._controller!.value.isPlaying?
      Align(alignment: Alignment.bottomCenter,
        child: Container(
          height: 6,
          child: VideoProgressIndicator(
              widget._controller!, allowScrubbing: true),
        ),):SizedBox(),
    );
  }

  ///
  bool _hidePlayControl = true;
  int _playControlOpacity = 0;

  void _togglePlayControl() {
    setState(() {
      if (_hidePlayControl) {
        /// 如果隐藏则显示
        _hidePlayControl = false;
        _playControlOpacity = 1;
        _startPlayControlTimer(); // 开始计时器，计时后隐藏
      } else {
        /// 如果显示就隐藏
        if (_timer != null) _timer!.cancel(); // 有计时器先移除计时器
        _playControlOpacity = 0;
        Future.delayed(Duration(milliseconds: 500)).whenComplete(() {
          _hidePlayControl = true; // 延迟500ms(透明度动画结束)后，隐藏
        });
      }
    });
  }
  Timer? _timer;
  void _startPlayControlTimer() {
    /// 计时器，
    if (_timer != null) _timer!.cancel();
    _timer = Timer(Duration(seconds: 4), () {
      /// 延迟4s后隐藏
      setState(() {
        _playControlOpacity = 0;
        Future.delayed(Duration(milliseconds: 500)).whenComplete(() {
          _hidePlayControl = true;
        });
      });
    });
  }

  ///全屏
  void _toggleFullScreen() {

    SystemChrome.setPreferredOrientations([
      // 强制竖屏
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    ///显示状态栏，与底部虚拟操作按钮
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);

    Get.back();

    // setState(() {
    //   _startPlayControlTimer(); // 操作完控件开始计时隐藏
    // });
  }

}
