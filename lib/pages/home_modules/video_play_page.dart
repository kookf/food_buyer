import 'dart:async';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_buyer/pages/home_modules/video_full_page.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import '../../services/address.dart';

class VideoPlayPage extends StatefulWidget {

  String urlPath;

  VideoPlayPage({required this.urlPath,Key? key}) : super(key: key);

  @override
  State<VideoPlayPage> createState() => _VideoPlayPageState();
}

class _VideoPlayPageState extends State<VideoPlayPage> {

  late VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

      _controller = VideoPlayerController.network(
          '${Address.storage}/${widget.urlPath}')
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
          print('object==${_controller.value.duration}');
        });
      _controller.addListener(_videoListener);
      // _controller.play();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();

    super.dispose();

  }

  GlobalKey _key = GlobalKey();

  void _videoListener() async {
    if (_controller.value.hasError) {
      setState(() {
        print('===================${_controller.value.hasError}');
        print('视频加载出错');
        _urlChange();
        // _videoError = true;
      });
    } else {
      Duration? res = await _controller.position;
      if (res! >= _controller.value.duration) {
        await _controller.seekTo(Duration(seconds: 0));
        await _controller.pause();
      }
      if (_controller.value.isPlaying && _key.currentState != null) {
        /// 减少build次数
        // _key.currentState.setPosition(
        //   position: res,
        //   totalDuration: _controller.value.duration,
        // );
      }
    }
  }

  Widget progress(){
    return  AnimatedSwitcher(duration: Duration(milliseconds: 200,),
      child: _controller.value.isPlaying?
      Align(alignment: Alignment.bottomCenter,
        child: Container(
          height: 10,
          child: VideoProgressIndicator(
              _controller, allowScrubbing: true),
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
    /// 计时器
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
  @override
  void didUpdateWidget(covariant VideoPlayPage oldWidget) {
    // TODO: implement didUpdateWidget


    print('_urlChange_urlChange_urlChange_urlChange');
    _urlChange(); // url变化时重新执行一次url加载

    super.didUpdateWidget(oldWidget);
  }
  void _urlChange() async {
    // if (widget.url == null || widget.url == '') return;
    _controller.removeListener(_videoListener);
    _controller.dispose();
    setState(() {
      /// 重置组件参数
    });
    _controller = VideoPlayerController.network(
        '${Address.storage}/${widget.urlPath}'
    );

    /// 加载资源完成时，监听播放进度，并且标记_videoInit=true加载完成
    _controller.addListener(_videoListener);
    await _controller.initialize();
    setState(() {
      // _controller.play();
    });
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
          height: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ValueListenableBuilder(
                    valueListenable: _controller,
                    builder: (BuildContext context, value, Widget? child) {
                      return  Text('${_printDuration(_controller.value.position)}/'
                          '${_printDuration(_controller.value.duration)}',
                        style: const TextStyle(
                            fontSize: 11,color: Colors.white
                        ),);
                    },
                  ),
                  Align(
                    child:  GestureDetector(
                      onTap: (){
                        _toggleFullScreen();
                      },
                      child: Image.asset('images/v_nofull_n.png',width: 15,
                        height: 15,),
                    ),
                    alignment: Alignment.topRight,
                  ),
                ],
              ),
              SizedBox(height: 5,),
              ValueListenableBuilder(
                valueListenable: _controller,
                builder: (BuildContext context, value, Widget? child) {
                  final durationState = _controller.value;
                  final progress = durationState.position ?? Duration.zero;
                  final buffered = durationState.buffered.first.end ?? Duration.zero;
                  final total = durationState.duration ?? Duration.zero;
                  return ProgressBar(
                    progressBarColor: Colors.red,
                    barCapShape: BarCapShape.round,
                    barHeight: 3,
                    thumbColor: Colors.red,
                    buffered:buffered ,
                    bufferedBarColor: Colors.yellowAccent,
                    thumbRadius: 5,
                    timeLabelTextStyle: TextStyle(
                        fontSize: 11,color: Colors.white
                    ),
                    timeLabelLocation: TimeLabelLocation.none,
                    progress: progress,
                    // buffered: buffered,
                    total: total,
                    onSeek: (duration) {
                      _controller.seekTo(duration);
                    },
                  );
                },
              ),
            ],
          ),
        ),),
    );
  }
  ///全屏
  void _toggleFullScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) {
      return VideoFullPage(_controller);
    }));

    setState(() {
      _startPlayControlTimer(); // 操作完控件开始计时隐藏
    });
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child:Center(
        child: _controller.value.isInitialized
            ? Hero(
          tag: 'hero',
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: Stack(
              children: [
                VideoPlayer(
                  _controller,key: _key,),
                GestureDetector(
                  onTap: () {
                    _togglePlayControl();
                    print('object');
                    // _controller.value.isPlaying ?
                    // _controller.pause() :
                    // _controller.play();
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
                        child:_controller.value.isPlaying?
                        IconButton(onPressed: (){
                          print('sdfsdf');
                          _controller.pause();
                          setState(() {

                          });
                        }, icon: Image.asset('images/v_pause_n.png',
                          width: 50,
                          height: 50,)):
                        IconButton(onPressed: (){
                          _controller.play();
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
    );

  }
}
