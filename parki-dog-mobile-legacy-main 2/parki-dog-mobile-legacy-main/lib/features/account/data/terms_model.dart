class TermsModel{
 final String title;
 final String body;

  TermsModel(this.title, this.body);
  factory TermsModel.fromjs(Map<String,dynamic> json)=>TermsModel(json['title'], json['body']);
}