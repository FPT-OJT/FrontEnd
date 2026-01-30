import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/home/presentation/constants/text.dart';
import 'package:fpt_ojt/features/home/presentation/widgets/mechant_deal_card.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/location.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_agency.dart';

const Merchant merchant = Merchant(
  id: '1',
  name: 'Merchant 1',
  description: 'Description 1',
  logoUrl:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRowblgC4PDfdIlo9vW2F3Sf1n_VaOFhMIeXA&s',
);

const MerchantAgency merchantAgency = MerchantAgency(
  id: '1',
  name: 'Merchant Agency 1',
  imageUrl:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRowblgC4PDfdIlo9vW2F3Sf1n_VaOFhMIeXA&s',
  discount: 10,
  location: Location(longitude: 106.694419, latitude: 10.771918),
  merchant: merchant,
  merchantId: '1',
);
const currentLocaltion = Location(longitude: 106.699419, latitude: 10.771918);

class MerchantSection extends StatelessWidget {
  const MerchantSection({super.key});

  @override
  Widget build(BuildContext context) => Column(
    spacing: UIGaps.size8,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        HomeText.merchantBestOfferTitle,
        style: AppTextStyles.h3.copyWith(color: AppColors.primaryForest),
      ),
      const Column(
        children: [
          MerchantDealCard(
            merchantAgency: merchantAgency,
            currentLocation: currentLocaltion,
          ),
        ],
      ),
    ],
  );
}
