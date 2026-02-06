import 'package:fpt_ojt/features/wallet/data/models/my_card.dart';
import 'package:fpt_ojt/features/wallet/data/models/my_fav_merchant.dart';
import 'package:fpt_ojt/features/wallet/domain/entities/wallet_item.dart';

extension MyCardMapper on MyCard {
  WalletItem toEntity() => WalletItem(id: userCardId, imageUrl: cardImageUrl);
}

extension MyFavMerchantMapper on MyFavMerchant {
  WalletItem toEntity() => WalletItem(id: merchantId, imageUrl: logoUrl);
}
