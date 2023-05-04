class File {
  String? file_id;
  String? file_name;
  String? file;
  String? user_email;

  File({this.file_id, this.file_name, this.file, this.user_email});

  File.fromJson(Map<String, dynamic> json) {
    file_id = json['file_id'];
    file_name = json['file_name'];
    file = json['file'];
    user_email = json['user_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['file_id'] = file_id;
    data['file_name'] = file_name;
    data['file'] = file;
    data['user_email'] = user_email;
    return data;
  }
}
