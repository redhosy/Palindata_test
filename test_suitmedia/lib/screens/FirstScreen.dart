import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_suitmedia/providers/FirstScreen_provider.dart';
import 'package:test_suitmedia/widgets/CustomPlaceholder.dart';
import 'package:test_suitmedia/widgets/CustomButton.dart';
import 'package:test_suitmedia/widgets/CustomPopUp.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kalimatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<FirstScreenProvider>(context, listen: false);
    _namaController.text = provider.nama;
    _kalimatController.text = provider.kalimat;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _kalimatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firstScreenProvider = context.read<FirstScreenProvider>();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.cover,
                ),
            ),
          ),
          // isi konten utama
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: CustomPlacholder(
                      width: 120,
                      height: 120,
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                      borderwidth: 2,
                      child: const Icon(
                        Icons.person_add_alt_1,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),

                  // mengirim input nama ke provider
                  TextField(
                    controller: _namaController,
                    decoration: const InputDecoration(hintText: 'Masukan Nama'),
                    onChanged: firstScreenProvider.setNama,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // mengirim input kalimat ke provider
                  TextField(
                    controller: _kalimatController,
                    decoration:
                        const InputDecoration(hintText: 'Cek Palindrome'),
                    onChanged: firstScreenProvider.setKalimat,
                  ),
                  const SizedBox(
                    height: 50,
                  ),

                  CustomButton(
                    text: 'CHECK',
                    onPressed: () {
                      final message = firstScreenProvider.getPalindromeCheckMessage();
                      final isPalindromeResult = firstScreenProvider.isPalindrome(firstScreenProvider.kalimat); 
                      final namaInput = firstScreenProvider.nama;
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return CustomResultDialog(
                           nama: namaInput,
                           message: message,
                           isPalindromeResult: isPalindromeResult,
                          );
                        },
                      );
                    },
                    backgroundColor: const Color(0xFF2B637B),
                    foregroundColor: Colors.white,
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  CustomButton(
                    text: 'NEXT',
                    onPressed: () {
                      context.read<FirstScreenProvider>().setNama(_namaController.text);
                      Navigator.pushNamed(context, '/second');
                    },
                    backgroundColor: const Color(0xFF2B637B),
                    foregroundColor: Colors.white,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
