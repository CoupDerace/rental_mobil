import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rental_mobil/app/routes/routes.dart';


final splashProvider =
AutoDisposeNotifierProvider<
SplashNotifier,
void>(
SplashNotifier.new);

class SplashNotifier
extends AutoDisposeNotifier<void>{

@override
void build(){}

Future<void> initialize(
BuildContext context,
) async{

await Future.delayed(
const Duration(seconds: 2),
);

context.go(AppRoutes.login);

}
}