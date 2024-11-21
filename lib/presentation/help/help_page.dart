// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wifi_smart_living/dimens.dart';
import 'package:wifi_smart_living/presentation/general_widgets/back_button_widget/back_button_widget.dart';
import 'package:wifi_smart_living/presentation/general_widgets/list_items/single_list_item_without_start_image.dart';
import 'package:wifi_smart_living/presentation/general_widgets/textWidgets/clickebal_text_widget.dart';
import 'package:wifi_smart_living/theme.dart';

import '../../connectivity/network_connection_helper.dart';
import '../../const/const_web_url.dart';
import '../../http_helper/uri_helper/uri_parser.dart';
import '../alert_dialogs/alert_dialog_information.dart';
import '../web_viewer/web_view_page.dart';

class HelpPage extends StatelessWidget {
  //Todo translation
  static const routName = "/hilfe_page";
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppLocalizations local = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButtonWidget(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(local.help),
            Text(
              local.overview,
              style: AppTheme.textStyleDefault,
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Dimens.paddingDefault),
        child: Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: Dimens.sizedBoxDefault,
              ),
              SingelListItemWidget(
                  title: local.faq,
                  itemClickedCallback: () async {
                    if (await NetworkStateHelper
                        .networkConnectionEstablished()) {
                      if (await NetworkStateHelper
                          .networkConnectionEstablished()) {
                        canLaunchUrl(UriParser.createBasicUri(
                                url: ConstWebUrls.webUrlFaq))
                            .then((value) async {
                          if (value) {
                            await launchUrl(UriParser.createBasicUri(
                                url: ConstWebUrls.webUrlFaq));
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => WebViewPage(
                                    title: local.faq,
                                    webUrl: ConstWebUrls.webUrlFaq))));
                          }
                        });
                      } else {
                        InformationAlert().showAlertDialog(
                            context: context,
                            message: local.noInternetConnectionAvaialable,
                            callback: () {});
                      }
                    } else {
                      InformationAlert().showAlertDialog(
                          context: context,
                          message: local.noInternetConnectionAvaialable,
                          callback: () {});
                    }
                  }),
              const Divider(
                color: AppTheme.textDarkGrey,
              ),
              SingelListItemWidget(
                  title: local.operationGuide,
                  itemClickedCallback: () async {
                    if (await NetworkStateHelper
                        .networkConnectionEstablished()) {
                      canLaunchUrl(UriParser.createBasicUri(
                              url: ConstWebUrls.webUrlBda))
                          .then((value) async {
                        if (value) {
                          await launchUrl(UriParser.createBasicUri(
                              url: ConstWebUrls.webUrlBda));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: ((context) => const WebViewPage(
                                  title: 'Downloads',
                                  webUrl: ConstWebUrls.webUrlBda))));
                        }
                      });
                    } else {
                      InformationAlert().showAlertDialog(
                          context: context,
                          message: local.noInternetConnectionAvaialable,
                          callback: () {});
                    }
                  }),
              const Divider(
                color: AppTheme.textDarkGrey,
              ),
              const SizedBox(
                height: Dimens.sizedBoxBigDefault,
              ),
              Text(
                local.supportContact,
                style: AppTheme.textStyleDefault,
              ),
              const SizedBox(
                height: Dimens.sizedBoxDefault,
              ),
              const Text(
                'Eurotronic Technology GmbH: ',
                style: AppTheme.textStyleDefault,
              ),
              const Text(
                'Südweg 1',
                style: AppTheme.textStyleDefault,
              ),
              const Text(
                '36396 Ulmbach',
                style: AppTheme.textStyleDefault,
              ),
              const SizedBox(
                height: Dimens.sizedBoxDefault,
              ),
              Row(
                children: [
                  const Text(
                    'Mail:',
                    style: AppTheme.textStyleDefault,
                  ),
                  const SizedBox(
                    width: Dimens.sizedBoxDefault,
                  ),
                  ClickedText(
                      text: 'support@eurotronic.org',
                      textColor: AppTheme.textDarkGrey,
                      onClick: () async {
                        {
                          await Clipboard.setData(const ClipboardData(
                                  text: 'support@eurotronic.org'))
                              .then(
                            (value) {
                              if (Platform.isIOS) {
                                return ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text('Copied to clipboard.',
                                        textAlign: TextAlign.center),
                                    behavior: SnackBarBehavior.floating,
                                    elevation: 0,
                                    width: 200,
                                    shape: StadiumBorder(),
                                  ),
                                );
                              }
                            },
                          );
                        }
                      }),
                ],
              ),
              const SizedBox(
                height: Dimens.sizedBoxDefault,
              ),
              Row(
                children: [
                  const Text(
                    'Web:',
                    style: AppTheme.textStyleDefault,
                  ),
                  const SizedBox(
                    width: Dimens.sizedBoxDefault,
                  ),
                  ClickedText(
                      text: 'www.eurotronic.org',
                      textColor: AppTheme.textDarkGrey,
                      onClick: () async {
                        if (await NetworkStateHelper
                            .networkConnectionEstablished()) {
                          canLaunchUrl(UriParser.createBasicUri(
                                  url: ConstWebUrls.webUrlEurotronicHomepage))
                              .then((value) async {
                            if (value) {
                              await launchUrl(UriParser.createBasicUri(
                                  url: ConstWebUrls.webUrlEurotronicHomepage));
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) => const WebViewPage(
                                      title: 'Homepage',
                                      webUrl: ConstWebUrls
                                          .webUrlEurotronicHomepage))));
                            }
                          });
                        } else {
                          InformationAlert().showAlertDialog(
                              context: context,
                              message: local.noInternetConnectionAvaialable,
                              callback: () {});
                        }
                      }),
                ],
              ),
              const SizedBox(
                height: Dimens.sizedBoxBigDefault,
              ),
              Image.asset(
                'assets/images/et_logo.png',
                height: 30,
              ),
              const SizedBox(
                height: Dimens.sizedBoxBigDefault,
              ),
              const Divider(
                color: AppTheme.textDarkGrey,
              ),
              SingelListItemWidget(
                  title: 'Adapter-Shop',
                  itemClickedCallback: () async {
                    if (await NetworkStateHelper
                        .networkConnectionEstablished()) {
                      canLaunchUrl(UriParser.createBasicUri(
                              url: ConstWebUrls.webUrlAdapterShop))
                          .then((value) async {
                        if (value) {
                          await launchUrl(UriParser.createBasicUri(
                              url: ConstWebUrls.webUrlAdapterShop));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: ((context) => const WebViewPage(
                                  title: 'Adapter-Shop',
                                  webUrl: ConstWebUrls.webUrlAdapterShop))));
                        }
                      });
                    } else {
                      InformationAlert().showAlertDialog(
                          context: context,
                          message: local.noInternetConnectionAvaialable,
                          callback: () {});
                    }
                  }),
              const Divider(
                color: AppTheme.textDarkGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
