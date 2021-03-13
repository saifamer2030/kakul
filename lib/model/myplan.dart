class MyPlan{
  String id,user_id,plan_id,create_date,status;

  MyPlan.fromMap(Map<String,dynamic> json){
    this.id=json['id'];
    this.user_id=json['user_id'];
    this.plan_id=json['plan_id'];
    this.create_date=json['create_date'];
    this.status=json['status'];
  }
}