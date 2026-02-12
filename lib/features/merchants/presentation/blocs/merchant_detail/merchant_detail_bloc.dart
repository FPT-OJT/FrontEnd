import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/features/merchants/domain/usecases/get_merchant_agency_detail.dart';
import 'package:fpt_ojt/features/merchants/presentation/blocs/merchant_detail/merchant_detail_event.dart';
import 'package:fpt_ojt/features/merchants/presentation/blocs/merchant_detail/merchant_detail_state.dart';

class MerchantDetailBloc
    extends Bloc<MerchantDetailEvent, MerchantDetailState> {
  MerchantDetailBloc({
    required GetMerchantAgencyDetailUseCase getMerchantAgencyDetailUseCase,
  }) : _getMerchantAgencyDetailUseCase = getMerchantAgencyDetailUseCase,
       super(const MerchantDetailInitial()) {
    on<MerchantDetailStarted>(_onMerchantDetailStarted);
    on<MerchantDetailCardSelected>(_onMerchantDetailCardSelected);
    on<MerchantDetailDealIndexChanged>(_onMerchantDetailDealIndexChanged);
  }
  final GetMerchantAgencyDetailUseCase _getMerchantAgencyDetailUseCase;

  Future<void> _onMerchantDetailStarted(
    MerchantDetailStarted event,
    Emitter<MerchantDetailState> emit,
  ) async {
    emit(const MerchantDetailLoading());
    final result = await _getMerchantAgencyDetailUseCase.call(event.merchantId);
    result.fold(
      (failure) => emit(MerchantDetailError(error: failure.message)),
      (merchantDetail) =>
          emit(MerchantDetailLoaded(merchantDetail: merchantDetail)),
    );
  }

  Future<void> _onMerchantDetailCardSelected(
    MerchantDetailCardSelected event,
    Emitter<MerchantDetailState> emit,
  ) async {
    if (state is MerchantDetailLoaded) {
      final loadedState = state as MerchantDetailLoaded;
      emit(loadedState.copyWith(selectedCard: event.card, selectedDealIndex: 0));
    } 
  }

  Future<void> _onMerchantDetailDealIndexChanged(
    MerchantDetailDealIndexChanged event,
    Emitter<MerchantDetailState> emit,
  ) async {
    if (state is MerchantDetailLoaded) {
      final loadedState = state as MerchantDetailLoaded;
      emit(loadedState.copyWith(selectedDealIndex: event.dealIndex));
    }
  }
}
