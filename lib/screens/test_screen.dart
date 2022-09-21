import 'package:flutter/material.dart';
import 'package:posao_app/providers/jobs.dart';
import 'package:provider/provider.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: TextButton.icon(
                    onPressed: null,
                    icon: Icon(Icons.title),
                    label: Text('press')),);
  }
}