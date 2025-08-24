import 'package:flutter/material.dart';
import '../utils/colores.dart';
import 'juego_memoria.dart';
import 'juego_atencion.dart';
import 'juego_lenguaje.dart';
import 'juego_motricidad.dart';

class HomePage extends StatelessWidget {
  final String nombre;

  HomePage({required this.nombre});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondo,
      appBar: AppBar(
        title: Text("Hola, $nombre 👋", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
        backgroundColor: AppColors.primario,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: [
            _opcionJuego(
              context,
              titulo: "Memoria",
              icono: Icons.memory,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => JuegoMemoria()),
              ),
            ),
            _opcionJuego(context,
              titulo: "Atención",
              icono: Icons.visibility,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => JuegoAtencion()),
              ),
            ),
            _opcionJuego(context,
              titulo: "Lenguaje",
              icono: Icons.record_voice_over,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => JuegoLenguaje()),
              ),
            ),
            _opcionJuego(context,
              titulo: "Motricidad",
              icono: Icons.touch_app,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => JuegoMotricidad()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _opcionJuego(BuildContext ctx,
      {required String titulo, required IconData icono, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: AppColors.acento,
        borderRadius: BorderRadius.circular(20),
        elevation: 6,
        shadowColor: Colors.black26,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icono, size: 50, color: Colors.white),
              SizedBox(height: 12),
              Text(
                titulo,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
