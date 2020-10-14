class PersonData {
  String firstName;
  String lastName;
  String email;
  String nic;
  String phone;
  String userId;
  String userType;
  bool isVerified;
  String profileImg;

  PersonData({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.nic = '',
    this.phone = '',
    this.userId = '',
    this.userType = '',
    this.isVerified = true,
    this.profileImg = '',
  });
}
