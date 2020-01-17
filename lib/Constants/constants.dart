
import 'package:flutter/material.dart';

final String TEST = "test";
final String MAIN_UI = "main_ui";
final String LOGIN_UI = "login_ui";
final String REGIST_UI = "regist_ui";
final String SALDO_UI = "saldo_ui";
final String HISTORY_UI = "history_ui";
final String PROFILE_UI = "profile_ui";
final String JARINGAN_UI = "jaringan_ui";
final String DETAIL_PROMOSI_UI = "detail_promosi_ui";
final String DETAIL_BERITA_UI = "detail_berita_ui";
final String KATEGORI_BERITA_UI = "kategori_berita_ui";
final String INSPIRASI = "inspirasi";
final String PRODUK_MLM_UI = "produk_mlm_ui";
final String PRODUK_ECOMMERCE_UI = "produk_ecommerce_ui";
final String DETAIL_PRODUK_MLM_UI = "detail_produk_mlm_ui";
final String DETAIL_PRODUK_ECOMMERCE_UI = "detail_produk_ecommerce_ui";
final String BAYAR_PRODUK_MLM_UI = "bayar_produk_mlm_ui";
final String SPLASH_SCREEN = "splash_screen";
final String BOTTOM_TABS_CONTROL = "bottom_tabs_control";
final String ASMA_UI = "asma_ui";
final String CHAT_UI = "chat_ui";
final String CHAT_ROOM_UI = "chat_room_ui";
final String SOSMED_UI = "sosmed_ui";
final String PULSA_UI = "pulsa_ui";
final String DETAIL_PULSA_UI = "detail_pulsa_ui";
final String DETAIL_KUOTA_PULSA_UI = "detail_kuota_pulsa_ui";
final String STATUS_DETAIL_PULSA_UI = "status_detail_pulsa_ui";
final String STATUS_DETAIL_KUOTA_PULSA_UI = "status_detail_kuota_pulsa_ui";
final String EMONEY_UI = "emoney_ui";
final String LISTRIK_UI = "listrik_ui";
final String DETAIL_STATUS_UNSUCCESS_UI = "detail_status_unsuccess_ui";
final String DETAIL_STATUS_PENDING_UI = "detail_status_pending_ui";
final String PULSA_SMS_TELP_UI = "pulsa_sms_telp_ui";
final String BPJS_UI = "bpjs_ui";
final String PDAM_UI = "pdam_ui";
final String TV_BERBAYAR_UI = "tv_berbayar_ui";
final String MULTIFINANCE_UI = "multifinance_ui";
final String ZAKAT_UI = "zakat_ui";
final String TELP_KABEL_UI = "tv_kabel_ui";
final String QURAN_LIST_UI = "quran_list_ui";
final String QURAN_READ_UI = "quran_read_ui";
final String VIDEO_LIST_UI = "video_list_ui";
final String TRANSFER_UI = "transfer_ui";
final String TRANSFER_KE_UI = "transfer_ke_ui";
final String PRAYER_LIST = "prayerList";
// final String CHECKOUT_MLM_UI = "checkout_mlm_ui";
final TextStyle styleFont = TextStyle(fontFamily: 'Rubik');

const BUBBLE_WIDTH = 55.0;

const FULL_TARNSITION_PX = 300.0;

const PERCENT_PER_MILLISECOND = 0.00125;

enum SlideDirection {
  leftToRight,
  rightToLeft,
  none,
}

enum UpdateType {
  dragging,
  doneDragging,
  animating,
  doneAnimating,
}

enum TransitionGoal {
  open,
  close,
}

removeAllHtmlTags(String htmlText) {
  RegExp exp = RegExp(
      r"^WS{1,2}:\/\/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:56789",
      multiLine: true,
      caseSensitive: true
  );

  return htmlText.replaceAll(exp, '');
}

class GojekPalette{
  static Color green        = Color.fromARGB(255, 69, 170, 74);
  static Color grey         = Color.fromARGB(255, 242, 242, 242);
  static Color grey200      = Color.fromARGB(200, 242, 242, 242);
  static Color menuRide     = Color(0xffe99e1e);
  static Color menuCar      = Color(0xff14639e);
  static Color menuBluebird = Color(0xff2da5d9);
  static Color menuFood     = Color(0xffec1d27);
  static Color menuSend     = Color(0xff8dc53e);
  static Color menuDeals    = Color(0xfff43f24);
  static Color menuPulsa    = Color(0xff72d2a2);
  static Color menuOther    = Color(0xffa6a6a6);
  static Color menuShop     = Color(0xff0b945e);
  static Color menuMart     = Color(0xff68a9e3);
  static Color menuTix      = Color(0xffe86f16);
}


class IconColors {
  static const Color send = Color(0xffecfaf8);
  static const Color transfer = Color(0xfffdeef5);
  static const Color passbook = Color(0xfffff4eb);
  static const Color more = Color(0xffeff1fe);
}

class IconImgs {
  static const String diterima = "assets/images/diterima.jpg";
  static const String pending = "assets/images/pending.png";
  static const String ditolak = "assets/images/ditolak.png";
  static const String more    = "assets/imgs/more.png";
  static const String freeze  = "assets/imgs/freeze.png";
  static const String unlock  = "assets/imgs/unlock.png";
  static const String secret  = "assets/imgs/secret.png";
  static const String noImage ='http://thaibah.com:3000/assets/profile.png';

}

