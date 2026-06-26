import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Stream para monitorar mudanças de autenticação
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Obtém o usuário atual
  User? get currentUser => _firebaseAuth.currentUser;

  // Fazer cadastro com email e senha
  Future<UserCredential?> signup(
    String email,
    String senha,
    String nome,
  ) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: senha);

      // Atualiza o nome do usuário
      await userCredential.user?.updateDisplayName(nome);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _tratarErro(e.code);
    }
  }

  // Fazer login com email e senha
  Future<UserCredential?> login(String email, String senha) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: senha);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _tratarErro(e.code);
    }
  }

  // Fazer logout
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw _tratarErro(e.code);
    }
  }

  // Resetar senha
  Future<void> resetarSenha(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _tratarErro(e.code);
    }
  }

  // Tratar erros do Firebase
  String _tratarErro(String codigo) {
    switch (codigo) {
      case 'weak-password':
        return 'A senha é muito fraca.';
      case 'email-already-in-use':
        return 'Este email já está registrado.';
      case 'invalid-email':
        return 'Email inválido.';
      case 'user-disabled':
        return 'Esta conta foi desabilitada.';
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'too-many-requests':
        return 'Muitas tentativas de login. Tente novamente mais tarde.';
      case 'operation-not-allowed':
        return 'Operação não permitida.';
      default:
        return 'Erro: $codigo';
    }
  }
}
