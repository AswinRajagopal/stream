import 'package:flutter/material.dart';

class JSONParser {
  static Widget parseWidget(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'Text':
        return Text(
          json['data'] ?? '',
          style: TextStyle(
            fontSize: json['style']?['fontSize']?.toDouble() ?? 14,
            color: json['style']?['color'] != null
                ? Color(int.parse(json['style']['color'].replaceAll("#", "0xff")))
                : Colors.black,
          ),
        );
      case 'Button':
        return ElevatedButton(
          onPressed: () {
            print('Navigate to: ${json['onTap']}');
          },
          child: Text(json['text'] ?? 'Button'),
        );
      default:
        return SizedBox.shrink();
    }
  }
}
