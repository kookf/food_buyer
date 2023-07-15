import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class ZhiHuSwiperPagination extends SwiperPlugin {
  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    return ConfigProvider(config: config,
        child1: const ZhiHuSwiperDotWidget());
  }
}

class ZhiHuSwiperDotWidget extends StatefulWidget {
  const ZhiHuSwiperDotWidget({super.key});

  @override
  State<StatefulWidget> createState() => ZhiHuSwiperDotWidgetState();
}

class ZhiHuSwiperDotWidgetState extends State<ZhiHuSwiperDotWidget> {
  SwiperPluginConfig? config;

  double? page;

  @override
  void didChangeDependencies() {
    config = ConfigProvider.of(context)?.config;
    page = config?.pageController?.page;
    config?.pageController?.addListener(() {
      setState(() {
        page = config?.pageController?.page;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    double baseWidth = 4.0;
    double ratio = 3.0;
    int itemCount = config!.itemCount;
    int floor = page!.floor();
    int ceil = page!.ceil();
    int preIndex = floor % itemCount;
    int nextIndex = ceil % itemCount;
    double prePercent = page! - preIndex;
    double nextPercent = 1 - prePercent;

    double baseOpacity = 0.3;
    double offsetOpacity = 1.0 - baseOpacity;

    for (int i = 0; i < itemCount; ++i) {
      double width;
      double opacity;
      if (i == preIndex) {
        width = baseWidth * (1.0 + ratio * nextPercent);
        opacity = baseOpacity + offsetOpacity * nextPercent;
      } else if (i == nextIndex) {
        width = baseWidth * (1.0 + ratio * prePercent);
        opacity = baseOpacity + offsetOpacity * prePercent;
      } else {
        width = baseWidth;
        opacity = baseOpacity;
      }

      list.add(Container(
        key: Key("zhihupagination_$i"),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        child: ClipRRect(
          borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(3), right: Radius.circular(3)),
          child: Container(
            color: Colors.blue.withOpacity(opacity),
            width: width,
            height: 6,
          ),
        ),
      ));
    }
    return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
            padding: const EdgeInsets.only(left: 0, bottom: 0),
            child: Row(mainAxisSize: MainAxisSize.min, children: list)));
  }

  @override
  void dispose() {
    config?.pageController!.dispose();
    super.dispose();
  }
}

class ConfigProvider extends InheritedWidget {
  final SwiperPluginConfig? config;
  final Widget child1;

  const ConfigProvider({super.key, this.config, required this.child1}) : super(child: child1);

  static ConfigProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ConfigProvider>();

  @override
  bool updateShouldNotify(ConfigProvider oldWidget) {
    return oldWidget.config != config;
  }
}