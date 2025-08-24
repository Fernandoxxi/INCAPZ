import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/colores.dart';

class JuegoLenguaje extends StatefulWidget {
  @override
  _JuegoLenguajeState createState() => _JuegoLenguajeState();
}

class _JuegoLenguajeState extends State<JuegoLenguaje> {
  final List<_Palabra> palabras = [
     _Palabra("manzana", "assets/img/manzana.png", "_anzana", "m"),
    _Palabra("loro", "assets/img/loro.png", "lo_o", "r"),
    _Palabra("perro", "assets/img/perro.png", "pe_ro", "r"),
    _Palabra("uva", "assets/img/uva.png", "_va", "u"),
    _Palabra("platano", "assets/img/platano.png", "pla_ano", "t"),
    _Palabra("fresa", "assets/img/fresa.png", "f_esa", "r"),
    _Palabra("pato", "assets/img/pato.png", "_ato", "p"),
    _Palabra("vaca", "assets/img/vaca.png", "_aca", "v"),
    _Palabra("manzana", "assets/img/manzana.png", "man_ana", "z"),
    _Palabra("loro", "assets/img/loro.png", "_oro", "l"),
    _Palabra("perro", "assets/img/perro.png", "p_rro", "e"),
    _Palabra("uva", "assets/img/uva.png", "u_a", "v"),
    _Palabra("platano", "assets/img/platano.png", "plata_o", "n"),
  ];

  late _Palabra actual;
  int puntaje = 0;
  int pregunta = 1;
  List<String> opciones = [];

  @override
  void initState() {
    super.initState();
    _nuevaPalabra();
  }

  void _nuevaPalabra() {
    final random = Random();
    setState(() {
      actual = palabras[random.nextInt(palabras.length)];
      opciones = [
        actual.letraCorrecta,
        String.fromCharCode(97 + random.nextInt(26)),
        String.fromCharCode(97 + random.nextInt(26))
      ];
      opciones.shuffle();
    });
  }

  void _verificar(String letra) {
    if (letra == actual.letraCorrecta) {
      setState(() => puntaje++);
      _mostrarDialogo("¡Bien hecho!", true);
    } else {
      _mostrarDialogo("¡Ups! Era '${actual.letraCorrecta.toUpperCase()}'", false);
    }
  }

  void _mostrarDialogo(String mensaje, bool correcto) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(mensaje),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Palabra completa: ${actual.palabra.toUpperCase()}"),
            SizedBox(height: 10),
            Image.asset(actual.imagen, height: 100),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                pregunta++;
              });
              _nuevaPalabra();
            },
            child: Text("Siguiente"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.fondo,
      appBar: AppBar(
        backgroundColor: AppColors.primario,
        title: Text("Juego de Lenguaje", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        centerTitle: true,
        elevation: 2,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text("📚 Pregunta $pregunta", style: TextStyle(fontSize: 20)),
              Text("⭐ Puntaje: $puntaje", style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              Image.asset(actual.imagen, height: 180),
              SizedBox(height: 30),
              Text(
                actual.palabraIncompleta.toUpperCase(),
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children: opciones.map((opcion) {
                  return ElevatedButton(
                    onPressed: () => _verificar(opcion),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primario,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                      shape: StadiumBorder(),
                      elevation: 4,
                    ),
                    child: Text(
                      opcion.toUpperCase(),
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Palabra {
  final String palabra;
  final String imagen;
  final String palabraIncompleta;
  final String letraCorrecta;

  _Palabra(this.palabra, this.imagen, this.palabraIncompleta, this.letraCorrecta);
}
