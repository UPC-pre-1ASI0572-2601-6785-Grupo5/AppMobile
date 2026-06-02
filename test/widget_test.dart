import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Asegúrate de que esta ruta coincida con el nombre de tu proyecto
import 'package:fueltrack_mobile/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Aquí está la corrección: llamamos a FuelTrackApp en lugar del antiguo MyApp
    await tester.pumpWidget(const FuelTrackApp());

    // Verifica que nuestro contador empiece en 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Toca el icono de '+' y dispara un frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verifica que el contador haya incrementado.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}