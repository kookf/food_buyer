import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LikeAnimation extends StatefulWidget {
  @override
  _LikeAnimationState createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation> with TickerProviderStateMixin{
  bool isLiked = false;
  late final AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(vsync: this);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('object');
        _controller.reset();
        _controller.duration = Duration(milliseconds: 800);
        _controller.forward();
        setState(() {
          // isLiked = !isLiked;
          // _controller.reverse();
        });
      },
      child: Container(

        color: Colors.yellow,
        child: Row(
          children: [
            // isLiked==false? Image.asset('images/ic_like.png',width: 20,height: 20,
            //   color: Colors.black87,):
            Lottie.asset(
              'images/LottieLogo1.json',
              controller: _controller,
              // fit: BoxFit.fill,
              onLoaded: (composition){
                _controller..duration = composition.duration..forward();
              },
              repeat: false,
            ),
            Text('123'),
          ],
        ),
      ),
    );
  }
}
