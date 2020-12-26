
class JobType{
  bool male,fmale;
int offers;

JobType(this.male, this.fmale, this.offers);

  JobType.fromMap(Map<String,dynamic> json){
    this.male=json['male'];
    this.fmale=json['fmale'];
    this.fmale=json['offers'];
  }
}