import 'package:quiver/core.dart';

class LoginData {
  final String name;
  final String password;
  final String phone;
  final String fatherPhone;
  final String gender;
  final String academicYear;
  final String centerName;

  LoginData({
    required this.name,
    required this.password,
    required this.phone,
    required this.fatherPhone,
    required this.gender,
    required this.academicYear,
    required this.centerName,
  });

  @override
  String toString() {
    return '$runtimeType($name, $password,$phone,$fatherPhone,$gender,$academicYear,$centerName)';
  }

  @override
  bool operator ==(Object other) {
    if (other is LoginData) {
      return name == other.name && password == other.password && phone == other.phone && fatherPhone == other.fatherPhone && gender == other.gender && academicYear == other.academicYear && centerName == other.centerName;
    }
    return false;
  }

  @override
  int get hashCode => hash2(name, password);
}
