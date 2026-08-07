// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get brand => 'SAĞLAM SPOT';

  @override
  String get home => '首页';

  @override
  String get searchHint => '您在为家里寻找什么？...';

  @override
  String get collection => '系列';

  @override
  String get eleganceAndComfort => '优雅与舒适';

  @override
  String productsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '找到$count个产品',
      one: '找到1个产品',
      zero: '未找到产品',
    );
    return '$_temp0';
  }

  @override
  String resultsFor(String query) {
    return '“$query” 的搜索结果';
  }

  @override
  String get seoHomeTitle => 'Sağlam Spot | 二手与全新家具';

  @override
  String get seoHomeDesc => '二手及全新家具的最优价格。20年商家信誉保障。';

  @override
  String get seoNewTitle => '全新产品 | Sağlam Spot';

  @override
  String get seoNewDesc => '品质保证的全新家具系列。';

  @override
  String get seoSpotTitle => '二手产品 | Sağlam Spot';

  @override
  String get seoSpotDesc => '经济实惠且高品质的二手家具选择。';

  @override
  String get seoAboutTitle => '关于我们 | Sağlam Spot';

  @override
  String get seoAboutDesc => '凭借20年经验，成为家具行业值得信赖的品牌。';

  @override
  String get seoProductDetailSuffix => '查看产品 | Sağlam Spot';

  @override
  String get category => '类别';

  @override
  String get categorySofa => '沙发套件';

  @override
  String get categoryChair => '椅子';

  @override
  String get categoryTable => '桌子';

  @override
  String get categoryBed => '卧室';

  @override
  String get categoryWardrobe => '衣柜';

  @override
  String get categoryWhite => '家电';

  @override
  String get categoryOther => '其他';

  @override
  String get condition => '状态';

  @override
  String get conditionAll => '全部';

  @override
  String get conditionNew => '全新';

  @override
  String get conditionUsed => '二手';

  @override
  String get priceRange => '价格区间';

  @override
  String get price => '价格';

  @override
  String get save => '保存';

  @override
  String get explanation => '描述';

  @override
  String get clear => '清除';

  @override
  String get filter => '筛选';

  @override
  String get apply => '应用';

  @override
  String get cancel => '取消';

  @override
  String get newSeason => '新季节';

  @override
  String get heroTitle => '极简风格\n舒适之巅';

  @override
  String get viewCollection => '查看系列';

  @override
  String get featureArtisan => '真诚匠心';

  @override
  String get featureDelivery => '安全配送';

  @override
  String get featureService => '亲切服务';

  @override
  String get featureShipping => '快速物流';

  @override
  String get quickOptions => '快速选项';

  @override
  String get easyFind => '轻松找到您需要的产品';

  @override
  String get mottoBrand => '焕新旧物，善用新物';

  @override
  String get newCollection => '新系列';

  @override
  String get newCollectionSub => '最新产品';

  @override
  String get spotProducts => '二手产品';

  @override
  String get spotProductsSub => '特惠产品';

  @override
  String get spotProductsDesc => '优质产品，超值价格';

  @override
  String get currentCollection => '当前系列';

  @override
  String get soldProducts => '已售产品';

  @override
  String pieces(int count) {
    return '$count 件';
  }

  @override
  String get stock => '有库存';

  @override
  String get sold => '已售出';

  @override
  String get byRoom => '按生活空间';

  @override
  String get byRoomSub => '为家中每个角落精选';

  @override
  String get roomLivingRoom => '客厅';

  @override
  String get roomLivingRoomSub => '舒适中心';

  @override
  String get roomBedroom => '卧室';

  @override
  String get roomBedroomSub => '安宁睡眠';

  @override
  String get roomKitchen => '厨房';

  @override
  String get roomKitchenSub => '实用方案';

  @override
  String get roomOffice => '办公室';

  @override
  String get roomOfficeSub => '高效办公';

  @override
  String get whoWeAre => '我们是谁？';

  @override
  String get artisanTitle => '20年真诚匠心，\n现代化服务。';

  @override
  String get artisanDesc => '欢迎光临我们的店铺，喝杯茶；让我们一起为您挑选最合适的家具。';

  @override
  String get visitUsButton => '欢迎光临';

  @override
  String get statHappyCustomer => '满意客户';

  @override
  String get statExperience => '经验';

  @override
  String get statDelivery => '配送';

  @override
  String get statTrust => '信任';

  @override
  String get explore => '探索';

  @override
  String get collections => '系列产品';

  @override
  String get corporate => '公司信息';

  @override
  String get aboutUs => '关于我们';

  @override
  String get contact => '联系方式';

  @override
  String get contactUs => '联系我们';

  @override
  String get sss => '常见问题';

  @override
  String get qualityFurniture => '\'优质家具，就在 Sağlam Spot\'';

  @override
  String get footerDesc => '凭借超过20年的经验，我们将品质与信任带到伊斯坦布尔的每个角落。';

  @override
  String get allRightsReserved => '© 2026 SAĞLAM SPOT 贸易公司。保留所有权利。';

  @override
  String get errorOccurred => '发生错误';

  @override
  String get productNotFound => '未找到产品';

  @override
  String get noImages => '无图片';

  @override
  String get error_check_connection => '请检查您的网络连接。';

  @override
  String get error_server_no_response => '服务器暂无响应。';

  @override
  String get error_connection => '连接错误';

  @override
  String get error_connection_lost => '连接已断开';

  @override
  String get status_waiting_connection => '等待连接...';

  @override
  String get error_no_internet_auto_retry => '没有网络连接。\n连接恢复后将自动继续。';

  @override
  String get goBack => '返回';

  @override
  String get galleryEmpty => '图库为空';

  @override
  String get month_1 => '一月';

  @override
  String get month_2 => '二月';

  @override
  String get month_3 => '三月';

  @override
  String get month_4 => '四月';

  @override
  String get month_5 => '五月';

  @override
  String get month_6 => '六月';

  @override
  String get month_7 => '七月';

  @override
  String get month_8 => '八月';

  @override
  String get month_9 => '九月';

  @override
  String get month_10 => '十月';

  @override
  String get month_11 => '十一月';

  @override
  String get month_12 => '十二月';

  @override
  String get noProductFoundTitle => '未找到符合条件的产品';

  @override
  String get noProductFoundDescription => '您可以尝试不同的筛选条件或更改搜索词';

  @override
  String get adminPanelTitle => '管理面板';

  @override
  String get totalCount => '总计';

  @override
  String get productAddedSuccess => '产品添加成功';

  @override
  String get authOrConnectionError => '发生授权或连接错误';

  @override
  String get fillRequiredFields => '请填写产品名称、价格并至少添加一张图片！';

  @override
  String get sessionClosed => '会话已关闭';

  @override
  String get addNewProduct => '添加新产品';

  @override
  String get productImages => '产品图片';

  @override
  String get generalInfo => '基本信息';

  @override
  String get productNameLabel => '产品名称';

  @override
  String get descriptionLabel => '描述';

  @override
  String get statusLabel => '状态';

  @override
  String get spotSecondHand => '二手';

  @override
  String get secondHandHint => '仅一件 — 不显示颜色选项';

  @override
  String get newProductHint => '全新产品 — 您可以添加颜色选项';

  @override
  String get colorOptionsOptional => '颜色选项（可选）';

  @override
  String get noImagesYet => '尚未添加图片';

  @override
  String get addImage => '添加图片';

  @override
  String get editProductTitle => '编辑产品';

  @override
  String get changeImages => '更换图片';

  @override
  String get saveChanges => '保存更改';

  @override
  String get deleteProductTitle => '删除产品';

  @override
  String get deleteProductConfirmSuffix => '将被删除。您确定吗？';

  @override
  String get yesDelete => '是，删除';

  @override
  String get emptyCategoryProducts => '该类别下未找到产品';

  @override
  String get adminLoginSubtitle => '管理面板登录';

  @override
  String get emailLabel => '电子邮箱';

  @override
  String get passwordLabel => '密码';

  @override
  String get loginButton => '登录';

  @override
  String get sponsored => '广告';

  @override
  String get addProductFab => '添加产品';

  @override
  String get singlePieceNotice => '这是二手/现货商品 — 库存仅有一件，颜色和外观与照片完全一致。';

  @override
  String get colorOptionsTitle => '颜色选项';

  @override
  String get newProductBadge => '全新产品';

  @override
  String get usedProductBadge => '二手';

  @override
  String get readMore => '阅读更多';

  @override
  String get readLess => '收起';

  @override
  String get specDelivery => '配送';

  @override
  String get specDeliveryValue => '1-2天内';

  @override
  String get specLocation => '位置';

  @override
  String get sellerTrustLine => '20年本地信誉商家 · İçerenköy';

  @override
  String get whatsappCta => '通过WhatsApp联系';

  @override
  String get callCta => '拨打电话';

  @override
  String get similarProducts => '相似产品';

  @override
  String get conditionShowcase => '展示';

  @override
  String get productDescriptionTitle => '描述';

  @override
  String get loginBrand => 'Sağlam Spot';

  @override
  String get logout => '退出登录';

  @override
  String get logoutConfirm => '您确定要安全退出您的账户吗？';
}
