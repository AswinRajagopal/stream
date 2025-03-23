import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthEvent {}

class GoogleSignInEvent extends AuthEvent {}

class EmailLoginEvent extends AuthEvent {
  final String email;
  final String password;
  EmailLoginEvent(this.email, this.password);
}

class PhoneLoginEvent extends AuthEvent {
  final String phoneNumber;
  PhoneLoginEvent(this.phoneNumber);
}

class OTPSent extends AuthState {
  final String verificationId;
  OTPSent(this.verificationId);
}

class VerifyOTPEvent extends AuthEvent {
  final String verificationId;
  final String otp;
  VerifyOTPEvent(this.verificationId, this.otp);
}

class AnonymousSignInEvent extends AuthEvent {}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;
  Authenticated(this.user);
}

class Unauthenticated extends AuthState {
  final String? error;
  Unauthenticated({this.error});
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial()) {
    on<GoogleSignInEvent>(_handleGoogleSignIn);
    on<EmailLoginEvent>(_handleEmailLogin);
    on<PhoneLoginEvent>(_handlePhoneLogin);
    on<VerifyOTPEvent>(_handleVerifyOTP);
    on<AnonymousSignInEvent>(_handleAnonymousSignIn);
  }

  Future<void> _handleGoogleSignIn(
      GoogleSignInEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      emit(Authenticated(userCredential.user!));
    } catch (e) {
      emit(Unauthenticated(error: e.toString()));
    }
  }

  Future<void> _handleEmailLogin(
      EmailLoginEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(Authenticated(userCredential.user!));
    } catch (e) {
      emit(Unauthenticated(error: e.toString()));
    }
  }

  String formatPhoneNumber(String number) {
    if (!number.startsWith("+")) {
      return "+91$number";
    }
    return number;
  }

  Future<void> _handlePhoneLogin(
      PhoneLoginEvent event, Emitter<AuthState> emit) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: formatPhoneNumber(event.phoneNumber),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          if (!emit.isDone) emit(Authenticated(_auth.currentUser!));
        },
        verificationFailed: (FirebaseAuthException e) {
          if (!emit.isDone) emit(Unauthenticated(error: e.message));
        },
        codeSent: (String verificationId, int? resendToken) async {
          print("OTP Sent. Verification ID: $verificationId");
          if (verificationId.isNotEmpty) {
            if (!emit.isDone) emit(OTPSent(verificationId));
          } else {
            print("Error: verificationId is empty!");
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print(" Auto-retrieval timeout. Verification ID: $verificationId");
        },
      );
    } catch (e) {
      if (!emit.isDone) emit(Unauthenticated(error: e.toString()));
    }
  }

  Future<void> _handleVerifyOTP(
      VerifyOTPEvent event, Emitter<AuthState> emit) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: event.verificationId,
        smsCode: event.otp,
      );
      await _auth.signInWithCredential(credential);
      emit(Authenticated(_auth.currentUser!));
    } catch (e) {
      emit(Unauthenticated(error: e.toString()));
    }
  }

  Future<void> _handleAnonymousSignIn(
      AnonymousSignInEvent event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      final userCredential = await _auth.signInAnonymously();
      emit(Authenticated(userCredential.user!));
    } catch (e) {
      emit(Unauthenticated(error: e.toString()));
    }
  }
}
