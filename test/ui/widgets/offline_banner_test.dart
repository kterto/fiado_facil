import 'package:fiado_facil/ui/theme/app_colors.dart';
import 'package:fiado_facil/ui/theme/app_text_styles.dart';
import 'package:fiado_facil/ui/widgets/offline_banner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../helpers/test_app.dart';

const String _offlineCopy =
    'Sem internet. Pode continuar usando: os dados serão enviados depois.';
const String _sendingCopy = 'Enviando dados...';

Widget _banner(OfflineBannerMode mode) {
  return wrapInApp(
    Align(
      alignment: Alignment.topCenter,
      child: OfflineBanner(mode: mode),
    ),
  );
}

void main() {
  final modes = <OfflineBannerMode, (IconData, String)>{
    OfflineBannerMode.offline: (Icons.cloud_off_rounded, _offlineCopy),
    OfflineBannerMode.sending: (Icons.cloud_upload_rounded, _sendingCopy),
  };

  modes.forEach((mode, expected) {
    final (icon, copy) = expected;

    group(mode.name, () {
      testWidgets('renders its icon and verbatim copy', (tester) async {
        await tester.pumpWidget(_banner(mode));

        expect(find.byIcon(icon), findsOneWidget);
        expect(find.text(copy), findsOneWidget);
      });

      testWidgets(
        'uses infoContainer bg, info icon and body textPrimary text',
        (tester) async {
          await tester.pumpWidget(_banner(mode));

          final box = tester.widget<Container>(
            find
                .descendant(
                  of: find.byType(OfflineBanner),
                  matching: find.byType(Container),
                )
                .first,
          );
          expect(box.color, AppColors.infoContainer);
          expect(tester.widget<Icon>(find.byIcon(icon)).color, AppColors.info);
          final style = renderedTextStyle(tester, find.text(copy));
          expect(style.fontSize, AppTextStyles.body.fontSize);
          expect(style.height, AppTextStyles.body.height);
          expect(style.fontWeight, AppTextStyles.body.fontWeight);
          expect(style.color, AppColors.textPrimary);
        },
      );

      testWidgets('is at least 48 high with 8/16 padding and a 12 gap', (
        tester,
      ) async {
        await tester.pumpWidget(_banner(mode));

        final banner = find.byType(OfflineBanner);
        expect(tester.getSize(banner).height, greaterThanOrEqualTo(48));
        final bannerRect = tester.getRect(banner);
        final iconRect = tester.getRect(find.byIcon(icon));
        final textRect = tester.getRect(find.text(copy));
        expect(iconRect.left - bannerRect.left, 16);
        expect(textRect.left - iconRect.right, 12);
        expect(textRect.top - bannerRect.top, greaterThanOrEqualTo(8));
        expect(bannerRect.bottom - textRect.bottom, greaterThanOrEqualTo(8));
        final box = tester.widget<Container>(
          find.descendant(of: banner, matching: find.byType(Container)).first,
        );
        expect(
          box.padding,
          const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        );
      });

      testWidgets('is a live region carrying the text', (tester) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(_banner(mode));

        expect(
          find.byWidgetPredicate(
            (w) => w is Semantics && (w.properties.liveRegion ?? false),
          ),
          findsOneWidget,
        );
        expect(
          tester.getSemantics(find.byType(OfflineBanner)),
          matchesSemantics(label: copy, isLiveRegion: true),
        );
        handle.dispose();
      });

      testWidgets('the icon is decorative (no semantic label)', (tester) async {
        await tester.pumpWidget(_banner(mode));

        expect(tester.widget<Icon>(find.byIcon(icon)).semanticLabel, isNull);
      });
    });
  });
}
