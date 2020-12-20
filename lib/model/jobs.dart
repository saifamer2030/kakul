
class Job{
  String id;
  String name,sex,salary,workHours,details,dateAt;


  Job.fromMap(Map<String,dynamic> json){
    this.id=json['id'];
    this.name=json['Name'];
    this.sex=json['Sex'];
    this.salary=json['Salary'];
    this.workHours=json['WorkHours'];
    this.details=json['Details'];
    this.dateAt=json['DateAt'];
  }
}