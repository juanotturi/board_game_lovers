import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:board_game_lovers/core/controller/user_controller.dart'; 

class AppMenu extends StatefulWidget implements PreferredSizeWidget {
  final bool showLogoOnly;
  const AppMenu({super.key, this.showLogoOnly = false});

  @override
  AppMenuState createState() => AppMenuState();

  @override
  Size get preferredSize => const Size.fromHeight(110); 
}

class AppMenuState extends State<AppMenu> {
  String? _selectedButton;
  User? user;
  late final StreamSubscription<User?> _authStateSubscription;

  @override
  void initState() {
    super.initState();
    _authStateSubscription = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {
          this.user = user;
        });
      }
    });
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 110,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(84, 40, 12, 1),
              Color.fromARGB(255, 216, 195, 164),
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 90,
              color: const Color.fromRGBO(84, 40, 12, 1),
              padding: const EdgeInsets.only(top: 25, left: 10, right: 10, bottom: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.go('/');
                    },
                    child: Image.asset(
                      'assets/logo.png',
                      height: 90,
                    ),
                  ),
                  if (!widget.showLogoOnly) ...[
                    const SizedBox(width: 20),
                    _buildIconButton(
                      context,
                      icon: FontAwesomeIcons.solidHeart,
                      tooltip: 'My Games',
                      route: '/mygames',
                      disabled: user == null,
                    ),
                    const SizedBox(width: 20),
                    _buildIconButton(
                      context,
                      icon: FontAwesomeIcons.users,
                      tooltip: 'Community',
                      route: '/community',
                      disabled: user == null,
                    ),
                    const Spacer(),
                    _buildIconButton(
                      context,
                      icon: FontAwesomeIcons.magnifyingGlass,
                      tooltip: 'Search',
                      route: '/buscar',
                      isSearch: true,
                    ),
                    const SizedBox(width: 20),
                    Consumer<UserController>(
                      builder: (context, userController, child) {
                        return _buildAuthButton(context, userController);
                      },
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: Container(
                height: 30,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(84, 40, 12, 1),
                      Color.fromARGB(255, 216, 195, 164),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthButton(BuildContext context, UserController userController) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _selectedButton == 'Auth' ? 60 : 0,
          child: GestureDetector(
            onTap: () {
              if (_selectedButton == 'Auth') {
                userController.manageAuth(context);
              } else {
                setState(() {
                  _selectedButton = 'Auth';
                });
              }
            },
            child: AnimatedOpacity(
              opacity: _selectedButton == 'Auth' ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                margin: const EdgeInsets.only(right: 4.0),
                child: Text(
                  user != null ? 'Logout' : 'Login',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (_selectedButton == 'Auth') {
              userController.manageAuth(context);
            } else {
              setState(() {
                _selectedButton = 'Auth';
              });
            }
          },
          child: Container(
            margin: const EdgeInsets.only(right: 14.0),
            child: Icon(
              user != null ? FontAwesomeIcons.plugCircleXmark : FontAwesomeIcons.solidUser,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton(BuildContext context, {required IconData icon, required String tooltip, required String route, bool isSearch = false, bool disabled = false}) {
    final iconColor = disabled ? const Color.fromARGB(255, 105, 105, 105) : Colors.white;

    return Row(
      children: [
        if (isSearch)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _selectedButton == tooltip ? 60 : 0,
            child: GestureDetector(
              onTap: () {
                if (!disabled) {
                  context.go(route);
                }
              },
              child: AnimatedOpacity(
                opacity: _selectedButton == tooltip ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  margin: const EdgeInsets.only(right: 4.0),
                  child: const Text(
                    'Search',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        GestureDetector(
          onTap: () {
            if (!disabled) {
              if (_selectedButton == tooltip) {
                context.go(route);
              } else {
                setState(() {
                  _selectedButton = tooltip;
                });
              }
            }
          },
          child: Icon(icon, color: iconColor),
        ),
        if (!isSearch)
          AnimatedContainer(
            duration: Duration(milliseconds: disabled ? 0 : 300),
            width: _selectedButton == tooltip ? 100 : 0,
            child: GestureDetector(
              onTap: () {
                if (!disabled) {
                  context.go(route);
                }
              },
              child: AnimatedOpacity(
                opacity: _selectedButton == tooltip ? 1.0 : 0.0,
                duration: Duration(milliseconds: disabled ? 0 : 300),
                child: Container(
                  margin: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    tooltip,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
