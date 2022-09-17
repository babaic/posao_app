import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:posao_app/models/ITJob.dart';
import 'package:posao_app/models/job.dart';
import 'package:posao_app/providers/jobs.dart';
import 'package:provider/provider.dart';

class ItJobTile extends StatelessWidget {
  final ITJob jobData;
  ItJobTile(this.jobData);

  Color levelColor(String level) {
    var color;
    switch(level.toLowerCase().trim()) {
      case "junior" : color = Colors.green; break;
      case "medior" : color = Colors.yellow; break;
      case "senior" : color = Colors.red; break;
      default: color = Colors.grey; break;
    }
    return color;
  }

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
              Visibility(child: Text(jobData.location), visible: jobData.location != ""),
              Text(jobData.department),
              Visibility(child: Text(jobData.sallary ?? '', style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.bold)), visible: (jobData.sallary != "" && jobData.sallary != null)),
              Row(children: jobData.level.split(",").map((lvl) => 
                Container(
                  margin: EdgeInsets.only(right: 5, top: 5),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: levelColor(lvl),
                    borderRadius: BorderRadius.all(Radius.circular(10)) 
                  ),
                  child: Text(lvl),
                )
              ).toList()),
              Visibility(
                visible: jobData.isRemote == true,
                child: Container(
                    margin: EdgeInsets.only(right: 5, top: 5),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.all(Radius.circular(10)) 
                    ),
                    child: RichText(
  text: TextSpan(
    children: [
      WidgetSpan(
        child: Icon(Icons.public, size: 15,color: Colors.white,),
      ),
      TextSpan(
        text: " REMOTE",style: TextStyle(fontSize: 12)
      ),
    ],
  ),
),
                  ),
              )
            ],
          ),
          // trailing: InkWell(
          //   onTap: () =>
          //       Provider.of<Jobs>(context, listen: false).saveJob(jobData),
          //   child: jobData.saved
          //       ? Icon(Icons.favorite)
          //       : Icon(Icons.favorite_border),
          // ),
        ),
        SizedBox(height: 2,),
        Divider(color: Colors.black, height: 1,)
      ],
    );
  }
}
