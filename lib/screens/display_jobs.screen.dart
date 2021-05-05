import 'package:flutter/material.dart';
import 'package:posao_app/models/job.dart';
import 'package:posao_app/providers/jobs.dart';
import 'package:posao_app/widgets/job_tile.dart';
import 'package:provider/provider.dart';

import 'job_detail_screen.dart';

class DisplayJobsScreen extends StatefulWidget {
  static const routeName = '/display-jobs';
  final String industry;
  final String title;
  final String location;
  DisplayJobsScreen({this.industry, this.title, this.location});

  @override
  _DisplayJobsScreenState createState() => _DisplayJobsScreenState();
}

class _DisplayJobsScreenState extends State<DisplayJobsScreen> {
  int pageNumber;
  var _controller = ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void showInSnackBar(String value, int duration) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      duration: Duration(seconds: duration),
    ));
  }

  @override
  void initState() {
    super.initState();
    pageNumber = 0;
    // Setup the listener.
    _controller.addListener(() async {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        print('pageNumber $pageNumber');
        if (pageNumber != Provider.of<Jobs>(context, listen: false).totPage) {
          try {
            showInSnackBar('Searching for more jobs...', 20);
            var res = await Provider.of<Jobs>(context, listen: false)
                .fetchAndSetJobs2(
                    ++pageNumber * 10, 10, widget.industry, widget.location);
          } catch (error) {}
          _scaffoldKey.currentState.hideCurrentSnackBar();
        } else {
          showInSnackBar('We have no more jobs today :(', 4);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: Provider.of<Jobs>(context, listen: false)
            .fetchAndSetJobs2(0, 10, widget.industry, widget.location),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //CircularProgressIndicator(),
                  Image.network(
                    'https://i.imgur.com/hGUmoWt.gif',
                    fit: BoxFit.cover,
                  )
                ],
              ),
            );
          } else {
            return Consumer<Jobs>(
                builder: (ctx, jobsData, child) => ListView.builder(
                    controller: _controller,
                    itemCount: jobsData.jobs.length,
                    itemBuilder: (ctx, index) {
                      return InkWell(
                          onTap: () =>
                              Navigator.of(context).push(PageRouteBuilder(
                                transitionDuration:
                                    Duration(milliseconds: 1000),
                                pageBuilder: (context, animation,
                                        secondaryAnimation) =>
                                    JobDetailScreen(jobsData.jobs[index].id),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  var begin = Offset(0.0, 1.0);
                                  var end = Offset.zero;
                                  var tween = Tween(begin: begin, end: end);
                                  var offsetAnimation = animation.drive(tween);

                                  return SlideTransition(
                                    position: offsetAnimation,
                                    child: child,
                                  );
                                },
                              )),
                          child: JobTile(jobsData.jobs[index]));
                    }));
          }
        },
      ),
    );
  }
}
