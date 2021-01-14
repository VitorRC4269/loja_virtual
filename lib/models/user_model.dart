import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  FirebaseAuth _auth = FirebaseAuth.instance;
  User firebaseUser;
  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _loadCurrentUser();
  }

  void signUp(
      {@required Map<String, dynamic> userData,
      @required String pass,
      @required VoidCallback onSucess,
      @required VoidCallback onFail}) {
    isLoading = true;
    notifyListeners();
    _auth
        .createUserWithEmailAndPassword(
            email: userData['email'], password: pass)
        .then((authResult) async {
      firebaseUser = authResult.user;

      await _saveUserData(userData);

      onSucess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signIn(
      {@required String email,
      @required String pass,
      @required VoidCallback onSucess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((authResult) async {
      firebaseUser = authResult.user;

      await _loadCurrentUser();

      onSucess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signOut() async {
    await _auth.signOut();
    if (googleSignIn.isSignedIn() != null) googleSignIn.signOut();

    userData = Map();
    firebaseUser = null;

    notifyListeners();
  }

  void signUpGoogle(
      {@required Map<String, dynamic> userData,
      @required VoidCallback onSucess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();
    try {
      await _saveUserData(userData);

      //await _loadCurrentUser();
      onSucess();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      onFail();
      isLoading = false;
      notifyListeners();
    }
    ;
  }

  Future<bool> signInGoogle() async {
    // if (firebaseUser != null) print('caori');
    isLoading = true;
    notifyListeners();

    print('tentnado');
    try {
      print('1');
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      print('2');
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      print('3');
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      //AuthResult agora é UserCredential
      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      firebaseUser = authResult.user;

      bool existe = false;
      await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: firebaseUser.email)
          .get()
          .then((value) async {
        if (value.size >= 1) {
          existe = true;
          await _loadCurrentUser();
        } else
          existe = false;
      });
      // ? true
      //  : false;

      isLoading = false;
      notifyListeners();
      return existe;
      //print('certin');
      //return user;

    } catch (error) {
      print('deumerda');
      //print(firebaseUser.displayName);
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  void recoverPass(String email) {
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .set(userData);
  }

  Future<Null> _loadCurrentUser() async {
    if (firebaseUser == null) firebaseUser = await _auth.currentUser;
    if (firebaseUser != null) {
      if (userData['name'] == null) {
        DocumentSnapshot docUser = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();
        userData = docUser.data();
      }
    }
    notifyListeners();
  }
}
