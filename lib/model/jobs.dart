
class Job{
  String id;
  String name,sex,salary,workHours,details,dateAt,Image;
  String IdSections,IdSubSection,Mobile;
  String Education,Experience;

  Job.fromMap(Map<String,dynamic> json){
    this.id=json['id'];
    this.name=json['Name'];
    this.sex=json['Sex'];
    this.salary=json['Salary'];
    this.workHours=json['WorkHours'];
    this.details=json['Details'];
    this.dateAt=json['DateAt'];
    this.Image=json['Image'];
    this.IdSections=json['IdSections'];
    this.IdSubSection=json['IdSubSection'];
    this.Mobile=json['Mobile'];
    this.Education=json['Education'];
    this.Experience=json['Experience'];
  }
}