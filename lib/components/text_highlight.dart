import 'package:flutter/material.dart';

//从_content字符串中将_keyWord高亮显示
//注意：字体颜色默认为白色
class TextHighlight extends StatelessWidget {

  final TextStyle _normalStyle; //正常样式
  final TextStyle _highlightStyle; //高亮样式
  final String _content; //字符串
  final String _keyWord; //字符串中需要高亮的关键字

  TextHighlight(this._content, this._keyWord, this._normalStyle, this._highlightStyle);

  @override
  Widget build(BuildContext context) {
    if(this._keyWord == null || this._keyWord == "") return Text(_content, style: _normalStyle,);
    List<TextSpan> spans = [];
    int start = 0;
    int end;
    while((end = _content.indexOf(_keyWord, start)) != -1){
      spans.add(TextSpan(text: _content.substring(start, end), style: _normalStyle));
      spans.add(TextSpan(text: _keyWord, style: _highlightStyle));
      start = end + _keyWord.length;
    }
    spans.add(TextSpan(text: _content.substring(start, _content.length), style: _normalStyle));
    return RichText(text: TextSpan(children: spans),);
  }
}
