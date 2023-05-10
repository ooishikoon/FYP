class UploadedImage {
  String? image_id;
  String? image_name;
  String? image;
  String? user_email;

  UploadedImage(String filePath, {this.image_id, this.image_name, this.image, this.user_email});

  UploadedImage.fromJson(Map<String, dynamic> json) {
    image_id = json['image_id'];
    image_name = json['image_name'];
    image = json['image'];
    user_email = json['user_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image_id'] = image_id;
    data['image_name'] = image_name;
    data['image'] = image;
    data['user_email'] = user_email;
    return data;
  }
}
