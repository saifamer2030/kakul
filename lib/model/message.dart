class Message{
  String id,text,company_id,create_date;

  Message.fromMap(Map<String,dynamic> json){
    this.id=json['id'];
    this.text=json['text'];
    this.company_id=json['company_id'];
    this.create_date=json['create_date'];
  }
}