import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/colores.dart';

class JuegoMotricidad extends StatefulWidget {
  @override
  _JuegoMotricidadState createState() => _JuegoMotricidadState();
}

class _JuegoMotricidadState extends State<JuegoMotricidad> with SingleTickerProviderStateMixin {
  double circleX = 100;
  double circleY = 100;
  double circleSize = 80;
  int puntaje = 0;
  int tiempoRestante = 30;
  bool enJuego = false;

  Timer? timer;
  Timer? moverTimer;
  final Random random = Random();
  final GlobalKey _circleKey = GlobalKey();

  late AnimationController _circleAnimController;
  late Animation<double> _circleScale;

  @override
  void initState() {
    super.initState();

    _circleAnimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      lowerBound: 0.7,
      upperBound: 1.0,
    )..repeat(reverse: true);
  }

  void _iniciarJuego() {
    setState(() {
      puntaje = 0;
      tiempoRestante = 30;
      enJuego = true;
    });

    _moverCirculo();

    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        tiempoRestante--;
        if (tiempoRestante <= 0) {
          _terminarJuego();
        }
      });
    });
  }

  void _terminarJuego() {
    timer?.cancel();
    moverTimer?.cancel();
    setState(() => enJuego = false);
    _mostrarResultado();
  }

  void _moverCirculo() {
    moverTimer = Timer.periodic(Duration(seconds: 1), (_) {
      final screen = MediaQuery.of(context).size;
      setState(() {
        circleX = random.nextDouble() * (screen.width - circleSize);
        circleY = 120 + random.nextDouble() * (screen.height - circleSize - 220);
      });
    });
  }

  void _tocarPantalla(TapDownDetails details) {
    if (!enJuego) return;

    RenderBox box = _circleKey.currentContext?.findRenderObject() as RenderBox;
    Offset circlePos = box.localToGlobal(Offset.zero);
    double dx = details.globalPosition.dx;
    double dy = details.globalPosition.dy;

    double centerX = circlePos.dx + circleSize / 2;
    double centerY = circlePos.dy + circleSize / 2;
    double distancia = sqrt(pow(dx - centerX, 2) + pow(dy - centerY, 2));

    if (distancia <= circleSize / 2) {
      setState(() => puntaje++);
    }
  }

  void _mostrarResultado() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("¡Buen trabajo!", textAlign: TextAlign.center),
        content: Text("Puntaje final: $puntaje", style: TextStyle(fontSize: 18)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Aceptar"),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    moverTimer?.cancel();
    _circleAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondo,
      appBar: AppBar(
        backgroundColor: AppColors.primario,
        title: Text("Juego de Motrocidad", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTapDown: _tocarPantalla,
        child: Stack(
          children: [
            Positioned(
              top: 40,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("⏱ Tiempo: $tiempoRestante s", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  SizedBox(height: 8),
                  Text("🎯 Puntaje: $puntaje", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            if (enJuego)
              Positioned(
                left: circleX,
                top: circleY,
                child: ScaleTransition(
                  scale: _circleAnimController,
                  child: Container(
                    key: _circleKey,
                    width: circleSize,
                    height: circleSize,
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 2)),
                      ],
                    ),
                  ),
                ),
              ),
            if (!enJuego)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.touch_app, size: 100, color: AppColors.acento),
                    SizedBox(height: 20),
                    Text(
                      "¡Toca el círculo lo más rápido que puedas!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
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
          ],
        ),
      ),
    );
  }
}
