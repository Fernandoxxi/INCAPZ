import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../utils/colores.dart';
import 'welcome_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AudioPlayer _player = AudioPlayer();
  double _progress = 0;
  int _porcentaje = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _iniciarAnimacionCarga();
    _reproducirAudio();
  }

  void _iniciarAnimacionCarga() {
    const duracionTotal = 20; // segundos
    const intervalo = Duration(milliseconds: 200);
    final pasos = (duracionTotal * 1000) ~/ intervalo.inMilliseconds;

    int contador = 0;
    _timer = Timer.periodic(intervalo, (timer) {
      setState(() {
        contador++;
        _progress = contador / pasos;
        _porcentaje = (_progress * 100).toInt();
      });

      if (_progress >= 1.0) {
        timer.cancel();
        _player.stop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => WelcomePage()),
        );
      }
    });
  }

  void _reproducirAudio() async {
    await _player.play(AssetSource('sonido/intro.mp3'));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondo,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/img/mundo.png', height: 180),
              SizedBox(height: 30),
              Text("Cargando...", style: TextStyle(fontSize: 24, color: AppColors.texto)),
              SizedBox(height: 20),
              LinearProgressIndicator(
                value: _progress,
                minHeight: 10,
                backgroundColor: Colors.grey.shade300,
                color: AppColors.primario,
              ),
              SizedBox(height: 10),
              Text("$_porcentaje%", style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
