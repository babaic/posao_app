class Company {
  final String name;
  final String webAddress;
  final String city;
  final String photo;
  Company({this.name, this.webAddress, this.city, this.photo});
}

class Job {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final String title;
  final int workers;
  final Company company;
  bool saved;
  Job({this.id, this.company, this.endDate, this.startDate, this.title, this.workers, this.saved = false});
}