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
}
