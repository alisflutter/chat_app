class UserModel {
  final String name;
  final String email;
  final String profilePic;
  final bool isOnline;
  final String uid;
  final String phoneNo;
  final List<String> groupID;

  UserModel({
    required this.name,
    required this.email,
    required this.profilePic,
    required this.isOnline,
    required this.uid,
    required this.phoneNo,
    required this.groupID,
  });

// map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'uid': uid,
      'phoneNo': phoneNo,
      'groupId[]': groupID,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? ' ',
      email: map['email'] ?? '',
      profilePic: map['profilePic'] ?? '',
      isOnline: map['isOnline'] ?? false,
      uid: map['uid'] ?? '',
      phoneNo: map['phoneNo'] ?? '',
      groupID: List<String>.from(map['groupId[]']), // ?? '',
    );
  }
}
