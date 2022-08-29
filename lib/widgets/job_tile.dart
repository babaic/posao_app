import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:posao_app/models/job.dart';
import 'package:posao_app/providers/jobs.dart';
import 'package:provider/provider.dart';

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
            child: Hero(
              tag: 'job-img-${jobData.id}',
              child: Image.network(jobData.company.photo,
    errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
        return Image.asset('assets/building.png');
    },
),
              // Image(
              //   image: jobData.company.photo != null ? NetworkImage(jobData.company.photo) : Image.network('assets/building.png'),
              // ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                jobData.title,
                style: TextStyle(color: Colors.green),
              ),
              Text(jobData.company.name),
              Text(jobData.company.city),
            ],
          ),
          trailing: InkWell(
            onTap: () =>
                Provider.of<Jobs>(context, listen: false).saveJob(jobData),
            child: jobData.saved
                ? Icon(Icons.favorite)
                : Icon(Icons.favorite_border),
          ),
        ),
        Divider(color: Colors.black)
      ],
    );
  }
}
