// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get brand => 'SAĞLAM SPOT';

  @override
  String get home => 'Αρχική';

  @override
  String get searchHint => 'Τι ψάχνατε για το σπίτι σας;...';

  @override
  String get collection => 'ΣΥΛΛΟΓΗ';

  @override
  String get eleganceAndComfort => 'Κομψότητα & Άνεση';

  @override
  String productsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Βρέθηκαν $count προϊόντα',
      one: 'Βρέθηκε 1 προϊόν',
      zero: 'Δεν βρέθηκαν προϊόντα',
    );
    return '$_temp0';
  }

  @override
  String resultsFor(String query) {
    return 'Αποτελέσματα για «$query»';
  }

  @override
  String get seoHomeTitle =>
      'Sağlam Spot | Μεταχειρισμένα και καινούργια έπιπλα';

  @override
  String get seoHomeDesc =>
      'Οι καλύτερες τιμές σε μεταχειρισμένα και καινούργια έπιπλα. Με εγγύηση 20 ετών επιχείρησης.';

  @override
  String get seoNewTitle => 'Καινούργια προϊόντα | Sağlam Spot';

  @override
  String get seoNewDesc =>
      'Εγγυημένη και ποιοτική συλλογή καινούργιων επίπλων.';

  @override
  String get seoSpotTitle => 'Μεταχειρισμένα προϊόντα | Sağlam Spot';

  @override
  String get seoSpotDesc =>
      'Οικονομικές και ποιοτικές επιλογές μεταχειρισμένων επίπλων.';

  @override
  String get seoAboutTitle => 'Σχετικά με εμάς | Sağlam Spot';

  @override
  String get seoAboutDesc =>
      'Η διεύθυνση εμπιστοσύνης στον κλάδο επίπλων με την 20ετή εμπειρία μας.';

  @override
  String get seoProductDetailSuffix => 'Προβολή προϊόντος | Sağlam Spot';

  @override
  String get category => 'Κατηγορία';

  @override
  String get categorySofa => 'Καναπέδες';

  @override
  String get categoryChair => 'Καρέκλα';

  @override
  String get categoryTable => 'Τραπέζι';

  @override
  String get categoryBed => 'Υπνοδωμάτιο';

  @override
  String get categoryWardrobe => 'Ντουλάπα';

  @override
  String get categoryWhite => 'Οικιακές συσκευές';

  @override
  String get categoryOther => 'Άλλο';

  @override
  String get condition => 'Κατάσταση';

  @override
  String get conditionAll => 'Όλα';

  @override
  String get conditionNew => 'Καινούργιο';

  @override
  String get conditionUsed => 'Μεταχειρισμένο';

  @override
  String get priceRange => 'Εύρος τιμών';

  @override
  String get price => 'Τιμή';

  @override
  String get save => 'Αποθήκευση';

  @override
  String get explanation => 'Περιγραφή';

  @override
  String get clear => 'Καθαρισμός';

  @override
  String get filter => 'Φιλτράρισμα';

  @override
  String get apply => 'Εφαρμογή';

  @override
  String get cancel => 'Ακύρωση';

  @override
  String get newSeason => 'ΝΕΑ ΣΕΖΟΝ';

  @override
  String get heroTitle => 'Μινιμαλιστικό\nΗ κορυφή της άνεσης';

  @override
  String get viewCollection => 'ΔΕΙΤΕ ΤΗ ΣΥΛΛΟΓΗ';

  @override
  String get featureArtisan => 'Ειλικρινής μαστοριά';

  @override
  String get featureDelivery => 'Ασφαλής παράδοση';

  @override
  String get featureService => 'Φιλική εξυπηρέτηση';

  @override
  String get featureShipping => 'Ταχεία αποστολή';

  @override
  String get quickOptions => 'Γρήγορες επιλογές';

  @override
  String get easyFind => 'Βρείτε εύκολα το προϊόν που ψάχνετε';

  @override
  String get mottoBrand => 'Ανανεώνει το παλιό, αξιοποιεί το καινούργιο';

  @override
  String get newCollection => 'Νέα συλλογή';

  @override
  String get newCollectionSub => 'Τα πιο πρόσφατα προϊόντα';

  @override
  String get spotProducts => 'Μεταχειρισμένα προϊόντα';

  @override
  String get spotProductsSub => 'Προϊόντα προσφοράς';

  @override
  String get spotProductsDesc => 'Απίστευτες τιμές σε ποιοτικά προϊόντα';

  @override
  String get currentCollection => 'ΤΡΕΧΟΥΣΑ ΣΥΛΛΟΓΗ';

  @override
  String get soldProducts => 'ΠΩΛΗΜΕΝΑ ΠΡΟΪΟΝΤΑ';

  @override
  String pieces(int count) {
    return '$count Τεμάχια';
  }

  @override
  String get stock => 'ΣΕ ΑΠΟΘΕΜΑ';

  @override
  String get sold => 'ΠΩΛΗΘΗΚΕ';

  @override
  String get byRoom => 'Ανά χώρο';

  @override
  String get byRoomSub => 'Ειδικές επιλογές για κάθε γωνιά του σπιτιού σας';

  @override
  String get roomLivingRoom => 'Σαλόνι';

  @override
  String get roomLivingRoomSub => 'Το κέντρο της άνεσης';

  @override
  String get roomBedroom => 'Υπνοδωμάτιο';

  @override
  String get roomBedroomSub => 'Ήσυχος ύπνος';

  @override
  String get roomKitchen => 'Κουζίνα';

  @override
  String get roomKitchenSub => 'Πρακτικές λύσεις';

  @override
  String get roomOffice => 'Γραφείο';

  @override
  String get roomOfficeSub => 'Αποδοτική εργασία';

  @override
  String get whoWeAre => 'ΠΟΙΟΙ ΕΙΜΑΣΤΕ;';

  @override
  String get artisanTitle =>
      '20 χρόνια ειλικρινούς μαστοριάς,\nμοντέρνη εξυπηρέτηση.';

  @override
  String get artisanDesc =>
      'Ελάτε στο κατάστημά μας, πιείτε ένα τσάι μαζί μας· ας επιλέξουμε μαζί το πιο κατάλληλο έπιπλο για εσάς.';

  @override
  String get visitUsButton => 'ΕΠΙΣΚΕΦΘΕΙΤΕ ΜΑΣ';

  @override
  String get statHappyCustomer => 'Ευχαριστημένος πελάτης';

  @override
  String get statExperience => 'Εμπειρία';

  @override
  String get statDelivery => 'Παράδοση';

  @override
  String get statTrust => 'Εμπιστοσύνη';

  @override
  String get explore => 'ΕΞΕΡΕΥΝΗΣΗ';

  @override
  String get collections => 'Συλλογές';

  @override
  String get corporate => 'ΕΤΑΙΡΕΙΑ';

  @override
  String get aboutUs => 'Σχετικά με εμάς';

  @override
  String get contact => 'Επικοινωνία';

  @override
  String get contactUs => 'ΕΠΙΚΟΙΝΩΝΗΣΤΕ ΜΑΖΙ ΜΑΣ';

  @override
  String get sss => 'Συχνές ερωτήσεις';

  @override
  String get qualityFurniture =>
      '\'Η διεύθυνση ποιοτικών επίπλων είναι το Sağlam Spot\'';

  @override
  String get footerDesc =>
      'Με πάνω από 20 χρόνια εμπειρίας, φέρνουμε ποιότητα και εμπιστοσύνη σε κάθε γωνιά της Κωνσταντινούπολης.';

  @override
  String get allRightsReserved =>
      '© 2026 SAĞLAM SPOT TİCARET. ΜΕ ΕΠΙΦΥΛΑΞΗ ΠΑΝΤΟΣ ΔΙΚΑΙΩΜΑΤΟΣ.';

  @override
  String get errorOccurred => 'Παρουσιάστηκε σφάλμα';

  @override
  String get productNotFound => 'Το προϊόν δεν βρέθηκε';

  @override
  String get noImages => 'Χωρίς εικόνες';

  @override
  String get error_check_connection => 'Ελέγξτε τη σύνδεση σας στο διαδίκτυο.';

  @override
  String get error_server_no_response =>
      'Ο διακομιστής δεν ανταποκρίνεται αυτή τη στιγμή.';

  @override
  String get error_connection => 'Σφάλμα σύνδεσης';

  @override
  String get error_connection_lost => 'Η σύνδεση χάθηκε';

  @override
  String get status_waiting_connection => 'Αναμονή σύνδεσης...';

  @override
  String get error_no_internet_auto_retry =>
      'Δεν υπάρχει σύνδεση στο διαδίκτυο.\nΘα συνεχίσει αυτόματα μόλις αποκατασταθεί η σύνδεση.';

  @override
  String get goBack => 'Πίσω';

  @override
  String get galleryEmpty => 'Η συλλογή είναι άδεια';

  @override
  String get month_1 => 'Ιανουάριος';

  @override
  String get month_2 => 'Φεβρουάριος';

  @override
  String get month_3 => 'Μάρτιος';

  @override
  String get month_4 => 'Απρίλιος';

  @override
  String get month_5 => 'Μάιος';

  @override
  String get month_6 => 'Ιούνιος';

  @override
  String get month_7 => 'Ιούλιος';

  @override
  String get month_8 => 'Αύγουστος';

  @override
  String get month_9 => 'Σεπτέμβριος';

  @override
  String get month_10 => 'Οκτώβριος';

  @override
  String get month_11 => 'Νοέμβριος';

  @override
  String get month_12 => 'Δεκέμβριος';

  @override
  String get noProductFoundTitle => 'Δεν βρέθηκε προϊόν με αυτά τα κριτήρια';

  @override
  String get noProductFoundDescription =>
      'Δοκιμάστε διαφορετικά φίλτρα ή αλλάξτε τον όρο αναζήτησης';

  @override
  String get adminPanelTitle => 'Πίνακας διαχείρισης';

  @override
  String get totalCount => 'Σύνολο';

  @override
  String get productAddedSuccess => 'Το προϊόν προστέθηκε με επιτυχία';

  @override
  String get authOrConnectionError =>
      'Παρουσιάστηκε σφάλμα εξουσιοδότησης ή σύνδεσης';

  @override
  String get fillRequiredFields =>
      'Προσθέστε όνομα προϊόντος, τιμή και τουλάχιστον μία εικόνα!';

  @override
  String get sessionClosed => 'Η συνεδρία έκλεισε';

  @override
  String get addNewProduct => 'Προσθήκη νέου προϊόντος';

  @override
  String get productImages => 'Εικόνες προϊόντος';

  @override
  String get generalInfo => 'Γενικές πληροφορίες';

  @override
  String get productNameLabel => 'Όνομα προϊόντος';

  @override
  String get descriptionLabel => 'Περιγραφή';

  @override
  String get statusLabel => 'Κατάσταση';

  @override
  String get spotSecondHand => 'Σποτ / Μεταχειρισμένο';

  @override
  String get secondHandHint =>
      'Μοναδικό κομμάτι — δεν θα εμφανίζονται επιλογές χρώματος';

  @override
  String get newProductHint =>
      'Καινούργιο προϊόν — μπορείτε να προσθέσετε επιλογές χρώματος';

  @override
  String get colorOptionsOptional => 'Επιλογές χρώματος (προαιρετικό)';

  @override
  String get noImagesYet => 'Δεν έχουν προστεθεί ακόμη εικόνες';

  @override
  String get addImage => 'Προσθήκη εικόνας';

  @override
  String get editProductTitle => 'Επεξεργασία προϊόντος';

  @override
  String get changeImages => 'Αλλαγή εικόνων';

  @override
  String get saveChanges => 'Αποθήκευση αλλαγών';

  @override
  String get deleteProductTitle => 'Διαγραφή προϊόντος';

  @override
  String get deleteProductConfirmSuffix => 'θα διαγραφεί. Είστε σίγουροι;';

  @override
  String get yesDelete => 'Ναι, διαγραφή';

  @override
  String get emptyCategoryProducts =>
      'Δεν βρέθηκαν προϊόντα σε αυτή την κατηγορία';

  @override
  String get adminLoginSubtitle => 'Σύνδεση στον πίνακα διαχείρισης';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Κωδικός πρόσβασης';

  @override
  String get loginButton => 'Σύνδεση';

  @override
  String get sponsored => 'Χορηγούμενο';

  @override
  String get addProductFab => 'Προσθήκη προϊόντος';

  @override
  String get singlePieceNotice =>
      'Αυτό είναι μεταχειρισμένο προϊόν — υπάρχει μόνο ένα κομμάτι σε απόθεμα, το χρώμα και η εμφάνιση είναι ακριβώς όπως στις φωτογραφίες.';

  @override
  String get colorOptionsTitle => 'Επιλογές χρώματος';

  @override
  String get newProductBadge => 'ΚΑΙΝΟΥΡΓΙΟ ΠΡΟΪΟΝ';

  @override
  String get usedProductBadge => 'ΜΕΤΑΧΕΙΡΙΣΜΕΝΟ';

  @override
  String get readMore => 'Διαβάστε περισσότερα';

  @override
  String get readLess => 'Λιγότερα';

  @override
  String get specDelivery => 'Παράδοση';

  @override
  String get specDeliveryValue => 'Εντός 1-2 ημερών';

  @override
  String get specLocation => 'Τοποθεσία';

  @override
  String get sellerTrustLine =>
      '20 χρόνια αξιόπιστης τοπικής επιχείρησης · İçerenköy';

  @override
  String get whatsappCta => 'Γράψτε στο WhatsApp';

  @override
  String get callCta => 'Κλήση';

  @override
  String get similarProducts => 'Παρόμοια προϊόντα';

  @override
  String get conditionShowcase => 'Έκθεση';

  @override
  String get productDescriptionTitle => 'Περιγραφή';

  @override
  String get loginBrand => 'Sağlam Spot';

  @override
  String get logout => 'Αποσύνδεση';

  @override
  String get logoutConfirm =>
      'Είστε σίγουροι ότι θέλετε να αποσυνδεθείτε με ασφάλεια από τον λογαριασμό σας;';

  @override
  String get testimonialsHeading => 'Τι Λένε οι Πελάτες μας';

  @override
  String get testimonialsSubheading =>
      'Εδώ και πάνω από 20 χρόνια έχουμε αγγίξει χιλιάδες σπίτια στο İçerenköy και τη γύρω περιοχή';

  @override
  String get testimonial1Comment =>
      'Πήραμε τον καναπέ σε πολύ καλή τιμή, σχεδόν σαν καινούριο. Η παράδοση έγινε αυθημερόν, από χέρι σε χέρι — η εμπιστοσύνη του πραγματικού τεχνίτη ήταν εμφανής από την αρχή.';

  @override
  String get testimonial2Comment =>
      'Αγόρασα το σετ υπνοδωματίου εδώ σε τιμή προσφοράς. Ταίριαζε ακριβώς με την περιγραφή του προϊόντος, καμία έκπληξη. Το συστήνω ανεπιφύλακτα.';

  @override
  String get testimonial3Comment =>
      'Κάναμε ομαδική αγορά επίπλων για το γραφείο μας, τόσο η τιμή όσο και η ποιότητα ξεπέρασαν τις προσδοκίες μας. Μια προσεκτική, υπομονετική ομάδα — ευχαριστούμε, Sağlam Spot.';

  @override
  String get testimonial4Comment =>
      'Αγοράσαμε το σετ τραπεζαρίας σε τίμια τιμή χωρίς παζάρια. Μας βοήθησαν και με τη μεταφορά, ψωνίσαμε με απόλυτη ηρεμία.';

  @override
  String get testimonial5Comment =>
      'Ψάχναμε μεταχειρισμένη ντουλάπα και βρήκαμε ένα στιβαρό και κομψό κομμάτι. Η καλύτερη σχέση ποιότητας-τιμής στην αγορά.';

  @override
  String get testimonial6Comment =>
      'Κατά την επίσκεψή μας στο κατάστημα είδαμε τα προϊόντα από κοντά, κάτι που ενίσχυσε την εμπιστοσύνη μας. Ήταν πάντα διαθέσιμοι και μετά την πώληση.';

  @override
  String get howItWorksHeading => 'Πώς Λειτουργεί';

  @override
  String get step1Title => 'Περιήγηση & Φιλτράρισμα';

  @override
  String get step1Desc =>
      'Βρες αυτό που σου αρέσει ανάμεσα σε χιλιάδες προϊόντα, ανά κατηγορία και εύρος τιμής.';

  @override
  String get step2Title => 'Επικοινώνησε μαζί μας';

  @override
  String get step2Desc =>
      'Επικοινώνησε με την ομάδα μας μέσω WhatsApp ή τηλεφώνου, απευθείας από τη σελίδα του προϊόντος.';

  @override
  String get step3Title => 'Επιβεβαίωσε την Τιμή';

  @override
  String get step3Desc =>
      'Δες το στο κατάστημά μας ή επιβεβαίωσέ το με φωτογραφίες, και συμφωνήστε σε μια δίκαιη τιμή.';

  @override
  String get step4Title => 'Παράδοση στην Πόρτα σου';

  @override
  String get step4Desc =>
      'Γρήγορη, ασφαλισμένη μεταφορά στο İçerenköy και την ασιατική πλευρά φέρνει τα έπιπλά σου με ασφάλεια στο σπίτι σου.';

  @override
  String get tipsEyebrow => 'ΣΥΜΒΟΥΛΕΣ';

  @override
  String get tipsHeading => 'Συμβουλές Φροντίδας από τον Ειδικό';

  @override
  String get tip1Title => 'Κάντε το Σαλόνι σας Πιο Αγαπητό';

  @override
  String get tip1Desc =>
      'Αφήστε 1-2 εκ. απόσταση ανάμεσα στον καναπέ και τον τοίχο — βοηθά στην κυκλοφορία του αέρα και κάνει το δωμάτιο πιο ανάλαφρο.';

  @override
  String get tip1Category => 'Τοποθέτηση';

  @override
  String get tip2Title => 'Ένας Χώρος Εργασίας που Φαίνεται Πάντα Καθαρός';

  @override
  String get tip2Desc =>
      'Τακτοποιήστε τα καλώδια με οργανωτές και σκουπίστε με πανί μικροϊνών με κυκλικές κινήσεις — το γραφείο σας μένει σαν καινούριο.';

  @override
  String get tip2Category => 'Καθαριότητα';

  @override
  String get tip3Title => 'Μια Ευχάριστη Διάταξη Κουζίνας';

  @override
  String get tip3Desc =>
      'Βάλτε τα βαριά αντικείμενα στα κάτω ράφια και τα καθημερινά στο ύψος των ματιών — πρακτικό και ασφαλές.';

  @override
  String get tip3Category => 'Οργάνωση';

  @override
  String get tip4Title => 'Δημιουργήστε μια Άνετη Γωνιά Ύπνου';

  @override
  String get tip4Desc =>
      'Τοποθετήστε το κεφαλάρι μακριά από το παράθυρο για να ελαχιστοποιήσετε το φως — μια μικρή αλλαγή για αισθητά βαθύτερο ύπνο.';

  @override
  String get tip4Category => 'Άνεση';

  @override
  String get tip5Title => 'Δώστε Ζωντάνια στην Ντουλάπα σας';

  @override
  String get tip5Desc =>
      'Ξεχωρίστε τα εποχιακά ρούχα, κρεμάστε τα όλα προς την ίδια κατεύθυνση — εξοικονομεί χώρο και διευκολύνει την επιλογή κάθε πρωί.';

  @override
  String get tip5Category => 'Οργάνωση';

  @override
  String get tip6Title => 'Προσθέστε Χρόνια στα Ξύλινα Έπιπλά σας';

  @override
  String get tip6Desc =>
      'Προστατέψτε τα από την άμεση ηλιακή ακτινοβολία, σκουπίστε με θρεπτικό λάδι μερικές φορές τον χρόνο — η πιο αποτελεσματική φροντίδα ενάντια σε γρατζουνιές και ξεθώριασμα.';

  @override
  String get tip6Category => 'Φροντίδα';

  @override
  String get tip7Title => 'Κάντε τους Υφασμάτινους Καναπέδες πιο Ανθεκτικούς';

  @override
  String get tip7Desc =>
      'Σκουπίστε με ηλεκτρική σκούπα εβδομαδιαία, καθαρίστε τους λεκέδες αμέσως με υγρό πανί — η αναμονή αφήνει τον λεκέ να εισχωρήσει στο ύφασμα.';

  @override
  String get tip7Category => 'Φροντίδα';

  @override
  String get tip8Title => 'Επιλέξτε τον Σωστό Φωτισμό';

  @override
  String get tip8Desc =>
      'Χρησιμοποιήστε φωτισμό σε επίπεδα αντί για ένα μόνο φωτιστικό οροφής: γενικός, εργασίας και ατμόσφαιρας φωτισμός μαζί κάνουν το δωμάτιο πιο ζεστό.';

  @override
  String get tip8Category => 'Φωτισμός';

  @override
  String get tip9Title => 'Χρησιμοποιήστε Έξυπνα τους Μικρούς Χώρους';

  @override
  String get tip9Desc =>
      'Προτιμήστε πτυσσόμενα, πολυχρηστικά έπιπλα· τα επιτοίχια ράφια ελευθερώνουν χώρο δαπέδου.';

  @override
  String get tip9Category => 'Οργάνωση';

  @override
  String get tip10Title => 'Μετατρέψτε το Μπαλκόνι σας σε Χώρο Διαβίωσης';

  @override
  String get tip10Desc =>
      'Ένα ανθεκτικό στις καιρικές συνθήκες σετ καθιστικού και μερικά γλαστράκια κάνουν το μπαλκόνι την πιο αγαπημένη γωνιά του σπιτιού.';

  @override
  String get tip10Category => 'Εξωτερικός Χώρος';

  @override
  String get popularCategoriesHeading => 'Δημοφιλείς Κατηγορίες';

  @override
  String get popularCategoriesSub => 'Βρες το κατάλληλο έπιπλο με ένα κλικ';

  @override
  String categoryProductCount(int count) {
    return '$count προϊόντα';
  }

  @override
  String get newsletterSubscribeSuccess =>
      'Εγγραφήκατε με επιτυχία στο newsletter μας!';

  @override
  String get newsletterHeading => 'Μάθετε Πρώτοι για τα Νέα Προϊόντα';

  @override
  String get newsletterDesc =>
      'Λάβετε προσφορές, νέες συλλογές και καμπάνιες απευθείας στο email σας. Χωρίς spam, μόνο ό,τι σας συμφέρει.';

  @override
  String get emailHint => 'Το email σας';

  @override
  String get emailRequired => 'Το email είναι υποχρεωτικό';

  @override
  String get emailInvalid => 'Εισάγετε ένα έγκυρο email';

  @override
  String get whyUsHeading => 'Γιατί Sağlam Spot;';

  @override
  String get usp1Title => '20 Χρόνια Αξιόπιστης Τεχνογνωσίας';

  @override
  String get usp1Desc =>
      'Πάνω από είκοσι χρόνια τεχνίτης στο İçerenköy και χιλιάδες ικανοποιημένοι πελάτες.';

  @override
  String get usp2Title => 'Τιμές Κάτω από την Αγορά';

  @override
  String get usp2Desc =>
      'Χωρίς μεσάζοντες, προσφέρουμε τις καλύτερες τιμές σε νέα και μεταχειρισμένα έπιπλα.';

  @override
  String get usp3Title => 'Ελεγμένη Ποιότητα Προϊόντων';

  @override
  String get usp3Desc =>
      'Κάθε προϊόν περνά από δομικό έλεγχο και έλεγχο υφάσματος/φινιρίσματος πριν διατεθεί προς πώληση.';

  @override
  String get usp4Title => 'Υποστήριξη Μετά την Πώληση';

  @override
  String get usp4Desc =>
      'Μια πραγματική ομάδα, προσβάσιμη ακόμη και μετά την παράδοση, που λύνει το πρόβλημά σας.';

  @override
  String get socialShowcaseEyebrow => 'ΜΟΙΡΑΣΟΥ';

  @override
  String get socialShowcaseHeading => 'Μοιράσου τον Χώρο σου με #SağlamSpot';

  @override
  String productsLoadError(String error) {
    return 'Παρουσιάστηκε σφάλμα κατά τη φόρτωση των προϊόντων: $error';
  }

  @override
  String get viewAllButton => 'Δείτε Όλα';

  @override
  String get showcaseEyebrow => 'ΒΙΤΡΙΝΑ';

  @override
  String get exploreButton => 'Εξερεύνηση';

  @override
  String get visitUsEyebrow => 'ΕΠΙΣΚΕΦΘΕΙΤΕ ΜΑΣ';

  @override
  String get visitUsHeading => 'Απλά Πείτε Γεια';

  @override
  String visitUsOpenLine(String hours) {
    return 'Η πόρτα μας είναι πάντα ανοιχτή. $hours';
  }

  @override
  String get directionsButton => 'Λήψη Οδηγιών';

  @override
  String get freeDeliveryLabel => 'Δωρεάν Παράδοση';

  @override
  String get busLinesLabel => 'Γραμμές Λεωφορείων';

  @override
  String get statYearsSuffix => '+ Χρόνια';

  @override
  String get storeAddress => 'İçerenköy, Ataşehir/İstanbul';

  @override
  String get stayUpdated => 'Μείνε Ενημερωμένος';

  @override
  String get viewButton => 'Προβολή';

  @override
  String get heroSlide2Eyebrow => 'ΜΕΤΑΧΕΙΡΙΣΜΕΝΑ';

  @override
  String get heroSlide2Title => 'Έπιπλα με Ιστορία';

  @override
  String get heroSlide2Subtitle =>
      'Προσεκτικά επιλεγμένα, στιβαρά μεταχειρισμένα κομμάτια με χαρακτήρα.';

  @override
  String get heroSlide3Title => 'Εξερευνήστε Όλη τη Συλλογή';

  @override
  String get aboutBadge => 'ΜΑΖΙ ΣΑΣ ΑΠΟ ΤΟ 2012';

  @override
  String get aboutHeroTitle => 'Sağlam Spot\nΗ Εμπιστοσύνη που Ξέρετε';

  @override
  String get aboutHeroSubtitle =>
      'Εξυπηρετούμε τη γειτονιά μας με αγάπη και φροντίδα σε ό,τι κάνουμε.';

  @override
  String get aboutStoryHeading => 'Ποιοι Είμαστε; (Η Ιστορία μας)';

  @override
  String get aboutStoryPara1 =>
      'Στόχος μας είναι να σας βοηθήσουμε να βρείτε ποιοτικά έπιπλα που φέρνουν ζεστασιά στο σπίτι σας και σας ταιριάζουν πραγματικά. Η ομορφιά των χώρων διαβίωσής σας είναι η δουλειά μας.';

  @override
  String get aboutStoryPara2 =>
      'Όλα ξεκίνησαν το 2012, σε αυτό ακριβώς το κατάστημα στο İçerenköy. Από τότε, ο αριθμός των σπιτιών που φιλοξενηθήκαμε συνεχώς αυξάνεται.';

  @override
  String get aboutStoryPara3 =>
      'Σήμερα, με νέα αλλά και προσεκτικά επιλεγμένα μεταχειρισμένα κομμάτια, έχουμε φιλοξενηθεί σε χιλιάδες σπίτια γειτόνων μας. Μεγαλώνουμε χάρη στην εμπιστοσύνη σας.';

  @override
  String get aboutStoryStartLabel => 'Ίδρυση';

  @override
  String get aboutStoryExperienceLabel => 'Χρόνια Εμπειρίας';

  @override
  String get aboutStorySmilesLabel => 'Χαμογελαστά Πρόσωπα';

  @override
  String get aboutValuesHeading => 'Οι Αρχές μας';

  @override
  String get aboutValuesSubheading =>
      'Οι αρχές στις οποίες δεν κάνουμε ποτέ συμβιβασμούς ως τεχνίτες';

  @override
  String get aboutValue1Title => 'Ποιότητα και Προσοχή';

  @override
  String get aboutValue1Desc =>
      'Είτε νέο είτε μεταχειρισμένο, το επιλέγουμε προσεκτικά και σας το προσφέρουμε ακριβώς έτσι.';

  @override
  String get aboutValue2Title => 'Χαμογελαστά Πρόσωπα';

  @override
  String get aboutValue2Desc =>
      'Για εμάς, το μεγαλύτερο κέρδος είναι ένας γείτονας που φεύγει ευχαριστημένος από το κατάστημα. Η ικανοποίησή σας έρχεται πρώτη από όλα.';

  @override
  String get aboutValue3Title => 'Σεβασμός στην Εργασία';

  @override
  String get aboutValue3Desc =>
      'Τα έπιπλα είναι πολύτιμη εργασία. Δίνοντας νέα ζωή σε μεταχειρισμένα προϊόντα, προστατεύουμε τόσο τον προϋπολογισμό σας όσο και το περιβάλλον.';

  @override
  String get aboutValue4Title => 'Εντιμότητα και Εμπιστοσύνη';

  @override
  String get aboutValue4Desc =>
      'Η διαφανής, έντιμη τεχνογνωσία είναι η μεγαλύτερή μας αξία. Είμαστε μαζί σας εδώ και χρόνια στην ίδια τοποθεσία.';

  @override
  String get aboutMasterHeading => 'Γνωρίστε τον Τεχνίτη μας';

  @override
  String get aboutMasterBody =>
      'Ο τεχνίτης μας εργάζεται ενεργά σε αυτόν τον κλάδο από το 1995 — πάνω από ένα τέταρτο του αιώνα. Έχει εργαστεί σε κορυφαίες μάρκες (İstikbal), αποκτώντας βαθιά γνώση των χαρακτηριστικών, των εξαρτημάτων και των μυστικών των επίπλων.\n\nΑπό την οδήγηση για παραδόσεις μέχρι τη συναρμολόγηση και την υποδοχή πελατών, εργάστηκε ο ίδιος σε κάθε τομέα, αποκτώντας ολοκληρωμένη εμπειρία. Το 2012, αποφάσισε να ανοίξει το δικό του κατάστημα, μεταφέροντας αυτή την εμπειρία στο Sağlam Spot.\n\nΣτόχος του είναι να συνδυάσει την ποιότητα που έμαθε σε αυτές τις μεγάλες εταιρείες με τη ζεστασιά και την προσοχή μιας γειτονιάς, για να σας προσφέρει την καλύτερη δυνατή εξυπηρέτηση.';

  @override
  String get aboutDeliveryHeading =>
      'Η Υπηρεσία Παράδοσης & Συναρμολόγησής μας';

  @override
  String get aboutDeliveryFreeTitle => 'Δωρεάν Παράδοση & Συναρμολόγηση';

  @override
  String get aboutDeliveryZonesLabel => 'Οι Δωρεάν Περιοχές Εξυπηρέτησής μας:';

  @override
  String get aboutDeliveryZonesList =>
      '• Η γειτονιά μας İçerenköy\n• Fındıklı, Kayışdağı, Küçükbakkalköy\n• Κοντινές γειτονιές όπως το İnönü και το Bostancı Sanayi';

  @override
  String get aboutDeliveryNote =>
      'Σημαντική Σημείωση: Για την προστασία της υγείας του τεχνίτη μας, δυστυχώς δεν μπορούμε να μεταφέρουμε αντικείμενα σε υψηλούς ορόφους σε κτίρια χωρίς ασανσέρ. Ευχαριστούμε για την κατανόησή σας.';

  @override
  String get aboutDeliveryPunctual =>
      '⏰ Είμαστε στην πόρτα σας την ώρα που συμφωνήσαμε!';

  @override
  String get aboutTransportHeading => 'Πώς να Φτάσετε στο Κατάστημά μας';

  @override
  String get aboutTransportBusIntro => 'Αν Έρχεστε με Λεωφορείο:';

  @override
  String get aboutBusStop1 => 'Στάση Ziyapaşa (Κατεύθυνση Kadıköy):';

  @override
  String get aboutBusStop2 => 'Στάση İçerenköy (Κατεύθυνση Kayışdağı):';

  @override
  String get aboutBusStop3 => 'Στάση İçerenköy (Yeniyol):';

  @override
  String get aboutContactPhoneLabel => 'Τηλέφωνο (Γρήγορη Λύση)';

  @override
  String get aboutContactAddressLabel => 'Διεύθυνση (Σας Περιμένουμε για Τσάι)';

  @override
  String get aboutContactAddressValue =>
      'İçerenköy Mahallesi\nBuket Sokak No:6';

  @override
  String get aboutContactHoursLabel => 'Ωράριο Λειτουργίας';

  @override
  String get aboutContactHoursValue =>
      'Δευ-Σαβ: 09:00 - 22:00\nΚυρ: 10:00 - 20:00';

  @override
  String get aboutContactHeading => 'Επικοινωνήστε μαζί μας';

  @override
  String get aboutCallNowButton => 'Καλέστε Τώρα';

  @override
  String get aboutViewMapButton => 'Προβολή στον Χάρτη';

  @override
  String get aboutMapHeading => 'Το Κατάστημά μας Είναι Ακριβώς Εδώ';

  @override
  String get aboutMapSubtext => 'Πατήστε τον χάρτη για οδηγίες';

  @override
  String get newProductsBadgeEyebrow => 'ΝΕΑ ΣΥΛΛΟΓΗ';

  @override
  String get newProductsTitle => 'Νέα\nΣυλλογή';

  @override
  String get productsBadgeLabel => 'ΠΡΟΪΟΝΤΑ';

  @override
  String get breadcrumbHome => 'Αρχική';

  @override
  String get statTotalProducts => 'ΣΥΝΟΛΟ ΠΡΟΪΟΝΤΩΝ';

  @override
  String get statCategoryLabel => 'ΚΑΤΗΓΟΡΙΕΣ';

  @override
  String get statConditionValueNew => 'ΝΕΟ';

  @override
  String get statConditionLabel => 'ΚΑΤΑΣΤΑΣΗ';

  @override
  String get statRatingLabel => 'ΒΑΘΜΟΛΟΓΙΑ';

  @override
  String get searchBarRichPrefix =>
      'Για λεπτομερή αναζήτηση προϊόντων πατήστε ';

  @override
  String get searchBarRichOr => ' ή κάντε κλικ ';

  @override
  String get searchBarRichHereLink => 'ΕΔΩ';

  @override
  String get searchBarRichSuffix => '.';

  @override
  String get sortNewProductsDefault => 'Νεότερα';

  @override
  String get sortSpotProductsDefault => 'Νεότερα';

  @override
  String get sortPriceLowHigh => 'Τιμή: Αύξουσα';

  @override
  String get sortPriceHighLow => 'Τιμή: Φθίνουσα';

  @override
  String get sortMostPopular => 'Πιο Δημοφιλή';

  @override
  String get spotBadgeEyebrow => 'ΠΡΟΪΟΝΤΑ ΠΡΟΣΦΟΡΑΣ';

  @override
  String get spotHeroTitle => 'Προϊόντα\nΠροσφοράς';

  @override
  String get spotDiscountLabel => 'ΕΚΠΤΩΣΗ';

  @override
  String get statSpotProductLabel => 'Προϊόντα Προσφοράς';

  @override
  String get statDiscountLabel => 'Έκπτωση';

  @override
  String get statSupportLabel => 'Υποστήριξη';

  @override
  String get statFreeLabel => 'Δωρεάν';

  @override
  String get statFreeShippingNote => 'Μόνο για Κοντινές Περιοχές, Μεταφορικά';

  @override
  String get statFreeShippingShort => 'Μεταφορικά';

  @override
  String get filtersPanelTitle => 'ΦΙΛΤΡΑ';

  @override
  String get dragToRotateHint => 'Σύρετε για περισσότερες φωτογραφίες';

  @override
  String get studioQuotaExceededNotice =>
      'Το μηνιαίο όριο εικόνων στούντιο συμπληρώθηκε — οι φωτογραφίες προστέθηκαν στην αρχική τους μορφή.';

  @override
  String get studioPreparingWait =>
      'Προετοιμασία φωτογραφίας στούντιο, παρακαλώ περιμένετε...';

  @override
  String get retry => 'Δοκιμάστε ξανά';

  @override
  String get studioGenerationFailed =>
      'Δεν ήταν δυνατή η δημιουργία φωτογραφίας στούντιο';

  @override
  String get storePhotoLabel => 'Κατάστημα';

  @override
  String get studioPhotoLabel => 'Στούντιο';

  @override
  String get onboardingSkip => 'Παράλειψη';

  @override
  String get onboardingStart => 'Ξεκινήστε';

  @override
  String get onboardingPage1Eyebrow => 'ΚΑΛΩΣ ΗΡΘΑΤΕ ΣΤΟ SAĞLAM SPOT';

  @override
  String get onboardingPage1Title => 'Η Σωστή Διεύθυνση\nΓια το Σπίτι σας';

  @override
  String get onboardingPage1Desc =>
      'Με πάνω από 20 χρόνια έμπειρης τεχνογνωσίας, φέρνουμε ποιοτικά έπιπλα στην τσέπη σας.';

  @override
  String get onboardingPage2Eyebrow => 'ΜΕΤΑΧΕΙΡΙΣΜΕΝΑ & ΚΑΙΝΟΥΡΓΙΑ ΜΑΖΙ';

  @override
  String get onboardingPage2Title => 'Επιλογές Για\nΚάθε Προϋπολογισμό';

  @override
  String get onboardingPage2Desc =>
      'Από εξαιρετικές μεταχειρισμένες ευκαιρίες έως τη νέα μας συλλογή — βρείτε εύκολα αυτό που ψάχνετε.';

  @override
  String get onboardingPage3Eyebrow => 'ΑΓΟΡΑΣΤΕ ΜΕ ΕΜΠΙΣΤΟΣΥΝΗ';

  @override
  String get onboardingPage3Title => 'Βρήκατε Κάτι;\nΡωτήστε Τώρα';

  @override
  String get onboardingPage3Desc =>
      'Επικοινωνήστε άμεσα μέσω WhatsApp, ρωτήστε για τιμές και διαπραγματευτείτε απευθείας.';

  @override
  String get favoritesTitle => 'Τα Αγαπημένα μου';

  @override
  String get favoritesEmptyTitle => 'Η λίστα αγαπημένων σας είναι άδεια';

  @override
  String get favoritesEmptyDesc =>
      'Πατήστε το εικονίδιο καρδιάς στα προϊόντα που σας αρέσουν για να τα προσθέσετε στα αγαπημένα σας.';

  @override
  String get sortPanelTitle => 'ΤΑΞΙΝΟΜΗΣΗ';

  @override
  String get priceRangeSectionTitle => 'ΕΥΡΟΣ ΤΙΜΗΣ';

  @override
  String get clearFiltersButton => 'ΚΑΘΑΡΙΣΜΟΣ ΦΙΛΤΡΩΝ';

  @override
  String get tryDifferentFiltersShort =>
      'Μπορείτε να δοκιμάσετε διαφορετικά φίλτρα';

  @override
  String get spotBadgeTag => 'ΠΡΟΣΦΟΡΑ';

  @override
  String productLoadError(String error) {
    return 'Το προϊόν δεν φορτώθηκε: $error';
  }

  @override
  String get productSpecConditionNew => 'Νέο Προϊόν';

  @override
  String get productLocationValue => 'İçerenköy, İstanbul';

  @override
  String get sortFeatured => 'Προτεινόμενα';

  @override
  String get sortPriceAsc => 'Τιμή: Αύξουσα';

  @override
  String get sortPriceDesc => 'Τιμή: Φθίνουσα';

  @override
  String get languageSelectorTitle => 'Επιλογή Γλώσσας';

  @override
  String get languageTooltip => 'Γλώσσα';

  @override
  String get galleryEmptyMessage =>
      'Δεν έχουν προστεθεί ακόμη φωτογραφίες για αυτό το προϊόν.';

  @override
  String get productCardNewBadge => 'ΝΕΟ';

  @override
  String get sssHelpCenterBadge => 'ΚΕΝΤΡΟ ΒΟΗΘΕΙΑΣ';

  @override
  String get sssHeroTitle => 'Συχνές\nΕρωτήσεις';

  @override
  String get sssHeroSubtitle => 'Απαντήσεις σε ό,τι σας απασχολεί';

  @override
  String get sssCategoryAll => 'Όλα';

  @override
  String get sssCategoryGeneral => 'Γενικά';

  @override
  String get sssCategoryProductService => 'Προϊόν & Υπηρεσία';

  @override
  String get sssCategoryDelivery => 'Παράδοση & Συναρμολόγηση';

  @override
  String get sssCategoryPayment => 'Πληρωμή & Παραγγελία';

  @override
  String get sssCategoryReturns => 'Επιστροφές & Εγγύηση';

  @override
  String get sssCategorySecondHandBuying => 'Διαδικασία Αγοράς Μεταχειρισμένων';

  @override
  String get sssPhoneSupportTitle => 'Τηλεφωνική Υποστήριξη';

  @override
  String get sssWorkingHoursTitle => 'Ωράριο Λειτουργίας';

  @override
  String get sssWorkingHoursValue => '09:00 - 22:00';

  @override
  String get sssStoreAddressTitle => 'Διεύθυνση Καταστήματος';

  @override
  String get sssStoreAddressValue => 'İçerenköy Mahallesi Buket Sok. No:6';

  @override
  String get sssNoAnswerTitle => 'Δεν Βρήκατε Απάντηση στην Ερώτησή σας;';

  @override
  String get sssNoAnswerSubtitle => 'Μπορείτε να Επικοινωνήσετε μαζί μας';

  @override
  String get sssVisitStoreButton => 'Επισκεφθείτε το Κατάστημα';

  @override
  String get sssQ1 =>
      'Μπορείτε να μας πείτε για την εργασιακή ζωή και την εμπειρία του τεχνίτη;';

  @override
  String get sssA1 =>
      'Ο τεχνίτης μας εργάζεται ενεργά σε αυτόν τον κλάδο από το 1995. Έχει δείξει συνεχή εξέλιξη από τα πρώτα του βήματα στην καριέρα του. Στη διάρκεια της εργασιακής του ζωής, εργάστηκε σε πολλές θέσεις όπως οδήγηση για παραδόσεις, μεταφορά, συναρμολόγηση, υποδοχή πελατών, αποκτώντας πολύπλευρη εμπειρία. Εργάστηκε ιδιαίτερα μέχρι το 2010 στην İstikbal, αποκτώντας βαθιά γνώση των χαρακτηριστικών, των εξαρτημάτων και των μυστικών των προϊόντων. Μετά το 2010, εργάστηκε στην κοντινή Işık Çeyiz, αυξάνοντας περαιτέρω την επάρκειά του στον κλάδο. Το 2012 αποφάσισε να ανοίξει το δικό του κατάστημα, θέτοντας από τότε την ποιοτική εξυπηρέτηση σε πρώτη προτεραιότητα και μεταφέροντας την εμπειρία του κλάδου στους πελάτες του με τον καλύτερο δυνατό τρόπο.';

  @override
  String get sssQ2 => 'Είναι αξιόπιστο το Sağlam Spot;';

  @override
  String get sssA2 =>
      'Από το 2012 εξυπηρετούμε τους γείτονές μας στο İçerenköy. Φιλοξενηθήκαμε σε αμέτρητα σπίτια και συνεχίζουμε να φιλοξενούμαστε.';

  @override
  String get sssQ3 => 'Μπορώ να έρθω στο κατάστημά σας για να δω τα προϊόντα;';

  @override
  String get sssA3 =>
      'Φυσικά! Μάλιστα το συστήνουμε ιδιαίτερα. Το να βλέπετε τα προϊόντα από κοντά, να τα αγγίζετε και να νιώθετε αν σας ταιριάζουν, ενώ πίνουμε τσάι, είναι το πιο υγιές. Σας περιμένουμε πάντα στο κατάστημά μας στο İçerenköy Mahallesi.';

  @override
  String get sssQ4 =>
      'Πώς ελέγχεται η κατάσταση των μεταχειρισμένων προϊόντων;';

  @override
  String get sssA4 =>
      'Για εμάς, μεταχειρισμένο δεν σημαίνει \'δεύτερη ποιότητα\'. Κάθε προϊόν περνά από τον σχολαστικό έλεγχο του τεχνίτη μας· ο καθαρισμός, η συντήρηση και οι απαραίτητες επισκευές γίνονται πλήρως. Αυτό που βλέπετε στις φωτογραφίες είναι αυτό που θα πάρετε, αλλά εμείς εξακολουθούμε να λέμε \'ελάτε να το δείτε κι εσείς\'. Το να το βλέπετε με τα μάτια σας είναι πάντα το καλύτερο.';

  @override
  String get sssQ5 => 'Ποια είναι η ποιότητα υλικού των επίπλων;';

  @override
  String get sssA5 =>
      'Δίνουμε σημασία στη διαφάνεια. Κάθε προϊόν έχει τη δική του ιστορία και υλικό. Γι\' αυτό γράφουμε όλες τις λεπτομέρειες, την ποιότητα υλικού και τα χαρακτηριστικά ξεκάθαρα στην περιγραφή του προϊόντος. Αν κάτι σας απασχολεί, μη διστάσετε να ρωτήσετε.';

  @override
  String get sssQ6 => 'Πώς καθορίζονται οι τιμές των προϊόντων;';

  @override
  String get sssA6 =>
      'Κατά τον καθορισμό των τιμών μας, λαμβάνουμε δίκαια υπόψη τόσο την ποιότητα του προϊόντος όσο και τις συνθήκες της αγοράς. Στόχος μας είναι να έχετε πρόσβαση σε ποιοτικά, μακράς διαρκείας προϊόντα χωρίς να επιβαρύνετε τον προϋπολογισμό σας. Ζητάμε ό,τι είναι δίκαιο, τίποτα παραπάνω.';

  @override
  String get sssQ7 => 'Υπάρχουν επιλογές χρωμάτων στα προϊόντα σας;';

  @override
  String get sssA7 =>
      'Επειδή τα προϊόντα μας είναι συνήθως μοναδικά κομμάτια, τα προσφέρουμε στο χρώμα που είναι διαθέσιμο. Δυστυχώς δεν μπορούμε να προσφέρουμε διαφορετικές επιλογές χρωμάτων. Το χρώμα που σας αρέσει είναι το χρώμα που βλέπετε.';

  @override
  String get sssQ8 => 'Δέχεστε ειδικές παραγγελίες;';

  @override
  String get sssA8 =>
      'Μακάρι να μπορούσαμε! Ωστόσο, επικεντρωνόμαστε περισσότερο στα υπάρχοντα, προσεκτικά επιλεγμένα προϊόντα μας. Δυστυχώς δεν μπορούμε προς το παρόν να δεχτούμε παραγγελίες ειδικής κατασκευής ή σχεδιασμού. Σας προτείνουμε να δείτε τα έτοιμα προϊόντα μας.';

  @override
  String get sssQ9 => 'Τι πρέπει να προσέξω στις περιγραφές των προϊόντων;';

  @override
  String get sssA9 =>
      'Η πιο σημαντική μας συμβουλή: Μέτρο! Παρακαλούμε συγκρίνετε προσεκτικά τις διαστάσεις στην περιγραφή του προϊόντος με τον χώρο που θα το τοποθετήσετε στο σπίτι σας. Η επίλυση του ερωτήματος \'άραγε χωράει;\' εξαρχής αποτρέπει προβλήματα αργότερα. Επίσης μην ξεχάσετε τον διάδρομο κατά τη μέτρηση: μετρήστε όχι μόνο τον χώρο τοποθέτησης, αλλά και πώς θα περάσει το έπιπλο από την πόρτα, τον διάδρομο και τη σκάλα. Διαβάστε επίσης οπωσδήποτε τις πληροφορίες υλικού και κατάστασης.';

  @override
  String get sssQ10 =>
      'Παραδίδετε σε κτίρια χωρίς ασανσέρ ή σε υψηλούς ορόφους;';

  @override
  String get sssA10 =>
      'Αυτό είναι από τα πιο ευαίσθητα και σημαντικά θέματα για εμάς. Είμαστε ένας μικρός τεχνίτης που κάνει τη δουλειά ο ίδιος. Ο τεχνίτης μας, μετά από χρόνια εμπειρίας, δεν είναι πια νέος, οπότε πρέπει να σκεφτόμαστε και την υγεία του. Ζητάμε την κατανόησή σας ότι σε κτίρια χωρίς ασανσέρ σε υψηλούς ορόφους (π.χ. 2ος όροφος και άνω) δεν μπορούμε καθόλου να προσφέρουμε υπηρεσία μεταφοράς αντικειμένων προς τα πάνω ή κάτω. Ας ξεκαθαρίσουμε αυτό το θέμα πριν κάνετε την παραγγελία σας, δεν θέλουμε να σας φέρουμε σε δύσκολη θέση.';

  @override
  String get sssQ11 => 'Παρέχετε υπηρεσία μεταφοράς;';

  @override
  String get sssA11 =>
      'Φυσικά, βοηθάμε τους γείτονές μας. Έχουμε δωρεάν υπηρεσία μεταφοράς κυρίως στο İçerenköy, καθώς και στις κοντινές περιοχές Fındıklı, Kayışdağı, Küçükbakkalköy, İnönü και Bostancı Sanayi. (Εκτός από ορισμένες περιοχές του Bostancı και του Kozyatağı, και λόγω της ηλικίας δεν μπορούμε να μεταφέρουμε σε υψηλούς ορόφους χωρίς ασανσέρ, αυτό θα το συζητήσουμε ξεχωριστά).';

  @override
  String get sssQ12 => 'Πόσο διαρκεί η παράδοση;';

  @override
  String get sssA12 =>
      'Μόλις κάνετε την παραγγελία, επικοινωνούμε μαζί σας. Ρωτάμε \'πότε είστε διαθέσιμοι;\'. Συμφωνούμε στην πιο κοντινή ώρα που ταιριάζει και στους δύο. Συνήθως ολοκληρώνουμε την παράδοση και τη συναρμολόγηση εντός 1-3 ημερών, στην ώρα που συμφωνήσαμε.';

  @override
  String get sssQ13 => 'Παρέχετε υπηρεσία συναρμολόγησης;';

  @override
  String get sssA13 =>
      'Φυσικά. Το να παίρνουμε το έπιπλο και να το αφήνουμε στην πόρτα δεν είναι το στιλ μας. Όλα τα μεγάλα προϊόντα τα συναρμολογεί ο ίδιος ο τεχνίτης μας και δεν ζητάμε επιπλέον χρέωση για αυτή την υπηρεσία. Εσείς απλώς δείξτε τη θέση, τα υπόλοιπα είναι δικά μας.';

  @override
  String get sssQ14 => 'Σε πόσο χρόνο παραδίδεται μια παραγγελία επίπλων;';

  @override
  String get sssA14 =>
      'Αν το προϊόν είναι έτοιμο, είμαστε στην πόρτα σας το συντομότερο δυνατό, σε μια ώρα που ορίζουμε από κοινού. Μην ανησυχείτε ούτε για τη συναρμολόγηση· το συναρμολογούμε όπως το φέραμε και το παραδίδουμε έτοιμο. Συνήθως όλα ολοκληρώνονται την ίδια μέρα.';

  @override
  String get sssQ15 => 'Μπορώ να παραγγείλω με βεσελί / πληρωμή αργότερα;';

  @override
  String get sssA15 =>
      'Ζητάμε την κατανόησή σας σε αυτό το θέμα. Ως τεχνίτης, για να επιβιώσουμε, δυστυχώς δεν μπορούμε να λειτουργήσουμε με μεθόδους όπως \'βεσελί\' ή \'πληρωμή αργότερα\'. Πρέπει να λάβουμε το συμφωνηθέν ποσό μετρητοίς κατά την παράδοση του προϊόντος. Προτιμούμε να δηλώνουμε αυτόν τον κανόνα εξαρχής για να μη σας φέρουμε σε δύσκολη θέση.';

  @override
  String get sssQ16 => 'Πώς μπορώ να κάνω παραγγελία;';

  @override
  String get sssA16 =>
      'Ο πιο υγιής τρόπος είναι πάντα η δια ζώσης επίσκεψη. Σημειώστε το προϊόν που σας αρέσει από τον ιστότοπο, μετά ελάτε στο κατάστημά μας. Δείτε το προϊόν από κοντά, κάντε τις ερωτήσεις που έχετε στο μυαλό σας, και αν σας ταιριάζει, ας ολοκληρώσουμε την παραγγελία σας εκεί. Έτσι δεν μένει καμία αμφιβολία.';

  @override
  String get sssQ17 => 'Ποια είναι η πολιτική επιστροφών προϊόντων;';

  @override
  String get sssA17 =>
      'Λόγω της φύσης των μεταχειρισμένων προϊόντων και του τρόπου λειτουργίας μας ως τεχνίτης, δυστυχώς δεν μπορούμε να δεχτούμε επιστροφές. Γι\' αυτό επιμένουμε \'ελάτε, δείτε, πιείτε το τσάι μας μαζί\'. Το σωστό είναι να εξετάσετε λεπτομερώς το προϊόν και να το μετρήσετε πριν την αγορά. Ας μην ολοκληρώνουμε την αγορά χωρίς βεβαιότητα.';

  @override
  String get sssQ18 => 'Υπάρχει περίοδος εγγύησης για τα προϊόντα;';

  @override
  String get sssA18 =>
      'Επειδή τα προϊόντα μας είναι μεταχειρισμένα, δυστυχώς δεν έχουμε επίσημη περίοδο εγγύησης όπως προσφέρει μια μάρκα. Ωστόσο δεν είμαστε από αυτούς που λένε \'πουλήσαμε, τέλος\'. Διασφαλίζουμε ότι όλα λειτουργούν σωστά κατά την παράδοση και τη συναρμολόγηση.';

  @override
  String get sssQ19 =>
      'Θέλω να πουλήσω αντικείμενα από το σπίτι μου, αγοράζετε μεταχειρισμένα;';

  @override
  String get sssA19 =>
      'Ναι, αγοράζουμε επιλεγμένα προϊόντα που πιστεύουμε ότι μπορούμε να εκθέσουμε στο κατάστημά μας, καθαρά και επαναπωλήσιμα. Ωστόσο, επειδή ο χώρος του καταστήματός μας είναι πραγματικά πολύ μικρός, είμαστε δυστυχώς αναγκασμένοι να είμαστε πολύ επιλεκτικοί σε αυτό το θέμα.\n\nΘέλουμε να είμαστε ειλικρινείς εξαρχής: η προσφορά που θα λάβετε από εμάς μπορεί να είναι κάπως χαμηλότερη από αυτή που θα μπορούσατε να πουλήσετε οι ίδιοι σε πλατφόρμες όπως το Letgo. Ο λόγος είναι ο εξής: ως τεχνίτης, καίμε βενζίνη για να παραλάβουμε το αντικείμενο, καταβάλλουμε κόπο για τη μεταφορά, και το σημαντικότερο, αναλαμβάνουμε ολόκληρη τη διαδικασία με τον πελάτη (διαπραγμάτευση, ερωτήσεις κτλ.) για να το εκθέσουμε και να το πουλήσουμε στο κατάστημά μας.\n\nΌταν πουλάτε εσείς οι ίδιοι σε αυτές τις πλατφόρμες, αναλαμβάνετε όλες αυτές τις διαδικασίες μόνοι σας. Εμείς αναλαμβάνουμε αυτόν τον κόπο για εσάς. Η προσφορά μας περιλαμβάνει και αυτή την υπηρεσία. Ευχαριστούμε για την κατανόησή σας.';

  @override
  String get sssQ20 =>
      'Αγοράζετε πλήρη σετ επίπλων (υπνοδωμάτιο, σαλόνι κτλ.);';

  @override
  String get sssA20 =>
      'Λόγω του μικρού μεγέθους του καταστήματός μας, δυστυχώς δεν μπορούμε να αγοράσουμε πλήρη, μεγάλα σετ όπως υπνοδωμάτιο ή σαλόνι. Ο χώρος μας είναι πολύ περιορισμένος. Επικεντρωνόμαστε περισσότερο σε μεμονωμένα κομμάτια που πωλούνται πιο εύκολα, όπως κονσόλες, ντουλάπες, τραπέζια και καρέκλες.';

  @override
  String get sssQ21 =>
      'Τα αντικείμενά μου είναι σε υψηλό όροφο και το κτίριο δεν έχει ασανσέρ. Θα τα αγοράσετε;';

  @override
  String get sssA21 =>
      'Όπως ακριβώς και στο θέμα της παράδοσης, αυτός είναι ο πιο σαφής μας κανόνας. Λόγω της υγείας του τεχνίτη μας, δεν μπορούμε καθόλου να κατεβάσουμε αντικείμενα από υψηλούς ορόφους σε κτίρια χωρίς ασανσέρ. Μπορούμε να το εξετάσουμε μόνο αν τα αντικείμενά σας είναι κοντά στο ισόγειο/είσοδο ή αν το κτίριο έχει ασανσέρ φορτίου.';

  @override
  String get sssQ22 => 'Αγοράζετε πάντα αντικείμενα;';

  @override
  String get sssA22 =>
      'Αυτό εξαρτάται εντελώς από τον χώρο που έχουμε διαθέσιμο στο κατάστημά μας. Επειδή το κατάστημά μας είναι μικρό, λειτουργούμε με ισορροπία \'πούλα-αγόρασε\'. Μερικές φορές μας αρέσει πολύ ένα προϊόν αλλά δεν μπορούμε να το πάρουμε επειδή δεν έχουμε χώρο. Το καλύτερο είναι να μας στείλετε φωτογραφίες του προϊόντος που θέλετε να πουλήσετε. Θα σας ενημερώσουμε ειλικρινά αν \'έχουμε χώρο τώρα\' ή αν \'δυστυχώς είμαστε γεμάτοι αυτή την περίοδο\'.';

  @override
  String get navDiscover => 'Ανακάλυψη';

  @override
  String get navCart => 'Καλάθι';

  @override
  String get navProfile => 'Προφίλ';

  @override
  String get storeHeroEyebrow => 'ΝΕΑ ΣΥΛΛΟΓΗ';

  @override
  String get storeHeroTitle => 'Έπιπλα που νιώθονται\nσαν σπίτι';

  @override
  String get storeHeroSubtitle =>
      'Ποιοτικά καινούργια και μεταχειρισμένα έπιπλα, στην πόρτα σας σε τιμές που θα αγαπήσετε.';

  @override
  String get storeHeroCta => 'Ξεκινήστε τις αγορές';

  @override
  String get sectionCategories => 'Κατηγορίες';

  @override
  String get sectionBestSellers => 'Δημοφιλή';

  @override
  String get sectionNewArrivals => 'Νέες Αφίξεις';

  @override
  String get seeAll => 'Δείτε Όλα';

  @override
  String get cartTitle => 'Το Καλάθι μου';

  @override
  String get cartEmptyTitle => 'Το καλάθι σας είναι άδειο';

  @override
  String get cartEmptyDesc =>
      'Προσθέστε προϊόντα που σας αρέσουν και ρωτήστε για όλα με ένα μήνυμα.';

  @override
  String get cartTotalLabel => 'Σύνολο';

  @override
  String get cartWhatsappCta => 'Αποστολή καλαθιού μέσω WhatsApp';

  @override
  String get cartItemRemoved => 'Αφαιρέθηκε από το καλάθι';

  @override
  String get addToCartCta => 'Προσθήκη στο Καλάθι';

  @override
  String get addedToCartMessage => 'Προστέθηκε στο καλάθι';

  @override
  String get alreadyInCartMessage => 'Ήδη στο καλάθι σας';

  @override
  String get settingsTitle => 'Ρυθμίσεις';

  @override
  String get settingsLanguageLabel => 'Γλώσσα';

  @override
  String get settingsAccountSection => 'Λογαριασμός';

  @override
  String get settingsGeneralSection => 'Γενικά';

  @override
  String get settingsContact => 'Επικοινωνία';

  @override
  String get settingsCallUs => 'Καλέστε μας';

  @override
  String get settingsAdminLogin => 'Σύνδεση Διαχειριστή';

  @override
  String get settingsAppVersion => 'Έκδοση Εφαρμογής';

  @override
  String cartItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count προϊόντα',
      one: '1 προϊόν',
      zero: 'Το καλάθι είναι άδειο',
    );
    return '$_temp0';
  }

  @override
  String get settingsRateApp => 'Αξιολογήστε την εφαρμογή';

  @override
  String get settingsShareApp => 'Κοινοποίηση εφαρμογής';

  @override
  String get settingsPrivacyPolicy => 'Πολιτική Απορρήτου';

  @override
  String get settingsTerms => 'Όροι Χρήσης';

  @override
  String get legalContentTurkishOnly =>
      'Αυτό το περιεχόμενο είναι προς το παρόν διαθέσιμο μόνο στα τουρκικά.';

  @override
  String get doubleBackToExit => 'Πατήστε ξανά πίσω για έξοδο';

  @override
  String get productLinkLabel => 'Σύνδεσμος προϊόντος';

  @override
  String get settingsAppSection => 'Εφαρμογή';

  @override
  String get settingsLegalSection => 'Νομικά';

  @override
  String get recentlyViewedTitle => 'Πρόσφατα Προβεβλημένα';

  @override
  String get productTrustBadgeVerified => 'Επαληθευμένος Πωλητής';

  @override
  String get productTrustBadgeNegotiate => 'Διαπραγμάτευση μέσω WhatsApp';

  @override
  String get productTrustBadgeDelivery => 'Παράδοση επί τόπου';

  @override
  String get howToBuyTitle => 'Πώς αγοράζω;';

  @override
  String get howToBuyStep1Title => 'Γράψτε στο WhatsApp';

  @override
  String get howToBuyStep1Desc =>
      'Αν σας αρέσει το προϊόν, επικοινωνήστε μαζί μας μέσω WhatsApp.';

  @override
  String get howToBuyStep2Title => 'Συζητήστε την τιμή';

  @override
  String get howToBuyStep2Desc =>
      'Συμφωνήστε μαζί για την τιμή και τις λεπτομέρειες παράδοσης.';

  @override
  String get howToBuyStep3Title => 'Παραλάβετέ το';

  @override
  String get howToBuyStep3Desc =>
      'Μετά τη συμφωνία, παραλάβετε το προϊόν σας με ασφάλεια.';

  @override
  String get listedToday => 'Καταχωρήθηκε σήμερα';

  @override
  String listedDaysAgo(int days) {
    return 'Καταχωρήθηκε πριν από $days ημέρες';
  }

  @override
  String listedWeeksAgo(int weeks) {
    return 'Καταχωρήθηκε πριν από $weeks εβδομάδες';
  }

  @override
  String get settingsAppearanceSection => 'Εμφάνιση';

  @override
  String get settingsThemeLight => 'Φωτεινό';

  @override
  String get settingsThemeSystem => 'Σύστημα';

  @override
  String get settingsThemeDark => 'Σκοτεινό';

  @override
  String get notificationsTitle => 'Ειδοποιήσεις';

  @override
  String get notificationsEmptyTitle => 'Δεν υπάρχουν ειδοποιήσεις ακόμα';

  @override
  String get notificationsEmptyDesc =>
      'Νέες καμπάνιες και ανακοινώσεις θα εμφανίζονται εδώ';

  @override
  String get markAllReadAction => 'Σήμανση όλων ως αναγνωσμένων';

  @override
  String get clearAllAction => 'Εκκαθάριση όλων';

  @override
  String get timeJustNow => 'Μόλις τώρα';

  @override
  String timeMinutesAgo(int minutes) {
    return 'Πριν από $minutes λεπτά';
  }

  @override
  String timeHoursAgo(int hours) {
    return 'Πριν από $hours ώρες';
  }

  @override
  String timeDaysAgoGeneric(int days) {
    return 'Πριν από $days ημέρες';
  }

  @override
  String get catalogCategoryTitleSofa => 'Καναπές';

  @override
  String get catalogCategoryTitleChair => 'Καρέκλα & Πολυθρόνα';

  @override
  String get catalogCategoryTitleTable => 'Τραπέζι κουζίνας';

  @override
  String get catalogCategoryTitleBed => 'Κρεβάτι & Βάση';

  @override
  String get catalogCategoryTitleWardrobe => 'Ντουλάπα & Ντουλάπι';

  @override
  String get catalogCategoryTitleWhite => 'Οικιακές Συσκευές';

  @override
  String get catalogCategoryTitleOther => 'Διακόσμηση';

  @override
  String get mottoTitlePart1 => 'Δες πριν έρθεις, ';

  @override
  String get mottoTitlePart2 => 'Έλα όταν σου αρέσει.';

  @override
  String get mottoSubtitle =>
      'Δες τη βιτρίνα μας πριν έρθεις στο κατάστημα, και πέρνα όταν βρεις αυτό που θέλεις.';

  @override
  String get gatewayNewEyebrow => 'ΝΕΑ ΣΥΛΛΟΓΗ';

  @override
  String get gatewayNewTitle => 'Διαχρονικά Κομμάτια';

  @override
  String get gatewayNewSubtitle => 'Ολοκαίνουργια, αχρησιμοποίητα έπιπλα.';

  @override
  String get gatewayNewButton => 'Δες τη Συλλογή';

  @override
  String get gatewaySpotEyebrow => 'ΠΡΟΣΦΟΡΕΣ SPOT';

  @override
  String get gatewaySpotTitle => 'Μεταχειρισμένο, αλλά Γερό';

  @override
  String get gatewaySpotSubtitle =>
      'Μεταχειρισμένα αλλά χρηστικά, σε προσιτές τιμές.';

  @override
  String get gatewaySpotButton => 'Δες τις Προσφορές';

  @override
  String freeDeliveryZonesNote(String zones) {
    return 'Η δωρεάν παράδοση ισχύει μόνο στις περιοχές $zones';
  }

  @override
  String get footerWarehouseTagline => 'ΑΠΟΘΗΚΗ ΕΠΙΠΛΩΝ · İÇERENKÖY / ATAŞEHİR';

  @override
  String get locationAndHoursLabel => 'ΤΟΠΟΘΕΣΙΑ & ΩΡΑΡΙΟ';

  @override
  String get openNowLabel => 'ΑΝΟΙΧΤΟ ΤΩΡΑ';

  @override
  String get closedNowLabel => 'ΚΛΕΙΣΤΟ ΤΩΡΑ';

  @override
  String todayHoursPrefix(String hours) {
    return '· Σήμερα $hours';
  }

  @override
  String get openInMapsButton => 'Άνοιγμα στους Χάρτες';

  @override
  String get viewOnGoogleMapsButton => 'Προβολή στους Χάρτες Google';

  @override
  String gatewayProductCount(int count) {
    return '$count προϊόντα';
  }

  @override
  String get gatewayNewEyebrowShort => 'ΝΕΟ';

  @override
  String get gatewayNewTitleShort => 'Συλλογή';

  @override
  String get gatewaySpotEyebrowShort => 'SPOT';

  @override
  String get gatewaySpotTitleShort => 'Προσφορές';

  @override
  String get spotHeroEyebrow => 'ΑΠΟΘΗΚΗ ΠΡΟΣΦΟΡΩΝ';

  @override
  String get spotHeroSubtitle =>
      'Μεταχειρισμένα αλλά χρηστικά. Σαν καινούρια, για κάθε προϋπολογισμό. Χωράει διαπραγμάτευση.';

  @override
  String spotHeroDealCount(int count) {
    return '$count+ Προσφορές';
  }

  @override
  String get spotStatNegotiable => 'Χωράει Διαπραγμάτευση';

  @override
  String get spotStatUsed => 'Μεταχειρισμένο';

  @override
  String get spotShowcaseBadgeTitle => 'Πλήρως Ανακαινισμένο';

  @override
  String get spotShowcaseBadgeSubtitle =>
      'Κάθε προϊόν ελέγχεται ξεχωριστά πριν την παράδοση.';

  @override
  String get spotBreadcrumbLabel => 'Spot & Μεταχειρισμένα';

  @override
  String get aphorismEyebrow => 'ΕΧΟΥΜΕ ΕΝΑ ΡΗΤΟ';

  @override
  String get aphorismQuote =>
      'Όχι φθαρμένο, αλλά αγαπημένο.\nΤα καλά έπιπλα δεν γερνούν ποτέ, απλώς αλλάζουν σπίτι.';

  @override
  String get aphorismBody =>
      'Γι\' αυτό ακριβώς είμαστε εδώ: για να φέρουμε κομμάτια που έχουν ακόμα ζωή σε ένα νέο σπίτι που θα τα εκτιμήσει.';

  @override
  String get spotSearchHint => 'Αναζήτηση προσφορών…';

  @override
  String get priceRangeLabel => 'Εύρος Τιμής';

  @override
  String get filtersSheetTitle => 'ΦΙΛΤΡΑ';

  @override
  String get applyFiltersButton => 'Εφαρμογή Φίλτρων';

  @override
  String get priceRangeSheetTitle => 'ΕΥΡΟΣ ΤΙΜΗΣ';

  @override
  String get applyButton => 'Εφαρμογή';

  @override
  String get sortSheetTitle => 'ΤΑΞΙΝΟΜΗΣΗ';

  @override
  String get sortNewest => 'Νεότερες Προσφορές';

  @override
  String get sortPopular => 'Πιο Δημοφιλή';

  @override
  String get spotEmptyStateTitle => 'Δεν βρήκαμε προσφορές με αυτά τα κριτήρια';

  @override
  String get spotEmptyStateSubtitle =>
      'Δοκίμασε να καθαρίσεις τα φίλτρα ή διαφορετική κατηγορία.';

  @override
  String get newHeroTitleLine1 => 'Για τον Χώρο σας\n';

  @override
  String get newHeroTitleEmphasis => 'Διαχρονική ';

  @override
  String get newHeroButtonCollection => 'Δες τη Συλλογή';

  @override
  String get newHeroButtonQuickFilter => 'Γρήγορο Φίλτρο';

  @override
  String get newStatActiveProductLabel => 'ΕΝΕΡΓΑ ΠΡΟΪΟΝΤΑ';

  @override
  String get newStatControlledStockLabel => 'ΕΛΕΓΜΕΝΟ ΑΠΟΘΕΜΑ';

  @override
  String get shopByCategoryTitlePrefix => 'Ανά Κατηγορία ';

  @override
  String get shopByCategoryTitleEmphasis => 'Εξερεύνησε';

  @override
  String get showAllButton => 'Εμφάνιση Όλων';

  @override
  String get newEmptyStateTitle => 'Δεν Βρέθηκαν Έπιπλα με Αυτά τα Κριτήρια';

  @override
  String get newEmptyStateSubtitle =>
      'Δοκίμασε να αλλάξεις τον όρο αναζήτησης ή να καθαρίσεις τα φίλτρα.';

  @override
  String get sortOptionsSheetTitle => 'Επιλογές Ταξινόμησης';

  @override
  String get newSortNewest => 'Νεότερα';

  @override
  String get newSortPopular => 'Πιο Δημοφιλή';

  @override
  String get cartWhatsappGreeting =>
      'Γεια σας, θα ήθελα πληροφορίες για αυτά τα προϊόντα:\n\n';

  @override
  String cartWhatsappAllProductsLine(String url) {
    return 'Όλα τα προϊόντα: $url';
  }

  @override
  String get defaultWhatsappGreeting =>
      'Γεια σας, θα ήθελα πληροφορίες για τα έπιπλα.';

  @override
  String get spotHeroPageTitle => 'Μεταχειρισμένα & Spot';

  @override
  String get sortByPriceLowHigh => 'Τιμή: Αύξουσα';

  @override
  String get sortByPriceHighLow => 'Τιμή: Φθίνουσα';
}
