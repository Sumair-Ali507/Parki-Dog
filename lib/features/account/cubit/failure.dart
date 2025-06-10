class Failure {
  int code;
  String message;
  final String? status;

  Failure(this.code, this.message, {this.status});
}

// class ResponseFailure extends Failure{
//   final String arMessage;
//   final String enMessage;
//   ResponseFailure(super.code, super.message, this.arMessage, this.enMessage);
// }
