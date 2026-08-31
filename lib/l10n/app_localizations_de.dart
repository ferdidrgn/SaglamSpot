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

  @override
  String get testimonialsHeading => 'Was unsere Kunden sagen';

  @override
  String get testimonialsSubheading =>
      'Seit über 20 Jahren berühren wir Tausende von Zuhause in İçerenköy und Umgebung';

  @override
  String get testimonial1Comment =>
      'Wir haben die Couchgarnitur zu einem sehr guten Preis bekommen, fast wie neu. Die Lieferung erfolgte noch am selben Tag von Hand zu Hand — echtes handwerkliches Vertrauen war von Anfang an spürbar.';

  @override
  String get testimonial2Comment =>
      'Ich habe das Schlafzimmerset hier zum Spotpreis gekauft. Es entsprach genau der Produktbeschreibung, keine Überraschungen. Ich empfehle es auf jeden Fall.';

  @override
  String get testimonial3Comment =>
      'Wir haben Möbel für unser Büro in großer Menge gekauft, Preis und Qualität übertrafen unsere Erwartungen. Ein aufmerksames, geduldiges Team — danke, Sağlam Spot.';

  @override
  String get testimonial4Comment =>
      'Wir haben das Esstisch-Set ohne Feilschen zu einem ehrlichen Preis gekauft. Sie haben auch beim Transport geholfen, wir konnten in aller Ruhe einkaufen.';

  @override
  String get testimonial5Comment =>
      'Wir suchten einen gebrauchten Kleiderschrank und fanden ein stabiles, elegantes Stück. Preis-Leistung war das beste Angebot auf dem Markt.';

  @override
  String get testimonial6Comment =>
      'Bei unserem Showroom-Besuch konnten wir die Produkte live sehen, das hat unser Vertrauen gestärkt. Auch nach dem Kauf waren sie immer erreichbar.';

  @override
  String get howItWorksHeading => 'So funktioniert es';

  @override
  String get step1Title => 'Durchsuchen & Filtern';

  @override
  String get step1Desc =>
      'Finde, was dir gefällt, unter Tausenden Produkten nach Kategorie und Preisspanne.';

  @override
  String get step2Title => 'Kontaktiere uns';

  @override
  String get step2Desc =>
      'Erreiche unser Team direkt von der Produktseite aus per WhatsApp oder Telefon.';

  @override
  String get step3Title => 'Preis klären';

  @override
  String get step3Desc =>
      'Sieh es dir im Showroom an oder bestätige es mit Fotos und vereinbare einen fairen Preis.';

  @override
  String get step4Title => 'Lieferung an deine Tür';

  @override
  String get step4Desc =>
      'Schneller, versicherter Transport nach İçerenköy und die anatolische Seite bringt deine Möbel sicher nach Hause.';

  @override
  String get tipsEyebrow => 'TIPPS';

  @override
  String get tipsHeading => 'Pflegetipps vom Fachmann';

  @override
  String get tip1Title => 'Machen Sie Ihr Wohnzimmer gemütlicher';

  @override
  String get tip1Desc =>
      'Lassen Sie 1-2 cm Abstand zwischen Sofa und Wand — das fördert die Luftzirkulation und macht den Raum luftiger.';

  @override
  String get tip1Category => 'Platzierung';

  @override
  String get tip2Title => 'Ein Arbeitsbereich, der immer sauber wirkt';

  @override
  String get tip2Desc =>
      'Ordnen Sie Kabel mit Organizern und wischen Sie mit einem Mikrofasertuch in kreisenden Bewegungen — Ihr Schreibtisch bleibt wie neu.';

  @override
  String get tip2Category => 'Reinigung';

  @override
  String get tip3Title => 'Eine angenehme Küchenaufstellung';

  @override
  String get tip3Desc =>
      'Schwere Gegenstände in untere Regale, häufig genutzte Dinge auf Augenhöhe — praktisch und sicher.';

  @override
  String get tip3Category => 'Organisation';

  @override
  String get tip4Title => 'Eine gemütliche Schlafecke einrichten';

  @override
  String get tip4Desc =>
      'Positionieren Sie das Kopfteil fern vom Fenster, um Licht zu minimieren — eine kleine Änderung für deutlich tieferen Schlaf.';

  @override
  String get tip4Category => 'Komfort';

  @override
  String get tip5Title => 'Bringen Sie Ordnung in Ihren Kleiderschrank';

  @override
  String get tip5Desc =>
      'Trennen Sie saisonale Kleidung, hängen Sie alles in dieselbe Richtung — spart Platz und erleichtert die Auswahl jeden Morgen.';

  @override
  String get tip5Category => 'Organisation';

  @override
  String get tip6Title => 'Verlängern Sie die Lebensdauer Ihrer Holzmöbel';

  @override
  String get tip6Desc =>
      'Vor direkter Sonneneinstrahlung schützen, einige Male im Jahr mit pflegendem Öl abwischen — die effektivste Pflege gegen Kratzer und Verblassen.';

  @override
  String get tip6Category => 'Pflege';

  @override
  String get tip7Title => 'Machen Sie Stoffsofas langlebiger';

  @override
  String get tip7Desc =>
      'Wöchentlich absaugen, Flecken sofort mit feuchtem Tuch abtupfen — Warten lässt Flecken tief ins Gewebe eindringen.';

  @override
  String get tip7Category => 'Pflege';

  @override
  String get tip8Title => 'Wählen Sie die richtige Beleuchtung';

  @override
  String get tip8Desc =>
      'Nutzen Sie geschichtete Beleuchtung statt einer einzelnen Deckenlampe: Grundlicht, Arbeitslicht und Stimmungslicht zusammen wirken wärmer.';

  @override
  String get tip8Category => 'Beleuchtung';

  @override
  String get tip9Title => 'Nutzen Sie kleine Räume clever';

  @override
  String get tip9Desc =>
      'Wählen Sie klappbare, multifunktionale Möbel; wandmontierte Regale schaffen mehr Bodenfläche.';

  @override
  String get tip9Category => 'Organisation';

  @override
  String get tip10Title => 'Verwandeln Sie Ihren Balkon in einen Wohnbereich';

  @override
  String get tip10Desc =>
      'Ein wetterfestes Sitzmöbel-Set und ein paar Topfpflanzen machen den Balkon zur beliebtesten Ecke des Zuhauses.';

  @override
  String get tip10Category => 'Außenbereich';

  @override
  String get popularCategoriesHeading => 'Beliebte Kategorien';

  @override
  String get popularCategoriesSub =>
      'Finde die passenden Möbel mit einem Klick';

  @override
  String categoryProductCount(int count) {
    return '$count Artikel';
  }

  @override
  String get newsletterSubscribeSuccess =>
      'Sie haben unseren Newsletter erfolgreich abonniert!';

  @override
  String get newsletterHeading =>
      'Seien Sie die/der Erste, die/der von neuen Produkten erfährt';

  @override
  String get newsletterDesc =>
      'Spotangebote, neue Kollektionen und Aktionen direkt in Ihr Postfach. Kein Spam, nur nützliche Angebote.';

  @override
  String get emailHint => 'Ihre E-Mail-Adresse';

  @override
  String get emailRequired => 'E-Mail ist erforderlich';

  @override
  String get emailInvalid => 'Geben Sie eine gültige E-Mail-Adresse ein';

  @override
  String get whyUsHeading => 'Warum Sağlam Spot?';

  @override
  String get usp1Title => '20 Jahre vertrauenswürdiges Handwerk';

  @override
  String get usp1Desc =>
      'Über zwanzig Jahre lokales Handwerk in İçerenköy und Tausende zufriedene Kunden.';

  @override
  String get usp2Title => 'Preise unter dem Marktniveau';

  @override
  String get usp2Desc =>
      'Ohne Zwischenhändler bieten wir die besten Preise für Spot- und neue Möbel.';

  @override
  String get usp3Title => 'Geprüfte Produktqualität';

  @override
  String get usp3Desc =>
      'Jedes Produkt durchläuft vor dem Verkauf eine Struktur- und Stoff-/Verarbeitungsprüfung.';

  @override
  String get usp4Title => 'Support nach dem Kauf';

  @override
  String get usp4Desc =>
      'Ein echtes Team, das auch nach der Lieferung erreichbar ist und Ihr Problem löst.';

  @override
  String get socialShowcaseEyebrow => 'TEILEN';

  @override
  String get socialShowcaseHeading => 'Teile dein Zuhause mit #SağlamSpot';

  @override
  String productsLoadError(String error) {
    return 'Beim Laden der Produkte ist ein Fehler aufgetreten: $error';
  }

  @override
  String get viewAllButton => 'Alle anzeigen';

  @override
  String get showcaseEyebrow => 'AUSSTELLUNG';

  @override
  String get exploreButton => 'Entdecken';

  @override
  String get visitUsEyebrow => 'BESUCH UNS';

  @override
  String get visitUsHeading => 'Sag einfach Hallo';

  @override
  String visitUsOpenLine(String hours) {
    return 'Unsere Tür steht immer offen. $hours';
  }

  @override
  String get directionsButton => 'Route anzeigen';

  @override
  String get freeDeliveryLabel => 'Kostenlose Lieferung';

  @override
  String get busLinesLabel => 'Buslinien';

  @override
  String get statYearsSuffix => '+ Jahre';

  @override
  String get storeAddress => 'İçerenköy, Ataşehir/İstanbul';

  @override
  String get stayUpdated => 'Bleib informiert';

  @override
  String get viewButton => 'Ansehen';

  @override
  String get heroSlide2Eyebrow => 'GEBRAUCHT';

  @override
  String get heroSlide2Title => 'Möbel mit Geschichte';

  @override
  String get heroSlide2Subtitle =>
      'Sorgfältig ausgewählte, stabile Gebrauchtstücke mit Charakter.';

  @override
  String get heroSlide3Title => 'Entdecke die ganze Kollektion';

  @override
  String get aboutBadge => 'SEIT 2012 AN IHRER SEITE';

  @override
  String get aboutHeroTitle => 'Sağlam Spot\nDas Vertrauen, das Sie kennen';

  @override
  String get aboutHeroSubtitle =>
      'Wir dienen unserer Nachbarschaft mit Liebe und Sorgfalt in allem, was wir tun.';

  @override
  String get aboutStoryHeading => 'Wer sind wir? (Unsere Geschichte)';

  @override
  String get aboutStoryPara1 =>
      'Unser Ziel ist es, Ihnen zu helfen, hochwertige Möbel zu finden, die Ihrem Zuhause Wärme verleihen und sich wirklich richtig anfühlen. Ihre Wohnräume zu verschönern ist unsere Aufgabe.';

  @override
  String get aboutStoryPara2 =>
      'Alles begann 2012 in genau diesem Laden in İçerenköy. Seitdem sind wir in immer mehr Zuhause zu Gast.';

  @override
  String get aboutStoryPara3 =>
      'Heute sind wir mit neuen und sorgfältig ausgewählten Gebrauchtmöbeln in Tausenden von Nachbarhäusern zu Gast gewesen. Wir wachsen durch Ihr Vertrauen.';

  @override
  String get aboutStoryStartLabel => 'Gegründet';

  @override
  String get aboutStoryExperienceLabel => 'Jahre Erfahrung';

  @override
  String get aboutStorySmilesLabel => 'Zufriedene Gesichter';

  @override
  String get aboutValuesHeading => 'Unsere Grundsätze';

  @override
  String get aboutValuesSubheading =>
      'Prinzipien, bei denen wir als Handwerksbetrieb keine Kompromisse machen';

  @override
  String get aboutValue1Title => 'Qualität und Sorgfalt';

  @override
  String get aboutValue1Desc =>
      'Ob neu oder gebraucht, wir wählen sorgfältig aus und bieten es Ihnen genauso an.';

  @override
  String get aboutValue2Title => 'Zufriedene Gesichter';

  @override
  String get aboutValue2Desc =>
      'Für uns ist der größte Gewinn ein Nachbar, der glücklich aus dem Laden geht. Ihre Zufriedenheit steht über allem.';

  @override
  String get aboutValue3Title => 'Respekt vor Handwerkskunst';

  @override
  String get aboutValue3Desc =>
      'Möbel sind wertvolle Arbeit. Indem wir Gebrauchtmöbeln neues Leben geben, schonen wir sowohl Ihr Budget als auch die Umwelt.';

  @override
  String get aboutValue4Title => 'Ehrlichkeit und Vertrauen';

  @override
  String get aboutValue4Desc =>
      'Transparentes, ehrliches Handwerk ist unser größter Wert. Seit Jahren sind wir am selben Standort für Sie da.';

  @override
  String get aboutMasterHeading => 'Lernen Sie unseren Meister kennen';

  @override
  String get aboutMasterBody =>
      'Unser Meister ist seit 1995 aktiv in dieser Branche tätig — über ein Vierteljahrhundert. Er hat bei führenden Marken (İstikbal) gearbeitet und dabei tiefes Wissen über Möbeleigenschaften, Teile und Feinheiten erworben.\n\nVom Fahren für Lieferungen über den Transport bis zur Montage und dem Kundenempfang hat er in jedem Bereich selbst mitgearbeitet und so umfassende Erfahrung gesammelt. 2012 entschied er sich für \'jetzt mein eigener Laden\' und brachte diese Erfahrung zu Sağlam Spot.\n\nSein Ziel ist es, die Qualität, die er bei den großen Firmen gelernt hat, mit der Herzlichkeit und Sorgfalt eines Nachbarschaftsbetriebs zu verbinden, um Ihnen den besten Service zu bieten.';

  @override
  String get aboutDeliveryHeading => 'Unser Liefer- und Montageservice';

  @override
  String get aboutDeliveryFreeTitle => 'Kostenlose Lieferung und Montage';

  @override
  String get aboutDeliveryZonesLabel => 'Unsere kostenlosen Servicegebiete:';

  @override
  String get aboutDeliveryZonesList =>
      '• Unsere Nachbarschaft İçerenköy\n• Fındıklı, Kayışdağı, Küçükbakkalköy\n• Nahe Nachbarn wie İnönü und Bostancı Sanayi';

  @override
  String get aboutDeliveryNote =>
      'Wichtiger Hinweis: Um die Gesundheit unseres Meisters zu schützen, können wir Möbel in Gebäuden ohne Aufzug leider nicht in hohe Stockwerke tragen. Vielen Dank für Ihr Verständnis.';

  @override
  String get aboutDeliveryPunctual =>
      '⏰ Wir stehen zur vereinbarten Zeit vor Ihrer Tür!';

  @override
  String get aboutTransportHeading => 'So erreichen Sie unseren Laden';

  @override
  String get aboutTransportBusIntro => 'Wenn Sie mit dem Bus kommen:';

  @override
  String get aboutBusStop1 => 'Haltestelle Ziyapaşa (Richtung Kadıköy):';

  @override
  String get aboutBusStop2 => 'Haltestelle İçerenköy (Richtung Kayışdağı):';

  @override
  String get aboutBusStop3 => 'Haltestelle İçerenköy (Yeniyol):';

  @override
  String get aboutContactPhoneLabel => 'Telefon (Schnelle Antwort)';

  @override
  String get aboutContactAddressLabel => 'Adresse (Wir erwarten Sie zum Tee)';

  @override
  String get aboutContactAddressValue =>
      'İçerenköy Mahallesi\nBuket Sokak No:6';

  @override
  String get aboutContactHoursLabel => 'Unsere Öffnungszeiten';

  @override
  String get aboutContactHoursValue =>
      'Mo-Sa: 09:00 - 22:00\nSo: 10:00 - 20:00';

  @override
  String get aboutContactHeading => 'Kontaktieren Sie uns';

  @override
  String get aboutCallNowButton => 'Jetzt anrufen';

  @override
  String get aboutViewMapButton => 'Auf Karte ansehen';

  @override
  String get aboutMapHeading => 'Unser Laden ist genau hier';

  @override
  String get aboutMapSubtext => 'Für die Wegbeschreibung auf die Karte tippen';

  @override
  String get newProductsBadgeEyebrow => 'NEUE KOLLEKTION';

  @override
  String get newProductsTitle => 'Neue\nKollektion';

  @override
  String get productsBadgeLabel => 'PRODUKTE';

  @override
  String get breadcrumbHome => 'Startseite';

  @override
  String get statTotalProducts => 'PRODUKTE GESAMT';

  @override
  String get statCategoryLabel => 'KATEGORIEN';

  @override
  String get statConditionValueNew => 'NEU';

  @override
  String get statConditionLabel => 'ZUSTAND';

  @override
  String get statRatingLabel => 'BEWERTUNG';

  @override
  String get searchBarRichPrefix =>
      'Für eine detaillierte Produktsuche drücken Sie ';

  @override
  String get searchBarRichOr => ' oder klicken Sie ';

  @override
  String get searchBarRichHereLink => 'HIER';

  @override
  String get searchBarRichSuffix => '.';

  @override
  String get sortNewProductsDefault => 'Neueste';

  @override
  String get sortSpotProductsDefault => 'Neueste';

  @override
  String get sortPriceLowHigh => 'Preis: Aufsteigend';

  @override
  String get sortPriceHighLow => 'Preis: Absteigend';

  @override
  String get sortMostPopular => 'Am beliebtesten';

  @override
  String get spotBadgeEyebrow => 'SPOT-PRODUKTE';

  @override
  String get spotHeroTitle => 'Angebots-\nprodukte';

  @override
  String get spotDiscountLabel => 'RABATT';

  @override
  String get statSpotProductLabel => 'Spot-Produkte';

  @override
  String get statDiscountLabel => 'Rabatt';

  @override
  String get statSupportLabel => 'Support';

  @override
  String get statFreeLabel => 'Kostenlos';

  @override
  String get statFreeShippingNote => 'Nur für nahegelegene Gebiete, Versand';

  @override
  String get statFreeShippingShort => 'Versand';

  @override
  String get filtersPanelTitle => 'FILTER';

  @override
  String get dragToRotateHint => 'Für weitere Fotos wischen';

  @override
  String get studioQuotaExceededNotice =>
      'Monatliches Studio-Bild-Limit erreicht — Fotos wurden im Original hinzugefügt.';

  @override
  String get studioPreparingWait =>
      'Studiofoto wird vorbereitet, bitte warten...';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get studioGenerationFailed =>
      'Studiofoto konnte nicht erstellt werden';

  @override
  String get storePhotoLabel => 'Geschäft';

  @override
  String get studioPhotoLabel => 'Studio';

  @override
  String get onboardingSkip => 'Überspringen';

  @override
  String get onboardingStart => 'Loslegen';

  @override
  String get onboardingPage1Eyebrow => 'WILLKOMMEN BEI SAĞLAM SPOT';

  @override
  String get onboardingPage1Title => 'Die richtige Adresse\nfür Ihr Zuhause';

  @override
  String get onboardingPage1Desc =>
      'Mit über 20 Jahren Handwerkserfahrung bringen wir hochwertige Möbel direkt in Ihre Hosentasche.';

  @override
  String get onboardingPage2Eyebrow => 'GEBRAUCHT & NEU, VEREINT';

  @override
  String get onboardingPage2Title => 'Optionen für\njedes Budget';

  @override
  String get onboardingPage2Desc =>
      'Von tollen Gebrauchtmöbeln bis zur brandneuen Kollektion — finden Sie ganz einfach, was Sie suchen.';

  @override
  String get onboardingPage3Eyebrow => 'SICHER EINKAUFEN';

  @override
  String get onboardingPage3Title => 'Etwas gefunden?\nJetzt Fragen';

  @override
  String get onboardingPage3Desc =>
      'Erreichen Sie uns sofort über WhatsApp, fragen Sie nach dem Preis und verhandeln Sie direkt.';

  @override
  String get favoritesTitle => 'Meine Favoriten';

  @override
  String get favoritesEmptyTitle => 'Ihre Favoritenliste ist leer';

  @override
  String get favoritesEmptyDesc =>
      'Tippen Sie auf das Herzsymbol bei Produkten, die Ihnen gefallen, um sie zu Ihren Favoriten hinzuzufügen.';

  @override
  String get sortPanelTitle => 'SORTIEREN';

  @override
  String get priceRangeSectionTitle => 'PREISSPANNE';

  @override
  String get clearFiltersButton => 'FILTER ZURÜCKSETZEN';

  @override
  String get tryDifferentFiltersShort =>
      'Sie können andere Filter ausprobieren';

  @override
  String get spotBadgeTag => 'SPOT';

  @override
  String productLoadError(String error) {
    return 'Produkt konnte nicht geladen werden: $error';
  }

  @override
  String get productSpecConditionNew => 'Neues Produkt';

  @override
  String get productLocationValue => 'İçerenköy, İstanbul';

  @override
  String get sortFeatured => 'Empfohlen';

  @override
  String get sortPriceAsc => 'Preis: Aufsteigend';

  @override
  String get sortPriceDesc => 'Preis: Absteigend';

  @override
  String get languageSelectorTitle => 'Sprachauswahl';

  @override
  String get languageTooltip => 'Sprache';

  @override
  String get galleryEmptyMessage =>
      'Zu diesem Produkt wurden noch keine Fotos hinzugefügt.';

  @override
  String get productCardNewBadge => 'NEU';

  @override
  String get sssHelpCenterBadge => 'HILFECENTER';

  @override
  String get sssHeroTitle => 'Häufig gestellte\nFragen';

  @override
  String get sssHeroSubtitle => 'Antworten auf alles, was Sie interessiert';

  @override
  String get sssCategoryAll => 'Alle';

  @override
  String get sssCategoryGeneral => 'Allgemein';

  @override
  String get sssCategoryProductService => 'Produkt & Service';

  @override
  String get sssCategoryDelivery => 'Lieferung & Montage';

  @override
  String get sssCategoryPayment => 'Zahlung & Bestellung';

  @override
  String get sssCategoryReturns => 'Rückgabe & Garantie';

  @override
  String get sssCategorySecondHandBuying => 'Ankaufsprozess für Gebrauchtes';

  @override
  String get sssPhoneSupportTitle => 'Telefonsupport';

  @override
  String get sssWorkingHoursTitle => 'Öffnungszeiten';

  @override
  String get sssWorkingHoursValue => '09:00 - 22:00';

  @override
  String get sssStoreAddressTitle => 'Ladenadresse';

  @override
  String get sssStoreAddressValue => 'İçerenköy Mahallesi Buket Sok. No:6';

  @override
  String get sssNoAnswerTitle => 'Keine Antwort auf Ihre Frage gefunden?';

  @override
  String get sssNoAnswerSubtitle => 'Sie können uns erreichen';

  @override
  String get sssVisitStoreButton => 'Laden besuchen';

  @override
  String get sssQ1 =>
      'Können Sie uns etwas über das Arbeitsleben und die Erfahrung des Meisters erzählen?';

  @override
  String get sssA1 =>
      'Unser Meister ist seit 1995 aktiv in dieser Branche tätig. Seit seinen ersten Schritten in seiner Karriere hat er sich stetig weiterentwickelt. Im Laufe seines Berufslebens hat er viele Positionen bekleidet — Fahren für Lieferungen, Transport, Montage, Kundenempfang — und dabei vielseitige Erfahrung gesammelt. Besonders bis 2010 arbeitete er bei İstikbal und erwarb dabei tiefes Wissen über Produkteigenschaften, Teile und Feinheiten. Nach 2010 arbeitete er im nahegelegenen Işık Çeyiz und erweiterte seine Fachkompetenz. 2012 entschied er sich, seinen eigenen Handwerksladen zu eröffnen, und seitdem stellt er hochwertigen Service in den Vordergrund und gibt seine Branchenerfahrung bestmöglich an seine Kunden weiter.';

  @override
  String get sssQ2 => 'Ist Sağlam Spot vertrauenswürdig?';

  @override
  String get sssA2 =>
      'Seit 2012 dienen wir unseren Nachbarn in İçerenköy. Wir waren in zahllosen Häusern zu Gast und sind es immer noch.';

  @override
  String get sssQ3 =>
      'Kann ich in Ihren Laden kommen, um die Produkte anzusehen?';

  @override
  String get sssA3 =>
      'Aber natürlich! Das empfehlen wir sogar besonders. Bei einem Tee die Produkte live zu sehen, anzufassen und zu spüren, ob sie zu Ihnen passen, ist am gesündesten. Wir freuen uns jederzeit auf Ihren Besuch in unserem Laden in İçerenköy Mahallesi.';

  @override
  String get sssQ4 => 'Wie wird der Zustand gebrauchter Produkte geprüft?';

  @override
  String get sssA4 =>
      'Für uns bedeutet gebraucht nicht \'zweite Wahl\'. Jedes Produkt durchläuft die sorgfältige Kontrolle unseres Meisters; Reinigung, Pflege und nötige Reparaturen werden vollständig durchgeführt. Was Sie auf den Fotos sehen, ist das, was Sie bekommen, aber wir sagen trotzdem gerne \'kommen Sie und sehen Sie selbst\'. Es mit eigenen Augen zu sehen ist immer am besten.';

  @override
  String get sssQ5 => 'Wie ist die Materialqualität der Möbel?';

  @override
  String get sssA5 =>
      'Transparenz ist uns wichtig. Jedes Produkt hat seine eigene Geschichte und sein eigenes Material. Deshalb schreiben wir alle Details, Materialqualität und Eigenschaften klar in die Produktbeschreibung. Wenn Ihnen etwas durch den Kopf geht, fragen Sie ruhig nach.';

  @override
  String get sssQ6 => 'Wie werden die Produktpreise festgelegt?';

  @override
  String get sssA6 =>
      'Bei der Preisfestlegung berücksichtigen wir fair sowohl die Qualität des Produkts als auch die Marktbedingungen. Unser Ziel ist es, Ihnen hochwertige, langlebige Produkte zu ermöglichen, ohne Ihr Budget zu belasten. Wir verlangen, was fair ist, nicht mehr.';

  @override
  String get sssQ7 => 'Gibt es bei Ihren Produkten Farboptionen?';

  @override
  String get sssA7 =>
      'Da unsere Produkte in der Regel spontane Einzelstücke sind, bieten wir sie in der jeweils vorhandenen Farbe an. Leider können wir keine unterschiedlichen Farboptionen anbieten. Die Farbe, die Ihnen gefällt, ist die Farbe, die Sie sehen.';

  @override
  String get sssQ8 => 'Nehmen Sie Sonderbestellungen an?';

  @override
  String get sssA8 =>
      'Wir wünschten, wir könnten es! Aber wir konzentrieren uns hauptsächlich auf unsere vorhandenen, sorgfältig ausgewählten Produkte. Sonderanfertigungen oder Designbestellungen können wir momentan leider nicht annehmen. Wir empfehlen, unsere vorrätigen Produkte anzusehen.';

  @override
  String get sssQ9 => 'Worauf sollte ich bei den Produktbeschreibungen achten?';

  @override
  String get sssA9 =>
      'Unser wichtigster Rat: das Maßband! Bitte vergleichen Sie die Maße in der Produktbeschreibung sorgfältig mit dem Platz, an den Sie es zu Hause stellen möchten. Die Frage \'passt es wohl?\' im Vorfeld zu klären, verhindert spätere Probleme. Vergessen Sie beim Messen auch nicht den Flur: Messen Sie nicht nur den Standort, sondern auch, wie das Möbelstück durch Tür, Flur und Treppe passt. Lesen Sie unbedingt auch die Material- und Zustandsangaben.';

  @override
  String get sssQ10 =>
      'Liefern Sie in Gebäude ohne Aufzug oder in hohe Stockwerke?';

  @override
  String get sssA10 =>
      'Das ist eines der sensibelsten und wichtigsten Themen für uns. Wir sind ein kleiner Handwerksbetrieb, der die Arbeit selbst erledigt. Da unser Meister nach jahrelanger Erfahrung nicht mehr jung ist, müssen wir auch an seine Gesundheit denken. Wir bitten um Ihr Verständnis, dass wir in Gebäuden ohne Aufzug in hohe Stockwerke (zum Beispiel 2. Stock und höher) definitiv keinen Möbeltransport nach oben oder unten anbieten können. Bitte klären wir das vor Ihrer Bestellung, wir möchten Sie nicht enttäuschen.';

  @override
  String get sssQ11 => 'Bieten Sie einen Transportservice an?';

  @override
  String get sssA11 =>
      'Selbstverständlich, wir helfen unseren Nachbarn. Vor allem für İçerenköy sowie Fındıklı, Kayışdağı, Küçükbakkalköy, İnönü und Bostancı Sanayi bieten wir kostenlosen Transport in der näheren Umgebung an. (Außer für einige Teile von Bostancı und Kozyatağı, und aus Altersgründen können wir hohe Stockwerke ohne Aufzug nicht bedienen, das besprechen wir separat.)';

  @override
  String get sssQ12 => 'Wie lange dauert die Lieferung?';

  @override
  String get sssA12 =>
      'Sobald Sie bestellen, nehmen wir Kontakt mit Ihnen auf. Wir fragen \'Wann passt es Ihnen?\' und vereinbaren einen für uns beide passenden Termin. In der Regel schließen wir Lieferung und Montage innerhalb von 1-3 Tagen zur vereinbarten Zeit ab.';

  @override
  String get sssQ13 => 'Bieten Sie einen Montageservice an?';

  @override
  String get sssA13 =>
      'Aber natürlich. Möbel abzuholen und einfach vor die Tür zu stellen ist nicht unser Stil. Alle großen Produkte werden persönlich von unserem Meister aufgebaut, und für diesen Service verlangen wir keine zusätzlichen Kosten. Zeigen Sie einfach den Platz, den Rest übernehmen wir.';

  @override
  String get sssQ14 => 'Wie lange dauert die Lieferung einer Möbelbestellung?';

  @override
  String get sssA14 =>
      'Wenn das Produkt bereit ist, sind wir so schnell wie möglich zur gemeinsam vereinbarten Zeit bei Ihnen. Machen Sie sich auch um die Montage keine Sorgen; wir bauen es so auf, wie wir es gebracht haben, und liefern es fertig ab. In der Regel ist alles am selben Tag erledigt.';

  @override
  String get sssQ15 => 'Kann ich auf Kredit / später zahlen bestellen?';

  @override
  String get sssA15 =>
      'Wir bitten hierbei um Ihr Verständnis. Als Handwerksbetrieb können wir leider nicht mit \'auf Kredit\' oder \'später bezahlen\' arbeiten, um bestehen zu können. Wir müssen den vereinbarten Betrag bei der Lieferung des Produkts bar erhalten. Wir teilen diese Regel lieber von Anfang an mit, um Ihnen keine unangenehme Situation zu bereiten.';

  @override
  String get sssQ16 => 'Wie kann ich eine Bestellung aufgeben?';

  @override
  String get sssA16 =>
      'Der zuverlässigste Weg ist immer der persönliche. Notieren Sie sich das Produkt, das Ihnen auf der Website gefällt, und kommen Sie dann in unseren Laden. Sehen Sie das Produkt live, stellen Sie Ihre Fragen, und wenn es Ihnen zusagt, schließen wir Ihre Bestellung dort ab. So bleibt kein Zweifel offen.';

  @override
  String get sssQ17 => 'Wie lautet Ihre Rückgabepolitik?';

  @override
  String get sssA17 =>
      'Aufgrund der Natur gebrauchter Produkte und unserer Arbeitsweise als Handwerksbetrieb können wir leider keine Rückgaben akzeptieren. Deshalb bestehen wir darauf: \'kommen Sie, sehen Sie es sich an, trinken Sie einen Tee mit uns\'. Es ist am sinnvollsten, das Produkt vor dem Kauf gründlich zu prüfen und zu vermessen. Schließen wir den Kauf nicht ab, ohne sicher zu sein.';

  @override
  String get sssQ18 => 'Gibt es eine Garantiezeit für die Produkte?';

  @override
  String get sssA18 =>
      'Da unsere Produkte gebraucht sind, bieten wir leider keine offizielle Garantiezeit wie eine Marke an. Aber wir sind nicht diejenigen, die sagen \'verkauft, fertig\'. Wir stellen bei Lieferung und Montage sicher, dass alles einwandfrei funktioniert.';

  @override
  String get sssQ19 =>
      'Ich möchte Gegenstände aus meinem Zuhause verkaufen, kaufen Sie Gebrauchtes an?';

  @override
  String get sssA19 =>
      'Ja, wir kaufen ausgewählte Produkte, die sauber und wiederverkaufsfähig sind und die wir in unserem Laden ausstellen können. Da unser Laden aber wirklich sehr klein ist, müssen wir dabei leider sehr wählerisch sein.\n\nWir sind hierbei gerne von Anfang an ehrlich: Das Angebot, das Sie von uns erhalten, könnte etwas niedriger sein als der Betrag, den Sie selbst z. B. auf Plattformen wie Letgo erzielen könnten. Der Grund dafür ist: Als Handwerksbetrieb verbrauchen wir Benzin, um das Stück abzuholen, investieren Arbeit in den Transport, und vor allem übernehmen wir den gesamten Kundenprozess (Verhandlung, Fragen usw.), um es in unserem Laden auszustellen und zu verkaufen.\n\nWenn Sie selbst auf diesen Plattformen verkaufen, übernehmen Sie all diese Prozesse selbst. Wir hingegen nehmen Ihnen diesen Aufwand ab. Unser Angebot beinhaltet auch diesen Service. Vielen Dank für Ihr Verständnis.';

  @override
  String get sssQ20 =>
      'Kaufen Sie komplette Möbelsets (Schlafzimmer, Wohnzimmerset usw.) an?';

  @override
  String get sssA20 =>
      'Da unser Laden klein ist, können wir leider keine kompletten Sets wie Schlafzimmer- oder Sofasets — große Sets — ankaufen. Unser Platz ist sehr begrenzt. Wir konzentrieren uns eher auf Einzelstücke, die sich leichter verkaufen lassen, wie Kommoden, Schränke, Tische oder Stühle.';

  @override
  String get sssQ21 =>
      'Meine Sachen befinden sich in einem hohen Stockwerk und das Gebäude hat keinen Aufzug. Kaufen Sie sie trotzdem an?';

  @override
  String get sssA21 =>
      'Genau wie bei der Lieferung ist das unsere klarste Regel. Aus gesundheitlichen Gründen unseres Meisters können wir Gegenstände aus hohen Stockwerken in Gebäuden ohne Aufzug definitiv nicht heruntertragen. Wir können es nur in Betracht ziehen, wenn sich Ihre Sachen in der Nähe des Erdgeschosses befinden oder das Gebäude einen Lastenaufzug hat.';

  @override
  String get sssQ22 => 'Kaufen Sie immer Gegenstände an?';

  @override
  String get sssA22 =>
      'Das hängt ganz davon ab, wie viel Platz wir gerade in unserem Laden haben. Da unser Laden klein ist, arbeiten wir nach dem Prinzip \'verkaufen-kaufen\'. Manchmal gefällt uns ein Produkt sehr, aber wir können es mangels Platz nicht annehmen. Am besten schicken Sie uns Fotos des Produkts, das Sie verkaufen möchten. Wir sagen Ihnen dann ehrlich, ob wir gerade Platz haben oder momentan leider ausgebucht sind.';

  @override
  String get navDiscover => 'Entdecken';

  @override
  String get navCart => 'Warenkorb';

  @override
  String get navProfile => 'Profil';

  @override
  String get storeHeroEyebrow => 'NEUE KOLLEKTION';

  @override
  String get storeHeroTitle => 'Möbel, die sich\nwie Zuhause anfühlen';

  @override
  String get storeHeroSubtitle =>
      'Hochwertige neue und gebrauchte Möbel, geliefert zu Preisen, die Ihnen gefallen.';

  @override
  String get storeHeroCta => 'Jetzt einkaufen';

  @override
  String get sectionCategories => 'Kategorien';

  @override
  String get sectionBestSellers => 'Bestseller';

  @override
  String get sectionNewArrivals => 'Neuheiten';

  @override
  String get seeAll => 'Alle anzeigen';

  @override
  String get cartTitle => 'Mein Warenkorb';

  @override
  String get cartEmptyTitle => 'Ihr Warenkorb ist leer';

  @override
  String get cartEmptyDesc =>
      'Fügen Sie Artikel hinzu und fragen Sie dann alle in einer Nachricht an.';

  @override
  String get cartTotalLabel => 'Gesamt';

  @override
  String get cartWhatsappCta => 'Warenkorb per WhatsApp senden';

  @override
  String get cartItemRemoved => 'Aus dem Warenkorb entfernt';

  @override
  String get addToCartCta => 'In den Warenkorb';

  @override
  String get addedToCartMessage => 'Zum Warenkorb hinzugefügt';

  @override
  String get alreadyInCartMessage => 'Bereits im Warenkorb';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsLanguageLabel => 'Sprache';

  @override
  String get settingsAccountSection => 'Konto';

  @override
  String get settingsGeneralSection => 'Allgemein';

  @override
  String get settingsContact => 'Kontakt';

  @override
  String get settingsCallUs => 'Rufen Sie uns an';

  @override
  String get settingsAdminLogin => 'Admin-Anmeldung';

  @override
  String get settingsAppVersion => 'App-Version';

  @override
  String cartItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Artikel',
      one: '1 Artikel',
      zero: 'Warenkorb ist leer',
    );
    return '$_temp0';
  }

  @override
  String get settingsRateApp => 'App bewerten';

  @override
  String get settingsShareApp => 'App teilen';

  @override
  String get settingsPrivacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get settingsTerms => 'Allgemeine Geschäftsbedingungen';

  @override
  String get legalContentTurkishOnly =>
      'Dieser Inhalt ist derzeit nur auf Türkisch verfügbar.';

  @override
  String get doubleBackToExit => 'Drücken Sie erneut zurück, um zu beenden';

  @override
  String get productLinkLabel => 'Produktlink';

  @override
  String get settingsAppSection => 'App';

  @override
  String get settingsLegalSection => 'Rechtliches';

  @override
  String get recentlyViewedTitle => 'Zuletzt angesehen';

  @override
  String get productTrustBadgeVerified => 'Verifizierter Verkäufer';

  @override
  String get productTrustBadgeNegotiate => 'Verhandeln über WhatsApp';

  @override
  String get productTrustBadgeDelivery => 'Lieferung vor Ort';

  @override
  String get howToBuyTitle => 'Wie kaufe ich?';

  @override
  String get howToBuyStep1Title => 'Auf WhatsApp schreiben';

  @override
  String get howToBuyStep1Desc =>
      'Wenn Ihnen der Artikel gefällt, kontaktieren Sie uns über WhatsApp.';

  @override
  String get howToBuyStep2Title => 'Preis besprechen';

  @override
  String get howToBuyStep2Desc =>
      'Vereinbaren Sie gemeinsam Preis und Lieferdetails.';

  @override
  String get howToBuyStep3Title => 'Abholen';

  @override
  String get howToBuyStep3Desc =>
      'Nach der Einigung erhalten Sie Ihren Artikel sicher.';

  @override
  String get listedToday => 'Heute eingestellt';

  @override
  String listedDaysAgo(int days) {
    return 'Vor $days Tagen eingestellt';
  }

  @override
  String listedWeeksAgo(int weeks) {
    return 'Vor $weeks Wochen eingestellt';
  }

  @override
  String get settingsAppearanceSection => 'Erscheinungsbild';

  @override
  String get settingsThemeLight => 'Hell';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeDark => 'Dunkel';

  @override
  String get notificationsTitle => 'Benachrichtigungen';

  @override
  String get notificationsEmptyTitle => 'Noch keine Benachrichtigungen';

  @override
  String get notificationsEmptyDesc =>
      'Neue Kampagnen und Ankündigungen erscheinen hier';

  @override
  String get markAllReadAction => 'Alle als gelesen markieren';

  @override
  String get clearAllAction => 'Alle löschen';

  @override
  String get timeJustNow => 'Gerade eben';

  @override
  String timeMinutesAgo(int minutes) {
    return 'Vor $minutes Min.';
  }

  @override
  String timeHoursAgo(int hours) {
    return 'Vor $hours Std.';
  }

  @override
  String timeDaysAgoGeneric(int days) {
    return 'Vor $days Tagen';
  }

  @override
  String get catalogCategoryTitleSofa => 'Sofa & Couch';

  @override
  String get catalogCategoryTitleChair => 'Stuhl & Sessel';

  @override
  String get catalogCategoryTitleTable => 'Esstisch';

  @override
  String get catalogCategoryTitleBed => 'Bett & Bettgestell';

  @override
  String get catalogCategoryTitleWardrobe => 'Kleiderschrank & Schrank';

  @override
  String get catalogCategoryTitleWhite => 'Haushaltsgeräte';

  @override
  String get catalogCategoryTitleOther => 'Dekoration';

  @override
  String get mottoTitlePart1 => 'Erst sehen, ';

  @override
  String get mottoTitlePart2 => 'Komm, wenn\'s dir gefällt.';

  @override
  String get mottoSubtitle =>
      'Stöbere in unserem Schaufenster, bevor du in den Laden kommst — komm einfach vorbei, sobald du etwas Passendes gefunden hast.';

  @override
  String get gatewayNewEyebrow => 'NEUE KOLLEKTION';

  @override
  String get gatewayNewTitle => 'Zeitlose Stücke';

  @override
  String get gatewayNewSubtitle => 'Brandneue, unbenutzte Möbel.';

  @override
  String get gatewayNewButton => 'Kollektion ansehen';

  @override
  String get gatewaySpotEyebrow => 'SPOT-ANGEBOTE';

  @override
  String get gatewaySpotTitle => 'Gebraucht, aber solide';

  @override
  String get gatewaySpotSubtitle =>
      'Gebraucht, aber praktisch — zu preiswerten Konditionen.';

  @override
  String get gatewaySpotButton => 'Angebote ansehen';

  @override
  String freeDeliveryZonesNote(String zones) {
    return 'Kostenlose Lieferung gilt nur in $zones';
  }

  @override
  String get footerWarehouseTagline => 'MÖBELLAGER · İÇERENKÖY / ATAŞEHİR';

  @override
  String get locationAndHoursLabel => 'STANDORT & ÖFFNUNGSZEITEN';

  @override
  String get openNowLabel => 'JETZT GEÖFFNET';

  @override
  String get closedNowLabel => 'JETZT GESCHLOSSEN';

  @override
  String todayHoursPrefix(String hours) {
    return '· Heute $hours';
  }

  @override
  String get openInMapsButton => 'In Karten öffnen';

  @override
  String get viewOnGoogleMapsButton => 'Auf Google Maps ansehen';

  @override
  String gatewayProductCount(int count) {
    return '$count Produkte';
  }

  @override
  String get gatewayNewEyebrowShort => 'NEU';

  @override
  String get gatewayNewTitleShort => 'Kollektion';

  @override
  String get gatewaySpotEyebrowShort => 'SPOT';

  @override
  String get gatewaySpotTitleShort => 'Angebote';

  @override
  String get spotHeroEyebrow => 'ANGEBOTSLAGER';

  @override
  String get spotHeroSubtitle =>
      'Gebraucht, aber praktisch. Wie neu wirkende Möbel für jedes Budget. Verhandlungsspielraum vorhanden.';

  @override
  String spotHeroDealCount(int count) {
    return '$count+ Angebote';
  }

  @override
  String get spotStatNegotiable => 'Verhandlungsspielraum';

  @override
  String get spotStatUsed => 'Gebraucht';

  @override
  String get spotShowcaseBadgeTitle => 'Generalüberholt';

  @override
  String get spotShowcaseBadgeSubtitle =>
      'Jedes Stück wird vor der Lieferung einzeln überprüft.';

  @override
  String get spotBreadcrumbLabel => 'Spot & Gebraucht';

  @override
  String get aphorismEyebrow => 'WIR HABEN EIN MOTTO';

  @override
  String get aphorismQuote =>
      'Nicht abgenutzt, sondern bewährt.\nGute Möbel altern nie — sie wechseln nur das Zuhause.';

  @override
  String get aphorismBody =>
      'Genau deshalb sind wir hier: Stücke, die noch Leben in sich tragen, zu einem neuen Zuhause bringen, das sie zu schätzen weiß.';

  @override
  String get spotSearchHint => 'Angebote suchen …';

  @override
  String get priceRangeLabel => 'Preisspanne';

  @override
  String get filtersSheetTitle => 'FILTER';

  @override
  String get applyFiltersButton => 'Filter anwenden';

  @override
  String get priceRangeSheetTitle => 'PREISSPANNE';

  @override
  String get applyButton => 'Anwenden';

  @override
  String get sortSheetTitle => 'SORTIEREN';

  @override
  String get sortNewest => 'Neueste Angebote';

  @override
  String get sortPopular => 'Meistgesehen';

  @override
  String get spotEmptyStateTitle =>
      'Wir haben dazu keine passenden Angebote gefunden';

  @override
  String get spotEmptyStateSubtitle =>
      'Versuche, die Filter zurückzusetzen oder eine andere Kategorie.';

  @override
  String get newHeroTitleLine1 => 'Für Ihren Wohnraum\n';

  @override
  String get newHeroTitleEmphasis => 'Zeitlose ';

  @override
  String get newHeroButtonCollection => 'Kollektion ansehen';

  @override
  String get newHeroButtonQuickFilter => 'Schnellfilter';

  @override
  String get newStatActiveProductLabel => 'AKTIVE PRODUKTE';

  @override
  String get newStatControlledStockLabel => 'GEPRÜFTER BESTAND';

  @override
  String get shopByCategoryTitlePrefix => 'Nach Kategorie ';

  @override
  String get shopByCategoryTitleEmphasis => 'Entdecken';

  @override
  String get showAllButton => 'Alle anzeigen';

  @override
  String get newEmptyStateTitle =>
      'Keine Möbel gefunden, die Ihrer Suche entsprechen';

  @override
  String get newEmptyStateSubtitle =>
      'Versuchen Sie einen anderen Suchbegriff oder setzen Sie die Filter zurück.';

  @override
  String get sortOptionsSheetTitle => 'Sortieroptionen';

  @override
  String get newSortNewest => 'Neueste';

  @override
  String get newSortPopular => 'Meistgesehen';

  @override
  String get cartWhatsappGreeting =>
      'Hallo, ich möchte Informationen zu diesen Produkten:\n\n';

  @override
  String cartWhatsappAllProductsLine(String url) {
    return 'Alle Produkte: $url';
  }

  @override
  String get defaultWhatsappGreeting =>
      'Hallo, ich möchte Informationen zu den Möbeln.';

  @override
  String get spotHeroPageTitle => 'Gebraucht & Spot';

  @override
  String get sortByPriceLowHigh => 'Preis: aufsteigend';

  @override
  String get sortByPriceHighLow => 'Preis: absteigend';

  @override
  String get seoSssTitle => 'Häufige Fragen | Sağlam Spot';

  @override
  String get seoSssDesc =>
      'Antworten auf alle Fragen zu Kauf, Lieferung und Garantie.';

  @override
  String get seoSearchTitle => 'Produkte suchen | Sağlam Spot';

  @override
  String get seoSearchDesc =>
      'Finden Sie die gesuchten Möbel durch Filtern nach Kategorie, Preis und Zustand.';

  @override
  String get seoPrivacyTitle => 'Datenschutzerklärung | Sağlam Spot';

  @override
  String get seoTermsTitle => 'Nutzungsbedingungen | Sağlam Spot';

  @override
  String get howItWorksEyebrow => 'ABLAUF';

  @override
  String get whyUsEyebrow => 'VORTEILE';
}
