import 'package:flutter/material.dart';
import '../utils/colores.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController nameCtrl = TextEditingController();
  String errorText = '';

  @override
  void initState() {
    super.initState();
  }

  void _entrar() {
    if (nameCtrl.text.trim().isEmpty) {
      setState(() {
        errorText = "Por favor ingresa tu nombre";
      });
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(nombre: nameCtrl.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondo,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "¿Cómo te llamas?",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  hintText: "Escribe tu nombre",
                  border: OutlineInputBorder(),
                  errorText: errorText.isEmpty ? null : errorText,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _entrar,
                icon: Icon(Icons.play_arrow),
                label: Text("Entrar"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primario,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
