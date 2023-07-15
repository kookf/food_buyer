import 'package:flutter/material.dart';

class TagInputField extends StatefulWidget {
  final ValueChanged<List<String>> onTagsChanged;

  TagInputField({required this.onTagsChanged});

  @override
  _TagInputFieldState createState() => _TagInputFieldState();
}

class _TagInputFieldState extends State<TagInputField> {
  final TextEditingController _textEditingController = TextEditingController();
  List<String> _tags = [];

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _addTag() {
    final enteredTag = _textEditingController.text.trim();
    if (enteredTag.isNotEmpty) {
      setState(() {
        _tags.add(enteredTag);
        _textEditingController.clear();
        widget.onTagsChanged(_tags);
      });
    }
  }

  void _removeTag(int index) {
    setState(() {
      _tags.removeAt(index);
      widget.onTagsChanged(_tags);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: _buildTags(),
        ),
        TextField(
          controller: _textEditingController,
          decoration: InputDecoration(
            hintText: 'Enter a tag',
            suffixIcon: IconButton(
              icon: Icon(Icons.add),
              onPressed: _addTag,
            ),
          ),
          onSubmitted: (_) => _addTag(),
        ),
      ],
    );
  }

  List<Widget> _buildTags() {
    return _tags.map<Widget>((tag) {
      return Chip(
        label: Text(tag),
        onDeleted: () => _removeTag(_tags.indexOf(tag)),
      );
    }).toList();
  }
}
