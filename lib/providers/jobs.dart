import 'dart:convert';
import 'dart:wasm';

import 'package:flutter/cupertino.dart';
import 'package:posao_app/models/job.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Jobs with ChangeNotifier {
  List<Job> _jobs = [];
  List<Job> _savedJobs = [];
  double totalPages;
  // final from;
  // final to;
  // final industry;

  // Jobs(this.from, this.to, this.industry);

  List<Job> get jobs {
    return [..._jobs];
  }

  List<Job> get savedJobs {
    return [..._savedJobs];
  }

  int get totPage {
    return totalPages.round();
  }
 
  Job selectedJobDetails;

  String title = '';

  void changeTitle(String tit) {
    title = tit;
    notifyListeners();
  }

  Future<void> fetchAndSetJobs2(
      int showFrom, int showTo, String industry, String location) async {
    //if it's first call clear old data
    if (showFrom == 0) {
      _jobs = [];
    }
    var urlQueryPart = '?firstResult=$showFrom&maxResults=10&jobstate=ACTIVE&range=any&$industry&sortField=productCategory.basicPrice-dsc&sortField=aprovementDate-dsc';
    if(location != null) {
      urlQueryPart = '?firstResult=$showFrom&maxResults=10&jobstate=ACTIVE&range=any&$industry&location=$location&sortField=productCategory.basicPrice-dsc&sortField=aprovementDate-dsc';
    }

    const url = 'https://www.mojposao.ba/api/data/jobs';
    var response = await http.get(url + urlQueryPart);
    var extractData = json.decode(utf8.decode(response.bodyBytes));
    totalPages = extractData['totalCount'] / 10;
    print(totPage);
    List<Job> jobsToAdd = new List<Job>();
    for (var i = 0; i < extractData['list'].length; i++) {
      var companyId = extractData['list'][i]['company']['id'];
      jobsToAdd.add(Job(
          company: Company(
              city: extractData['list'][i]['locations'][0]['location']['name'],
              name: extractData['list'][i]['company']['name'],
              webAddress: extractData['list'][i]['company']['webAddress'],
              photo:
                  'https://www.mojposao.ba/company/$companyId/logo/214x97.jpg'),
          id: extractData['list'][i]['locations'][0]['jobLocationNewPK']
              ['jobNew_id'],
          startDate: DateTime.fromMicrosecondsSinceEpoch(
              extractData['list'][i]['startDate']),
          endDate: DateTime.fromMicrosecondsSinceEpoch(
              extractData['list'][i]['endDate']),
          title: extractData['list'][i]['title']['name'],
          workers: extractData['list'][i]['workersNumber'],
          saved: isSaved(extractData['list'][i]['locations'][0]
              ['jobLocationNewPK']['jobNew_id'])));
    }
    _jobs = _jobs + jobsToAdd;

    notifyListeners();
  }

  bool isSaved(int id) {
    bool hasMatch = false;
    getSavedJobs();
    savedJobs.forEach((element) {
      if (element.id == id) {
        hasMatch = true;
      }
    });
    return hasMatch;
  }

  Future<void> fetchAndSetJobs0() async {
    print('fetchAndSetJobs');
    return Future.delayed(Duration(seconds: 1), () {
      _jobs = [];

      List<Job> loadedJobsToAdd = new List<Job>();
      for (var i = 0; i < 10; i++) {
        loadedJobsToAdd.add(Job(
            company: Company(
                city: 'Sarajevo',
                name: 'Test company $i',
                webAddress: 'ddd',
                photo:
                    'https://www.mojposao.ba/company/583236/logo/214x97.jpg'),
            id: 397570,
            startDate: DateTime.now(),
            endDate: DateTime.now(),
            title: 'This is job description',
            workers: 2));
      }
      _jobs = _jobs + loadedJobsToAdd;
      print(loadedJobsToAdd.length);
    });
  }

  Future<dynamic> getJobById(int id) async {
    print('getJobById');
    var response = await http.get(
        'https://www.mojposao.ba/api/data/jobs/$id?view=ba.posao.module.api.server.mixins.Views%24ExtendedPublic');
    var extractData = json.decode(utf8.decode(response.bodyBytes));
    getJobDetails(id);
    return extractData;
    //print(response.body);
  }

  void getJobDetails(int id) {
    var jobDetails = _jobs.firstWhere((job) => job.id == id);
    selectedJobDetails = jobDetails;
  }

  Future<Job> selectedJob(int id) async {
    print(id);
    return _jobs.firstWhere((element) => element.id == id);
  }

  Future<void> saveJob(Job jobData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //await prefs.clear();
    //1. get old data
    var savedJobs = prefs.getStringList('savedJob');

    List<String> ids = new List<String>();

    bool exist = false;
    int index;
    if(savedJobs != null) {
      for (var i = 0; i < savedJobs.length; i++) {
      var decodedJob = json.decode(savedJobs[i]);
      if (decodedJob['id'] == jobData.id) {
        index = i;
        print(index);
        exist = true;
      }
    }

    if (exist) {
      List<String> newList = new List<String>();
      for(var i = 0; i<savedJobs.length;i++) {
        if(i == index) {
          continue;
        }
        else {
          newList.add(savedJobs[i]);
        }
      }
      savedJobs = newList;
      ids = savedJobs;
      print(_jobs.length);
      if(_jobs.length > 0) {
        var actualJob = _jobs.firstWhere((element) => element.id == jobData.id, orElse: () => null);
        print(actualJob);
        if(actualJob != null) {
          actualJob.saved = false;
        }
      }
    } else {
      ids = savedJobs;
      ids.add(json.encode({
        'title': jobData.title,
        'id': jobData.id,
        'company': jobData.company.name,
        'photo': jobData.company.photo,
        'city': jobData.company.city
      }));
      var actualJob = _jobs.where((element) => element.id == jobData.id).first;
      actualJob.saved = true;
      }
    }
    

    prefs.setStringList('savedJob', ids);

    notifyListeners();
  }

  Future<void> getSavedJobs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Job> jobsToAdd = new List<Job>();
    var yourList = prefs.getStringList('savedJob');
    yourList.forEach((element) {
      var decodedJob = json.decode(element);
      jobsToAdd.add(Job(
          id: decodedJob['id'],
          title: decodedJob['title'],
          saved: true,
          company: Company(
              name: decodedJob['company'],
              city: decodedJob['city'],
              photo: decodedJob['photo'])));
    });

    _savedJobs = jobsToAdd;
    print(savedJobs);
  }
}
