import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/colores.dart';

class JuegoMemoria extends StatefulWidget {
  @override
  _JuegoMemoriaState createState() => _JuegoMemoriaState();
}

class _JuegoMemoriaState extends State<JuegoMemoria> {
  List<String> todasLasImagenes = [
    'assets/img/fresa.png',
    'assets/img/loro.png',
    'assets/img/manzana.png',
    'assets/img/pato.png',
    'assets/img/perro.png',
    'assets/img/platano.png',
    'assets/img/uva.png',
    'assets/img/vaca.png',
  ];

  List<_Tarjeta> tarjetas = [];
  _Tarjeta? primeraSeleccionada;
  bool bloquear = false;
  int paresEncontrados = 0;
  int intentos = 0;
  int nivel = 1;
  int totalPares = 4;
  Stopwatch cronometro = Stopwatch();
  Timer? timer;
  int segundos = 0;
  bool juegoIniciado = false;

  @override
  void initState() {
    super.initState();
    _generarTarjetas();
  }

  void _generarTarjetas() {
    cronometro.reset();
    timer?.cancel();
    juegoIniciado = false;
    intentos = 0;
    paresEncontrados = 0;
    primeraSeleccionada = null;
    tarjetas = [];

    List<String> seleccionadas = todasLasImagenes.take(totalPares).toList();
    List<String> pares = [...seleccionadas, ...seleccionadas];
    pares.shuffle(Random());

    for (int i = 0; i < pares.length; i++) {
      tarjetas.add(_Tarjeta(id: i, imagen: pares[i]));
    }

    setState(() {});
  }

  void _iniciarCronometro() {
    if (!juegoIniciado) {
      juegoIniciado = true;
      cronometro.start();
      timer = Timer.periodic(Duration(seconds: 1), (_) {
        setState(() {
          segundos++;
        });
      });
    }
  }

  void _voltearTarjeta(_Tarjeta tarjeta) {
    if (bloquear || tarjeta.mostrando || tarjeta.encontrada) return;

    _iniciarCronometro();

    setState(() {
      tarjeta.mostrando = true;
    });

    if (primeraSeleccionada == null) {
      primeraSeleccionada = tarjeta;
    } else {
      bloquear = true;
      intentos++;

      if (primeraSeleccionada!.imagen == tarjeta.imagen) {
        setState(() {
          tarjeta.encontrada = true;
          primeraSeleccionada!.encontrada = true;
          paresEncontrados++;
          primeraSeleccionada = null;
          bloquear = false;
        });

        if (paresEncontrados == totalPares) {
          cronometro.stop();
          timer?.cancel();
          Future.delayed(Duration(milliseconds: 600), () {
            _mostrarFelicidades();
          });
        }
      } else {
        Timer(Duration(seconds: 1), () {
          setState(() {
            tarjeta.mostrando = false;
            primeraSeleccionada!.mostrando = false;
            primeraSeleccionada = null;
            bloquear = false;
          });
        });
      }
    }
  }

  void _mostrarFelicidades() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(
          children: [
            Icon(Icons.emoji_events, color: Colors.amber, size: 40),
            SizedBox(height: 10),
            Text("¡Muy bien!", textAlign: TextAlign.center),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Completaste el nivel 👏"),
            Text("Intentos: $intentos"),
            Text("Tiempo: ${segundos}s"),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  segundos = 0;
                });
                _generarTarjetas();
              },
              icon: Icon(Icons.refresh),
              label: Text("Jugar de nuevo"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primario,
                shape: StadiumBorder(),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _cambiarNivel() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Selecciona nivel"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _botonNivel("Fácil (4 pares)", 1, 4),
            _botonNivel("Medio (6 pares)", 2, 6),
            _botonNivel("Difícil (8 pares)", 3, 8),
          ],
        ),
      ),
    );
  }

  Widget _botonNivel(String texto, int nivelNuevo, int pares) {
    return ListTile(
      title: Text(texto),
      leading: Icon(Icons.star),
      onTap: () {
        setState(() {
          nivel = nivelNuevo;
          totalPares = pares;
          segundos = 0;
        });
        Navigator.pop(context);
        _generarTarjetas();
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondo,
      appBar: AppBar(
        backgroundColor: AppColors.primario,
        title: Row(
          children: [
            Icon(Icons.memory),
            SizedBox(width: 10),
            Text("Memoria Visual", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          ],
        ),
        actions: [
          IconButton(onPressed: _cambiarNivel, icon: Icon(Icons.settings)),
          IconButton(
            onPressed: () {
              setState(() {
                segundos = 0;
              });
              _generarTarjetas();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 12),
          Text("🧠 Nivel: ${nivel == 1 ? "Fácil" : nivel == 2 ? "Medio" : "Difícil"}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text("⏱ Tiempo: ${segundos}s   |   🔁 Intentos: $intentos",
              style: TextStyle(fontSize: 16)),
          SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: tarjetas.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.7, // MÁS ALTO QUE ANCHO
                ),
                itemBuilder: (context, index) {
                  final tarjeta = tarjetas[index];
                  return GestureDetector(
                    onTap: () => _voltearTarjeta(tarjeta),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            )
                          ],
                        ),
                        child: Image.asset(
                          tarjeta.mostrando || tarjeta.encontrada
                              ? tarjeta.imagen
                              : 'assets/img/dorso.avif',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tarjeta {
  final int id;
  final String imagen;
  bool mostrando = false;
  bool encontrada = false;

  _Tarjeta({required this.id, required this.imagen});
}
