import 'package:google_sign_in/google_sign_in.dart';
import '../../errors/exception.dart';

abstract interface class GoogleAuthService {
  Future<void> initialize();
  // Future<GoogleSignInAccount?> signIn();
  Future<String> getIdToken();
  Future<void> signOut();
  GoogleSignInAccount? get currentUser;
}

class GoogleAuthServiceImpl implements GoogleAuthService {
  final GoogleSignIn _googleSignIn;
  final String? serverClientId;
  GoogleSignInAccount? _currentUser;

  GoogleAuthServiceImpl({GoogleSignIn? googleSignIn, this.serverClientId})
    : _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  @override
  Future<void> initialize() async {
    try {
      await _googleSignIn.initialize(serverClientId: serverClientId);
    } on Exception catch (e) {
      throw GoogleAuthException(
        'Failed to initialize Google Sign-In. '
        'Please check your configuration: ${e.toString()}',
      );
    }
    await _googleSignIn.attemptLightweightAuthentication();
  }

  @override
  GoogleSignInAccount? get currentUser => _currentUser;

  // @override
  // Future<GoogleSignInAccount?> signIn() async {
  //   try {
  //     if (!_googleSignIn.supportsAuthenticate()) {
  //       throw GoogleAuthException('Platform does not support authentication');
  //     }

  //     await _googleSignIn.authenticate();

  //     await Future.delayed(const Duration(milliseconds: 100));

  //     return _currentUser;
  //   } on GoogleSignInException catch (e) {
  //     if (e.code == GoogleSignInExceptionCode.canceled) {
  //       return null;
  //     }
  //     throw GoogleAuthException('Sign in failed: ${e.description}');
  //   }
  // }

  @override
  Future<String> getIdToken() async {
    try {
      // 1. check if there's already a signed-in user
      var user = _currentUser;

      // 2. if not, trigger the sign-in flow
      if (user == null) {
        if (!_googleSignIn.supportsAuthenticate()) {
          throw GoogleAuthException('Platform does not support authentication');
        }

        _currentUser = await _googleSignIn.authenticate();

        // wait for authentication to complete
        await Future.delayed(const Duration(milliseconds: 100));

        user = _currentUser;

        if (user == null) {
          throw GoogleAuthException('Sign-in failed or was cancelled');
        }
      }
      // 3. user already sign-in, get authentication details
      final auth = user.authentication;
      final idToken = auth.idToken;

      if (idToken == null) {
        throw GoogleAuthException('Failed to obtain ID token');
      }
      return idToken;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw GoogleAuthException('User cancelled sign-in');
      }
      throw GoogleAuthException('Sign-in failed: ${e.description}');
    } catch (e) {
      if (e is GoogleAuthException) rethrow;
      throw GoogleAuthException('Failed to get ID token: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    _currentUser = null;
  }
}
