import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;
  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    Widget _builderDrawerBack() => Container(
          decoration: BoxDecoration(
            /*  gradient: LinearGradient(
              colors: [
                //Color.fromARGB(255, 203, 236, 241),
                Colors.white,
                Color.fromARGB(255, 26, 29, 44),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),*/
            color: Color.fromARGB(255, 26, 29, 44),
          ),
        );

    return Drawer(
        child: Stack(
      children: <Widget>[
        _builderDrawerBack(),
        ListView(
          padding: EdgeInsets.only(left: 32.0, top: 16.0),
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 0.0),
              padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
              height: 170.0,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 8.0,
                    left: 0.0,
                    child: Text(
                      'Asi Lanches',
                      style: TextStyle(
                          fontSize: 34.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                //'hey',
                                'Olá, ${!model.isLoggedIn() ? '' : model.userData['name']}',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              GestureDetector(
                                child: Text(
                                  !model.isLoggedIn()
                                      ? 'Entre ou cadastre-se >'
                                      : 'Sair',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  if (!model.isLoggedIn())
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()));
                                  else
                                    model.signOut();
                                },
                              )
                            ],
                          );
                        },
                      ))
                ],
              ),
            ),
            Divider(),
            DrawerTile(Icons.home, "Início", pageController, 0),
            DrawerTile(Icons.list, "Produtos", pageController, 1),
            DrawerTile(Icons.location_on, "Lojas", pageController, 2),
            DrawerTile(
                Icons.playlist_add_check, "Meus pedidos", pageController, 3),
            Container(
              height: 340.0,
              //width: 340.0,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    bottom: 20,
                    right: 40,
                    child: Image.asset(
                      "images/asimov.png",
                      fit: BoxFit.contain,
                      height: 57.0,
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ],
    ));
  }
}
