import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gemicates_test/controller/auth_controller.dart';
import 'package:gemicates_test/firebase_options.dart';
import 'package:gemicates_test/views/login_page.dart';
import 'package:gemicates_test/views/product_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Gemicates Test',
        theme: ThemeData(primarySwatch: Colors.blue),
        home:  const AuthWrapper(),
      ),
    );
  }
}
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final authvm= ref.watch(authController);
    
    return authvm.currentUser == null ? LoginPage() : const ProductsPage();
  }
}
