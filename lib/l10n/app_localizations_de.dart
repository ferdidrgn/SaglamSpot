// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get brand => 'SAĞLAM SPOT';

  @override
  String get home => 'Startseite';

  @override
  String get searchHint => 'Wonach haben Sie für Ihr Zuhause gesucht?...';

  @override
  String get collection => 'KOLLEKTION';

  @override
  String get eleganceAndComfort => 'Eleganz & Komfort';

  @override
  String productsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Produkte gefunden',
      one: '1 Produkt gefunden',
      zero: 'Keine Produkte gefunden',
    );
    return '$_temp0';
  }

  @override
  String resultsFor(String query) {
    return 'Ergebnisse für \"$query\"';
  }

  @override
  String get seoHomeTitle => 'Sağlam Spot | Gebrauchte und neue Möbel';

  @override
  String get seoHomeDesc =>
      'Beste Preise für Gebraucht- und Neumöbel. Mit 20 Jahren Geschäftsgarantie.';

  @override
  String get seoNewTitle => 'Neue Produkte | Sağlam Spot';

  @override
  String get seoNewDesc =>
      'Garantierte und hochwertige Kollektion neuer Möbel.';

  @override
  String get seoSpotTitle => 'Gebrauchte Produkte | Sağlam Spot';

  @override
  String get seoSpotDesc =>
      'Wirtschaftliche und hochwertige Gebrauchtmöbel-Optionen.';

  @override
  String get seoAboutTitle => 'Über uns | Sağlam Spot';

  @override
  String get seoAboutDesc =>
      'Die Adresse des Vertrauens in der Möbelbranche mit unserer 20-jährigen Erfahrung.';

  @override
  String get seoProductDetailSuffix => 'Produkt ansehen | Sağlam Spot';

  @override
  String get category => 'Kategorie';

  @override
  String get categorySofa => 'Sitzgruppen';

  @override
  String get categoryChair => 'Stuhl';

  @override
  String get categoryTable => 'Tisch';

  @override
  String get categoryBed => 'Schlafzimmer';

  @override
  String get categoryWardrobe => 'Kleiderschrank';

  @override
  String get categoryWhite => 'Haushaltsgeräte';

  @override
  String get categoryOther => 'Sonstiges';

  @override
  String get condition => 'Zustand';

  @override
  String get conditionAll => 'Alle';

  @override
  String get conditionNew => 'Neu';

  @override
  String get conditionUsed => 'Gebraucht';

  @override
  String get priceRange => 'Preisbereich';

  @override
  String get price => 'Preis';

  @override
  String get save => 'Speichern';

  @override
  String get explanation => 'Beschreibung';

  @override
  String get clear => 'Löschen';

  @override
  String get filter => 'Filtern';

  @override
  String get apply => 'Anwenden';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get newSeason => 'NEUE SAISON';

  @override
  String get heroTitle => 'Minimalistisch\nDer Gipfel des Komforts';

  @override
  String get viewCollection => 'KOLLEKTION ANSEHEN';

  @override
  String get featureArtisan => 'Aufrichtiges Handwerk';

  @override
  String get featureDelivery => 'Sichere Lieferung';

  @override
  String get featureService => 'Freundlicher Service';

  @override
  String get featureShipping => 'Schneller Versand';

  @override
  String get quickOptions => 'Schnelle Optionen';

  @override
  String get easyFind => 'Finden Sie ganz einfach, was Sie suchen';

  @override
  String get mottoBrand => 'Erneuert das Alte, schätzt das Neue';

  @override
  String get newCollection => 'Neue Kollektion';

  @override
  String get newCollectionSub => 'Neueste Produkte';

  @override
  String get spotProducts => 'Gebrauchte Produkte';

  @override
  String get spotProductsSub => 'Angebotsprodukte';

  @override
  String get spotProductsDesc => 'Unglaubliche Preise für hochwertige Produkte';

  @override
  String get currentCollection => 'AKTUELLE KOLLEKTION';

  @override
  String get soldProducts => 'VERKAUFTE PRODUKTE';

  @override
  String pieces(int count) {
    return '$count Stück';
  }

  @override
  String get stock => 'AUF LAGER';

  @override
  String get sold => 'VERKAUFT';

  @override
  String get byRoom => 'Nach Wohnbereich';

  @override
  String get byRoomSub => 'Besondere Auswahl für jede Ecke Ihres Zuhauses';

  @override
  String get roomLivingRoom => 'Wohnzimmer';

  @override
  String get roomLivingRoomSub => 'Das Zentrum des Komforts';

  @override
  String get roomBedroom => 'Schlafzimmer';

  @override
  String get roomBedroomSub => 'Ruhiger Schlaf';

  @override
  String get roomKitchen => 'Küche';

  @override
  String get roomKitchenSub => 'Praktische Lösungen';

  @override
  String get roomOffice => 'Büro';

  @override
  String get roomOfficeSub => 'Effizientes Arbeiten';

  @override
  String get whoWeAre => 'WER SIND WIR?';

  @override
  String get artisanTitle =>
      '20 Jahre aufrichtiges Handwerk,\nmoderner Service.';

  @override
  String get artisanDesc =>
      'Besuchen Sie unser Geschäft, trinken Sie einen Tee mit uns; lassen Sie uns gemeinsam das passende Möbelstück für Sie auswählen.';

  @override
  String get visitUsButton => 'BESUCHEN SIE UNS';

  @override
  String get statHappyCustomer => 'Zufriedener Kunde';

  @override
  String get statExperience => 'Erfahrung';

  @override
  String get statDelivery => 'Lieferung';

  @override
  String get statTrust => 'Vertrauen';

  @override
  String get explore => 'ENTDECKEN';

  @override
  String get collections => 'Kollektionen';

  @override
  String get corporate => 'UNTERNEHMEN';

  @override
  String get aboutUs => 'Über uns';

  @override
  String get contact => 'Kontakt';

  @override
  String get contactUs => 'KONTAKTIEREN SIE UNS';

  @override
  String get sss => 'FAQ';

  @override
  String get qualityFurniture =>
      '\'Die Adresse für hochwertige Möbel ist Sağlam Spot\'';

  @override
  String get footerDesc =>
      'Mit über 20 Jahren Erfahrung bringen wir Qualität und Vertrauen in jede Ecke Istanbuls.';

  @override
  String get allRightsReserved =>
      '© 2026 SAĞLAM SPOT TİCARET. ALLE RECHTE VORBEHALTEN.';

  @override
  String get errorOccurred => 'Ein Fehler ist aufgetreten';

  @override
  String get productNotFound => 'Produkt nicht gefunden';

  @override
  String get noImages => 'Keine Bilder';

  @override
  String get error_check_connection =>
      'Überprüfen Sie Ihre Internetverbindung.';

  @override
  String get error_server_no_response => 'Der Server antwortet derzeit nicht.';

  @override
  String get error_connection => 'Verbindungsfehler';

  @override
  String get error_connection_lost => 'Verbindung unterbrochen';

  @override
  String get status_waiting_connection => 'Warte auf Verbindung...';

  @override
  String get error_no_internet_auto_retry =>
      'Keine Internetverbindung.\nEs wird automatisch fortgesetzt, sobald die Verbindung wiederhergestellt ist.';

  @override
  String get goBack => 'Zurück';

  @override
  String get galleryEmpty => 'Galerie ist leer';

  @override
  String get month_1 => 'Januar';

  @override
  String get month_2 => 'Februar';

  @override
  String get month_3 => 'März';

  @override
  String get month_4 => 'April';

  @override
  String get month_5 => 'Mai';

  @override
  String get month_6 => 'Juni';

  @override
  String get month_7 => 'Juli';

  @override
  String get month_8 => 'August';

  @override
  String get month_9 => 'September';

  @override
  String get month_10 => 'Oktober';

  @override
  String get month_11 => 'November';

  @override
  String get month_12 => 'Dezember';

  @override
  String get noProductFoundTitle =>
      'Kein Produkt mit diesen Kriterien gefunden';

  @override
  String get noProductFoundDescription =>
      'Sie können andere Filter ausprobieren oder Ihren Suchbegriff ändern';

  @override
  String get adminPanelTitle => 'Admin-Panel';

  @override
  String get totalCount => 'Gesamt';

  @override
  String get productAddedSuccess => 'Produkt erfolgreich hinzugefügt';

  @override
  String get authOrConnectionError =>
      'Es ist ein Autorisierungs- oder Verbindungsfehler aufgetreten';

  @override
  String get fillRequiredFields =>
      'Bitte Produktname, Preis und mindestens ein Bild hinzufügen!';

  @override
  String get sessionClosed => 'Sitzung geschlossen';

  @override
  String get addNewProduct => 'Neues Produkt hinzufügen';

  @override
  String get productImages => 'Produktbilder';

  @override
  String get generalInfo => 'Allgemeine Informationen';

  @override
  String get productNameLabel => 'Produktname';

  @override
  String get descriptionLabel => 'Beschreibung';

  @override
  String get statusLabel => 'Status';

  @override
  String get spotSecondHand => 'Spot / Gebraucht';

  @override
  String get secondHandHint =>
      'Einzelstück — Farboptionen werden nicht angezeigt';

  @override
  String get newProductHint =>
      'Neues Produkt — Sie können Farboptionen hinzufügen';

  @override
  String get colorOptionsOptional => 'Farboptionen (optional)';

  @override
  String get noImagesYet => 'Noch keine Bilder hinzugefügt';

  @override
  String get addImage => 'Bild hinzufügen';

  @override
  String get editProductTitle => 'Produkt bearbeiten';

  @override
  String get changeImages => 'Bilder ändern';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get deleteProductTitle => 'Produkt löschen';

  @override
  String get deleteProductConfirmSuffix => 'wird gelöscht. Sind Sie sicher?';

  @override
  String get yesDelete => 'Ja, löschen';

  @override
  String get emptyCategoryProducts =>
      'In dieser Kategorie wurden keine Produkte gefunden';

  @override
  String get adminLoginSubtitle => 'Anmeldung zum Admin-Panel';

  @override
  String get emailLabel => 'E-Mail';

  @override
  String get passwordLabel => 'Passwort';

  @override
  String get loginButton => 'Anmelden';

  @override
  String get sponsored => 'Gesponsert';

  @override
  String get addProductFab => 'Produkt hinzufügen';

  @override
  String get singlePieceNotice =>
      'Dies ist ein Gebraucht-/Spot-Produkt — es ist nur ein Stück auf Lager, Farbe und Aussehen entsprechen genau den Fotos.';

  @override
  String get colorOptionsTitle => 'Farboptionen';

  @override
  String get newProductBadge => 'NEUES PRODUKT';

  @override
  String get usedProductBadge => 'GEBRAUCHT';

  @override
  String get readMore => 'Weiterlesen';

  @override
  String get readLess => 'Weniger anzeigen';

  @override
  String get specDelivery => 'Lieferung';

  @override
  String get specDeliveryValue => 'Innerhalb von 1-2 Tagen';

  @override
  String get specLocation => 'Standort';

  @override
  String get sellerTrustLine =>
      '20 Jahre vertrauenswürdiges lokales Geschäft · İçerenköy';

  @override
  String get whatsappCta => 'Auf WhatsApp schreiben';

  @override
  String get callCta => 'Anrufen';

  @override
  String get similarProducts => 'Ähnliche Produkte';

  @override
  String get conditionShowcase => 'Ausstellung';

  @override
  String get productDescriptionTitle => 'Beschreibung';

  @override
  String get loginBrand => 'Sağlam Spot';

  @override
  String get logout => 'Abmelden';

  @override
  String get logoutConfirm =>
      'Sind Sie sicher, dass Sie sich sicher von Ihrem Konto abmelden möchten?';
}
