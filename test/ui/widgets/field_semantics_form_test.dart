import 'package:fiado_facil/ui/widgets/app_text_field.dart';
import 'package:fiado_facil/ui/widgets/money_field.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

const List<String> _labels = <String>['Nome', 'Telefone', 'Limite'];

Widget _customerForm({ValueChanged<int?>? onLimitChanged}) {
  return wrapInApp(
    SingleChildScrollView(
      child: Column(
        children: [
          const AppTextField(label: 'Nome', hintText: 'Ex.: Maria'),
          const AppTextField(label: 'Telefone', hintText: '(81) 99999-9999'),
          MoneyField(
            label: 'Limite',
            labelSuffix: '(opcional)',
            onChanged: onLimitChanged ?? (_) {},
          ),
        ],
      ),
    ),
  );
}

SemanticsData _inputNode(WidgetTester tester, int index) {
  return tester
      .getSemantics(find.byType(EditableText).at(index))
      .getSemanticsData();
}

List<SemanticsData> _announcedNodesLabelled(String text) {
  return find.semantics
      .byPredicate((node) => !node.isMergedIntoParent)
      .evaluate()
      .map((node) => node.getSemanticsData())
      .where((data) => data.label.contains(text))
      .toList();
}

void main() {
  group('a form with several fields', () {
    testWidgets('names each input by its own label only', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_customerForm());

      for (var i = 0; i < _labels.length; i++) {
        final node = _inputNode(tester, i);
        expect(node.flagsCollection.isTextField, isTrue);
        expect(node.label, contains(_labels[i]));
        for (final other in _labels.where((l) => l != _labels[i])) {
          expect(node.label, isNot(contains(other)));
        }
      }
      handle.dispose();
    });

    testWidgets('announces every label once, on its input', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_customerForm());

      for (final label in [..._labels, '(opcional)']) {
        final labelled = _announcedNodesLabelled(label);
        expect(labelled, hasLength(1), reason: label);
        expect(labelled.single.flagsCollection.isTextField, isTrue);
      }
      handle.dispose();
    });

    testWidgets('names the money input with its label suffix and currency', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_customerForm());

      final limit = _inputNode(tester, 2);
      expect(limit.label, contains('Limite'));
      expect(limit.label, contains('(opcional)'));
      expect(limit.label, contains(r'R$'));
      handle.dispose();
    });

    testWidgets('activating a named input focuses that input', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_customerForm());

      tester.semantics.tap(
        find.semantics.byPredicate(
          (node) =>
              !node.isMergedIntoParent &&
              node.getSemanticsData().label.contains('Telefone'),
        ),
      );
      await tester.pump();

      final focused = [
        for (final state in tester.stateList<EditableTextState>(
          find.byType(EditableText),
        ))
          state.widget.focusNode.hasFocus,
      ];
      expect(focused, [false, true, false]);
      handle.dispose();
    });

    testWidgets('typed text becomes the value and the name stays the label', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      final reported = <int?>[];
      await tester.pumpWidget(_customerForm(onLimitChanged: reported.add));

      await tester.enterText(find.byType(EditableText).at(0), 'Maria');
      await tester.enterText(find.byType(EditableText).at(2), '4790');
      await tester.pumpAndSettle();

      final name = _inputNode(tester, 0);
      expect(name.value, 'Maria');
      expect(name.label, contains('Nome'));
      expect(name.label, isNot(contains('Ex.: Maria')));

      final limit = _inputNode(tester, 2);
      expect(limit.value, '47,90');
      expect(limit.label, contains('Limite'));
      expect(reported.last, 4790);
      handle.dispose();
    });
  });
}
