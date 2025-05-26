import 'package:flutter/material.dart';

Drawer appDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(color: Colors.cyan),
          child: Text("Menu", style: TextStyle(color: Colors.white, fontSize: 24)),
        ),
        ListTile(
          title: const Text("Estudantes"),
          leading: const Icon(Icons.person),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
        ListTile(
          title: const Text("Disciplinas"),
          leading: const Icon(Icons.book),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/disciplinas');
          },
        ),
        ListTile(
          title: const Text("Cursando"),
          leading: const Icon(Icons.link),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/cursando');
          },
        ),
        ListTile(
          title: const Text("Vínculos"),
          leading: const Icon(Icons.search),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/vinculos');
          },
        ),
      ],
    ),
  );
}
