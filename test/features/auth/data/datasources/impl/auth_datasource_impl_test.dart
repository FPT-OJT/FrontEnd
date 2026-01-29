import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpt_ojt/features/auth/data/datasources/impl/auth_datasource_impl.dart';
import 'package:fpt_ojt/features/auth/data/models/auth_models.dart';
import 'package:fpt_ojt/features/shared/models/api_response.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
import 'auth_datasource_impl_test.mocks.dart';

void main() {
  late MockDio mockDio;
  late AuthDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = AuthDataSourceImpl(dio: mockDio);
  });

  group('AuthDataSourceImpl', () {
    const email = 'test@example.com';
    const password = 'password';

    group('loginWithEmail', () {
      test('should perform a POST request to /public/auth/login', () async {
        // Arrange
        final responsePayload = {
          'statusCode': 200,
          'message': 'Success',
          'data': {
            'accessToken': 'token',
            'refreshToken': 'refToken',
            'role': 'user',
            'userId': '1',
          },
        };

        when(
          mockDio.post<Map<String, dynamic>>(any, data: anyNamed('data')),
        ).thenAnswer(
          (_) async => Response(
            data: responsePayload,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/public/auth/login'),
          ),
        );

        // Act
        final result = await dataSource.loginWithEmail(email, password);

        // Assert
        expect(result, isA<ApiResponse<TokenResponse>>());
        expect(result.data!.accessToken, 'token');
        verify(
          mockDio.post<Map<String, dynamic>>(
            '/public/auth/login',
            data: {
              'username': email,
              'password': password,
              'rememberMe': false,
            },
          ),
        ).called(1);
      });
    });

    group('loginWithGoogle', () {
      const idToken = 'google_id_token';
      test('should perform a POST request to /public/auth/google', () async {
        // Arrange
        final responsePayload = {
          'statusCode': 200,
          'message': 'Success',
          'data': {
            'accessToken': 'token',
            'refreshToken': 'refToken',
            'role': 'user',
            'userId': '1',
          },
        };

        when(mockDio.post<Map<String, dynamic>>(any)).thenAnswer(
          (_) async => Response(
            data: responsePayload,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/public/auth/google'),
          ),
        );

        // Act
        final result = await dataSource.loginWithGoogle(idToken);

        // Assert
        expect(result, isA<ApiResponse<TokenResponse>>());
        expect(result.data!.accessToken, 'token');
        verify(
          mockDio.post<Map<String, dynamic>>(
            '/public/auth/google?googleToken=$idToken',
          ),
        ).called(1);
      });
    });

    group('register', () {
      test('should perform a POST request to /public/auth/register', () async {
        // Arrange
        final responsePayload = {
          'statusCode': 200,
          'message': 'Success',
          'data': {
            'accessToken': 'token',
            'refreshToken': 'refToken',
            'role': 'user',
            'userId': '1',
          },
        };

        when(
          mockDio.post<Map<String, dynamic>>(any, data: anyNamed('data')),
        ).thenAnswer(
          (_) async => Response(
            data: responsePayload,
            statusCode: 200,
            requestOptions: RequestOptions(path: '/public/auth/register'),
          ),
        );

        // Act
        final result = await dataSource.register(
          firstName: 'First',
          lastName: 'Last',
          username: 'user',
          password: 'pass',
          repeatPassword: 'pass',
          email: email,
        );

        // Assert
        expect(result, isA<ApiResponse<TokenResponse>>());
        verify(
          mockDio.post<Map<String, dynamic>>(
            '/public/auth/register',
            data: anyNamed('data'),
          ),
        ).called(1);
      });
    });

    group('forgotPassword', () {
      test(
        'should perform a POST request to /public/auth/password/forgot',
        () async {
          // Arrange
          final responsePayload = {
            'statusCode': 200,
            'message': 'Success',
            'data':
                <String, dynamic>{}, // Expecting explicit Map<String, dynamic>
          };

          when(mockDio.post<Map<String, dynamic>>(any)).thenAnswer(
            (_) async => Response(
              data: responsePayload,
              statusCode: 200,
              requestOptions: RequestOptions(
                path: '/public/auth/password/forgot',
              ),
            ),
          );

          // Act
          final result = await dataSource.forgotPassword(email);

          // Assert
          expect(result, isA<ApiResponse<void>>());
          verify(
            mockDio.post<Map<String, dynamic>>(
              '/public/auth/password/forgot?email=$email',
            ),
          ).called(1);
        },
      );
    });

    group('resetPassword', () {
      test(
        'should perform a POST request to /public/auth/password/reset',
        () async {
          // Arrange
          final responsePayload = {
            'statusCode': 200,
            'message': 'Success',
            'data': <String, dynamic>{},
          };

          when(
            mockDio.post<Map<String, dynamic>>(any, data: anyNamed('data')),
          ).thenAnswer(
            (_) async => Response(
              data: responsePayload,
              statusCode: 200,
              requestOptions: RequestOptions(
                path: '/public/auth/password/reset',
              ),
            ),
          );

          // Act
          final result = await dataSource.resetPassword(
            email,
            '123456',
            'newpass',
          );

          // Assert
          expect(result, isA<ApiResponse<void>>());
          verify(
            mockDio.post<Map<String, dynamic>>(
              '/public/auth/password/reset',
              data: anyNamed('data'),
            ),
          ).called(1);
        },
      );
    });

    group('logout', () {
      test('should perform a POST request to /auth/logout', () async {
        // Arrange
        when(mockDio.post<Map<String, dynamic>>(any)).thenAnswer(
          (_) async => Response(
            data: {},
            statusCode: 200,
            requestOptions: RequestOptions(path: '/auth/logout'),
          ),
        );

        // Act
        await dataSource.logout();

        // Assert
        verify(mockDio.post<Map<String, dynamic>>('/auth/logout')).called(1);
      });
    });

    group('getCurrentUser', () {
      test('should perform a GET request and return dummy user', () async {
        // Arrange
        when(mockDio.get<Map<String, dynamic>>(any)).thenAnswer(
          (_) async => Response(
            data: {},
            statusCode: 200,
            requestOptions: RequestOptions(path: '/home/test'),
          ),
        );

        // Act
        final user = await dataSource.getCurrentUser();

        // Assert
        expect(user!.email, 'test@test.com');
        verify(mockDio.get<Map<String, dynamic>>('/home/test')).called(1);
      });
    });
  });
}
