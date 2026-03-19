import 'package:flutter/material.dart';

void main() {
  runApp(const EmissionCalculatorApp());
}

class EmissionCalculatorApp extends StatelessWidget {
  const EmissionCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Калькулятор викидів',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {

  final coalController = TextEditingController();
  final mazutController = TextEditingController();
  final gasController = TextEditingController();

  String result = "";

  void calculate() {

    double coal = double.tryParse(coalController.text) ?? 0;
    double mazut = double.tryParse(mazutController.text) ?? 0;

    double eta = 0.985;

    double Qcoal = 20.47;
    double Acoal = 25.20;
    double avin = 0.8;
    double G = 1.5;

    double Qmazut = 39.48;
    double Amazut = 0.15;

    double kCoal = (1000000 / Qcoal) * avin * (Acoal / (100 - G)) * (1 - eta);
    double Ecoal = 1e-6 * kCoal * Qcoal * coal * 1000;

    double kMazut = (1000000 / Qmazut) * (Amazut / 100) * (1 - eta);
    double Emazut = 1e-6 * kMazut * Qmazut * mazut * 1000;

    setState(() {
      result = """
Показник емісії (вугілля): ${kCoal.toStringAsFixed(2)} г/ГДж
Валовий викид (вугілля): ${Ecoal.toStringAsFixed(2)} т

Показник емісії (мазут): ${kMazut.toStringAsFixed(2)} г/ГДж
Валовий викид (мазут): ${Emazut.toStringAsFixed(2)} т

Газ:
Показник емісії: 0 г/ГДж
Валовий викид: 0 т
""";
    });
  }

  Widget inputField(String label, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue),
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff0f2027), Color(0xff203a43), Color(0xff2c5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [

                const SizedBox(height: 10),

                const Center(
                  child: Text(
                    "Калькулятор викидів",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const Center(
                  child: Text(
                    "Розрахунок твердих частинок при спалюванні палива",
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 30),

                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [

                        inputField("Вугілля (т)", Icons.local_fire_department, coalController),
                        inputField("Мазут (т)", Icons.oil_barrel, mazutController),
                        inputField("Природний газ (м³)", Icons.cloud, gasController),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: calculate,
                            child: const Text(
                              "Розрахувати",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                if (result.isNotEmpty)
                  Card(
                    color: Colors.blue.shade50,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        result,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
