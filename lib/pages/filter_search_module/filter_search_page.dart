import 'package:flutter/material.dart';

class FilterSearchPage extends StatefulWidget {
  const FilterSearchPage({Key? key}) : super(key: key);

  @override
  State<FilterSearchPage> createState() => _FilterSearchPageState();
}

class _FilterSearchPageState extends State<FilterSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Search'),
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
