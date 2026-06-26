import 'package:firebase_auth/firebase_auth.dart';

class AutenticacaoServicos {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  cadastrarUsuario({
    required String email,
    required String senha,
    required String nome,
  }) {
    _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: senha)
        .then((userCredential) {
          // Atualiza o nome do usuário
          userCredential.user?.updateDisplayName(nome);
        })
        .catchError((error) {
          throw Exception('Erro ao cadastrar usuário: $error');
        });
  }
}
