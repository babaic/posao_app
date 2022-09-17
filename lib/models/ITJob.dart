import 'job.dart';

class ITJob extends Job {
  final String level;
  final String sallary;
  final bool isRemote;
  final String department;
  final String location;
  final String companySlug;
  final String jobSlug;
  String url;
  String externalUrl;

  ITJob({id, company, endDate, startDate, title, this.level, this.department, this.isRemote, this.sallary, this.location, this.companySlug, this.jobSlug}) : super(company: company, id: id, endDate: endDate, startDate: startDate, title: title){
    url = 'https://www.dzobs.com/_next/data/wxfPjjwvHHk7eXIM8KPAk/posao/$companySlug/$jobSlug.json';
    externalUrl = 'https://www.dzobs.com/posao/$companySlug/$jobSlug';
  }
}

class ITJobDetail extends ITJob {
  final String opisPosla;
  final String oKompaniji;
  final String kvalifikacije;
  final List<String> tags;

  ITJobDetail(
      {this.opisPosla,
      this.oKompaniji,
      this.kvalifikacije,
      this.tags,
      String title,
      String locations,
      Company company,
      level,
      companySlug,
      jobSlug
      })
      : super(title: title, location: locations, company: company, level: level, companySlug: companySlug, jobSlug: jobSlug);
}

class ITJobCategory {
  final String value;
  final String label;

  ITJobCategory(this.value, this.label);
}