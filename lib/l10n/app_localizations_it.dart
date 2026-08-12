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

  @override
  String get testimonialsHeading => 'Cosa Dicono i Nostri Clienti';

  @override
  String get testimonialsSubheading =>
      'Da oltre 20 anni tocchiamo migliaia di case a İçerenköy e dintorni';

  @override
  String get testimonial1Comment =>
      'Abbiamo preso il divano a un ottimo prezzo, quasi come nuovo. Consegnato lo stesso giorno, di persona — si sentiva davvero la fiducia di un vero artigiano fin dall\'inizio.';

  @override
  String get testimonial2Comment =>
      'Ho comprato il set camera da letto qui a prezzo speciale. Corrispondeva esattamente alla descrizione, nessuna sorpresa. Lo consiglio vivamente.';

  @override
  String get testimonial3Comment =>
      'Abbiamo fatto un acquisto di mobili in blocco per il nostro ufficio, prezzo e qualità hanno superato le aspettative. Un team premuroso e paziente — grazie, Sağlam Spot.';

  @override
  String get testimonial4Comment =>
      'Abbiamo comprato il set del tavolo da pranzo a un prezzo onesto, senza trattative. Ci hanno anche aiutato col trasporto, abbiamo fatto acquisti con serenità.';

  @override
  String get testimonial5Comment =>
      'Cercavamo un armadio usato e abbiamo trovato un pezzo solido ed elegante. Il miglior rapporto qualità-prezzo sul mercato.';

  @override
  String get testimonial6Comment =>
      'Durante la visita allo showroom abbiamo potuto vedere i prodotti dal vivo, il che ha rafforzato la nostra fiducia. Sono sempre stati raggiungibili anche dopo la vendita.';

  @override
  String get howItWorksHeading => 'Come Funziona';

  @override
  String get step1Title => 'Sfoglia e Filtra';

  @override
  String get step1Desc =>
      'Trova ciò che ti piace tra migliaia di prodotti per categoria e fascia di prezzo.';

  @override
  String get step2Title => 'Contattaci';

  @override
  String get step2Desc =>
      'Raggiungi il nostro team su WhatsApp o al telefono direttamente dalla pagina prodotto.';

  @override
  String get step3Title => 'Concorda il Prezzo';

  @override
  String get step3Desc =>
      'Vedilo nello showroom o confermalo con foto, e accordati su un prezzo giusto e onesto.';

  @override
  String get step4Title => 'Consegna a Casa Tua';

  @override
  String get step4Desc =>
      'Trasporto rapido e assicurato a İçerenköy e nel lato anatolico porta i tuoi mobili a casa in sicurezza.';

  @override
  String get tipsEyebrow => 'CONSIGLI';

  @override
  String get tipsHeading => 'Consigli di Cura dal Nostro Esperto';

  @override
  String get tip1Title => 'Rendi il Salotto più Accogliente';

  @override
  String get tip1Desc =>
      'Lascia 1-2 cm di spazio tra il divano e la parete; favorisce la circolazione dell\'aria e rende la stanza più ariosa.';

  @override
  String get tip1Category => 'Disposizione';

  @override
  String get tip2Title => 'Una Scrivania Sempre in Ordine';

  @override
  String get tip2Desc =>
      'Ordina i cavi con degli organizer e pulisci con un panno in microfibra con movimenti circolari — la scrivania resterà sempre come nuova.';

  @override
  String get tip2Category => 'Pulizia';

  @override
  String get tip3Title => 'Una Cucina Organizzata con Piacere';

  @override
  String get tip3Desc =>
      'Metti gli oggetti pesanti sui ripiani bassi e quelli di uso quotidiano all\'altezza degli occhi — pratico e sicuro allo stesso tempo.';

  @override
  String get tip3Category => 'Organizzazione';

  @override
  String get tip4Title => 'Crea un Angolo Notte Confortevole';

  @override
  String get tip4Desc =>
      'Posiziona la testiera lontano dalla finestra per ridurre la luce — un piccolo cambiamento per un sonno notevolmente più profondo.';

  @override
  String get tip4Category => 'Comfort';

  @override
  String get tip5Title => 'Dai Nuova Vita al Tuo Armadio';

  @override
  String get tip5Desc =>
      'Separa i vestiti stagionali, appendi tutto nella stessa direzione — risparmi spazio e ogni mattina scegliere è più facile.';

  @override
  String get tip5Category => 'Organizzazione';

  @override
  String get tip6Title => 'Allunga la Vita ai Mobili in Legno';

  @override
  String get tip6Desc =>
      'Proteggili dalla luce solare diretta, passaci un olio nutriente qualche volta all\'anno — la cura più efficace contro graffi e scoloriture.';

  @override
  String get tip6Category => 'Cura';

  @override
  String get tip7Title => 'Fai Durare più a Lungo i Divani in Tessuto';

  @override
  String get tip7Desc =>
      'Passa l\'aspirapolvere ogni settimana, tampona subito le macchie con un panno umido — aspettare fa penetrare la macchia nel tessuto.';

  @override
  String get tip7Category => 'Cura';

  @override
  String get tip8Title => 'Scegli l\'Illuminazione Giusta';

  @override
  String get tip8Desc =>
      'Usa un\'illuminazione a più livelli invece di un\'unica lampada a soffitto: luce generale, funzionale e d\'atmosfera insieme rendono la stanza più calda.';

  @override
  String get tip8Category => 'Illuminazione';

  @override
  String get tip9Title => 'Sfrutta al Meglio gli Spazi Piccoli';

  @override
  String get tip9Desc =>
      'Scegli mobili pieghevoli e multiuso; le mensole a parete liberano spazio a terra.';

  @override
  String get tip9Category => 'Organizzazione';

  @override
  String get tip10Title => 'Trasforma il Tuo Balcone in uno Spazio Living';

  @override
  String get tip10Desc =>
      'Un set da esterno resistente alle intemperie e qualche pianta in vaso rendono il balcone l\'angolo più amato della casa.';

  @override
  String get tip10Category => 'Esterni';

  @override
  String get popularCategoriesHeading => 'Categorie Popolari';

  @override
  String get popularCategoriesSub =>
      'Trova il mobile giusto per te in un click';

  @override
  String categoryProductCount(int count) {
    return '$count prodotti';
  }

  @override
  String get newsletterSubscribeSuccess =>
      'Ti sei iscritto con successo alla nostra newsletter!';

  @override
  String get newsletterHeading => 'Scopri per Primo i Nuovi Prodotti';

  @override
  String get newsletterDesc =>
      'Ricevi offerte speciali, nuove collezioni e promozioni direttamente nella tua casella email. Niente spam, solo offerte utili.';

  @override
  String get emailHint => 'Il tuo indirizzo email';

  @override
  String get emailRequired => 'L\'email è obbligatoria';

  @override
  String get emailInvalid => 'Inserisci un indirizzo email valido';

  @override
  String get whyUsHeading => 'Perché Sağlam Spot?';

  @override
  String get usp1Title => '20 Anni di Artigianato di Fiducia';

  @override
  String get usp1Desc =>
      'Oltre vent\'anni come artigiani a İçerenköy e migliaia di clienti soddisfatti.';

  @override
  String get usp2Title => 'Prezzi Sotto il Mercato';

  @override
  String get usp2Desc =>
      'Grazie al nostro modello senza intermediari, abbiamo i migliori prezzi su mobili nuovi e in offerta.';

  @override
  String get usp3Title => 'Qualità del Prodotto Controllata';

  @override
  String get usp3Desc =>
      'Ogni prodotto passa un controllo strutturale e del tessuto/finitura prima della vendita.';

  @override
  String get usp4Title => 'Assistenza Post-Vendita';

  @override
  String get usp4Desc =>
      'Un team reale, raggiungibile anche dopo la consegna, che risolve il tuo problema.';

  @override
  String get socialShowcaseEyebrow => 'CONDIVIDI';

  @override
  String get socialShowcaseHeading => 'Condividi il Tuo Setup con #SağlamSpot';

  @override
  String productsLoadError(String error) {
    return 'Si è verificato un errore durante il caricamento dei prodotti: $error';
  }

  @override
  String get viewAllButton => 'Vedi Tutti';

  @override
  String get showcaseEyebrow => 'VETRINA';

  @override
  String get exploreButton => 'Esplora';

  @override
  String get visitUsEyebrow => 'VIENI A TROVARCI';

  @override
  String get visitUsHeading => 'Basta un Saluto';

  @override
  String visitUsOpenLine(String hours) {
    return 'La nostra porta è sempre aperta. $hours';
  }

  @override
  String get directionsButton => 'Ottieni Indicazioni';

  @override
  String get freeDeliveryLabel => 'Consegna Gratuita';

  @override
  String get busLinesLabel => 'Linee di Autobus';

  @override
  String get statYearsSuffix => '+ Anni';

  @override
  String get storeAddress => 'İçerenköy, Ataşehir/İstanbul';

  @override
  String get stayUpdated => 'Resta Aggiornato';

  @override
  String get viewButton => 'Vedi';

  @override
  String get heroSlide2Eyebrow => 'USATO';

  @override
  String get heroSlide2Title => 'Mobili con una Storia';

  @override
  String get heroSlide2Subtitle =>
      'Pezzi usati solidi e caratteristici, selezionati con cura.';

  @override
  String get heroSlide3Title => 'Scopri l\'Intera Collezione';

  @override
  String get aboutBadge => 'CON VOI DAL 2012';

  @override
  String get aboutHeroTitle => 'Sağlam Spot\nLa Fiducia che Conosci';

  @override
  String get aboutHeroSubtitle =>
      'Serviamo il nostro quartiere con amore e cura in tutto ciò che facciamo.';

  @override
  String get aboutStoryHeading => 'Chi Siamo? (La Nostra Storia)';

  @override
  String get aboutStoryPara1 =>
      'Il nostro obiettivo è aiutarti a trovare mobili di qualità che diano calore alla tua casa e che ti sembrino davvero giusti. Rendere più belli i tuoi spazi è il nostro lavoro.';

  @override
  String get aboutStoryPara2 =>
      'Tutto è iniziato nel 2012, proprio in questo negozio a İçerenköy. Da allora, il numero di case in cui siamo stati ospitati è cresciuto sempre di più.';

  @override
  String get aboutStoryPara3 =>
      'Oggi, con prodotti sia nuovi che usati accuratamente selezionati, siamo stati ospiti di migliaia di case dei nostri vicini. Cresciamo grazie alla vostra fiducia.';

  @override
  String get aboutStoryStartLabel => 'Fondazione';

  @override
  String get aboutStoryExperienceLabel => 'Anni di Esperienza';

  @override
  String get aboutStorySmilesLabel => 'Volti Felici';

  @override
  String get aboutValuesHeading => 'I Nostri Principi';

  @override
  String get aboutValuesSubheading =>
      'I principi su cui non scendiamo mai a compromessi come artigiani';

  @override
  String get aboutValue1Title => 'Qualità e Cura';

  @override
  String get aboutValue1Desc =>
      'Che sia nuovo o usato, lo scegliamo con cura e te lo offriamo esattamente così.';

  @override
  String get aboutValue2Title => 'Volti Felici';

  @override
  String get aboutValue2Desc =>
      'Per noi, il guadagno più grande è un vicino che lascia il negozio soddisfatto. La vostra soddisfazione viene prima di tutto.';

  @override
  String get aboutValue3Title => 'Rispetto per il Lavoro Artigianale';

  @override
  String get aboutValue3Desc =>
      'I mobili sono un lavoro prezioso. Dando nuova vita ai prodotti usati, proteggiamo sia il vostro budget che l\'ambiente.';

  @override
  String get aboutValue4Title => 'Onestà e Fiducia';

  @override
  String get aboutValue4Desc =>
      'L\'artigianato trasparente e onesto è il nostro valore più grande. Siamo con voi da anni nello stesso luogo.';

  @override
  String get aboutMasterHeading => 'Conosci il Nostro Artigiano';

  @override
  String get aboutMasterBody =>
      'Il nostro artigiano lavora attivamente in questo settore dal 1995 — oltre un quarto di secolo. Ha lavorato per marchi leader (İstikbal), acquisendo una conoscenza profonda di caratteristiche, componenti e segreti dei mobili.\n\nDalla guida per le consegne al montaggio, dall\'accoglienza clienti al trasporto, ha lavorato personalmente in ogni ambito, accumulando un\'esperienza a tutto tondo. Nel 2012 ha deciso di aprire il proprio negozio, portando questa esperienza in Sağlam Spot.\n\nIl suo obiettivo è unire la qualità appresa in quelle grandi aziende con il calore e la cura di un\'attività di quartiere, per offrirvi il miglior servizio possibile.';

  @override
  String get aboutDeliveryHeading =>
      'Il Nostro Servizio di Consegna e Montaggio';

  @override
  String get aboutDeliveryFreeTitle => 'Consegna e Montaggio Gratuiti';

  @override
  String get aboutDeliveryZonesLabel => 'Le Nostre Zone di Servizio Gratuito:';

  @override
  String get aboutDeliveryZonesList =>
      '• Il nostro quartiere İçerenköy\n• Fındıklı, Kayışdağı, Küçükbakkalköy\n• Zone vicine come İnönü e Bostancı Sanayi';

  @override
  String get aboutDeliveryNote =>
      'Nota Importante: Per proteggere la salute del nostro artigiano, purtroppo non possiamo trasportare oggetti ai piani alti in edifici senza ascensore. Grazie per la comprensione.';

  @override
  String get aboutDeliveryPunctual =>
      '⏰ Siamo alla vostra porta all\'ora concordata!';

  @override
  String get aboutTransportHeading => 'Come Raggiungere il Nostro Negozio';

  @override
  String get aboutTransportBusIntro => 'Se Venite in Autobus:';

  @override
  String get aboutBusStop1 => 'Fermata Ziyapaşa (Direzione Kadıköy):';

  @override
  String get aboutBusStop2 => 'Fermata İçerenköy (Direzione Kayışdağı):';

  @override
  String get aboutBusStop3 => 'Fermata İçerenköy (Yeniyol):';

  @override
  String get aboutContactPhoneLabel => 'Telefono (Soluzione Rapida)';

  @override
  String get aboutContactAddressLabel => 'Indirizzo (Vi Aspettiamo per un Tè)';

  @override
  String get aboutContactAddressValue =>
      'İçerenköy Mahallesi\nBuket Sokak No:6';

  @override
  String get aboutContactHoursLabel => 'I Nostri Orari';

  @override
  String get aboutContactHoursValue =>
      'Lun-Sab: 09:00 - 22:00\nDom: 10:00 - 20:00';

  @override
  String get aboutContactHeading => 'Contattaci';

  @override
  String get aboutCallNowButton => 'Chiama Ora';

  @override
  String get aboutViewMapButton => 'Vedi sulla Mappa';

  @override
  String get aboutMapHeading => 'Il Nostro Negozio è Proprio Qui';

  @override
  String get aboutMapSubtext => 'Tocca la mappa per le indicazioni';

  @override
  String get newProductsBadgeEyebrow => 'NUOVA COLLEZIONE';

  @override
  String get newProductsTitle => 'Nuova\nCollezione';

  @override
  String get productsBadgeLabel => 'PRODOTTI';

  @override
  String get breadcrumbHome => 'Home';

  @override
  String get statTotalProducts => 'PRODOTTI TOTALI';

  @override
  String get statCategoryLabel => 'CATEGORIE';

  @override
  String get statConditionValueNew => 'NUOVO';

  @override
  String get statConditionLabel => 'CONDIZIONE';

  @override
  String get statRatingLabel => 'VALUTAZIONE';

  @override
  String get searchBarRichPrefix =>
      'Per una ricerca prodotti dettagliata premi ';

  @override
  String get searchBarRichOr => ' oppure clicca ';

  @override
  String get searchBarRichHereLink => 'QUI';

  @override
  String get searchBarRichSuffix => '.';

  @override
  String get sortNewProductsDefault => 'Più Recenti';

  @override
  String get sortSpotProductsDefault => 'Più Recenti';

  @override
  String get sortPriceLowHigh => 'Prezzo: Crescente';

  @override
  String get sortPriceHighLow => 'Prezzo: Decrescente';

  @override
  String get sortMostPopular => 'Più Popolari';

  @override
  String get spotBadgeEyebrow => 'PRODOTTI IN OFFERTA';

  @override
  String get spotHeroTitle => 'Prodotti\nin Offerta';

  @override
  String get spotDiscountLabel => 'SCONTO';

  @override
  String get statSpotProductLabel => 'Prodotti in Offerta';

  @override
  String get statDiscountLabel => 'Sconto';

  @override
  String get statSupportLabel => 'Assistenza';

  @override
  String get statFreeLabel => 'Gratuito';

  @override
  String get statFreeShippingNote => 'Solo per Zone Vicine, Spedizione';

  @override
  String get statFreeShippingShort => 'Spedizione';

  @override
  String get filtersPanelTitle => 'FILTRI';

  @override
  String get priceRangeSectionTitle => 'FASCIA DI PREZZO';

  @override
  String get clearFiltersButton => 'AZZERA FILTRI';

  @override
  String get tryDifferentFiltersShort => 'Puoi provare filtri diversi';

  @override
  String get spotBadgeTag => 'OFFERTA';

  @override
  String productLoadError(String error) {
    return 'Impossibile caricare il prodotto: $error';
  }

  @override
  String get productSpecConditionNew => 'Prodotto Nuovo';

  @override
  String get productLocationValue => 'İçerenköy, İstanbul';

  @override
  String get sortFeatured => 'In Evidenza';

  @override
  String get sortPriceAsc => 'Prezzo: Crescente';

  @override
  String get sortPriceDesc => 'Prezzo: Decrescente';

  @override
  String get languageSelectorTitle => 'Selezione Lingua';

  @override
  String get languageTooltip => 'Lingua';

  @override
  String get galleryEmptyMessage =>
      'Non sono ancora state aggiunte foto per questo prodotto.';

  @override
  String get productCardNewBadge => 'NUOVO';

  @override
  String get sssHelpCenterBadge => 'CENTRO ASSISTENZA';

  @override
  String get sssHeroTitle => 'Domande\nFrequenti';

  @override
  String get sssHeroSubtitle => 'Risposte a tutto ciò che vuoi sapere';

  @override
  String get sssCategoryAll => 'Tutte';

  @override
  String get sssCategoryGeneral => 'Generale';

  @override
  String get sssCategoryProductService => 'Prodotto e Servizio';

  @override
  String get sssCategoryDelivery => 'Consegna e Montaggio';

  @override
  String get sssCategoryPayment => 'Pagamento e Ordini';

  @override
  String get sssCategoryReturns => 'Resi e Garanzia';

  @override
  String get sssCategorySecondHandBuying => 'Processo di Acquisto dell\'Usato';

  @override
  String get sssPhoneSupportTitle => 'Assistenza Telefonica';

  @override
  String get sssWorkingHoursTitle => 'Orari di Apertura';

  @override
  String get sssWorkingHoursValue => '09:00 - 22:00';

  @override
  String get sssStoreAddressTitle => 'Indirizzo del Negozio';

  @override
  String get sssStoreAddressValue => 'İçerenköy Mahallesi Buket Sok. No:6';

  @override
  String get sssNoAnswerTitle => 'Non Hai Trovato la Risposta?';

  @override
  String get sssNoAnswerSubtitle => 'Puoi Contattarci';

  @override
  String get sssVisitStoreButton => 'Visita il Negozio';

  @override
  String get sssQ1 =>
      'Potete parlarci della vita lavorativa e dell\'esperienza dell\'artigiano?';

  @override
  String get sssA1 =>
      'Il nostro artigiano lavora attivamente in questo settore dal 1995. Ha continuato a svilupparsi fin dai primi passi della sua carriera. Nel corso della sua vita lavorativa, ha ricoperto molti ruoli — guida per le consegne, trasporto, montaggio, accoglienza clienti — acquisendo un\'esperienza a tutto tondo. In particolare, fino al 2010 ha lavorato presso İstikbal, dove ha acquisito una conoscenza approfondita delle caratteristiche, dei componenti e dei segreti dei prodotti. Dopo il 2010, ha lavorato presso il vicino Işık Çeyiz, affinando ulteriormente le sue competenze nel settore. Nel 2012 ha deciso di aprire il proprio negozio artigianale, e da allora ha puntato a mettere al primo posto un servizio di qualità, trasferendo al meglio la propria esperienza ai clienti.';

  @override
  String get sssQ2 => 'Sağlam Spot è affidabile?';

  @override
  String get sssA2 =>
      'Dal 2012 serviamo i nostri vicini a İçerenköy. Siamo stati ospiti di innumerevoli case e continuiamo a esserlo.';

  @override
  String get sssQ3 => 'Posso venire nel vostro negozio per vedere i prodotti?';

  @override
  String get sssA3 =>
      'Certo! Anzi, lo consigliamo espressamente. Vedere i prodotti dal vivo, toccarli e sentire se fanno per voi davanti a un tè è la cosa più sana da fare. Vi aspettiamo sempre nel nostro negozio nel quartiere İçerenköy.';

  @override
  String get sssQ4 =>
      'Come viene controllata la condizione dei prodotti usati?';

  @override
  String get sssA4 =>
      'Per noi, usato non significa \'qualità inferiore\'. Ogni prodotto passa dal controllo meticoloso del nostro artigiano; pulizia, manutenzione e riparazioni necessarie vengono eseguite completamente. Quello che vedete nelle foto è quello che ottenete, ma diciamo comunque \'venite a vederlo di persona\'. Vederlo con i propri occhi è sempre la cosa migliore.';

  @override
  String get sssQ5 => 'Qual è la qualità dei materiali dei mobili?';

  @override
  String get sssA5 =>
      'Teniamo alla trasparenza. Ogni prodotto ha la sua storia e i suoi materiali. Per questo scriviamo chiaramente tutti i dettagli, la qualità dei materiali e le caratteristiche nella descrizione del prodotto. Se avete qualche dubbio, non esitate a chiedere.';

  @override
  String get sssQ6 => 'Come vengono determinati i prezzi dei prodotti?';

  @override
  String get sssA6 =>
      'Nel fissare i nostri prezzi, guardiamo con equità sia alla qualità del prodotto sia alle condizioni di mercato. Il nostro obiettivo è farvi accedere a prodotti di qualità e duraturi senza pesare sul vostro budget. Chiediamo ciò che è giusto, niente di più.';

  @override
  String get sssQ7 => 'I vostri prodotti hanno opzioni di colore?';

  @override
  String get sssA7 =>
      'Poiché i nostri prodotti sono generalmente pezzi unici e occasionali, li offriamo nel colore disponibile. Purtroppo non possiamo offrire colori diversi. Il colore che vi piace è il colore che vedete.';

  @override
  String get sssQ8 => 'Accettate ordini personalizzati?';

  @override
  String get sssA8 =>
      'Vorremmo poterlo fare! Ma ci concentriamo principalmente sui nostri prodotti esistenti, scelti con cura. Purtroppo al momento non possiamo accettare ordini di produzione o design personalizzati. Vi consigliamo di dare un\'occhiata ai prodotti già disponibili.';

  @override
  String get sssQ9 =>
      'A cosa devo prestare attenzione nelle descrizioni dei prodotti?';

  @override
  String get sssA9 =>
      'Il nostro consiglio più importante: il metro! Vi preghiamo di confrontare attentamente le misure nella descrizione del prodotto con lo spazio in cui lo metterete in casa. Risolvere la domanda \'ci starà?\' fin dall\'inizio previene problemi in seguito. Inoltre, non dimenticate il corridoio quando misurate: misurate non solo dove metterete il mobile, ma anche come passerà dalla porta, dal corridoio e dalle scale. Leggete anche assolutamente le informazioni su materiale e condizione.';

  @override
  String get sssQ10 => 'Consegnate in edifici senza ascensore o ai piani alti?';

  @override
  String get sssA10 =>
      'Questo è uno degli argomenti più delicati e importanti per noi. Siamo un piccolo artigiano che svolge il lavoro di persona. Il nostro artigiano, dopo anni di esperienza, non è più giovane, quindi dobbiamo pensare anche alla sua salute. Chiediamo la vostra comprensione: in edifici senza ascensore, ai piani alti (per esempio dal 2° piano in su), non possiamo assolutamente offrire il servizio di trasporto oggetti su e giù. Chiariamo questo punto prima di ordinare, non vorremmo mettervi in imbarazzo.';

  @override
  String get sssQ11 => 'Fornite un servizio di trasporto?';

  @override
  String get sssA11 =>
      'Certo, aiutiamo i nostri vicini. Abbiamo un servizio di trasporto gratuito soprattutto per İçerenköy, così come per le zone vicine di Fındıklı, Kayışdağı, Küçükbakkalköy, İnönü e Bostancı Sanayi. (Escluse alcune zone di Bostancı e Kozyatağı, e per motivi di età non possiamo trasportare ai piani alti senza ascensore, ne parliamo separatamente).';

  @override
  String get sssQ12 => 'Quanto tempo richiede la consegna?';

  @override
  String get sssA12 =>
      'Non appena effettuate l\'ordine, vi contattiamo. Vi chiediamo \'quando siete disponibili?\'. Ci accordiamo sull\'orario più vicino che va bene a entrambi. Di solito completiamo consegna e montaggio entro 1-3 giorni, all\'orario concordato.';

  @override
  String get sssQ13 => 'Offrite un servizio di montaggio?';

  @override
  String get sssA13 =>
      'Certo. Prendere il mobile e lasciarlo alla porta non è il nostro stile. Tutti i prodotti grandi vengono montati personalmente dal nostro artigiano e non chiediamo un sovrapprezzo per questo servizio. Voi indicate solo il posto, al resto pensiamo noi.';

  @override
  String get sssQ14 => 'In quanto tempo viene consegnato un ordine di mobili?';

  @override
  String get sssA14 =>
      'Se il prodotto è pronto, siamo alla vostra porta il prima possibile, all\'orario che concordiamo insieme. Non preoccupatevi nemmeno del montaggio; lo montiamo così come lo portiamo e lo consegniamo pronto. Di solito tutto si conclude nello stesso giorno.';

  @override
  String get sssQ15 => 'Posso ordinare a credito / pagare dopo?';

  @override
  String get sssA15 =>
      'Vi chiediamo comprensione su questo punto. Come artigiani, per poter andare avanti, purtroppo non possiamo lavorare con metodi come \'a credito\' o \'paga dopo\'. Dobbiamo ricevere l\'importo concordato in contanti al momento della consegna del prodotto. Preferiamo dichiarare questa regola fin dall\'inizio per non mettervi in imbarazzo.';

  @override
  String get sssQ16 => 'Come posso effettuare un ordine?';

  @override
  String get sssA16 =>
      'Il metodo più sicuro è sempre quello di persona. Prendete nota del prodotto che vi piace sul sito, poi venite nel nostro negozio. Vedete il prodotto dal vivo, fate le domande che avete in mente, e se vi convince, completiamo l\'ordine lì. Così non resta alcun dubbio.';

  @override
  String get sssQ17 => 'Qual è la vostra politica di reso?';

  @override
  String get sssA17 =>
      'Per la natura dei prodotti usati e per il modo in cui lavoriamo come artigiani, purtroppo non possiamo accettare resi. Per questo insistiamo: \'venite, guardate, prendete un tè con noi\'. La cosa più giusta è esaminare il prodotto nel dettaglio e misurarlo prima di acquistarlo. Non concludiamo l\'acquisto senza essere sicuri.';

  @override
  String get sssQ18 => 'C\'è un periodo di garanzia per i prodotti?';

  @override
  String get sssA18 =>
      'Poiché i nostri prodotti sono usati, purtroppo non abbiamo un periodo di garanzia ufficiale come offrirebbe un marchio. Ma non siamo del tipo che dice \'venduto, finita lì\'. Ci assicuriamo che tutto funzioni correttamente durante consegna e montaggio.';

  @override
  String get sssQ19 =>
      'Voglio vendere oggetti di casa mia, acquistate l\'usato?';

  @override
  String get sssA19 =>
      'Sì, acquistiamo prodotti selezionati che riteniamo di poter esporre nel nostro negozio, puliti e rivendibili. Tuttavia, poiché lo spazio del nostro negozio è davvero molto piccolo, purtroppo dobbiamo essere molto selettivi su questo.\n\nCi teniamo a essere onesti fin dall\'inizio: l\'offerta che riceverete da noi potrebbe essere leggermente inferiore a quanto potreste ottenere vendendo voi stessi su piattaforme come Letgo. Il motivo è questo: come artigiani, consumiamo benzina per ritirare l\'oggetto, ci impegniamo nel trasporto e, soprattutto, ci occupiamo dell\'intero processo con il cliente (trattative, domande ecc.) per esporlo e venderlo nel nostro negozio.\n\nQuando vendete voi stessi su quelle piattaforme, vi assumete voi tutti questi processi. Noi invece ve li togliamo dalle spalle. La nostra offerta include anche questo servizio. Grazie per la comprensione.';

  @override
  String get sssQ20 =>
      'Acquistate set completi di mobili (camera da letto, salotto ecc.)?';

  @override
  String get sssA20 =>
      'Poiché il nostro negozio è piccolo, purtroppo non possiamo acquistare set completi grandi come camera da letto o salotto. Il nostro spazio è molto limitato. Ci concentriamo maggiormente su pezzi singoli, più facili da vendere, come consolle, armadi, tavoli e sedie.';

  @override
  String get sssQ21 =>
      'I miei oggetti sono a un piano alto e l\'edificio non ha ascensore. Li acquistereste comunque?';

  @override
  String get sssA21 =>
      'Proprio come per la consegna, questa è la nostra regola più chiara. A causa della salute del nostro artigiano, non possiamo assolutamente scendere oggetti da piani alti in edifici senza ascensore. Possiamo prenderlo in considerazione solo se i vostri oggetti sono vicini al piano terra/ingresso o se l\'edificio ha un montacarichi.';

  @override
  String get sssQ22 => 'Acquistate sempre oggetti?';

  @override
  String get sssA22 =>
      'Dipende interamente dallo spazio che abbiamo nel negozio in quel momento. Poiché il nostro negozio è piccolo, operiamo con un equilibrio \'vendi-compra\'. A volte un prodotto ci piace molto ma non possiamo prenderlo perché non abbiamo spazio. La cosa migliore è inviarci le foto del prodotto che volete vendere. Vi diremo onestamente se \'abbiamo spazio ora\' oppure se \'purtroppo siamo al completo in questo periodo\'.';

  @override
  String get navDiscover => 'Scopri';

  @override
  String get navCart => 'Carrello';

  @override
  String get navProfile => 'Profilo';

  @override
  String get storeHeroEyebrow => 'NUOVA COLLEZIONE';

  @override
  String get storeHeroTitle => 'Mobili che sembrano\ncasa tua';

  @override
  String get storeHeroSubtitle =>
      'Mobili nuovi e usati di qualità, consegnati a casa tua a prezzi che amerai.';

  @override
  String get storeHeroCta => 'Inizia lo shopping';

  @override
  String get sectionCategories => 'Categorie';

  @override
  String get sectionBestSellers => 'Più Venduti';

  @override
  String get sectionNewArrivals => 'Nuovi Arrivi';

  @override
  String get seeAll => 'Vedi Tutto';

  @override
  String get cartTitle => 'Il Mio Carrello';

  @override
  String get cartEmptyTitle => 'Il carrello è vuoto';

  @override
  String get cartEmptyDesc =>
      'Aggiungi i prodotti che ti piacciono, poi chiedi informazioni con un solo messaggio.';

  @override
  String get cartTotalLabel => 'Totale';

  @override
  String get cartWhatsappCta => 'Invia carrello su WhatsApp';

  @override
  String get cartItemRemoved => 'Rimosso dal carrello';

  @override
  String get addToCartCta => 'Aggiungi al Carrello';

  @override
  String get addedToCartMessage => 'Aggiunto al carrello';

  @override
  String get alreadyInCartMessage => 'Già nel carrello';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsLanguageLabel => 'Lingua';

  @override
  String get settingsAccountSection => 'Account';

  @override
  String get settingsGeneralSection => 'Generale';

  @override
  String get settingsContact => 'Contatti';

  @override
  String get settingsCallUs => 'Chiamaci';

  @override
  String get settingsAdminLogin => 'Accesso Amministratore';

  @override
  String get settingsAppVersion => 'Versione App';

  @override
  String cartItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count articoli',
      one: '1 articolo',
      zero: 'Carrello vuoto',
    );
    return '$_temp0';
  }

  @override
  String get settingsRateApp => 'Valuta l\'app';

  @override
  String get settingsShareApp => 'Condividi l\'app';

  @override
  String get settingsPrivacyPolicy => 'Informativa sulla Privacy';

  @override
  String get settingsTerms => 'Termini e Condizioni';

  @override
  String get legalContentTurkishOnly =>
      'Questo contenuto è attualmente disponibile solo in turco.';

  @override
  String get doubleBackToExit => 'Premi di nuovo indietro per uscire';

  @override
  String get productLinkLabel => 'Link al prodotto';

  @override
  String get settingsAppSection => 'App';

  @override
  String get settingsLegalSection => 'Legale';

  @override
  String get recentlyViewedTitle => 'Visti di Recente';
}
