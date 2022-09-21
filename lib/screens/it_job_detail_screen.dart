import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:posao_app/models/ITJob.dart';
import 'package:posao_app/models/job.dart';
import 'package:posao_app/providers/jobs.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ItJobDetailScreen extends StatefulWidget {
  static const routeName = '/job-detail';

  final String url;
  ItJobDetailScreen(this.url);

  static const kHtml = '''
<p>...</p>
<div class="carousel">
  <div class="image">
    <img src="https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba" />
  </div>
  ...
</div>
<p>...</p>
''';

  @override
  State<ItJobDetailScreen> createState() => _ItJobDetailScreenState();
}

class _ItJobDetailScreenState extends State<ItJobDetailScreen> {
  ITJobDetail jobsData;
  var title = '';

  bool isLoading = true;

  void _launchURL(String _url) async => await launch(_url);

  @override
  initState() {
    super.initState();
    Provider.of<Jobs>(context, listen: false)
        .getJobDetailFrom_Dzobs(widget.url)
        .then((value) {
      jobsData = value;
      print(jobsData.title);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //final id = ModalRoute.of(context).settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Consumer<Jobs>(
          builder: (context, data, _) {
            return Text(isLoading ? '...' : data.title);
          },
        ),
      ),
      bottomNavigationBar: isLoading ? CircularProgressIndicator() : Container(
        color: Colors.grey[100],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border.all(color: Colors.blue, width: 1)),
                child: TextButton(
                    onPressed: () =>
                        _launchURL(jobsData.externalUrl),
                    child: Text('Prijavi se',
                        style: TextStyle(color: Colors.white))),
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              child: Column(children: [
              Stack(
                children: [
                  Container(
                    height: 60,
                    width: double.infinity,
                    color: Colors.green,
                  ),
                  Center(
                    child: Container(
                        height: 100,
                        width: 100,
                        color: Colors.green,
                        child: Hero(
                          tag: 'job-img-${widget.url}',
                          child: Image.network(
                            jobsData.company.photo,
                            fit: BoxFit.fill,
                          ),
                        )),
                  ),
                ],
              ),
              Column(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      // Text(
                      //   jobsData.selectedJobDetails.title,
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 15),
                      // ),
                      VisibilityDetector(
                        key: Key('jobdesc'),
                        onVisibilityChanged: (visibilityInfo) {
                          var visiblePercentage =
                              visibilityInfo.visibleFraction * 100;
                          if (visiblePercentage < 10) {
                            Provider.of<Jobs>(context, listen: false)
                                .changeTitle(jobsData.title);
                          } else {
                            Provider.of<Jobs>(context, listen: false)
                                .changeTitle('');
                          }
                        },
                        child: Text(
                          jobsData.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        jobsData.company.name,
                        style: TextStyle(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.pin_drop,
                                size: 20,
                                color: Colors.green,
                              ),
                            ),
                            TextSpan(
                                text: " ${jobsData.location}",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black)),
                          ],
                        ),
                      ),
                      Wrap(
                          children: jobsData.tags
                              .map((e) => Container(
                                margin: EdgeInsets.only(top: 10,right: 5),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.all(Radius.circular(10)) 
                    ),
                                child: Text(e)))
                              .toList()),
                      Divider(color: Colors.grey)
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'O kompaniji',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(jobsData.oKompaniji),
                        Text(
                          'O poslu',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(jobsData.opisPosla),
                        SizedBox(height: 10),
                        Text(
                          'Kvalifikacije',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(jobsData.kvalifikacije),
                        SizedBox(height: 10),
                        Text(
                          'Iskustvo',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(jobsData.level),
                      ],
                    ),
                  )
                ],
              )
            ])),
    );
  }
}
