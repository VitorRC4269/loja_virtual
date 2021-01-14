import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignupScreenGoogle extends StatefulWidget {
  @override
  _SignupScreenGoogleState createState() => _SignupScreenGoogleState();
}

class _SignupScreenGoogleState extends State<SignupScreenGoogle> {
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Dados adicionais'),
          centerTitle: true,
          actions: <Widget>[],
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading)
              return Center(
                child: CircularProgressIndicator(),
              );
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: 'Endereço: Rua, Bairro, Número',
                    ),
                    validator: (text) {
                      if (text.isEmpty) return 'Endereço inválido';
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      hintText: 'Telefone',
                    ),
                    validator: (text) {
                      if (text.isEmpty || text.length < 11)
                        return 'Telefone inválido';
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      child: Text(
                        'Entrar',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Map<String, dynamic> userData = {
                            'name': model.firebaseUser.displayName,
                            'email': model.firebaseUser.email,
                            'address': _addressController.text,
                            'phone': _phoneController.text,
                          };
                          model.signUpGoogle(
                              userData: userData,
                              //    pass: _passController.text,
                              onSucess: _onSucess,
                              onFail: _onFail);
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }

  void _onSucess() async {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('Login feito com sucesso!'),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('Falha ao entrar!'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
