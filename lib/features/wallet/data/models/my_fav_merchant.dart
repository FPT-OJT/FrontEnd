import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_fav_merchant.freezed.dart';
part 'my_fav_merchant.g.dart';

@Freezed()
abstract class MyFavMerchant with _$MyFavMerchant {
  const factory MyFavMerchant({String? merchantId, String? logoUrl}) =
      _MyFavMerchant;

  factory MyFavMerchant.fromJson(Map<String, dynamic> json) =>
      _$MyFavMerchantFromJson(json);
}
