class UploadedPDF {
  String? pdf_id;
  String? pdf_name;
  String? user_email;

  UploadedPDF(String filePath, {this.pdf_id, this.pdf_name, this.user_email});

  UploadedPDF.fromJson(Map<String, dynamic> json) {
    pdf_id = json['pdf_id'];
    pdf_name = json['pdf_name'];
    user_email = json['user_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pdf_id'] = pdf_id;
    data['pdf_name'] = pdf_name;
    data['user_email'] = user_email;
    return data;
  }
}
