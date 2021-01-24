import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:posao_app/models/job.dart';
import 'package:http/http.dart' as http;

class Jobs with ChangeNotifier {
  List<Job> _jobs = [];

  List<Job> get jobs {
    return [..._jobs];
  }

  Job selectedJobDetails;

  String title = '';

  void changeTitle(String tit) {
    title = tit;
    notifyListeners();
  }


  Future<void> fetchAndSetJobs() async {
    _jobs = [];
    var response = await http.get('https://www.mojposao.ba/api/data/jobs/top?firstResult=0&maxResult=10');
    var extractData = json.decode(utf8.decode(response.bodyBytes));
    List<Job> loadedJobs = new List<Job>();
    for(var i = 0; i < extractData.length; i++) {
      var companyId = extractData[i][0]['company']['id'];
      loadedJobs.add(Job(
        company: Company(
          city: extractData[i][0]['company']['companyAddress'][0]['address']['city']['name'],
          name: extractData[i][0]['company']['name'],
          webAddress: extractData[i][0]['company']['webAddress'],
          photo: 'https://www.mojposao.ba/company/$companyId/logo/214x97.jpg'
        ),
        id: extractData[i][0]['locations'][0]['jobLocationNewPK']['jobNew_id'],
        startDate: DateTime.fromMicrosecondsSinceEpoch(extractData[i][0]['startDate']),
        endDate: DateTime.fromMicrosecondsSinceEpoch(extractData[i][0]['endDate']),
        title: extractData[i][0]['title']['name'],
        workers: extractData[0][0]['workersNumber']
      ));
    }
    _jobs = loadedJobs;

    _jobs.forEach((element) {
      print(element.company.name);
      print(element.title);
    });
    
  }

  Future<void> fetchAndSetJobs0() async {
    print('fetchAndSetJobs');
    return Future.delayed(Duration(seconds: 1), () {
      _jobs = [];
    
    List<Job> loadedJobs = new List<Job>();
    for(var i = 0; i < 10; i++) {
      loadedJobs.add(Job(
        company: Company(
          city: 'Sarajevo',
          name: 'Test company $i',
          webAddress: 'ddd',
          photo: 'https://www.mojposao.ba/company/583236/logo/214x97.jpg'
        ),
        id: 397570,
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        title: 'This is job description',
        workers: 2
      ));
    }
    _jobs = loadedJobs;
    });

  }

  Future<dynamic> getJobById(int id) async {
    print('getJobById');
    var response = await http.get('https://www.mojposao.ba/api/data/jobs/$id?view=ba.posao.module.api.server.mixins.Views%24ExtendedPublic');
    var extractData = json.decode(utf8.decode(response.bodyBytes));
    getJobDetails(id);
    return extractData;
    //print(response.body);
  }

  void getJobDetails(int id) {
    var jobDetails = _jobs.firstWhere((job) => job.id == id);
    selectedJobDetails = jobDetails;
  }

}