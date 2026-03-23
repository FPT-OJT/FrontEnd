import 'package:flutter/widgets.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/shared/widgets/primary_button.dart';

class AiSection extends StatelessWidget {
  const AiSection({super.key});

  @override
  Widget build(BuildContext context) => Column(
    spacing: UIGaps.size20,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [PrimaryButton(onPressed: () {}, text: 'Ai Suggest')],
  );
}
