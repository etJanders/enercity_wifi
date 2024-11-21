import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/http_helper/uri_helper/uri_parser.dart';
import 'package:wifi_smart_living/presentation/general_widgets/back_button_widget/back_button_widget.dart';
import 'package:wifi_smart_living/presentation/general_widgets/list_items/list_item_with_start_image.dart';
import 'package:wifi_smart_living/presentation/web_viewer/web_view_page.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../connectivity/network_connection_helper.dart';
import '../../const/const_web_url.dart';
import '../alert_dialogs/alert_dialog_information.dart';
import 'legal_nodes_item_builder.dart';

class LegalNotesPage extends StatelessWidget {
  static const String routname = "/legal_nodes_page";

  const LegalNotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    LegalNodesItems items = LegalNodesItems(context: context);
    return Scaffold(
      appBar: AppBar(
        leading: const BackButtonWidget(),
        title: Text(local.legalNodes),
      ),
      body: Container(
          margin: const EdgeInsets.only(top: Dimens.paddingDefault),
          padding: const EdgeInsets.all(Dimens.paddingDefault),
          child: ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: ((context, index) => ListItemStartImage(
                  onClick: () {
                    NetworkStateHelper.networkConnectionEstablished()
                        .then((value) {
                      if (value) {
                        _itemSelected(
                            context,
                            items.buildLegalNodesItems()[index].itemIdentifier,
                            items.buildLegalNodesItems()[index].title);
                      } else {
                        InformationAlert().showAlertDialog(
                            context: context,
                            message: local.noInternetConnectionAvaialable,
                            callback: () {});
                      }
                    });
                  },
                  title: items.buildLegalNodesItems()[index].title,
                  assetName: "paragraph.png")),
              separatorBuilder: ((context, index) => const Divider(
                    color: AppTheme.textDarkGrey,
                  )),
              itemCount: items.buildLegalNodesItems().length)),
    );
  }

  void _itemSelected(
      BuildContext context, LegalNodesIdentifier identifier, String title) {
    if (LegalNodesIdentifier.privacyPolicy == identifier) {
      canLaunchUrl(
              UriParser.createBasicUri(url: ConstWebUrls.webUrlPrivacyPolicy))
          .then((value) async {
        if (value) {
          await launchUrl(
              UriParser.createBasicUri(url: ConstWebUrls.webUrlPrivacyPolicy));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: ((context) => WebViewPage(
                  title: title, webUrl: ConstWebUrls.webUrlPrivacyPolicy))));
        }
      });
    } else if (LegalNodesIdentifier.termsAndConditions == identifier) {
      canLaunchUrl(UriParser.createBasicUri(
              url: ConstWebUrls.webUrlTermsAndContitions))
          .then((value) async {
        if (value) {
          await launchUrl(UriParser.createBasicUri(
              url: ConstWebUrls.webUrlTermsAndContitions));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: ((context) => WebViewPage(
                  title: title,
                  webUrl: ConstWebUrls.webUrlTermsAndContitions))));
        }
      });
    }
  }
}
