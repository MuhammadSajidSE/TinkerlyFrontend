class UserModel {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final int age;
  final String address;
  final int nic;
  final String token;
  final bool isCustomer;
  final bool isWorker;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    required this.address,
    required this.nic,
    required this.token,
    required this.isCustomer,
    required this.isWorker,
  });
}
