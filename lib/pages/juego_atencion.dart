import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/colores.dart';

class JuegoAtencion extends StatefulWidget {
  @override
  _JuegoAtencionState createState() => _JuegoAtencionState();
}

class _JuegoAtencionState extends State<JuegoAtencion> with SingleTickerProviderStateMixin {
  final List<Color> colores = [Colors.red, Colors.green, Colors.blue, Colors.yellow];
  final List<String> nombres = ["ROJO", "VERDE", "AZUL", "AMARILLO"];

  int puntaje = 0;
  int tiempoRestante = 30;
  String colorObjetivo = "";
  Color colorTexto = Colors.black;
  bool juegoIniciado = false;

  Timer? temporizador;
  Random random = Random();
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      lowerBound: 0.7,
      upperBound: 1.0,
    )..repeat(reverse: true);

    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );

    _generarNuevoColor();
  }

  void _iniciarTemporizador() {
    temporizador = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (tiempoRestante > 0) {
          tiempoRestante--;
        } else {
          temporizador?.cancel();
          juegoIniciado = false;
          _mostrarResultado();
        }
      });
    });
  }

  void _iniciarJuego() {
    setState(() {
      puntaje = 0;
      tiempoRestante = 30;
      juegoIniciado = true;
    });
    _generarNuevoColor();
    _iniciarTemporizador();
  }

  void _generarNuevoColor() {
    int index = random.nextInt(colores.length);
    setState(() {
      colorObjetivo = nombres[index];
      colorTexto = colores[index];
    });
  }

  void _verificar(Color seleccionado) {
    if (!juegoIniciado) return;

    int indexEsperado = nombres.indexOf(colorObjetivo);
    if (colores[indexEsperado] == seleccionado) {
      setState(() => puntaje++);
    } else {
      setState(() => puntaje = (puntaje > 0) ? puntaje - 1 : 0);
    }
    _generarNuevoColor();
  }

  void _mostrarResultado() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("¡Tiempo terminado!", textAlign: TextAlign.center),
        content: Text("Puntaje: $puntaje", style: TextStyle(fontSize: 20)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _iniciarJuego();
            },
            child: Text("Jugar de nuevo"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Salir"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    temporizador?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondo,
      appBar: AppBar(
        backgroundColor: AppColors.primario,
        title: Text("Juego de Atención", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text("⏱ Tiempo: $tiempoRestante s", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
            SizedBox(height: 5),
            Text("🎯 Puntaje: $puntaje", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
            SizedBox(height: 30),

            if (juegoIniciado)
              Column(
                children: [
                  Text("TOCA EL COLOR CORRECTO", style: TextStyle(fontSize: 18)),
                  SizedBox(height: 10),
                  ScaleTransition(
                    scale: _scaleAnim,
                    child: Text(
                      colorObjetivo,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: colorTexto,
                      ),
                    ),
                  ),
                ],
              )
            else
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.visibility, size: 100, color: AppColors.acento),
                      SizedBox(height: 20),
                      Text("Presiona el botón para comenzar", style: TextStyle(fontSize: 18)),
                      SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: _iniciarJuego,
                        icon: Icon(Icons.play_arrow),
                        label: Text("Iniciar juego"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primario,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: StadiumBorder(),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (juegoIniciado)
              Expanded(
                child: Center(
                  child: Wrap(
                    spacing: 30,
                    runSpacing: 30,
                    children: colores.map((color) {
                      return GestureDetector(
                        onTap: () => _verificar(color),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black26, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
