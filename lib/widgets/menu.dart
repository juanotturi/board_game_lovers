import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class AppMenu extends StatefulWidget implements PreferredSizeWidget {
  const AppMenu({super.key});

  @override
  AppMenuState createState() => AppMenuState();

  @override
  Size get preferredSize => const Size.fromHeight(110); // Aumentar la altura del AppBar
}

class AppMenuState extends State<AppMenu> {
  String? _selectedButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 110, // Aumentar la altura del AppBar
      backgroundColor: Colors.transparent, // Hacer el AppBar transparente
      automaticallyImplyLeading: false, // Eliminar la flecha de retroceso
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(84, 40, 12, 1), // Color inicial
              Color.fromARGB(255, 216, 195, 164), // Color final
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 90, // Altura para la parte sin degradado
              color: const Color.fromRGBO(84, 40, 12, 1), // Color inicial
              padding: const EdgeInsets.only(top: 25, left: 10, right: 10, bottom: 10), // Ajustar para que comience más abajo y margenes horizontales
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.go('/'); // Ruta a la pantalla principal
                    },
                    child: Image.asset(
                      'assets/logo.png', // Asegúrate de que el logo esté en la carpeta assets
                      height: 90, // Tamaño del logo incrementado
                    ),
                  ),
                  const SizedBox(width: 20), // Espacio entre el logo y los íconos
                  _buildIconButton(
                    context,
                    icon: FontAwesomeIcons.gamepad,
                    tooltip: 'My Games',
                    route: '/mygames',
                  ),
                  const SizedBox(width: 20), // Añadir padding entre botones
                  _buildIconButton(
                    context,
                    icon: FontAwesomeIcons.users,
                    tooltip: 'Community',
                    route: '/community',
                  ),
                  const Spacer(),
                  _buildIconButton(
                    context,
                    icon: FontAwesomeIcons.magnifyingGlass,
                    tooltip: 'Search',
                    route: '/buscar',
                    isSearch: true,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                height: 30, // Reducir la altura del gradiente
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(84, 40, 12, 1), // Color inicial
                      Color.fromARGB(255, 216, 195, 164), // Color final
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

  Widget _buildIconButton(BuildContext context, {required IconData icon, required String tooltip, required String route, bool isSearch = false}) {
    return Row(
      children: [
        if (isSearch)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _selectedButton == tooltip ? 60 : 0,
            child: GestureDetector(
              onTap: () {
                context.go(route);
              },
              child: AnimatedOpacity(
                opacity: _selectedButton == tooltip ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  margin: const EdgeInsets.only(right: 4.0), // Reducir el margen aquí
                  child: const Text(
                    'Search',
                    overflow: TextOverflow.ellipsis, // Asegurarse de que el texto no se pase a dos líneas
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
            if (_selectedButton == tooltip) {
              context.go(route);
            } else {
              setState(() {
                _selectedButton = tooltip;
              });
            }
          },
          child: Icon(icon, color: Colors.white),
        ),
        if (!isSearch)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: _selectedButton == tooltip ? 100 : 0,
            child: GestureDetector(
              onTap: () {
                context.go(route);
              },
              child: AnimatedOpacity(
                opacity: _selectedButton == tooltip ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  margin: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    tooltip,
                    overflow: TextOverflow.ellipsis, // Asegurarse de que el texto no se pase a dos líneas
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
