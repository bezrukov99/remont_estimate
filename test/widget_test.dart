import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:remont_estimate/app.dart';

class _MockStorage implements Storage {
  @override
  dynamic read(String key) => null;

  @override
  Future<void> write(String key, dynamic value) async {}

  @override
  Future<void> delete(String key) async {}

  @override
  Future<void> clear() async {}

  @override
  Future<void> close() async {}
}

void main() {
  testWidgets('dashboard renders budget and rooms section', (tester) async {
    HydratedBloc.storage = _MockStorage();

    await tester.pumpWidget(const RemontEstimateApp());
    await tester.pumpAndSettle();

    expect(find.text('Materials total'), findsOneWidget);
    expect(find.text('Spent'), findsOneWidget);
    expect(find.text('Rooms'), findsOneWidget);
    expect(find.text('No rooms yet'), findsOneWidget);
  });
}
