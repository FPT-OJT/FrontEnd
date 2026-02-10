import 'package:equatable/equatable.dart';

class Country extends Equatable {
  const Country({
    required this.phoneCode,
    required this.isoCode,
    required this.name,
  });
  final String phoneCode;
  final String isoCode;
  final String name;
  @override
  List<Object?> get props => [phoneCode, isoCode, name];
}
