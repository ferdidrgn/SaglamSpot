// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get brand => 'SAĞLAM SPOT';

  @override
  String get home => 'Home';

  @override
  String get searchHint => 'Cosa stavi cercando per casa tua?...';

  @override
  String get collection => 'COLLEZIONE';

  @override
  String get eleganceAndComfort => 'Eleganza e comfort';

  @override
  String productsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count prodotti trovati',
      one: '1 prodotto trovato',
      zero: 'Nessun prodotto trovato',
    );
    return '$_temp0';
  }

  @override
  String resultsFor(String query) {
    return 'Risultati per \"$query\"';
  }

  @override
  String get seoHomeTitle => 'Sağlam Spot | Mobili usati e nuovi';

  @override
  String get seoHomeDesc =>
      'I migliori prezzi su mobili usati e nuovi. Con la garanzia di 20 anni di attività.';

  @override
  String get seoNewTitle => 'Prodotti nuovi | Sağlam Spot';

  @override
  String get seoNewDesc => 'Collezione di mobili nuovi garantita e di qualità.';

  @override
  String get seoSpotTitle => 'Prodotti usati | Sağlam Spot';

  @override
  String get seoSpotDesc => 'Opzioni di mobili usati economiche e di qualità.';

  @override
  String get seoAboutTitle => 'Chi siamo | Sağlam Spot';

  @override
  String get seoAboutDesc =>
      'L\'indirizzo della fiducia nel settore dei mobili con i nostri 20 anni di esperienza.';

  @override
  String get seoProductDetailSuffix => 'Visualizza prodotto | Sağlam Spot';

  @override
  String get category => 'Categoria';

  @override
  String get categorySofa => 'Salotti';

  @override
  String get categoryChair => 'Sedia';

  @override
  String get categoryTable => 'Tavolo';

  @override
  String get categoryBed => 'Camera da letto';

  @override
  String get categoryWardrobe => 'Armadio';

  @override
  String get categoryWhite => 'Elettrodomestici';

  @override
  String get categoryOther => 'Altro';

  @override
  String get condition => 'Condizione';

  @override
  String get conditionAll => 'Tutti';

  @override
  String get conditionNew => 'Nuovo';

  @override
  String get conditionUsed => 'Usato';

  @override
  String get priceRange => 'Fascia di prezzo';

  @override
  String get price => 'Prezzo';

  @override
  String get save => 'Salva';

  @override
  String get explanation => 'Descrizione';

  @override
  String get clear => 'Cancella';

  @override
  String get filter => 'Filtra';

  @override
  String get apply => 'Applica';

  @override
  String get cancel => 'Annulla';

  @override
  String get newSeason => 'NUOVA STAGIONE';

  @override
  String get heroTitle => 'Minimalista\nIl vertice del comfort';

  @override
  String get viewCollection => 'VEDI COLLEZIONE';

  @override
  String get featureArtisan => 'Artigianalità sincera';

  @override
  String get featureDelivery => 'Consegna sicura';

  @override
  String get featureService => 'Servizio cordiale';

  @override
  String get featureShipping => 'Spedizione rapida';

  @override
  String get quickOptions => 'Opzioni rapide';

  @override
  String get easyFind => 'Trova facilmente il prodotto che cerchi';

  @override
  String get mottoBrand => 'Rinnova il vecchio, valorizza il nuovo';

  @override
  String get newCollection => 'Nuova collezione';

  @override
  String get newCollectionSub => 'Prodotti più recenti';

  @override
  String get spotProducts => 'Prodotti usati';

  @override
  String get spotProductsSub => 'Prodotti in offerta';

  @override
  String get spotProductsDesc => 'Prezzi incredibili su prodotti di qualità';

  @override
  String get currentCollection => 'COLLEZIONE ATTUALE';

  @override
  String get soldProducts => 'PRODOTTI VENDUTI';

  @override
  String pieces(int count) {
    return '$count Pezzi';
  }

  @override
  String get stock => 'DISPONIBILE';

  @override
  String get sold => 'VENDUTO';

  @override
  String get byRoom => 'Per ambiente';

  @override
  String get byRoomSub =>
      'Selezioni speciali per ogni angolo della vostra casa';

  @override
  String get roomLivingRoom => 'Soggiorno';

  @override
  String get roomLivingRoomSub => 'Il centro del comfort';

  @override
  String get roomBedroom => 'Camera da letto';

  @override
  String get roomBedroomSub => 'Sonno tranquillo';

  @override
  String get roomKitchen => 'Cucina';

  @override
  String get roomKitchenSub => 'Soluzioni pratiche';

  @override
  String get roomOffice => 'Ufficio';

  @override
  String get roomOfficeSub => 'Lavoro efficiente';

  @override
  String get whoWeAre => 'CHI SIAMO?';

  @override
  String get artisanTitle =>
      '20 anni di sincera artigianalità,\nservizio moderno.';

  @override
  String get artisanDesc =>
      'Venite nel nostro negozio, prendiamo un tè insieme; scegliamo insieme il mobile più adatto a voi.';

  @override
  String get visitUsButton => 'VISITACI';

  @override
  String get statHappyCustomer => 'Cliente felice';

  @override
  String get statExperience => 'Esperienza';

  @override
  String get statDelivery => 'Consegna';

  @override
  String get statTrust => 'Fiducia';

  @override
  String get explore => 'ESPLORA';

  @override
  String get collections => 'Collezioni';

  @override
  String get corporate => 'AZIENDA';

  @override
  String get aboutUs => 'Chi siamo';

  @override
  String get contact => 'Contatti';

  @override
  String get contactUs => 'CONTATTACI';

  @override
  String get sss => 'FAQ';

  @override
  String get qualityFurniture =>
      '\'L\'indirizzo dei mobili di qualità è Sağlam Spot\'';

  @override
  String get footerDesc =>
      'Con oltre 20 anni di esperienza, portiamo qualità e fiducia in ogni angolo di Istanbul.';

  @override
  String get allRightsReserved =>
      '© 2026 SAĞLAM SPOT TİCARET. TUTTI I DIRITTI RISERVATI.';

  @override
  String get errorOccurred => 'Si è verificato un errore';

  @override
  String get productNotFound => 'Prodotto non trovato';

  @override
  String get noImages => 'Nessuna immagine';

  @override
  String get error_check_connection => 'Controlla la tua connessione internet.';

  @override
  String get error_server_no_response => 'Il server non risponde al momento.';

  @override
  String get error_connection => 'Errore di connessione';

  @override
  String get error_connection_lost => 'Connessione persa';

  @override
  String get status_waiting_connection => 'In attesa di connessione...';

  @override
  String get error_no_internet_auto_retry =>
      'Nessuna connessione internet.\nSi continuerà automaticamente quando la connessione sarà ripristinata.';

  @override
  String get goBack => 'Torna indietro';

  @override
  String get galleryEmpty => 'Galleria vuota';

  @override
  String get month_1 => 'Gennaio';

  @override
  String get month_2 => 'Febbraio';

  @override
  String get month_3 => 'Marzo';

  @override
  String get month_4 => 'Aprile';

  @override
  String get month_5 => 'Maggio';

  @override
  String get month_6 => 'Giugno';

  @override
  String get month_7 => 'Luglio';

  @override
  String get month_8 => 'Agosto';

  @override
  String get month_9 => 'Settembre';

  @override
  String get month_10 => 'Ottobre';

  @override
  String get month_11 => 'Novembre';

  @override
  String get month_12 => 'Dicembre';

  @override
  String get noProductFoundTitle =>
      'Nessun prodotto trovato con questi criteri';

  @override
  String get noProductFoundDescription =>
      'Puoi provare filtri diversi o modificare il termine di ricerca';

  @override
  String get adminPanelTitle => 'Pannello di amministrazione';

  @override
  String get totalCount => 'Totale';

  @override
  String get productAddedSuccess => 'Prodotto aggiunto con successo';

  @override
  String get authOrConnectionError =>
      'Si è verificato un errore di autorizzazione o connessione';

  @override
  String get fillRequiredFields =>
      'Inserisci nome prodotto, prezzo e almeno un\'immagine!';

  @override
  String get sessionClosed => 'Sessione chiusa';

  @override
  String get addNewProduct => 'Aggiungi nuovo prodotto';

  @override
  String get productImages => 'Immagini prodotto';

  @override
  String get generalInfo => 'Informazioni generali';

  @override
  String get productNameLabel => 'Nome prodotto';

  @override
  String get descriptionLabel => 'Descrizione';

  @override
  String get statusLabel => 'Stato';

  @override
  String get spotSecondHand => 'Spot / Usato';

  @override
  String get secondHandHint =>
      'Pezzo unico — le opzioni colore non saranno mostrate';

  @override
  String get newProductHint =>
      'Prodotto nuovo — puoi aggiungere opzioni colore';

  @override
  String get colorOptionsOptional => 'Opzioni colore (opzionale)';

  @override
  String get noImagesYet => 'Nessuna immagine ancora aggiunta';

  @override
  String get addImage => 'Aggiungi immagine';

  @override
  String get editProductTitle => 'Modifica prodotto';

  @override
  String get changeImages => 'Cambia immagini';

  @override
  String get saveChanges => 'Salva modifiche';

  @override
  String get deleteProductTitle => 'Elimina prodotto';

  @override
  String get deleteProductConfirmSuffix => 'verrà eliminato. Sei sicuro?';

  @override
  String get yesDelete => 'Sì, elimina';

  @override
  String get emptyCategoryProducts =>
      'Nessun prodotto trovato in questa categoria';

  @override
  String get adminLoginSubtitle => 'Accesso al pannello di amministrazione';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Accedi';

  @override
  String get sponsored => 'Sponsorizzato';

  @override
  String get addProductFab => 'Aggiungi prodotto';

  @override
  String get singlePieceNotice =>
      'Questo è un prodotto usato/spot — è disponibile un solo pezzo in magazzino, colore e aspetto sono esattamente come nelle foto.';

  @override
  String get colorOptionsTitle => 'Opzioni colore';

  @override
  String get newProductBadge => 'PRODOTTO NUOVO';

  @override
  String get usedProductBadge => 'USATO';

  @override
  String get readMore => 'Continua a leggere';

  @override
  String get readLess => 'Mostra meno';

  @override
  String get specDelivery => 'Consegna';

  @override
  String get specDeliveryValue => 'In 1-2 giorni';

  @override
  String get specLocation => 'Posizione';

  @override
  String get sellerTrustLine =>
      '20 anni di fiducia da commerciante locale · İçerenköy';

  @override
  String get whatsappCta => 'Scrivi su WhatsApp';

  @override
  String get callCta => 'Chiama';

  @override
  String get similarProducts => 'Prodotti simili';

  @override
  String get conditionShowcase => 'Vetrina';

  @override
  String get productDescriptionTitle => 'Descrizione';

  @override
  String get loginBrand => 'Sağlam Spot';

  @override
  String get logout => 'Esci';

  @override
  String get logoutConfirm =>
      'Sei sicuro di voler uscire in sicurezza dal tuo account?';
}
