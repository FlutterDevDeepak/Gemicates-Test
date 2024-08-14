import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gemicates_test/controller/auth_controller.dart';
import 'package:gemicates_test/views/product_page.dart';
import 'package:gemicates_test/views/signup_page.dart';
import 'package:gemicates_test/widgets/my_app_buttons.dart';
import 'package:gemicates_test/widgets/my_custom_snack_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginPage extends HookConsumerWidget {
  LoginPage({super.key});
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authVm = ref.watch(authController);
    final isPasswordvisible = useState<bool>(false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                const Text(
                  "Login",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 50,
                ),
                TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: emailValidator),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                        onTap: () {
                          isPasswordvisible.value = !isPasswordvisible.value;
                        },
                        child: Icon(isPasswordvisible.value ? Icons.visibility : Icons.visibility_off)),
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  obscureText: isPasswordvisible.value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                authVm.isLoading
                    ? const MyLoadingButton()
                    : MyButton(
                        title: "Login",
                        function: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              bool res = await authVm.signIn(_emailController.text, _passwordController.text, context);
                              if (res) {
                                if (context.mounted) {
                                  MycustomSnackbar.showSnackBar(context, "Login success");
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ProductsPage()),
                                  );
                                }
                              }
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                          }
                        }),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage()),
                    );
                  },
                  child: const Text('Create an account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
