import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_auto_service_app/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // <--- Get current user --->
  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // <--- Sign up with Email/Password --->
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String username,
    String? mobileNumber,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // <--- Create user (Firestore) --->
      if (credential.user != null) {
        final user = UserModel(
          uid: credential.user!.uid,
          email: email,
          username: username,
          mobileNumber: mobileNumber,
          authProvider: 'email',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(user.toFirestore());
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // <--- Sign in with Email/Password --->
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // <--- Sign in with Google --->
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize();

      final GoogleSignInAccount account = await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = account.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      // <--- Create or update in Firestore --->
      if (userCredential.user != null) {
        final userDoc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (!userDoc.exists) {
          final user = UserModel(
            uid: userCredential.user!.uid,
            email: userCredential.user!.email ?? account.email,
            username: account.displayName ?? 'User',
            photoUrl: account.photoUrl,
            authProvider: 'google',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set(user.toFirestore());
        }
      }

      return userCredential;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw 'Google Sign-In was cancelled';
      }
      throw 'Google Sign-In failed: ${e.description}';
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  //! Sign in with Facebook (NOT IMPLEMENTED)
  Future<UserCredential> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.cancelled) {
        throw 'Facebook Sign-In was cancelled';
      }

      if (result.status == LoginStatus.failed) {
        throw 'Facebook Sign-In failed: ${result.message ?? "No App ID/Secret configured. Please set up Facebook App credentials in Firebase Console."}';
      }

      if (result.accessToken == null) {
        throw 'Facebook Sign-In failed: No access token received. Facebook App may not be configured properly.';
      }

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken!.tokenString);

      final userCredential = await _auth.signInWithCredential(
        facebookAuthCredential,
      );

      // <--- Create or update user document in Firestore --->
      if (userCredential.user != null) {
        final userDoc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (!userDoc.exists) {
          final userData = await FacebookAuth.instance.getUserData();

          final user = UserModel(
            uid: userCredential.user!.uid,
            email: userCredential.user!.email ?? userData['email'] ?? '',
            username: userData['name'] ?? 'User',
            photoUrl: userData['picture']?['data']?['url'],
            authProvider: 'facebook',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set(user.toFirestore());
        }
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // <--- Update user profile --->
  Future<void> updateUserProfile({
    required String username,
    String? mobileNumber,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw 'No user logged in';

    await _firestore.collection('users').doc(user.uid).update({
      'username': username,
      'mobileNumber': mobileNumber,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // <--- Get current user data --->
  Future<UserModel?> getCurrentUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    return UserModel.fromFirestore(doc);
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> signOut() async {
    // Sign out from Google
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}

    // Sign out from Firebase
    await _auth.signOut();
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'invalid-credential':
        return 'Invalid credentials. Please check your email and password.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }
}
