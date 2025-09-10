class GlobalUser {
  String? id; //
  String? loginBy; //
  String? firstname;
  String? lastname;
  String? username;
  String? email;
  String? image;
  String? balance;
  String? countryCode;
  String? mobile;
  String? dialCode;
  String? refBy; //
  String? address;
  String? city;
  String? state;
  String? zip;
  String? country;
  String? totalReviews; //
  String? avgRating;
  String? status; //
  String? kv; //
  String? ev; //
  String? sv; //
  String? profileComplete; //
  String? verCodeSendAt;
  String? tsc;
  String? banReason;
  String? createdAt;
  String? updatedAt;
  String? imageWithPath;

  GlobalUser({
    this.id,
    this.loginBy,
    this.firstname,
    this.lastname,
    this.username,
    this.email,
    this.image,
    this.countryCode,
    this.mobile,
    this.refBy,
    this.address,
    this.city,
    this.state,
    this.zip,
    this.country,
    this.totalReviews,
    this.avgRating,
    this.status,
    this.kv,
    this.ev,
    this.sv,
    this.profileComplete,
    this.verCodeSendAt,
    this.tsc,
    this.banReason,
    this.createdAt,
    this.updatedAt,
    this.balance,
    this.imageWithPath,
    this.dialCode,
  });

  factory GlobalUser.fromJson(Map<String, dynamic> json) => GlobalUser(
        id: json["id"].toString(),
        loginBy: json["login_by"] != null ? json["login_by"].toString() : "0",
        firstname: json["firstname"].toString(),
        lastname: json["lastname"].toString(),
        username: json["username"].toString(),
        email: json["email"].toString(),
        image: json["image"].toString(),
        balance: json["balance"].toString(),
        countryCode: json["country_code"].toString(),
        dialCode: json["dial_code"].toString(),
        mobile: json["mobile"].toString(),
        refBy: json["ref_by"].toString(),
        address: json["address"] ?? "",
        city: json["city"] ?? "",
        zip: json["zip"] ?? "",
        country: json["country"] ?? "",
        state: json["state"] ?? "",
        totalReviews: json["total_reviews"].toString(),
        avgRating: json["avg_rating"].toString(),
        status: json["status"].toString(),
        kv: json["kv"].toString(),
        ev: json["ev"].toString(),
        sv: json["sv"].toString(),
        profileComplete: json["profile_complete"].toString(),
        verCodeSendAt: json["ver_code_send_at"].toString(),
        tsc: json["tsc"].toString(),
        banReason: json["ban_reason"].toString(),
        createdAt: json["created_at"]?.toString(),
        updatedAt: json["updated_at"]?.toString(),
        imageWithPath: json["image_with_path"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "username": username,
        "email": email,
        "avatar": image,
        "balance": balance,
        "country_code": countryCode,
        "dial_code": dialCode,
        "mobile": mobile,
        "ref_by": refBy,
        "address": address,
        "city": city,
        "state": state,
        "country": country,
        "total_reviews": totalReviews,
        "avg_rating": avgRating,
        "status": status,
        "kv": kv,
        "ev": ev,
        "sv": sv,
        "profile_complete": profileComplete,
        "ver_code_send_at": verCodeSendAt,
        "tsc": tsc,
        "ban_reason": banReason,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "image_with_path": imageWithPath,
      };
  String getFullName() {
    return "${firstname ?? ""} ${lastname ?? ""}".trim();
  }
}
