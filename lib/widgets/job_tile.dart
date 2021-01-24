import 'package:flutter/material.dart';
import 'package:posao_app/models/job.dart';

class JobTile extends StatelessWidget {
  final Job jobData;
  JobTile(this.jobData);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            height: 50,
            width: 50,
            child: Image(
              image: NetworkImage(
                  jobData.company.photo),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                jobData.title,
                style: TextStyle(color: Colors.blue),
              ),
              Text(jobData.company.name),
              Text(jobData.company.city),
            ],
          ),
          trailing: Icon(Icons.favorite_border),
        ),
        Divider(color: Colors.black)
      ],
    );
  }
}
