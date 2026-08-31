// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get brand => 'SAĞLAM SPOT';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get searchHint => 'Eviniz için ne aramıştınız?...';

  @override
  String get collection => 'KOLEKSİYON';

  @override
  String get eleganceAndComfort => 'Zarafet & Konfor';

  @override
  String productsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Ürün Bulundu',
      one: '1 Ürün Bulundu',
      zero: 'Ürün bulunamadı',
    );
    return '$_temp0';
  }

  @override
  String resultsFor(String query) {
    return '\"$query\" için sonuçlar';
  }

  @override
  String get seoHomeTitle => 'Sağlam Spot | Spot & Sıfır Mobilya';

  @override
  String get seoHomeDesc =>
      'Spot ve sıfır mobilyalarda en uygun fiyatlar. 20 yıllık esnaf güvencesiyle.';

  @override
  String get seoNewTitle => 'Sıfır Ürünler | Sağlam Spot';

  @override
  String get seoNewDesc => 'Garantili ve kaliteli sıfır mobilya koleksiyonu.';

  @override
  String get seoSpotTitle => 'Spot Ürünler | Sağlam Spot';

  @override
  String get seoSpotDesc => 'Ekonomik ve kaliteli spot mobilya seçenekleri.';

  @override
  String get seoAboutTitle => 'Hakkımızda | Sağlam Spot';

  @override
  String get seoAboutDesc =>
      '20 yıllık tecrübemizle mobilya sektöründe güvenin adresi.';

  @override
  String get seoProductDetailSuffix => 'Ürünü İncele | Sağlam Spot';

  @override
  String get category => 'Kategori';

  @override
  String get categorySofa => 'Oturma Grupları';

  @override
  String get categoryChair => 'Sandalye';

  @override
  String get categoryTable => 'Masa';

  @override
  String get categoryBed => 'Yatak Odası';

  @override
  String get categoryWardrobe => 'Dolap';

  @override
  String get categoryWhite => 'Beyaz Eşya';

  @override
  String get categoryOther => 'Diğer';

  @override
  String get condition => 'Durum';

  @override
  String get conditionAll => 'Tümü';

  @override
  String get conditionNew => 'Sıfır';

  @override
  String get conditionUsed => 'İkinci El';

  @override
  String get priceRange => 'Fiyat Aralığı';

  @override
  String get price => 'Fiyat';

  @override
  String get save => 'Kaydet';

  @override
  String get explanation => 'Açıklama';

  @override
  String get clear => 'Temizle';

  @override
  String get filter => 'Filtrele';

  @override
  String get apply => 'Uygula';

  @override
  String get cancel => 'Vazgeç';

  @override
  String get newSeason => 'YENİ SEZON';

  @override
  String get heroTitle => 'Minimalist\nKonforun Zirvesi';

  @override
  String get viewCollection => 'KOLEKSİYONU GÖR';

  @override
  String get featureArtisan => 'Samimi Esnaflık';

  @override
  String get featureDelivery => 'Güvenli Teslimat';

  @override
  String get featureService => 'Güler Yüzlü Hizmet';

  @override
  String get featureShipping => 'Hızlı Nakliye';

  @override
  String get quickOptions => 'Hızlı Seçenekler';

  @override
  String get easyFind => 'Aradığınız ürünü kolayca bulun';

  @override
  String get mottoBrand => 'Eskiyi Yeniler, Yeniyi Değerlendirir';

  @override
  String get newCollection => 'Yeni Koleksiyon';

  @override
  String get newCollectionSub => 'En yeni ürünler';

  @override
  String get spotProducts => 'Spot Ürünler';

  @override
  String get spotProductsSub => 'Fırsat Ürünleri';

  @override
  String get spotProductsDesc => 'Kaliteli ürünlerde inanılmaz fiyatlar';

  @override
  String get currentCollection => 'MEVCUT KOLEKSİYON';

  @override
  String get soldProducts => 'SATILMIŞ ÜRÜNLER';

  @override
  String pieces(int count) {
    return '$count Parça';
  }

  @override
  String get stock => 'STOKTA';

  @override
  String get sold => 'SATILDI';

  @override
  String get byRoom => 'Yaşam Alanına Göre';

  @override
  String get byRoomSub => 'Evinizin her köşesi için özel seçimler';

  @override
  String get roomLivingRoom => 'Salon';

  @override
  String get roomLivingRoomSub => 'Konforun Merkezi';

  @override
  String get roomBedroom => 'Yatak';

  @override
  String get roomBedroomSub => 'Huzurlu Uykular';

  @override
  String get roomKitchen => 'Mutfak';

  @override
  String get roomKitchenSub => 'Pratik Çözümler';

  @override
  String get roomOffice => 'Ofis';

  @override
  String get roomOfficeSub => 'Verimli Çalışma';

  @override
  String get whoWeAre => 'BİZ KİMİZ?';

  @override
  String get artisanTitle => '20 Yıllık Samimi Esnaflık,\nModern Hizmet.';

  @override
  String get artisanDesc =>
      'Mağazamıza gelin, bir çayımızı için; size en uygun mobilyayı birlikte seçelim.';

  @override
  String get visitUsButton => 'BİZİ ZİYARET EDİN';

  @override
  String get statHappyCustomer => 'Mutlu Müşteri';

  @override
  String get statExperience => 'Tecrübe';

  @override
  String get statDelivery => 'Teslimat';

  @override
  String get statTrust => 'Güven';

  @override
  String get explore => 'KEŞFET';

  @override
  String get collections => 'Koleksiyonlar';

  @override
  String get corporate => 'KURUMSAL';

  @override
  String get aboutUs => 'Hakkımızda';

  @override
  String get contact => 'İletişim';

  @override
  String get contactUs => 'BİZE ULAŞIN';

  @override
  String get sss => 'SSS';

  @override
  String get qualityFurniture => '\'Kaliteli mobilyanın adresi Sağlam Spot\'';

  @override
  String get footerDesc =>
      '20 yılı aşkın tecrübemizle İstanbul\'un her noktasına kaliteyi ve güveni taşıyoruz.';

  @override
  String get allRightsReserved =>
      '© 2026 SAĞLAM SPOT TİCARET. TÜM HAKLARI SAKLIDIR.';

  @override
  String get errorOccurred => 'Bir hata oluştu';

  @override
  String get productNotFound => 'Ürün bulunamadı';

  @override
  String get noImages => 'Görsel Yok';

  @override
  String get error_check_connection => 'İnternet bağlantınızı kontrol edin.';

  @override
  String get error_server_no_response => 'Sunucu şu an yanıt vermiyor.';

  @override
  String get error_connection => 'Bağlantı hatası';

  @override
  String get error_connection_lost => 'Bağlantı Kesildi';

  @override
  String get status_waiting_connection => 'Bağlantı bekleniyor...';

  @override
  String get error_no_internet_auto_retry =>
      'İnternet bağlantınız yok.\nBağlantı sağlandığında otomatik olarak devam edeceksiniz.';

  @override
  String get goBack => 'Geri Dön';

  @override
  String get galleryEmpty => 'Galeri boş';

  @override
  String get month_1 => 'Ocak';

  @override
  String get month_2 => 'Şubat';

  @override
  String get month_3 => 'Mart';

  @override
  String get month_4 => 'Nisan';

  @override
  String get month_5 => 'Mayıs';

  @override
  String get month_6 => 'Haziran';

  @override
  String get month_7 => 'Temmuz';

  @override
  String get month_8 => 'Ağustos';

  @override
  String get month_9 => 'Eylül';

  @override
  String get month_10 => 'Ekim';

  @override
  String get month_11 => 'Kasım';

  @override
  String get month_12 => 'Aralık';

  @override
  String get noProductFoundTitle => 'Aradığınız Kriterde Ürün Bulunamadı';

  @override
  String get noProductFoundDescription =>
      'Farklı filtreler deneyebilir veya arama teriminizi değiştirebilirsiniz';

  @override
  String get adminPanelTitle => 'Yönetici Paneli';

  @override
  String get totalCount => 'Toplam';

  @override
  String get productAddedSuccess => 'Ürün başarıyla eklendi';

  @override
  String get authOrConnectionError => 'Yetki veya bağlantı hatası oluştu';

  @override
  String get fillRequiredFields =>
      'Lütfen ürün adı, fiyat ve en az bir görsel ekleyin!';

  @override
  String get sessionClosed => 'Oturum kapalı';

  @override
  String get addNewProduct => 'Yeni Ürün Ekle';

  @override
  String get productImages => 'Ürün Görselleri';

  @override
  String get generalInfo => 'Genel Bilgiler';

  @override
  String get productNameLabel => 'Ürün Adı';

  @override
  String get descriptionLabel => 'Açıklama';

  @override
  String get statusLabel => 'Durum';

  @override
  String get spotSecondHand => 'Spot / İkinci El';

  @override
  String get secondHandHint => 'Tek parça — renk seçeneği gösterilmeyecek';

  @override
  String get newProductHint => 'Sıfır ürün — renk seçeneği ekleyebilirsin';

  @override
  String get colorOptionsOptional => 'Renk Seçenekleri (opsiyonel)';

  @override
  String get noImagesYet => 'Henüz görsel eklenmedi';

  @override
  String get addImage => 'Görsel Ekle';

  @override
  String get editProductTitle => 'Ürünü Düzenle';

  @override
  String get changeImages => 'Görselleri Değiştir';

  @override
  String get saveChanges => 'Değişiklikleri Kaydet';

  @override
  String get deleteProductTitle => 'Ürünü Sil';

  @override
  String get deleteProductConfirmSuffix => 'silinecek. Emin misiniz?';

  @override
  String get yesDelete => 'Evet, Sil';

  @override
  String get emptyCategoryProducts => 'Bu kategoride ürün bulunamadı';

  @override
  String get adminLoginSubtitle => 'Yönetici Paneline Giriş';

  @override
  String get emailLabel => 'E-posta';

  @override
  String get passwordLabel => 'Şifre';

  @override
  String get loginButton => 'Giriş Yap';

  @override
  String get sponsored => 'Sponsorlu';

  @override
  String get addProductFab => 'Ürün Ekle';

  @override
  String get singlePieceNotice =>
      'Bu, ikinci el / spot bir üründür — stokta tek parça vardır, renk ve görsel tamamen fotoğraflardaki gibidir.';

  @override
  String get colorOptionsTitle => 'Renk Seçenekleri';

  @override
  String get newProductBadge => 'SIFIR ÜRÜN';

  @override
  String get usedProductBadge => 'İKİNCİ EL';

  @override
  String get readMore => 'Devamını oku';

  @override
  String get readLess => 'Daha az göster';

  @override
  String get specDelivery => 'Teslimat';

  @override
  String get specDeliveryValue => '1-2 Gün İçinde';

  @override
  String get specLocation => 'Konum';

  @override
  String get sellerTrustLine => '20 yıllık esnaf güvencesi · İçerenköy';

  @override
  String get whatsappCta => 'WhatsApp\'tan Yaz';

  @override
  String get callCta => 'Ara';

  @override
  String get similarProducts => 'Benzer Ürünler';

  @override
  String get conditionShowcase => 'Vitrin';

  @override
  String get productDescriptionTitle => 'Açıklama';

  @override
  String get loginBrand => 'Sağlam Spot';

  @override
  String get logout => 'Oturumu Kapat';

  @override
  String get logoutConfirm =>
      'Hesabınızdan güvenli bir şekilde çıkış yapmak istediğinize emin misiniz?';

  @override
  String get testimonialsHeading => 'Müşterilerimiz Ne Diyor?';

  @override
  String get testimonialsSubheading =>
      '20 yılı aşkın süredir İçerenköy ve çevresinde binlerce eve dokunduk';

  @override
  String get testimonial1Comment =>
      'Koltuk takımını çok uygun fiyata aldık, hem de sıfır gibi. Teslimat aynı gün elden ele yapıldı, esnaf usulü güven tam anlamıyla buradaydı.';

  @override
  String get testimonial2Comment =>
      'Yatak odası takımını spot fiyatına buradan aldım. Ürün açıklamasıyla birebir aynıydı, hiçbir sürpriz yaşamadım. Kesinlikle tavsiye ederim.';

  @override
  String get testimonial3Comment =>
      'Ofis için toplu mobilya alımı yaptık, hem fiyat hem kalite beklentimizin üzerindeydi. İlgili ve sabırlı bir ekip, teşekkürler Sağlam Spot.';

  @override
  String get testimonial4Comment =>
      'Yemek masası setini pazarlıksız, dürüst bir fiyata satın aldık. Nakliye konusunda da yardımcı oldular, gönül rahatlığıyla alışveriş yaptık.';

  @override
  String get testimonial5Comment =>
      'İkinci el gardırop aradık, hem sağlam hem şık bir ürün bulduk. Fiyat/performans olarak piyasadaki en iyi seçenekti.';

  @override
  String get testimonial6Comment =>
      'Showroom ziyaretimizde ürünleri yerinde görme şansımız oldu, bu güveni artırdı. Satış sonrası da bize her zaman ulaşılabilir oldular.';

  @override
  String get howItWorksHeading => 'Nasıl Çalışır?';

  @override
  String get step1Title => 'Gözat & Filtrele';

  @override
  String get step1Desc =>
      'Kategoriler ve fiyat aralığına göre binlerce ürün arasından beğendiğini bul.';

  @override
  String get step2Title => 'Bizimle İletişime Geç';

  @override
  String get step2Desc =>
      'Ürün sayfasından tek tıkla WhatsApp veya telefonla ekibimize ulaş.';

  @override
  String get step3Title => 'Fiyatı Netleştir';

  @override
  String get step3Desc =>
      'Ürünü showroomda gör veya fotoğraflarla teyit et, esnaf usulü net fiyat al.';

  @override
  String get step4Title => 'Kapına Teslim';

  @override
  String get step4Desc =>
      'İçerenköy ve Anadolu Yakası\'na hızlı, sigortalı taşıma ile mobilyan güvenle evine gelsin.';

  @override
  String get tipsEyebrow => 'İPUÇLARI';

  @override
  String get tipsHeading => 'Uzmanından Bakım Önerileri';

  @override
  String get tip1Title => 'Oturma Odasını Sevilesi Hale Getirin';

  @override
  String get tip1Desc =>
      'Koltuk yerleşimini duvardan 1-2 cm boşluk bırakarak yapın; hem hava sirkülasyonu sağlar hem de odayı ferahlatır.';

  @override
  String get tip1Category => 'Yerleştirme';

  @override
  String get tip2Title => 'Temiz Görünen Bir Çalışma Alanı';

  @override
  String get tip2Desc =>
      'Kabloları toplayıcılarla düzenleyin, mikrofiber bezle dairesel hareketlerle silin — masanız hep yeni gibi kalsın.';

  @override
  String get tip2Category => 'Temizlik';

  @override
  String get tip3Title => 'Mutfakta Keyifli Bir Kurulum';

  @override
  String get tip3Desc =>
      'Ağır malzemeleri alt raflara, sık kullandıklarınızı göz hizasına yerleştirin — hem pratik hem güvenli.';

  @override
  String get tip3Category => 'Düzen';

  @override
  String get tip4Title => 'Rahat Bir Uyku Köşesi Kurun';

  @override
  String get tip4Desc =>
      'Yatak başlığını pencereden uzağa, ışığı en aza indirecek şekilde konumlandırın — daha derin bir uyku için küçük ama etkili bir değişiklik.';

  @override
  String get tip4Category => 'Konfor';

  @override
  String get tip5Title => 'Dolabınızı Ferahlatın';

  @override
  String get tip5Desc =>
      'Sezonluk kıyafetleri ayırın, askı yönünü tek taraflı tutun — hem yer kazanır hem de her sabah seçim yapmak kolaylaşır.';

  @override
  String get tip5Category => 'Organizasyon';

  @override
  String get tip6Title => 'Ahşap Mobilyaya Ömür Katın';

  @override
  String get tip6Desc =>
      'Doğrudan güneş ışığından koruyun, yılda birkaç kez besleyici yağ ile silin — çizik ve solmaya karşı en etkili bakım budur.';

  @override
  String get tip6Category => 'Bakım';

  @override
  String get tip7Title => 'Kumaş Koltukları Uzun Ömürlü Kılın';

  @override
  String get tip7Desc =>
      'Haftada bir vakumlayın, lekeleri hemen nemli bezle tamponlayın — beklemek lekenin kumaşa işlemesine sebep olur.';

  @override
  String get tip7Category => 'Bakım';

  @override
  String get tip8Title => 'Doğru Aydınlatmayı Seçin';

  @override
  String get tip8Desc =>
      'Tek bir tavan lambası yerine kat kat aydınlatma kullanın: genel, görev ve atmosfer ışığı bir arada odayı daha sıcak gösterir.';

  @override
  String get tip8Category => 'Aydınlatma';

  @override
  String get tip9Title => 'Küçük Alanları Akıllıca Kullanın';

  @override
  String get tip9Desc =>
      'Katlanabilir ve çok amaçlı mobilyalar tercih edin; duvara monte raflar zemin alanını özgür bırakır.';

  @override
  String get tip9Category => 'Düzen';

  @override
  String get tip10Title => 'Balkonunuzu Yaşam Alanına Dönüştürün';

  @override
  String get tip10Desc =>
      'Hava koşullarına dayanıklı bir koltuk takımı ve birkaç saksı bitkiyle balkon, evin en sevilen köşesi haline gelir.';

  @override
  String get tip10Category => 'Dış Mekan';

  @override
  String get popularCategoriesHeading => 'Popüler Kategoriler';

  @override
  String get popularCategoriesSub => 'İhtiyacına uygun mobilyayı tek tıkla bul';

  @override
  String categoryProductCount(int count) {
    return '$count ürün';
  }

  @override
  String get newsletterSubscribeSuccess =>
      'Bültenimize başarıyla abone oldunuz!';

  @override
  String get newsletterHeading => 'Yeni Ürünlerden İlk Siz Haberdar Olun';

  @override
  String get newsletterDesc =>
      'Spot fırsatlar, yeni koleksiyonlar ve kampanyalar e-posta kutunuza gelsin. Spam yok, sadece işinize yarayacak fırsatlar.';

  @override
  String get emailHint => 'E-posta adresiniz';

  @override
  String get emailRequired => 'E-posta gerekli';

  @override
  String get emailInvalid => 'Geçerli bir e-posta girin';

  @override
  String get whyUsHeading => 'Neden Sağlam Spot?';

  @override
  String get usp1Title => '20 Yıllık Esnaf Güvencesi';

  @override
  String get usp1Desc =>
      'İçerenköy\'de yirmi yılı aşan bir esnaflık geçmişi ve binlerce memnun müşteri.';

  @override
  String get usp2Title => 'Piyasanın Altında Fiyat';

  @override
  String get usp2Desc =>
      'Aracısız çalışma modelimizle spot ve sıfır mobilyada en uygun fiyatlar bizde.';

  @override
  String get usp3Title => 'Kontrollü Ürün Kalitesi';

  @override
  String get usp3Desc =>
      'Her ürün satışa çıkmadan önce yapısal ve kumaş/kaplama kontrolünden geçer.';

  @override
  String get usp4Title => 'Satış Sonrası Destek';

  @override
  String get usp4Desc =>
      'Teslimat sonrası da ulaşabileceğin, sorununu çözen gerçek bir ekip.';

  @override
  String get socialShowcaseEyebrow => 'PAYLAŞIN';

  @override
  String get socialShowcaseHeading => '#SağlamSpot ile Kurulumunuzu Paylaşın';

  @override
  String productsLoadError(String error) {
    return 'Ürünler yüklenirken hata oluştu: $error';
  }

  @override
  String get viewAllButton => 'Tümünü Gör';

  @override
  String get showcaseEyebrow => 'VİTRİN';

  @override
  String get exploreButton => 'Keşfet';

  @override
  String get visitUsEyebrow => 'BİZE UĞRA';

  @override
  String get visitUsHeading => 'Bir Selam Ver, Yeter';

  @override
  String visitUsOpenLine(String hours) {
    return 'Kapımız her zaman açık. $hours';
  }

  @override
  String get directionsButton => 'Yol Tarifi';

  @override
  String get freeDeliveryLabel => 'Ücretsiz Teslimat';

  @override
  String get busLinesLabel => 'Otobüs Hatları';

  @override
  String get statYearsSuffix => '+ Yıl';

  @override
  String get storeAddress => 'İçerenköy, Ataşehir/İstanbul';

  @override
  String get stayUpdated => 'Güncel Kalın';

  @override
  String get viewButton => 'İncele';

  @override
  String get heroSlide2Eyebrow => 'İKİNCİ EL';

  @override
  String get heroSlide2Title => 'Öyküsü Olan Mobilyalar';

  @override
  String get heroSlide2Subtitle =>
      'Özenle seçilmiş, sağlam ve karakterli ikinci el parçalar.';

  @override
  String get heroSlide3Title => 'Tüm Koleksiyonu Keşfedin';

  @override
  String get aboutBadge => '2012\'DEN BERİ SİZİNLE';

  @override
  String get aboutHeroTitle => 'Sağlam Spot\nBildiğiniz Güven';

  @override
  String get aboutHeroSubtitle =>
      'İşimizi sevgi ve titizlikle yaparak\nmahallemize hizmet veriyoruz.';

  @override
  String get aboutStoryHeading => 'Biz Kimiz? (Hikayemiz)';

  @override
  String get aboutStoryPara1 =>
      'Amacımız, evinize sıcaklık katacak, kaliteli ve içinize sinen mobilyaları bulmanıza yardımcı olmak. Yaşam alanlarınızı güzelleştirmek bizim işimiz.';

  @override
  String get aboutStoryPara2 =>
      'Her şey 2012\'de, İçerenköy\'deki bu dükkanda başladı. O günden beri konuk olduğumuz ev sayısı daha da arttı.';

  @override
  String get aboutStoryPara3 =>
      'Bugün, hem sıfır hem de özenle seçtiğimiz ikinci el ürünlerimizle, binlerce komşumuzun evine konuk olduk. Sizin güveninizle büyüyoruz.';

  @override
  String get aboutStoryStartLabel => 'Başlangıç';

  @override
  String get aboutStoryExperienceLabel => 'Yıllık Tecrübe';

  @override
  String get aboutStorySmilesLabel => 'Gülen Yüz';

  @override
  String get aboutValuesHeading => 'İlkelerimiz';

  @override
  String get aboutValuesSubheading =>
      'Esnaflıktan ödün vermediğimiz prensiplerimiz';

  @override
  String get aboutValue1Title => 'Kalite ve Titizlik';

  @override
  String get aboutValue1Desc =>
      'İster sıfır ister ikinci el olsun titizlikle seçer, size öyle sunarız.';

  @override
  String get aboutValue2Title => 'Gülen Yüz';

  @override
  String get aboutValue2Desc =>
      'Bizim için en büyük kazanç, dükkandan mutlu ayrılan bir komşumuzdur. Memnuniyetiniz her şeyden önce gelir.';

  @override
  String get aboutValue3Title => 'Emeğe Saygı';

  @override
  String get aboutValue3Desc =>
      'Mobilya kıymetli bir emektir. İkinci el ürünlere yeniden hayat vererek hem bütçenizi hem de doğayı koruruz.';

  @override
  String get aboutValue4Title => 'Dürüstlük ve Güven';

  @override
  String get aboutValue4Desc =>
      'Şeffaf ve dürüst esnaflık en büyük değerimizdir. Yıllardır aynı konumumuzda sizlerle birlikteyiz.';

  @override
  String get aboutMasterHeading => 'Ustamızı Tanıyın';

  @override
  String get aboutMasterBody =>
      'Ustamız, 1995\'ten beri, yani çeyrek asırdan fazladır bu işin içinde. Sektörün tozunu yutmuş, en iyi markalarda (İstikbal) çalışarak mobilyanın \'püf noktalarını\' öğrenmiş biridir.\n\nSürücülükten montaja, müşteri karşılamadan taşımaya kadar her alanda bizzat çalışarak tam bir tecrübe kazanmıştır. 2012\'de ise \'artık kendi dükkanım\' diyerek bu tecrübesini Sağlam Spot\'a taşımıştır.\n\nAmacı, o büyük firmalarda öğrendiği kaliteyi, mahalle esnafının samimiyeti ve titizliğiyle birleştirip size en iyi hizmeti sunmaktır.';

  @override
  String get aboutDeliveryHeading => 'Nakliye ve Montaj Hizmetimiz';

  @override
  String get aboutDeliveryFreeTitle => 'Ücretsiz Nakliye ve Montaj';

  @override
  String get aboutDeliveryZonesLabel => 'Ücretsiz Hizmet Bölgelerimiz:';

  @override
  String get aboutDeliveryZonesList =>
      '• İçerenköy Mahallemiz\n• Fındıklı, Kayışdağı, Küçükbakkalköy\n• İnönü ve Bostancı Sanayi gibi yakın komşularımız';

  @override
  String get aboutDeliveryNote =>
      'Önemli Not: Ustamızın sağlığını korumak için, asansör olmayan binalarda yüksek katlara maalesef hizmet veremiyoruz. Anlayışınız için teşekkür ederiz.';

  @override
  String get aboutDeliveryPunctual =>
      '⏰ Sizinle sözleştiğimiz saatte kapınızdayız!';

  @override
  String get aboutTransportHeading => 'Dükkanımıza Nasıl Gelirsiniz?';

  @override
  String get aboutTransportBusIntro => 'Otobüsle Gelirseniz:';

  @override
  String get aboutBusStop1 => 'Ziyapaşa Durağı (Kadıköy Yönü):';

  @override
  String get aboutBusStop2 => 'İçerenköy Durağı (Kayışdağı Yönü):';

  @override
  String get aboutBusStop3 => 'İçerenköy Durağı (Yeniyol):';

  @override
  String get aboutContactPhoneLabel => 'Telefon (Hızlı Çözüm)';

  @override
  String get aboutContactAddressLabel => 'Adres (Çaya Bekleriz)';

  @override
  String get aboutContactAddressValue =>
      'İçerenköy Mahallesi\nBuket Sokak No:6';

  @override
  String get aboutContactHoursLabel => 'Çalışma Saatlerimiz';

  @override
  String get aboutContactHoursValue =>
      'Pzt-Cmt: 09:00 - 22:00\nPazar: 10:00 - 20:00';

  @override
  String get aboutContactHeading => 'Bize Ulaşın';

  @override
  String get aboutCallNowButton => 'Hemen Ara';

  @override
  String get aboutViewMapButton => 'Haritada Gör';

  @override
  String get aboutMapHeading => 'Dükkanımız Tam Burada';

  @override
  String get aboutMapSubtext => 'Yol tarifi almak için haritaya dokunun';

  @override
  String get newProductsBadgeEyebrow => 'NEW COLLECTION';

  @override
  String get newProductsTitle => 'Yeni\nKoleksiyon';

  @override
  String get productsBadgeLabel => 'ÜRÜN';

  @override
  String get breadcrumbHome => 'Ana Sayfa';

  @override
  String get statTotalProducts => 'TOPLAM ÜRÜN';

  @override
  String get statCategoryLabel => 'KATEGORİ';

  @override
  String get statConditionValueNew => 'YENİ';

  @override
  String get statConditionLabel => 'DURUM';

  @override
  String get statRatingLabel => 'PUAN';

  @override
  String get searchBarRichPrefix => 'Detaylı ürün araması için ';

  @override
  String get searchBarRichOr => ' yapın ya da ';

  @override
  String get searchBarRichHereLink => 'BURADAKİ';

  @override
  String get searchBarRichSuffix => ' yazıya tıklayın.';

  @override
  String get sortNewProductsDefault => 'Yeniler';

  @override
  String get sortSpotProductsDefault => 'En Yeni';

  @override
  String get sortPriceLowHigh => 'Fiyat: Düşük-Yüksek';

  @override
  String get sortPriceHighLow => 'Fiyat: Yüksek-Düşük';

  @override
  String get sortMostPopular => 'En Popüler';

  @override
  String get spotBadgeEyebrow => 'SPOT ÜRÜNLER';

  @override
  String get spotHeroTitle => 'Fırsat\nÜrünleri';

  @override
  String get spotDiscountLabel => 'İNDİRİM';

  @override
  String get statSpotProductLabel => 'Spot Ürün';

  @override
  String get statDiscountLabel => 'İndirim';

  @override
  String get statSupportLabel => 'Destek';

  @override
  String get statFreeLabel => 'Ücretsiz';

  @override
  String get statFreeShippingNote => 'Maalesef Yakın Çevrelerimize, Kargo';

  @override
  String get statFreeShippingShort => 'Kargo';

  @override
  String get filtersPanelTitle => 'FİLTRELER';

  @override
  String get dragToRotateHint => 'Diğer fotoğraflar için kaydırın';

  @override
  String get studioQuotaExceededNotice =>
      'Bu ay stüdyo (arka plansız) görsel limiti doldu — fotoğraflar normal haliyle eklendi.';

  @override
  String get studioPreparingWait =>
      'Stüdyo görseli hazırlanıyor, lütfen bekleyin...';

  @override
  String get retry => 'Tekrar Dene';

  @override
  String get studioGenerationFailed => 'Stüdyo görseli oluşturulamadı';

  @override
  String get storePhotoLabel => 'Mağaza';

  @override
  String get studioPhotoLabel => 'Stüdyo';

  @override
  String get onboardingSkip => 'Atla';

  @override
  String get onboardingStart => 'Başla';

  @override
  String get onboardingPage1Eyebrow => 'SAĞLAM SPOT\'A HOŞ GELDİNİZ';

  @override
  String get onboardingPage1Title => 'Eviniz İçin\nDoğru Adres';

  @override
  String get onboardingPage1Desc =>
      '20 yılı aşkın esnaf tecrübesiyle, kaliteli mobilyayı cebinize taşıyoruz.';

  @override
  String get onboardingPage2Eyebrow => 'SPOT & SIFIR BİR ARADA';

  @override
  String get onboardingPage2Title => 'Her Bütçeye\nUygun Seçenekler';

  @override
  String get onboardingPage2Desc =>
      'İkinci el fırsatlardan sıfır koleksiyona kadar — aradığınızı kolayca bulun.';

  @override
  String get onboardingPage3Eyebrow => 'GÜVENLE ALIŞVERİŞ';

  @override
  String get onboardingPage3Title => 'Beğendiniz mi?\nHemen Yazın';

  @override
  String get onboardingPage3Desc =>
      'Tek dokunuşla WhatsApp\'tan ulaşın, fiyat sorun, pazarlık edin.';

  @override
  String get favoritesTitle => 'Favorilerim';

  @override
  String get favoritesEmptyTitle => 'Favori Listeniz Boş';

  @override
  String get favoritesEmptyDesc =>
      'Beğendiğiniz ürünleri kalp ikonuna dokunarak favorilerinize ekleyin.';

  @override
  String get sortPanelTitle => 'SIRALA';

  @override
  String get priceRangeSectionTitle => 'FİYAT ARALIĞI';

  @override
  String get clearFiltersButton => 'FİLTRELERİ TEMİZLE';

  @override
  String get tryDifferentFiltersShort => 'Farklı filtreler deneyebilirsiniz';

  @override
  String get spotBadgeTag => 'SPOT';

  @override
  String productLoadError(String error) {
    return 'Ürün yüklenemedi: $error';
  }

  @override
  String get productSpecConditionNew => 'Sıfır Ürün';

  @override
  String get productLocationValue => 'İçerenköy, İstanbul';

  @override
  String get sortFeatured => 'Öne Çıkanlar';

  @override
  String get sortPriceAsc => 'Fiyat: Artan';

  @override
  String get sortPriceDesc => 'Fiyat: Azalan';

  @override
  String get languageSelectorTitle => 'Dil Seçimi';

  @override
  String get languageTooltip => 'Dil';

  @override
  String get galleryEmptyMessage => 'Bu ürüne ait henüz fotoğraf eklenmemiş.';

  @override
  String get productCardNewBadge => 'SIFIR';

  @override
  String get sssHelpCenterBadge => 'YARDIM MERKEZİ';

  @override
  String get sssHeroTitle => 'Sıkça Sorulan\nSorular';

  @override
  String get sssHeroSubtitle => 'Merak ettiğiniz her şeyin cevabı burada';

  @override
  String get sssCategoryAll => 'Tümü';

  @override
  String get sssCategoryGeneral => 'Genel';

  @override
  String get sssCategoryProductService => 'Ürün & Hizmet';

  @override
  String get sssCategoryDelivery => 'Teslimat & Montaj';

  @override
  String get sssCategoryPayment => 'Ödeme & Sipariş';

  @override
  String get sssCategoryReturns => 'İade & Garanti';

  @override
  String get sssCategorySecondHandBuying => 'İkinci El Alım Süreci';

  @override
  String get sssPhoneSupportTitle => 'Telefon Desteği';

  @override
  String get sssWorkingHoursTitle => 'Çalışma Saatleri';

  @override
  String get sssWorkingHoursValue => '09:00 - 22:00';

  @override
  String get sssStoreAddressTitle => 'Mağaza Adresi';

  @override
  String get sssStoreAddressValue => 'İçerenköy Mahallesi Buket Sok. No:6';

  @override
  String get sssNoAnswerTitle => 'Sorunuz Yanıt Bulamadı mı?';

  @override
  String get sssNoAnswerSubtitle => 'Bize Ulaşabilirsiniz';

  @override
  String get sssVisitStoreButton => 'Mağazaya Gel';

  @override
  String get sssQ1 =>
      'Ustanın çalışma hayatı ve tecrübesi hakkında bilgi verebilir misiniz?';

  @override
  String get sssA1 =>
      'Ustamız, 1995 yılından beri bu sektörde aktif olarak çalışmaktadır. Kariyerine ilk adımlarını attığı günden itibaren sürekli bir gelişim göstermiştir. Çalışma hayatı boyunca, teslimatlar için sürücülük, taşıma, montaj, müşteri karşılama gibi birçok iş pozisyonunda görev alarak çok yönlü bir deneyim kazanmıştır. Özellikle 2010 yılına kadar İstikbal\'de çalışmış ve bu süreçte ürünlerin özellikleri, parçaları ve püf noktaları hakkında derinlemesine bilgi sahibi olmuştur. 2010\'dan sonra, yakın civardaki Işık Çeyiz\'de çalışarak sektördeki yetkinliğini artırmıştır. 2012 yılında ise kendi esnaf dükkanını açma kararı almış ve bu süreçte kaliteli hizmet anlayışını ön planda tutarak, sektördeki deneyimlerini müşterilerine en iyi şekilde aktarmayı hedeflemiştir.';

  @override
  String get sssQ2 => 'Sağlam Spot güvenilir mi?';

  @override
  String get sssA2 =>
      '2012 yılından beri İçerenköy\'de, komşularımıza hizmet veriyoruz. Sayısızca evlere konuk olduk ve hâlâ konuk olmaya devam ediyoruz.';

  @override
  String get sssQ3 => 'Ürünleri incelemek için mağazanıza gelebilir miyim?';

  @override
  String get sssA3 =>
      'Elbette! Hatta biz de özellikle bunu tavsiye ediyoruz. Çayımızı içerken ürünleri canlı canlı görmeniz, dokunmanız ve içinize sinmesi en sağlıklısı. İçerenköy Mahallesi\'ndeki dükkanımıza her zaman bekleriz.';

  @override
  String get sssQ4 => 'İkinci el ürünlerin durumu nasıl kontrol ediliyor?';

  @override
  String get sssA4 =>
      'Bizim için ikinci el, \'ikinci kalite\' demek değildir. Her ürün ustamızın titiz kontrolünden geçer; temizliği, bakımı ve gerekli onarımları eksiksiz yapılır. Fotoğraflarda ne görüyorsanız o, ama biz yine de \'gelin, bir de siz görün\' deriz. Gözünüzle görmeniz her zaman en iyisidir.';

  @override
  String get sssQ5 => 'Mobilyaların malzeme kalitesi nedir?';

  @override
  String get sssA5 =>
      'Şeffaflığı önemsiyoruz. Her ürünün kendine ait bir hikayesi ve malzemesi var. Bu yüzden tüm detayları, malzeme kalitesini ve özelliklerini ürün açıklama bölümlerine net bir şekilde yazıyoruz. Aklınıza takılan bir şey olursa sormaktan çekinmeyin.';

  @override
  String get sssQ6 => 'Ürün fiyatları nasıl belirleniyor?';

  @override
  String get sssA6 =>
      'Fiyatlarımızı belirlerken hem ürünün kalitesine hem de piyasa koşullarına adil bir şekilde bakıyoruz. Amacımız, bütçenizi zorlamadan, kaliteli ve uzun ömürlü ürünlere ulaşmanızı sağlamaktır. Hakkı neyse, o.';

  @override
  String get sssQ7 => 'Ürünlerinizde renk seçenekleri var mı?';

  @override
  String get sssA7 =>
      'Ürünlerimiz genellikle anlık ve tek parçalar olduğu için, mevcut renkleri neyse o şekilde sunuyoruz. Maalesef farklı renk seçenekleri yapamıyoruz. Beğendiğiniz ürünün rengi, gördüğünüz renktir.';

  @override
  String get sssQ8 => 'Özel sipariş alıyor musunuz?';

  @override
  String get sssA8 =>
      'Keşke yapabilsek! Ancak biz daha çok mevcut, özenle seçilmiş ürünlerimize odaklanıyoruz. Özel üretim veya tasarım siparişi şu an için maalesef alamıyoruz. Hazırdaki ürünlerimizi incelemenizi öneririz.';

  @override
  String get sssQ9 => 'Ürün açıklamalarında nelere dikkat etmeliyim?';

  @override
  String get sssA9 =>
      'En önemli tavsiyemiz: Mezura! Lütfen ürün açıklamasındaki ölçüleri, evinize koyacağınız yerle dikkatlice karşılaştırın. \'Acaba sığar mı?\' sorusunu en başta çözmek, sonradan yaşanacak sıkıntıları önler. Ayrıca ölçü Alırken Koridoru Unutmayın: Sadece mobilyayı koyacağınız yeri değil, o mobilyanın kapıdan, koridordan ve merdivenden nasıl geçeceğini de ölçün. Malzeme ve durum bilgilerini de mutlaka okuyun.';

  @override
  String get sssQ10 =>
      'Asansör olmayan binalara veya yüksek katlara teslimat yapıyor musunuz?';

  @override
  String get sssA10 =>
      'Bu, bizim için en hassas ve önemli konulardan biri. Biz, işini bizzat yapan küçük bir esnafız. Ustamız, yılların tecrübesiyle birlikte artık genç olmadığı için sağlığını da düşünmek zorundayız. Anlayışınıza sığınarak, asansör olmayan binalarda yüksek katlara (örneğin 2. kat ve üzeri) eşya çıkarma ve indirme hizmeti kesinlikle veremiyoruz. Lütfen siparişinizi vermeden önce bu konuyu netleştirelim, size mahcup olmak istemeyiz.';

  @override
  String get sssQ11 => 'Taşıma hizmeti sağlıyor musunuz?';

  @override
  String get sssA11 =>
      'Elbette, komşularımıza yardımcı oluyoruz. İçerenköy başta olmak üzere Fındıklı, Kayışdağı, Küçükbakkalköy, İnönü ve Bostancı Sanayi gibi yakın çevremize ücretsiz nakliye hizmetimiz var. (Bostancı ve Kozyatağı\'nın bazı bölgeleri hariç, ve yaşlılık açısından yüksek katlara asansörsüz taşıyamıyoruz, onu ayrıca konuşuruz).';

  @override
  String get sssQ12 => 'Teslimat süresi ne kadar?';

  @override
  String get sssA12 =>
      'Siparişi verdiğiniz an sizinle iletişime geçeriz. \'Ne zaman müsaitsiniz?\' diye sorarız. Hem size hem bize uyan en yakın vakit için sözleşiriz. Genellikle 1-3 gün içinde, anlaştığımız saatte teslimatı ve montajı tamamlamış oluruz.';

  @override
  String get sssQ13 => 'Montaj hizmeti veriyor musunuz?';

  @override
  String get sssA13 =>
      'Tabii ki. Mobilyayı alıp kapıya bırakmak bizim tarzımız değil. Büyük ürünlerin hepsini ustamız bizzat kurar ve bu hizmet için ekstra bir ücret talep etmeyiz. Siz sadece yerini gösterin, gerisi bizde.';

  @override
  String get sssQ14 => 'Mobilya siparişi ne kadar sürede teslim edilir?';

  @override
  String get sssA14 =>
      'Ürün hazırsa, sizinle ortak belirlediğimiz bir zamanda en kısa sürede kapınızdayız. Montajı da dert etmeyin; getirdiğimiz gibi kurar, öyle teslim ederiz. Genellikle aynı gün içinde her şey biter.';

  @override
  String get sssQ15 => 'Veresiye sipariş verebilir miyim?';

  @override
  String get sssA15 =>
      'Bu konuda anlayışınızı rica ediyoruz. Bir esnaf olarak ayakta kalabilmemiz için \'veresiye\' veya \'sonra ödeme\' gibi yöntemlerle maalesef çalışamıyoruz. Anlaştığımız ücreti, ürünü teslim ederken peşin olarak almamız gerekiyor. Size mahcup olmamak için bu kuralımızı baştan belirtmeyi tercih ediyoruz.';

  @override
  String get sssQ16 => 'Nasıl sipariş verebilirim?';

  @override
  String get sssA16 =>
      'En sağlıklı yöntem, her zaman yüz yüze olandır. Siteden beğendiğiniz ürünü not edin, sonra dükkanımıza gelin. Ürünü canlı görün, aklınızdaki soruları sorun, içinize sinerse siparişinizi orada tamamlayalım. Böylece hiçbir şüphe kalmaz.';

  @override
  String get sssQ17 => 'Ürün iade politikası nedir?';

  @override
  String get sssA17 =>
      'İkinci el ürünlerin doğası gereği ve esnaf usulü çalıştığımız için maalesef iade kabul edemiyoruz. Bu yüzden \'gelin, görün, çayımızı için\' diye ısrar ediyoruz. Almadan önce ürünü detaylıca incelemeniz, ölçüp biçmeniz en doğrusu. Emin olmadan alışverişi tamamlamayalım.';

  @override
  String get sssQ18 => 'Ürünlerin garanti süresi var mı?';

  @override
  String get sssA18 =>
      'Ürünlerimiz ikinci el olduğu için, bir markanın sunduğu gibi resmi bir garanti süremiz maalesef yok. Ancak biz \'sattık, bitti\' diyenlerden değiliz. Teslimat ve montaj sırasında her şeyin düzgün çalıştığından emin oluruz.';

  @override
  String get sssQ19 =>
      'Evimdeki eşyaları satmak istiyorum, ikinci el alımı yapıyor musunuz?';

  @override
  String get sssA19 =>
      'Evet, dükkanımızda sergileyebileceğimize inandığımız, temiz ve yeniden satılabilir durumdaki seçili ürünleri alıyoruz. Ancak, dükkanımızın yeri gerçekten çok küçük olduğu için bu konuda maalesef çok seçici davranmak zorundayız.\n\nBu konuda baştan dürüst olmayı severiz: Bizden alacağınız teklif, muhtemelen Letgo gibi platformlarda kendinizin satabileceğiniz rakamdan biraz daha düşük olabilir. Bunun sebebi şudur: Biz esnaf olarak o eşyayı almak için benzin yakıyor, taşıma için emek harcıyor ve en önemlisi, onu satmak için dükkanımızda sergileyip tüm müşteri süreciyle (pazarlık, sorular vs.) biz ilgileniyoruz.\n\nSiz o platformlarda satarken bu süreçlerin tamamını kendiniz üstlenirsiniz. Biz ise sizden bu zahmeti de devralmış oluyoruz. Teklifimizi bu hizmeti de içerecek şekilde veriyoruz. Anlayışınız için teşekkür ederiz.';

  @override
  String get sssQ20 =>
      'Komple takım mobilyaları (Yatak odası, salon takımı vb.) alıyor musunuz?';

  @override
  String get sssA20 =>
      'Dükkanımızın küçük olmasından dolayı, maalesef komple yatak odası, koltuk takımı gibi büyük setleri alamıyoruz. Yerimiz çok kısıtlı. Biz daha çok tek parça, satışı daha kolay olan (konsol, dolap, masa, sandalye gibi) ürünlere odaklanıyoruz.';

  @override
  String get sssQ21 =>
      'Eşyalarım yüksek katta ve binada asansör yok. Alım yapar mısınız?';

  @override
  String get sssA21 =>
      'Tıpkı teslimat konusunda olduğu gibi, bu bizim için en net kuralımız. Ustamızın sağlık durumu nedeniyle, asansör olmayan binalarda yüksek katlardan eşya indirme işlemi kesinlikle yapamıyoruz. Eşyalarınız zemin/giriş kata yakın ise veya binada yük asansörü varsa ancak o zaman değerlendirebiliriz.';

  @override
  String get sssQ22 => 'Her zaman eşya alımı yapıyor musunuz?';

  @override
  String get sssA22 =>
      'Bu tamamen dükkanımızdaki boşluğa bağlı. Dükkanımız küçük olduğu için, \'sat-al\' dengesiyle çalışıyoruz. Bazen bir ürünü çok beğensek de yerimiz olmadığı için alamayabiliyoruz. En sağlıklısı, bize satmak istediğiniz ürünün fotoğraflarını göndermenizdir. Size dürüstçe \'şu an yerimiz var\' veya \'maalesef bu ara doluyuz\' diye bilgi veririz.';

  @override
  String get navDiscover => 'Keşfet';

  @override
  String get navCart => 'Sepet';

  @override
  String get navProfile => 'Profil';

  @override
  String get storeHeroEyebrow => 'YENİ KOLEKSİYON';

  @override
  String get storeHeroTitle => 'Evinize Yakışan\nMobilyaları Keşfedin';

  @override
  String get storeHeroSubtitle =>
      'Kaliteli sıfır ve ikinci el mobilyalar, cebinize uygun fiyatlarla kapınızda.';

  @override
  String get storeHeroCta => 'Alışverişe Başla';

  @override
  String get sectionCategories => 'Kategoriler';

  @override
  String get sectionBestSellers => 'Çok Satanlar';

  @override
  String get sectionNewArrivals => 'Yeni Gelenler';

  @override
  String get seeAll => 'Tümünü Gör';

  @override
  String get cartTitle => 'Sepetim';

  @override
  String get cartEmptyTitle => 'Sepetiniz Boş';

  @override
  String get cartEmptyDesc =>
      'Beğendiğiniz ürünleri sepete ekleyin, sonra tek mesajla bize sorun.';

  @override
  String get cartTotalLabel => 'Toplam';

  @override
  String get cartWhatsappCta => 'Sepeti WhatsApp\'tan Gönder';

  @override
  String get cartItemRemoved => 'Sepetten kaldırıldı';

  @override
  String get addToCartCta => 'Sepete Ekle';

  @override
  String get addedToCartMessage => 'Sepete eklendi';

  @override
  String get alreadyInCartMessage => 'Bu ürün zaten sepette';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsLanguageLabel => 'Dil';

  @override
  String get settingsAccountSection => 'Hesap';

  @override
  String get settingsGeneralSection => 'Genel';

  @override
  String get settingsContact => 'İletişim';

  @override
  String get settingsCallUs => 'Bizi Arayın';

  @override
  String get settingsAdminLogin => 'Yönetici Girişi';

  @override
  String get settingsAppVersion => 'Uygulama Sürümü';

  @override
  String cartItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ürün',
      one: '1 ürün',
      zero: 'Sepet boş',
    );
    return '$_temp0';
  }

  @override
  String get settingsRateApp => 'Uygulamayı Değerlendir';

  @override
  String get settingsShareApp => 'Uygulamayı Paylaş';

  @override
  String get settingsPrivacyPolicy => 'Gizlilik Politikası';

  @override
  String get settingsTerms => 'Kullanım Koşulları';

  @override
  String get legalContentTurkishOnly =>
      'Bu içerik şu anda yalnızca Türkçe olarak sunulmaktadır.';

  @override
  String get doubleBackToExit => 'Çıkmak için tekrar geri tuşuna basın';

  @override
  String get productLinkLabel => 'Ürün linki';

  @override
  String get settingsAppSection => 'Uygulama';

  @override
  String get settingsLegalSection => 'Yasal';

  @override
  String get recentlyViewedTitle => 'Son Görüntülenenler';

  @override
  String get productTrustBadgeVerified => 'Satıcı Onaylı';

  @override
  String get productTrustBadgeNegotiate => 'WhatsApp\'tan Pazarlık';

  @override
  String get productTrustBadgeDelivery => 'Yerinde Teslim';

  @override
  String get howToBuyTitle => 'Nasıl Satın Alırım?';

  @override
  String get howToBuyStep1Title => 'WhatsApp\'tan Yaz';

  @override
  String get howToBuyStep1Desc =>
      'Ürünü beğendiyseniz WhatsApp üzerinden bize ulaşın.';

  @override
  String get howToBuyStep2Title => 'Fiyatı Konuş';

  @override
  String get howToBuyStep2Desc =>
      'Fiyat ve teslimat detaylarını birlikte görüşelim.';

  @override
  String get howToBuyStep3Title => 'Teslim Alın';

  @override
  String get howToBuyStep3Desc =>
      'Anlaştıktan sonra ürününüzü güvenle teslim alın.';

  @override
  String get listedToday => 'Bugün eklendi';

  @override
  String listedDaysAgo(int days) {
    return '$days gün önce eklendi';
  }

  @override
  String listedWeeksAgo(int weeks) {
    return '$weeks hafta önce eklendi';
  }

  @override
  String get settingsAppearanceSection => 'Görünüm';

  @override
  String get settingsThemeLight => 'Açık';

  @override
  String get settingsThemeSystem => 'Sistem';

  @override
  String get settingsThemeDark => 'Koyu';

  @override
  String get notificationsTitle => 'Bildirimler';

  @override
  String get notificationsEmptyTitle => 'Henüz bildirim yok';

  @override
  String get notificationsEmptyDesc =>
      'Yeni kampanya ve duyurular burada görünecek';

  @override
  String get markAllReadAction => 'Tümünü okundu işaretle';

  @override
  String get clearAllAction => 'Tümünü temizle';

  @override
  String get timeJustNow => 'Az önce';

  @override
  String timeMinutesAgo(int minutes) {
    return '$minutes dakika önce';
  }

  @override
  String timeHoursAgo(int hours) {
    return '$hours saat önce';
  }

  @override
  String timeDaysAgoGeneric(int days) {
    return '$days gün önce';
  }

  @override
  String get catalogCategoryTitleSofa => 'Koltuk & Kanepe';

  @override
  String get catalogCategoryTitleChair => 'Sandalye & Berjer';

  @override
  String get catalogCategoryTitleTable => 'Yemek Masası';

  @override
  String get catalogCategoryTitleBed => 'Yatak & Baza';

  @override
  String get catalogCategoryTitleWardrobe => 'Gardırop & Dolap';

  @override
  String get catalogCategoryTitleWhite => 'Beyaz Eşya';

  @override
  String get catalogCategoryTitleOther => 'Dekorasyon';

  @override
  String get mottoTitlePart1 => 'Gelmeden Gör, ';

  @override
  String get mottoTitlePart2 => 'Beğenince Gel.';

  @override
  String get mottoSubtitle =>
      'Dükkâna gelmeden önce vitrinimizi gez, istediğini bulunca bize uğra.';

  @override
  String get gatewayNewEyebrow => 'SIFIR KOLEKSİYON';

  @override
  String get gatewayNewTitle => 'Zamansız Parçalar';

  @override
  String get gatewayNewSubtitle => 'Hiç kullanılmamış, yeni gibi mobilyalar.';

  @override
  String get gatewayNewButton => 'Koleksiyonu Gör';

  @override
  String get gatewaySpotEyebrow => 'SPOT FIRSATLAR';

  @override
  String get gatewaySpotTitle => 'Kullanılmış, Sağlam';

  @override
  String get gatewaySpotSubtitle =>
      'İkinci el ama kullanışlı, cebe uygun fiyatlarla.';

  @override
  String get gatewaySpotButton => 'Fırsatları Gör';

  @override
  String freeDeliveryZonesNote(String zones) {
    return 'Ücretsiz teslimat sadece $zones bölgelerinde geçerlidir';
  }

  @override
  String get footerWarehouseTagline => 'MOBİLYA DEPOSU · İÇERENKÖY / ATAŞEHİR';

  @override
  String get locationAndHoursLabel => 'KONUM & ÇALIŞMA SAATİ';

  @override
  String get openNowLabel => 'ŞU AN AÇIK';

  @override
  String get closedNowLabel => 'ŞU AN KAPALI';

  @override
  String todayHoursPrefix(String hours) {
    return '· Bugün $hours';
  }

  @override
  String get openInMapsButton => 'Haritada Aç';

  @override
  String get viewOnGoogleMapsButton => 'Google Haritalar\'da Görüntüle';

  @override
  String gatewayProductCount(int count) {
    return '$count ürün';
  }

  @override
  String get gatewayNewEyebrowShort => 'SIFIR';

  @override
  String get gatewayNewTitleShort => 'Koleksiyon';

  @override
  String get gatewaySpotEyebrowShort => 'SPOT';

  @override
  String get gatewaySpotTitleShort => 'Fırsatlar';

  @override
  String get spotHeroEyebrow => 'FIRSAT DEPOSU';

  @override
  String get spotHeroSubtitle =>
      'Kullanılmış ama kullanışlı. Her bütçeye uygun, yeni gibi ürünler. Pazarlık payı açıktır.';

  @override
  String spotHeroDealCount(int count) {
    return '$count+ Fırsat';
  }

  @override
  String get spotStatNegotiable => 'Pazarlık Payı Mevcut';

  @override
  String get spotStatUsed => 'Kullanılmış';

  @override
  String get spotShowcaseBadgeTitle => 'Elden Geçirildi';

  @override
  String get spotShowcaseBadgeSubtitle =>
      'Her ürün teslimden önce tek tek kontrol edilir.';

  @override
  String get spotBreadcrumbLabel => 'Spot & İkinci El';

  @override
  String get aphorismEyebrow => 'BİR SÖZÜMÜZ VAR';

  @override
  String get aphorismQuote =>
      'Eskimiş değil, emek görmüş.\nİyi mobilya asla eskimez, sadece ev değiştirir.';

  @override
  String get aphorismBody =>
      'Biz de tam bu yüzden buradayız: hâlâ hayatı olan parçaları, onlara değer verecek yeni bir eve ulaştırmak için.';

  @override
  String get spotSearchHint => 'Fırsat ara...';

  @override
  String get priceRangeLabel => 'Fiyat Aralığı';

  @override
  String get filtersSheetTitle => 'FİLTRELER';

  @override
  String get applyFiltersButton => 'Filtreleri Uygula';

  @override
  String get priceRangeSheetTitle => 'FİYAT ARALIĞI';

  @override
  String get applyButton => 'Uygula';

  @override
  String get sortSheetTitle => 'SIRALAMA';

  @override
  String get sortNewest => 'En Yeni Fırsatlar';

  @override
  String get sortPopular => 'En Çok İncelenen';

  @override
  String get spotEmptyStateTitle => 'Bu kriterde fırsat bulamadık';

  @override
  String get spotEmptyStateSubtitle =>
      'Filtreleri temizlemeyi veya farklı bir kategori denemeyi dene.';

  @override
  String get newHeroTitleLine1 => 'Yaşam Alanınız İçin\n';

  @override
  String get newHeroTitleEmphasis => 'Zamansız ';

  @override
  String get newHeroButtonCollection => 'Koleksiyonu İncele';

  @override
  String get newHeroButtonQuickFilter => 'Hızlı Filtrele';

  @override
  String get newStatActiveProductLabel => 'AKTİF ÜRÜN';

  @override
  String get newStatControlledStockLabel => 'KONTROLLÜ STOK';

  @override
  String get shopByCategoryTitlePrefix => 'Kategoriye Göre ';

  @override
  String get shopByCategoryTitleEmphasis => 'Keşfet';

  @override
  String get showAllButton => 'Tümünü Göster';

  @override
  String get newEmptyStateTitle => 'Aradığınız Kriterde Mobilya Bulunamadı';

  @override
  String get newEmptyStateSubtitle =>
      'Arama kelimesini değiştirebilir ya da filtreleri temizleyebilirsiniz.';

  @override
  String get sortOptionsSheetTitle => 'Sıralama Seçenekleri';

  @override
  String get newSortNewest => 'En Yeniler';

  @override
  String get newSortPopular => 'En Çok İncelenenler';

  @override
  String get cartWhatsappGreeting =>
      'Merhaba, şu ürünler hakkında bilgi almak istiyorum:\n\n';

  @override
  String cartWhatsappAllProductsLine(String url) {
    return 'Tüm ürünler: $url';
  }

  @override
  String get defaultWhatsappGreeting =>
      'Merhaba, mobilyalar hakkında bilgi almak istiyorum.';

  @override
  String get spotHeroPageTitle => 'İkinci El & Spot';

  @override
  String get sortByPriceLowHigh => 'Fiyat: Düşükten Yükseğe';

  @override
  String get sortByPriceHighLow => 'Fiyat: Yüksekten Düşüğe';

  @override
  String get seoSssTitle => 'Sıkça Sorulan Sorular | Sağlam Spot';

  @override
  String get seoSssDesc =>
      'Mobilya alım satımı, teslimat ve garanti süreçleriyle ilgili tüm sorularınızın yanıtları.';

  @override
  String get seoSearchTitle => 'Ürün Ara | Sağlam Spot';

  @override
  String get seoSearchDesc =>
      'Aradığınız mobilyayı kategori, fiyat ve duruma göre filtreleyerek bulun.';

  @override
  String get seoPrivacyTitle => 'Gizlilik Politikası | Sağlam Spot';

  @override
  String get seoTermsTitle => 'Kullanım Şartları | Sağlam Spot';
}
