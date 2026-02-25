import 'package:fpt_ojt/features/ai/data/datasources/ai_datasource.dart';
import 'package:fpt_ojt/features/ai/data/models/ai_message_model.dart';

const _mockResponses = [
  'Dựa trên danh mục chi tiêu của bạn, thẻ Vietcombank Visa Platinum sẽ giúp bạn hoàn tiền tới 5% tại các nhà hàng và siêu thị gần bạn.',
  'Minstant AI nhận thấy bạn chi tiêu nhiều tại chuỗi cà phê. Thẻ Techcombank Cashback có thể giúp bạn tiết kiệm đến 10% mỗi lần thanh toán tại đây.',
  'Với khoảng cách hiện tại của bạn, có 3 đối tác ưu đãi trong vòng 2km. Hãy thử dùng thẻ MB JCB để được giảm thêm 15% tại những địa điểm đó.',
  'Tôi có thể giúp bạn so sánh ưu đãi giữa các thẻ tín dụng hiện tại. Bạn muốn so sánh thẻ nào?',
  'Ưu đãi hoàn tiền tốt nhất tháng này đến từ thẻ BIDV Visa Signature với mức hoàn 8% tại các điểm mua sắm thời trang.',
  'Bạn có thể tích điểm nhanh hơn bằng cách thanh toán online qua ứng dụng. Thẻ VPBank StepUP tặng thêm 2X điểm cho mọi giao dịch trực tuyến.',
];

int _mockIndex = 0;

class AiDatasourceImpl implements AiDatasource {
  @override
  Future<AiMessageModel> genText({
    required String sessionId,
    required String userMessage,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));

    final response = _mockResponses[_mockIndex % _mockResponses.length];
    _mockIndex++;

    return AiMessageModel(
      content: response,
      isUser: false,
      timestamp: DateTime.now(),
    );
  }
}
