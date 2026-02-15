import 'package:e_commerce_client/core/errors/exception.dart';
import 'package:e_commerce_client/core/external/google/google_auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock
    implements GoogleSignInAuthentication {}

void main() {
  late GoogleAuthService service;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockGoogleSignInAccount mockAccount;
  late MockGoogleSignInAuthentication mockAuth;

  setUp(() {
    mockGoogleSignIn = MockGoogleSignIn();
    mockAccount = MockGoogleSignInAccount();
    mockAuth = MockGoogleSignInAuthentication();

    service = GoogleAuthServiceImpl(
      googleSignIn: mockGoogleSignIn,
      serverClientId: 'test-server-client-id',
    );
  });

  group('initialize', () {
    test('should call GoogleSignIn.initialize with serverClientId', () async {
      // arrange
      when(
        () => mockGoogleSignIn.initialize(
          serverClientId: any(named: 'serverClientId'),
        ),
      ).thenAnswer((_) async {});

      // act
      await service.initialize();

      // assert
      verify(
        () => mockGoogleSignIn.initialize(
          serverClientId: 'test-server-client-id',
        ),
      ).called(1);
    });

    test(
      'should call attemptLightweightAuthentication after initialize',
      () async {
        // arrange
        when(
          () => mockGoogleSignIn.initialize(
            serverClientId: any(named: 'serverClientId'),
          ),
        ).thenAnswer((_) async {});

        when(
          () => mockGoogleSignIn.attemptLightweightAuthentication(),
        ).thenAnswer((_) async => mockAccount);

        // act
        await service.initialize();

        // assert
        verifyInOrder([
          () => mockGoogleSignIn.initialize(
            serverClientId: 'test-server-client-id',
          ),
          () => mockGoogleSignIn.attemptLightweightAuthentication(),
        ]);
      },
    );

    test('should throw GoogleAuthException when initialize fails', () async {
      // arrange
      when(
        () => mockGoogleSignIn.initialize(
          serverClientId: any(named: 'serverClientId'),
        ),
      ).thenThrow(Exception('Platform initialization error'));

      // act & assert
      expect(
        () => service.initialize(),
        throwsA(
          isA<GoogleAuthException>().having(
            (e) => e.message,
            'message',
            allOf([
              contains('Failed to initialize Google Sign-In'),
              contains('Please check your configuration'),
              contains('Platform initialization error'),
            ]),
          ),
        ),
      );
    });

    test('should handle null serverClientId', () async {
      // arrange
      final serviceWithNullId = GoogleAuthServiceImpl(
        googleSignIn: mockGoogleSignIn,
        serverClientId: null,
      );

      when(
        () => mockGoogleSignIn.initialize(
          serverClientId: any(named: 'serverClientId'),
        ),
      ).thenAnswer((_) async {});

      when(
        () => mockGoogleSignIn.attemptLightweightAuthentication(),
      ).thenAnswer((_) async => mockAccount);

      // act
      await serviceWithNullId.initialize();

      // assert
      verify(() => mockGoogleSignIn.initialize(serverClientId: null)).called(1);
    });
  });

  group('getIdToken', () {
    const tIdToken = 'test_id_token_12345';
    test('should return id token when user is not signed in', () async {
      // arrange
      when(() => mockGoogleSignIn.supportsAuthenticate()).thenReturn(true);
      when(
        () => mockGoogleSignIn.authenticate(),
      ).thenAnswer((_) async => mockAccount);
      when(() => mockAccount.authentication).thenReturn(mockAuth);
      when(() => mockAuth.idToken).thenReturn(tIdToken);

      // act
      await service.getIdToken();

      // assert
      verify(() => mockGoogleSignIn.authenticate()).called(1);

      // Now test getting token when already signed in
      // arrange
      // when(() => mockAccount.authentication).thenReturn(mockAuth);
      // when(() => mockAuth.idToken).thenReturn(tIdToken);

      // // act
      // final result = await service.getIdToken();

      // // assert
      // expect(result, tIdToken);
    });

    test('should return id token from authenticated user', () async {
      // arrange
      when(() => mockGoogleSignIn.supportsAuthenticate()).thenReturn(true);
      when(
        () => mockGoogleSignIn.authenticate(),
      ).thenAnswer((_) async => mockAccount);
      when(() => mockAccount.authentication).thenReturn(mockAuth);
      when(() => mockAuth.idToken).thenReturn(tIdToken);

      // act
      final result = await service.getIdToken();

      // assert
      expect(result, tIdToken);
    });

    test(
      'should throw GoogleAuthException when user cancels sign-in',
      () async {
        // arrange
        when(() => mockGoogleSignIn.supportsAuthenticate()).thenReturn(true);
        when(() => mockAccount.authentication).thenReturn(mockAuth);
        when(() => mockAuth.idToken).thenReturn(tIdToken);
        when(() => mockGoogleSignIn.authenticate()).thenThrow(
          GoogleSignInException(
            code: GoogleSignInExceptionCode.canceled,
            description: 'User canceled',
          ),
        );

        // act & asset
        expect(
          () => service.getIdToken(),
          throwsA(
            isA<GoogleAuthException>().having(
              (e) => e.message,
              'message',
              'User cancelled sign-in',
            ),
          ),
        );
      },
    );

    test('should check if platform supports authenticate', () async {
      // arrange
      when(() => mockGoogleSignIn.supportsAuthenticate()).thenReturn(false);

      // act & assert
      expect(
        () => service.getIdToken(),
        throwsA(
          isA<GoogleAuthException>().having(
            (e) => e.message,
            'message',
            'Platform does not support authentication',
          ),
        ),
      );
    });

    test('should use existing user if already sign in', () async {
      // arrange
      // Simulate currentUser:
      // - First call returns null (not signed in yet)
      // - Second call returns mockAccount (already signed in)
      when(() => mockGoogleSignIn.supportsAuthenticate()).thenReturn(true);
      when(
        () => mockGoogleSignIn.authenticate(),
      ).thenAnswer((_) async => mockAccount);
      when(() => mockAccount.authentication).thenReturn(mockAuth);
      when(() => mockAuth.idToken).thenReturn(tIdToken);

      // First call - triggers authentication flow
      await service.getIdToken();

      // Reset interactions before second call
      clearInteractions(mockGoogleSignIn);

      // act
      // Second call should reuse existing user and NOT call authenticate()
      await service.getIdToken();

      // assert
      verifyNever(() => mockGoogleSignIn.authenticate());
    });

    test('should throw GoogleAuthException when idToken is null', () async {
      // arrange
      when(() => mockGoogleSignIn.supportsAuthenticate()).thenReturn(true);
      when(
        () => mockGoogleSignIn.authenticate(),
      ).thenAnswer((_) async => mockAccount);

      when(() => mockAccount.authentication).thenAnswer((_) => mockAuth);

      when(() => mockAuth.idToken).thenReturn(null);

      // act & assert
      expect(
        () => service.getIdToken(),
        throwsA(
          isA<GoogleAuthException>().having(
            (e) => e.message,
            'message',
            'Failed to obtain ID token',
          ),
        ),
      );
    });

    test(
      'should throw GoogleAuthException with description for other sign-in errors',
      () async {
        // arrange
        when(() => mockGoogleSignIn.supportsAuthenticate()).thenReturn(true);

        when(() => mockGoogleSignIn.authenticate()).thenThrow(
          GoogleSignInException(
            code: GoogleSignInExceptionCode.unknownError,
            description: 'Unknown error',
          ),
        );

        // act & assert
        expect(
          () => service.getIdToken(),
          throwsA(
            isA<GoogleAuthException>().having(
              (e) => e.message,
              'message',
              allOf([contains('Sign-in failed')]),
            ),
          ),
        );
      },
    );

    test('should wrap generic exceptions in GoogleAuthException', () async {
      // arrange
      when(() => mockGoogleSignIn.supportsAuthenticate()).thenReturn(true);
      when(
        () => mockGoogleSignIn.authenticate(),
      ).thenAnswer((_) async => mockAccount);
      when(
        () => mockAccount.authentication,
      ).thenThrow(Exception('Unexpected error'));

      // act & assert
      expect(
        () => service.getIdToken(),
        throwsA(
          isA<GoogleAuthException>().having(
            (e) => e.message,
            'message',
            allOf([
              contains('Failed to get ID token'),
              contains('Unexpected error'),
            ]),
          ),
        ),
      );
    });
  });

  group('signOut', () {
    test('should clear currentUser after sign out', () async {
      // arrange
      when(() => mockGoogleSignIn.disconnect()).thenAnswer((_) async {});

      // act
      await service.signOut();

      // assert
      expect(service.currentUser, isNull);
      verify(() => mockGoogleSignIn.disconnect()).called(1);
    });
  });

  //   test('should listen to authenticationEvents', () async {
  //     // arrange
  //     when(
  //       () => mockGoogleSignIn.initialize(
  //         serverClientId: any(named: 'serverClientId'),
  //       ),
  //     ).thenAnswer((_) async {});

  //     when(
  //       () => mockGoogleSignIn.attemptLightweightAuthentication(),
  //     ).thenAnswer((_) async => mockAccount);

  //     // act
  //     await service.initialize();

  //     // assert
  //     verify(() => mockGoogleSignIn.authenticationEvents).called(1);
  //   });

  //   test('should call attemptLightweightAuthentication', () async {
  //     // arrange
  //     when(
  //       () => mockGoogleSignIn.initialize(
  //         serverClientId: any(named: 'serverClientId'),
  //       ),
  //     ).thenAnswer((_) async {});
  //     when(
  //       () => mockGoogleSignIn.attemptLightweightAuthentication(),
  //     ).thenAnswer((_) async {});

  //     // act
  //     await service.initialize();

  //     // assert
  //     verify(
  //       () => mockGoogleSignIn.attemptLightweightAuthentication(),
  //     ).called(1);
  //   });

  //   test('should update currentUser when sign-in event is received', () async {
  //     // arrange
  //     when(
  //       () => mockGoogleSignIn.initialize(
  //         serverClientId: any(named: 'serverClientId'),
  //       ),
  //     ).thenAnswer((_) async {});
  //     when(
  //       () => mockGoogleSignIn.attemptLightweightAuthentication(),
  //     ).thenAnswer((_) async {});

  //     // act
  //     await service.initialize();

  //     // Emit sign-in event
  //     authEventsController.add(
  //       GoogleSignInAuthenticationEventSignIn(mockAccount),
  //     );

  //     // Wait for event to be processed
  //     await Future.delayed(const Duration(milliseconds: 50));

  //     // assert
  //     expect(service.currentUser, mockAccount);
  //   });

  //   test('should clear currentUser when sign-out event is received', () async {
  //     // arrange
  //     when(
  //       () => mockGoogleSignIn.initialize(
  //         serverClientId: any(named: 'serverClientId'),
  //       ),
  //     ).thenAnswer((_) async {});
  //     when(
  //       () => mockGoogleSignIn.attemptLightweightAuthentication(),
  //     ).thenAnswer((_) async {});

  //     // act
  //     await service.initialize();

  //     // First sign in
  //     authEventsController.add(
  //       GoogleSignInAuthenticationEventSignIn(mockAccount),
  //     );
  //     await Future.delayed(const Duration(milliseconds: 50));

  //     // Then sign out
  //     authEventsController.add(GoogleSignInAuthenticationEventSignOut());
  //     await Future.delayed(const Duration(milliseconds: 50));

  //     // assert
  //     expect(service.currentUser, isNull);
  //   });

  //   test('should throw exception when initialize fails', () async {
  //     // arrange
  //     when(
  //       () => mockGoogleSignIn.initialize(
  //         serverClientId: any(named: 'serverClientId'),
  //       ),
  //     ).thenThrow(Exception('Initialization failed'));

  //     // act & assert
  //     expect(() => service.initialize(), throwsException);
  //   });

  // group('signIn', () {
  //   setUp(() {
  //     when(
  //       () => mockGoogleSignIn.initialize(
  //         serverClientId: any(named: 'serverClientId'),
  //       ),
  //     ).thenAnswer((_) async {});
  //     when(
  //       () => mockGoogleSignIn.attemptLightweightAuthentication(),
  //     ).thenAnswer((_) async {});
  //   });

  //   test('should return user when sign-in is successful', () async {
  //     // arrange
  //     await service.initialize();

  //     when(() => mockGoogleSignIn.supportsAuthenticate()).thenReturn(true);
  //     when(() => mockGoogleSignIn.authenticate()).thenAnswer((_) async {
  //       // Simulate authentication event
  //       authEventsController.add(
  //         GoogleSignInAuthenticationEventSignIn(mockAccount),
  //       );
  //     });

  //     // act
  //     final result = await service.signIn();

  //     // assert
  //     expect(result, mockAccount);
  //     verify(() => mockGoogleSignIn.supportsAuthenticate()).called(1);
  //     verify(() => mockGoogleSignIn.authenticate()).called(1);
  //   });

  //   test(
  //     'should throw GoogleAuthException when platform does not support authenticate',
  //     () async {
  //       // arrange
  //       await service.initialize();
  //       when(() => mockGoogleSignIn.supportsAuthenticate()).thenReturn(false);

  //       // act & assert
  //       expect(
  //         () => service.signIn(),
  //         throwsA(
  //           isA<GoogleAuthException>().having(
  //             (e) => e.message,
  //             'message',
  //             'Platform does not support authentication',
  //           ),
  //         ),
  //       );
  //       verifyNever(() => mockGoogleSignIn.authenticate());
  //     },
  //   );

  //   test('should return null when user cancels sign-in', () async {
  //     // arrange
  //     await service.initialize();

  //     when(() => mockGoogleSignIn.supportsAuthenticate()).thenReturn(true);
  //     when(() => mockGoogleSignIn.authenticate()).thenThrow(
  //       GoogleSignInException(
  //         code: GoogleSignInExceptionCode.canceled,
  //         description: 'User canceled',
  //       ),
  //     );

  //     // act
  //     final result = await service.signIn();

  //     // assert
  //     expect(result, isNull);
  //   });

  //   test(
  //     'should throw GoogleAuthException when sign-in fails with other error',
  //     () async {
  //       // arrange
  //       await service.initialize();

  //       when(() => mockGoogleSignIn.supportsAuthenticate()).thenReturn(true);
  //       when(() => mockGoogleSignIn.authenticate()).thenThrow(
  //         GoogleSignInException(
  //           code: GoogleSignInExceptionCode.networkError,
  //           description: 'Network error',
  //         ),
  //       );

  //       // act & assert
  //       expect(
  //         () => service.signIn(),
  //         throwsA(
  //           isA<GoogleAuthException>().having(
  //             (e) => e.message,
  //             'message',
  //             contains('Sign in failed'),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // });

  // group('getIdToken', () {
  //   const tIdToken = 'test_id_token_12345';

  //   test('should return id token when authentication is successful', () async {
  //     // arrange
  //     when(() => mockAccount.authentication).thenAnswer((_) async => mockAuth);
  //     when(() => mockAuth.idToken).thenReturn(tIdToken);

  //     // act
  //     final result = await service.getIdToken(mockAccount);

  //     // assert
  //     expect(result, tIdToken);
  //     verify(() => mockAccount.authentication).called(1);
  //   });

  //   test('should throw GoogleAuthException when idToken is null', () async {
  //     // arrange
  //     when(() => mockAccount.authentication).thenAnswer((_) async => mockAuth);
  //     when(() => mockAuth.idToken).thenReturn(null);

  //     // act & assert
  //     expect(
  //       () => service.getIdToken(mockAccount),
  //       throwsA(
  //         isA<GoogleAuthException>().having(
  //           (e) => e.message,
  //           'message',
  //           'Failed to obtain ID token',
  //         ),
  //       ),
  //     );
  //   });

  //   test(
  //     'should throw GoogleAuthException when authentication fails',
  //     () async {
  //       // arrange
  //       when(
  //         () => mockAccount.authentication,
  //       ).thenThrow(Exception('Auth failed'));

  //       // act & assert
  //       expect(
  //         () => service.getIdToken(mockAccount),
  //         throwsA(
  //           isA<GoogleAuthException>().having(
  //             (e) => e.message,
  //             'message',
  //             contains('Failed to get ID token'),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // });

  // group('signOut', () {
  //   setUp(() {
  //     when(
  //       () => mockGoogleSignIn.initialize(
  //         serverClientId: any(named: 'serverClientId'),
  //       ),
  //     ).thenAnswer((_) async {});
  //     when(
  //       () => mockGoogleSignIn.attemptLightweightAuthentication(),
  //     ).thenAnswer((_) async {});
  //   });

  //   test('should call GoogleSignIn.disconnect', () async {
  //     // arrange
  //     await service.initialize();
  //     when(() => mockGoogleSignIn.disconnect()).thenAnswer((_) async {});

  //     // act
  //     await service.signOut();

  //     // assert
  //     verify(() => mockGoogleSignIn.disconnect()).called(1);
  //   });

  //   test('should clear currentUser', () async {
  //     // arrange
  //     await service.initialize();

  //     // Set current user first
  //     authEventsController.add(
  //       GoogleSignInAuthenticationEventSignIn(mockAccount),
  //     );
  //     await Future.delayed(const Duration(milliseconds: 50));

  //     expect(service.currentUser, mockAccount);

  //     when(() => mockGoogleSignIn.disconnect()).thenAnswer((_) async {});

  //     // act
  //     await service.signOut();

  //     // assert
  //     expect(service.currentUser, isNull);
  //   });

  //   test('should handle disconnect failure gracefully', () async {
  //     // arrange
  //     await service.initialize();
  //     when(
  //       () => mockGoogleSignIn.disconnect(),
  //     ).thenThrow(Exception('Disconnect failed'));

  //     // act & assert
  //     expect(() => service.signOut(), throwsException);
  //   });
  // });

  // group('currentUser', () {
  //   setUp(() {
  //     when(
  //       () => mockGoogleSignIn.initialize(
  //         serverClientId: any(named: 'serverClientId'),
  //       ),
  //     ).thenAnswer((_) async {});
  //     when(
  //       () => mockGoogleSignIn.attemptLightweightAuthentication(),
  //     ).thenAnswer((_) async {});
  //   });

  //   test('should return null initially', () {
  //     // assert
  //     expect(service.currentUser, isNull);
  //   });

  //   test('should return current user after sign-in event', () async {
  //     // arrange
  //     await service.initialize();

  //     // act
  //     authEventsController.add(
  //       GoogleSignInAuthenticationEventSignIn(mockAccount),
  //     );
  //     await Future.delayed(const Duration(milliseconds: 50));

  //     // assert
  //     expect(service.currentUser, mockAccount);
  //   });

  //   test('should return null after sign-out event', () async {
  //     // arrange
  //     await service.initialize();

  //     // Sign in first
  //     authEventsController.add(
  //       GoogleSignInAuthenticationEventSignIn(mockAccount),
  //     );
  //     await Future.delayed(const Duration(milliseconds: 50));

  //     // act - Sign out
  //     authEventsController.add(GoogleSignInAuthenticationEventSignOut());
  //     await Future.delayed(const Duration(milliseconds: 50));

  //     // assert
  //     expect(service.currentUser, isNull);
  //   });
  // });

  // group('GoogleAuthException', () {
  //   test('should contain correct message', () {
  //     // arrange
  //     const message = 'Test error message';
  //     final exception = GoogleAuthException(message);

  //     // assert
  //     expect(exception.message, message);
  //     expect(exception.toString(), 'GoogleAuthException: $message');
  //   });
  // });
}
