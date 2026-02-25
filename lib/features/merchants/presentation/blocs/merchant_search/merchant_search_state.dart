import 'package:equatable/equatable.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_agency.dart';

class MerchantSearchState extends Equatable {
  const MerchantSearchState({
    this.query = '',
    this.results = const [],
    this.recentSearches = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final String query;
  final List<MerchantAgency> results;
  final List<MerchantAgency> recentSearches;
  final bool isLoading;
  final String? errorMessage;

  bool get hasQuery => query.trim().isNotEmpty;

  MerchantSearchState copyWith({
    String? query,
    List<MerchantAgency>? results,
    List<MerchantAgency>? recentSearches,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) => MerchantSearchState(
    query: query ?? this.query,
    results: results ?? this.results,
    recentSearches: recentSearches ?? this.recentSearches,
    isLoading: isLoading ?? this.isLoading,
    errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
  );

  @override
  List<Object?> get props => [
    query,
    results,
    recentSearches,
    isLoading,
    errorMessage,
  ];
}
