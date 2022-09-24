import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:posao_app/models/ITJob.dart';
import 'package:posao_app/models/job.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Jobs with ChangeNotifier {
  List<Job> _jobs = [];
  List<ITJob> _itJobs = [];
  List<Job> _savedJobs = [];
  double totalPages;
  // final from;
  // final to;
  // final industry;

  // Jobs(this.from, this.to, this.industry);

  List<Job> get jobs {
    return [..._jobs];
  }
  List<ITJob> get itJobs {
    return [..._itJobs];
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

  Future<List<ITJobCategory>> getCategoriesFrom_Dzobs() async {
    List<ITJobCategory> itJobsCategories = List<ITJobCategory>();
    var response = await http.get(Uri.parse('https://www.dzobs.com/api/tags/get'));
    var extractData = json.decode(utf8.decode(response.bodyBytes));
    for(var i = 0; i < extractData.length; i++) {
      itJobsCategories.add(ITJobCategory(extractData[i]['value'], extractData[i]['label']));
    }
    return itJobsCategories;
  }

  Future<ITJobDetail> getJobDetailFrom_Dzobs(String url) async {
    print(url);
    // url = 'https://raw.githubusercontent.com/babaic/remoteUrls/main/jobdetail.json';
    var response = await http.get(Uri.parse(url));
    var extractData = json.decode(utf8.decode(response.bodyBytes));
    print(response.statusCode);
    var opisPoslaJson = json.decode(extractData['pageProps']['job']['opisPosla']);
    var opisPosla = '';
    var oKompanijiJson = json.decode(extractData['pageProps']['job']['oKompaniji']);
    var oKompaniji = '';
    var kvalifikacijeJson = json.decode(extractData['pageProps']['job']['kvalifikacije']);
    var kvalifikacije = '';
    var iskustvo = '';

    try {
      for(var i = 0; i < opisPoslaJson['blocks'].length; i++) {
      opisPosla += opisPoslaJson['blocks'][i]['text'] +"\n";
    }
    }catch(e){
      opisPosla = "";
    }
    
    try {
      for(var i = 0; i < oKompanijiJson['blocks'].length; i++) {
      oKompaniji += oKompanijiJson['blocks'][i]['text'] +"\n";
    }
    }catch(e) {
      oKompaniji = "";
    }
    
    try {
      for(var i = 0; i < kvalifikacijeJson['blocks'].length; i++) {
      kvalifikacije += kvalifikacijeJson['blocks'][i]['text'] +"\n";
     }
    }catch(e) {
      kvalifikacije = "";
    }

    try {
      iskustvo = extractData['pageProps']['job']['meta']['level'];
    }
    catch(e) {
      iskustvo = "/";
    }

    var tagsToAdd = List<String>();

    for(var i = 0; i < extractData['pageProps']['job']['meta']['tags'].length; i++) {
      tagsToAdd.add(extractData['pageProps']['job']['meta']['tags'][i]);
    }

    var jobDetail = ITJobDetail(
        opisPosla: opisPosla,
        oKompaniji: oKompaniji,
        kvalifikacije: kvalifikacije,
        tags: tagsToAdd,
        locations: extractData['pageProps']['job']['meta']['cities'],
        title: extractData['pageProps']['job']['title'],
        level: extractData['pageProps']['job']['meta']['level'],
        company: Company(name: extractData['pageProps']['job']['meta']['company'], photo: extractData['pageProps']['job']['meta']['companyLogo']),
        companySlug: extractData['pageProps']['job']['meta']['companySlug'],
        jobSlug: extractData['pageProps']['job']['slug']
        );
    return jobDetail;
  }

  static Future<String> DzobsDetailsUrl() async {
    var db = await FirebaseFirestore.instance.collection('urls').doc('dzobsDetails').get();
    return db.get('url');
  }

  Future<void> fetchJobsFrom_Dzobs(int page, [bool isQuery = false, String lokacija, String kategorija, String iskustvo]) async {
    var url;
    var db = await FirebaseFirestore.instance.collection('urls').doc('dzobsMain').get();
    
    url = db.get('url');
    
    if (page == 1) {
      _itJobs = [];
    }

    var urlQueryPart = page.toString() + '.json';

    if(isQuery) {
      var db = await FirebaseFirestore.instance.collection('urls').doc('dzobsPretraga').get();
      url = db.get('url');

      if(lokacija != null && lokacija != '') {
        url += 'lokacija=$lokacija&';
      }
      else {
        url += 'lokacija=&';
      }
      if(kategorija != null && kategorija != '') {
        url +='tag=$kategorija&';
      }
      else {
        url +='tag=&';
      }
      if(iskustvo != null && iskustvo != '') {
        url +='iskustvo=$iskustvo';
      }
      else {
        url +='iskustvo=';
      }
      urlQueryPart='&page=$page';
    }
print(url + urlQueryPart);
    var response = await http.get(Uri.parse(url + urlQueryPart));
    //var response = await http.get(Uri.parse('https://raw.githubusercontent.com/babaic/remoteUrls/main/jobs.json'));
    print(url + urlQueryPart);
    print('response status ${response.statusCode}');
    var extractData = json.decode(utf8.decode(response.bodyBytes));
    totalPages = extractData['pageProps']['total'] / 12;
    print('total $totalPages');
    List<ITJob> jobsToAdd = List<ITJob>();
    for(var i = 0; i < extractData['pageProps']['jobs'].length; i++) {
      jobsToAdd.add(ITJob(
          company: Company(
              name: extractData['pageProps']['jobs'][i]['company']['name'],
              photo: extractData['pageProps']['jobs'][i]['company']['logo']),
          title: extractData['pageProps']['jobs'][i]['title'],
          isRemote: extractData['pageProps']['jobs'][i]['isRemote'],
          sallary: extractData['pageProps']['jobs'][i]['sallary'],
          location: extractData['pageProps']['jobs'][i]['locations'],
          level: extractData['pageProps']['jobs'][i]['levels'],
          id: extractData['pageProps']['jobs'][i]['id'],
          department: extractData['pageProps']['jobs'][i]['department'],
          companySlug: extractData['pageProps']['jobs'][i]['company']['slug'],
          jobSlug: extractData['pageProps']['jobs'][i]['slug']
      ));
    }
    _itJobs = _itJobs + jobsToAdd;
    print('jobs ${_itJobs.length}');
    notifyListeners();
  }

  Future<void> fetchAndSetJobs2(
      int showFrom, int showTo, String industry, String location, String keyword) async {
    print('fetch and sets jobs');
    print(keyword);

    //if it's first call clear old data
    if (showFrom == 0) {
      _jobs = [];
    }
    var urlQueryPart = '?firstResult=$showFrom&maxResults=10&jobstate=ACTIVE&range=any';
    if(keyword != null) {
      urlQueryPart += '&keyword=$keyword';
    }
    if (location != null && location != '') {
      urlQueryPart +='&location=$location';
    }
    if(industry != null && industry != '0') {
      urlQueryPart += '&industry=$industry';
    }
    urlQueryPart += '&sortField=productCategory.basicPrice-dsc&sortField=aprovementDate-dsc';
    // urlQueryPart =
    //     '?firstResult=$showFrom&maxResults=10&jobstate=ACTIVE&range=any&$industry&sortField=productCategory.basicPrice-dsc&sortField=aprovementDate-dsc';
    // if (location != null) {
    //   urlQueryPart =
    //       '?firstResult=$showFrom&maxResults=10&jobstate=ACTIVE&range=any&$industry&location=$location&sortField=productCategory.basicPrice-dsc&sortField=aprovementDate-dsc';
    // }

    const url = 'https://www.mojposao.ba/api/data/jobs';
    print('url ${url + urlQueryPart}');
    var response = await http.get(Uri.parse(url + urlQueryPart));
    print('response status ${response.statusCode}');
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
    var response = await http.get(Uri.parse(
        'https://www.mojposao.ba/api/data/jobs/$id?view=ba.posao.module.api.server.mixins.Views%24ExtendedPublic'));
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
    if (savedJobs != null) {
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
        for (var i = 0; i < savedJobs.length; i++) {
          if (i == index) {
            continue;
          } else {
            newList.add(savedJobs[i]);
          }
        }
        savedJobs = newList;
        ids = savedJobs;
        print(_jobs.length);
        if (_jobs.length > 0) {
          var actualJob = _jobs.firstWhere(
              (element) => element.id == jobData.id,
              orElse: () => null);
          print(actualJob);
          if (actualJob != null) {
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
        var actualJob =
            _jobs.where((element) => element.id == jobData.id).first;
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
    if (yourList != null) {
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
    }
  }

  Future<bool> isCategorySaved(String industryA) async {
    var industry = industryA.replaceAll(new RegExp(r'[^0-9]'),'');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var savedCategories = prefs.getStringList('savedCategories');
    if(savedCategories == null) {
      return false;
    }
    for (var i = 0; i < savedCategories.length; i++) {
        var decodedCategories = json.decode(savedCategories[i]);
        print(decodedCategories);
        if (industry == decodedCategories['industry']) {
          return true;
        }
    }
    return false;
  }

  Future getJobsFromCategoryInterest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var savedCategories = prefs.getStringList('savedCategories');
    var range = ['dayBefore', 'today'];    

    List<String> mySavedCategories = new List<String>();
    _jobs = [];
    if (savedCategories != null) {
      for (var i = 0; i < savedCategories.length; i++) {
        var decodedCategories = json.decode(savedCategories[i]);
        var industry = decodedCategories['industry'];
try {
  var urlQueryPart =
        '?firstResult=0&maxResults=20&jobstate=ALL&keyword=&location=&range=${range[1]}&industry=$industry&sortField=productCategory.basicPrice-dsc&sortField=aprovementDate-dsc';
    const url = 'https://www.mojposao2.ba/api/data/jobs';
    var response = await http.get(Uri.parse(url + urlQueryPart));//vrati ovo!
    // var response = await http.get(Uri.parse(urlQueryPart));
    print('response status ${response.statusCode}');
    var extractData = json.decode(utf8.decode(response.bodyBytes));
    totalPages = extractData['totalCount'] / 10;
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
}catch(e) {

}
        

    }

      }

  }

  Future<void> saveCategoryAsInterest(String industryA, String title) async {
    var industry = industryA.replaceAll(new RegExp(r'[^0-9]'),''); // '23'

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //await prefs.clear();
    //1. get old data
    var savedCategories = prefs.getStringList('savedCategories');

    List<String> mySavedCategories = new List<String>();

    bool exist = false;
    int index;
    if (savedCategories != null) {
      for (var i = 0; i < savedCategories.length; i++) {
        var decodedCategories = json.decode(savedCategories[i]);
        if (decodedCategories['industry'] == industry) {
          index = i;
          print(index);
          exist = true;
        }
      }

      if (exist) {
        print('EXIST');
        List<String> newList = new List<String>();
        for (var i = 0; i < savedCategories.length; i++) {
          if (i == index) {
            continue;
          } else {
            newList.add(savedCategories[i]);
          }
        }
        savedCategories = newList;
        mySavedCategories = savedCategories;
        print(_jobs.length);
        // if (_jobs.length > 0) {
        //   var actualJob = _jobs.firstWhere(
        //       (element) => element.id == jobData.id,
        //       orElse: () => null);
        //   print(actualJob);
        //   if (actualJob != null) {
        //     actualJob.saved = false;
        //   }
        // }
      } else {
        mySavedCategories = savedCategories;
        mySavedCategories.add(json.encode({
          'industry': industry,
          'title': title,
        }));
      }
    }
    else {
      mySavedCategories.add(json.encode({
          'industry': industry,
          'title': title,
        }));
    }

    prefs.setStringList('savedCategories', mySavedCategories);
    var yourList = prefs.getStringList('savedCategories');
    print('saved categories $yourList');
    isCategorySaved(industry);
  }
}
