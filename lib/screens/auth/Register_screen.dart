import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lotapp/screens/auth/Login_screen.dart';
import 'package:lotapp/services/auth_service.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<Register> {
  int currentStep = 0;
  String? selectedGradeLevel;
  String? selectedSection;
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtUserName = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final TextEditingController txtPasswordConfirmation = TextEditingController();
  final TextEditingController txtLRN = TextEditingController();
  final TextEditingController txtCpNum = TextEditingController();

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: Duration(seconds: 3)),
    );
  }

  bool checkInputs() {
    String name = txtName.text.trim();
    String username = txtUserName.text.trim();
    String email = txtEmail.text.trim();
    String password = txtPassword.text.trim();
    String passwordConfirmation = txtPasswordConfirmation.text.trim();
    String lrn = txtLRN.text.trim();
    String glevel = selectedGradeLevel ?? "";
    String section = selectedSection ?? "";
    String cpnumber = txtCpNum.text.trim();

    if (currentStep == 0) {
      if (name.isEmpty) {
        showError('Please input your name...');
        return false;
      }

      if (lrn.isEmpty) {
        showError('Input your LRN...');
        return false;
      }
      if (lrn.length < 12) {
        showError('Invalid LRN...');
        return false;
      }

      if (glevel.isEmpty) {
        showError('What is your grade level...');
        return false;
      }

      if (section.isEmpty) {
        showError('Section is unspecified...');
        return false;
      }

      if (cpnumber.isEmpty) {
        showError('Indicate your cellphone number...');
        return false;
      }
      if (cpnumber.length < 11) {
        showError('Invalid cellphone number...');
        return false;
      }

      return true;
    } else if (currentStep == 1) {
      if (username.isEmpty) {
        showError('Indicate your username...');
        return false;
      }
      if (email.isEmpty) {
        showError('Indicate your email...');
        return false;
      }
      if (password.isEmpty) {
        showError('Password field is empty...');
        return false;
      }
      if (password.length < 8) {
        showError('Password is too short...');
        return false;
      }
      if (passwordConfirmation != password) {
        showError('Password doesn\'t match...');
        return false;
      }

      return true;
    }

    return true;
  }

  void register() {
    String name = txtName.text;
    String username = txtUserName.text;
    String email = txtEmail.text;
    String password = txtPassword.text;
    String passwordConfirmation = txtPasswordConfirmation.text;
    String lrn = txtLRN.text;
    String glevel = selectedGradeLevel ?? "";
    String section = selectedSection ?? "";
    String cpnumber = txtCpNum.text;

    AuthService.register(
      name,
      username,
      email,
      password,
      passwordConfirmation,
      lrn,
      glevel,
      section,
      cpnumber,
    ).then((success) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Please log in.'),
            duration: Duration(seconds: 3),
          ),
        );

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration failed. Try again later.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    });
  }

  void goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      body: Stepper(
        type: StepperType.horizontal,
        steps: getSteps(),
        currentStep: currentStep,
        onStepContinue: () {},
        onStepTapped: (step) => setState(() => currentStep = step),
        controlsBuilder: (context, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentStep == 0 ? goToLogin() : currentStep -= 1;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 85, 85, 85),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    currentStep == 0 ? '<- Back to Login' : '<- Back',
                  ),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (checkInputs()) {
                      setState(() {
                        currentStep == 2 ? register() : currentStep += 1;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 8, 77, 117),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(currentStep == 2 ? 'Register' : 'Next ->'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Step> getSteps() => [
    Step(
      state: currentStep > 0 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 0,
      title: Text(currentStep == 0 ? 'Information' : ''),
      content: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: txtName,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: txtLRN,
              decoration: const InputDecoration(labelText: 'LRN'),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(12),
              ],
            ),
            const SizedBox(height: 30),

            DropdownButtonFormField<String>(
              value: selectedGradeLevel,
              decoration: const InputDecoration(labelText: 'Grade level'),
              items: ['7', '8', '9', '10', '11', '12']
                  .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text('Grade $value'),
                    );
                  })
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedGradeLevel = newValue;
                });
              },
            ),
            const SizedBox(height: 30),

            DropdownButtonFormField<String>(
              value: selectedSection,
              decoration: const InputDecoration(labelText: 'Section'),
              items: ['A', 'B'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedSection = newValue;
                });
              },
            ),
            const SizedBox(height: 30),

            TextField(
              controller: txtCpNum,
              decoration: const InputDecoration(labelText: 'Cellphone Number'),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    ),
    Step(
      state: currentStep > 1 ? StepState.complete : StepState.indexed,

      isActive: currentStep >= 1,
      title: Text(currentStep == 1 ? 'Credentials' : ''),
      content: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: txtUserName,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: txtEmail,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: txtPassword,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: txtPasswordConfirmation,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    ),
    Step(
      isActive: currentStep >= 2,
      title: Text(currentStep == 2 ? 'Confirmation' : ''),
      content: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Name: ${txtName.text}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                'Username: ${txtUserName.text}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                'Email: ${txtEmail.text}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                'LRN: ${txtLRN.text}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                'Grade level: $selectedGradeLevel',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                'Section: $selectedSection',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                'Mobile number: ${txtCpNum.text}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    ),
  ];
}
