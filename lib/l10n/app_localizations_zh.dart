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

  @override
  String get testimonialsHeading => '客户怎么说';

  @override
  String get testimonialsSubheading => '20多年来，我们已经走进了 İçerenköy 及周边数千个家庭';

  @override
  String get testimonial1Comment =>
      '我们以非常划算的价格买到了沙发套装，几乎和新的一样。当天就当面送货上门——从一开始就能感受到真正手艺人的诚信。';

  @override
  String get testimonial2Comment => '我在这里以特价买到了卧室套装。和产品描述完全一致，没有任何意外。强烈推荐。';

  @override
  String get testimonial3Comment =>
      '我们为办公室批量采购了家具，价格和质量都超出预期。一个细心又耐心的团队——谢谢你们，Sağlam Spot。';

  @override
  String get testimonial4Comment => '我们以诚实的价格、不讨价还价买到了餐桌套装。他们还帮忙运输，购物过程非常安心。';

  @override
  String get testimonial5Comment => '我们在找一个二手衣柜，找到了一件结实又有品位的家具。是市场上性价比最高的选择。';

  @override
  String get testimonial6Comment => '在展厅参观时我们能亲眼看到产品，这增强了我们的信任。售后他们也一直保持联系。';

  @override
  String get howItWorksHeading => '如何运作';

  @override
  String get step1Title => '浏览与筛选';

  @override
  String get step1Desc => '按类别和价格区间，在数千件产品中找到你喜欢的。';

  @override
  String get step2Title => '联系我们';

  @override
  String get step2Desc => '直接在产品页面上通过 WhatsApp 或电话联系我们的团队。';

  @override
  String get step3Title => '确认价格';

  @override
  String get step3Desc => '到展厅查看实物或通过照片确认，然后约定一个公道的价格。';

  @override
  String get step4Title => '送货上门';

  @override
  String get step4Desc => '快速、有保险的运输，将您的家具安全送达 İçerenköy 及安纳托利亚一侧的家中。';

  @override
  String get tipsEyebrow => '小贴士';

  @override
  String get tipsHeading => '专家护理建议';

  @override
  String get tip1Title => '让客厅更讨人喜欢';

  @override
  String get tip1Desc => '沙发与墙壁之间留出1-2厘米的空隙——有助于空气流通，让房间更通透。';

  @override
  String get tip1Category => '摆放';

  @override
  String get tip2Title => '始终整洁的工作台';

  @override
  String get tip2Desc => '用理线器整理电线，用超细纤维布画圈擦拭——书桌始终保持如新。';

  @override
  String get tip2Category => '清洁';

  @override
  String get tip3Title => '令人愉悦的厨房布局';

  @override
  String get tip3Desc => '重物放在下层架子上，常用物品放在视线高度——实用又安全。';

  @override
  String get tip3Category => '整理';

  @override
  String get tip4Title => '打造舒适的睡眠角落';

  @override
  String get tip4Desc => '把床头远离窗户，减少光线——一个小改变换来明显更深的睡眠。';

  @override
  String get tip4Category => '舒适';

  @override
  String get tip5Title => '让衣柜焕然一新';

  @override
  String get tip5Desc => '把季节性衣物分开，衣架朝同一方向挂——既省空间，每天挑选也更容易。';

  @override
  String get tip5Category => '整理';

  @override
  String get tip6Title => '延长实木家具的寿命';

  @override
  String get tip6Desc => '避免阳光直射，每年用滋养油擦拭几次——是防刮痕和褪色最有效的护理方法。';

  @override
  String get tip6Category => '保养';

  @override
  String get tip7Title => '让布艺沙发更耐用';

  @override
  String get tip7Desc => '每周吸尘一次，污渍立即用湿布擦拭——拖延会让污渍渗入布料。';

  @override
  String get tip7Category => '保养';

  @override
  String get tip8Title => '选择合适的照明';

  @override
  String get tip8Desc => '使用分层照明而非单一的吸顶灯：主灯、任务照明和氛围灯结合，让房间更温馨。';

  @override
  String get tip8Category => '照明';

  @override
  String get tip9Title => '聪明利用小空间';

  @override
  String get tip9Desc => '选择可折叠、多用途的家具；壁挂式搁架能释放地面空间。';

  @override
  String get tip9Category => '整理';

  @override
  String get tip10Title => '把阳台变成生活空间';

  @override
  String get tip10Desc => '一套耐候的座椅加上几盆盆栽，能让阳台成为家中最受欢迎的角落。';

  @override
  String get tip10Category => '户外';

  @override
  String get popularCategoriesHeading => '热门分类';

  @override
  String get popularCategoriesSub => '一键找到适合你的家具';

  @override
  String categoryProductCount(int count) {
    return '$count 件商品';
  }

  @override
  String get newsletterSubscribeSuccess => '您已成功订阅我们的通讯！';

  @override
  String get newsletterHeading => '第一时间了解新品';

  @override
  String get newsletterDesc => '让特价优惠、新品系列和活动直接发送到您的邮箱。没有垃圾邮件，只有值得关注的优惠。';

  @override
  String get emailHint => '您的电子邮箱';

  @override
  String get emailRequired => '电子邮箱为必填项';

  @override
  String get emailInvalid => '请输入有效的电子邮箱';

  @override
  String get whyUsHeading => '为什么选择 Sağlam Spot？';

  @override
  String get usp1Title => '20年值得信赖的手艺';

  @override
  String get usp1Desc => '在 İçerenköy 从事手艺工作超过二十年，拥有数千名满意的客户。';

  @override
  String get usp2Title => '低于市场的价格';

  @override
  String get usp2Desc => '凭借无中间商的经营模式，我们在特价和全新家具上提供最优惠的价格。';

  @override
  String get usp3Title => '经过检验的产品质量';

  @override
  String get usp3Desc => '每件产品在上架销售前都会经过结构和面料/工艺检查。';

  @override
  String get usp4Title => '售后支持';

  @override
  String get usp4Desc => '一个真实的团队，即使在送货之后也能联系到，帮您解决问题。';

  @override
  String get socialShowcaseEyebrow => '分享';

  @override
  String get socialShowcaseHeading => '用 #SağlamSpot 分享您的家居布置';

  @override
  String productsLoadError(String error) {
    return '加载产品时出错：$error';
  }

  @override
  String get viewAllButton => '查看全部';

  @override
  String get showcaseEyebrow => '精选展示';

  @override
  String get exploreButton => '探索';

  @override
  String get visitUsEyebrow => '欢迎光临';

  @override
  String get visitUsHeading => '打个招呼就好';

  @override
  String visitUsOpenLine(String hours) {
    return '我们的大门始终敞开。$hours';
  }

  @override
  String get directionsButton => '获取路线';

  @override
  String get freeDeliveryLabel => '免费送货';

  @override
  String get busLinesLabel => '公交线路';

  @override
  String get statYearsSuffix => '+ 年';

  @override
  String get storeAddress => 'İçerenköy, Ataşehir/İstanbul';

  @override
  String get stayUpdated => '保持关注';

  @override
  String get viewButton => '查看';

  @override
  String get heroSlide2Eyebrow => '二手';

  @override
  String get heroSlide2Title => '有故事的家具';

  @override
  String get heroSlide2Subtitle => '精心挑选、结实又有个性的二手家具。';

  @override
  String get heroSlide3Title => '探索完整系列';

  @override
  String get aboutBadge => '自2012年起与您同行';

  @override
  String get aboutHeroTitle => 'Sağlam Spot\n您熟悉的信任';

  @override
  String get aboutHeroSubtitle => '我们用心去做每一件事，用爱与关怀服务我们的社区。';

  @override
  String get aboutStoryHeading => '我们是谁？（我们的故事）';

  @override
  String get aboutStoryPara1 =>
      '我们的目标是帮助您找到能为家增添温暖、真正称心如意的优质家具。让您的居住空间更美好，是我们的使命。';

  @override
  String get aboutStoryPara2 =>
      '一切始于2012年，就在 İçerenköy 的这家小店。从那时起，我们走进的家庭越来越多。';

  @override
  String get aboutStoryPara3 =>
      '如今，凭借全新以及精心挑选的二手产品，我们已经走进了数千户邻居的家中。我们因您的信任而不断成长。';

  @override
  String get aboutStoryStartLabel => '创立';

  @override
  String get aboutStoryExperienceLabel => '年经验';

  @override
  String get aboutStorySmilesLabel => '满意笑脸';

  @override
  String get aboutValuesHeading => '我们的原则';

  @override
  String get aboutValuesSubheading => '作为手艺人，我们绝不妥协的原则';

  @override
  String get aboutValue1Title => '品质与用心';

  @override
  String get aboutValue1Desc => '无论是新品还是二手，我们都精心挑选，原样呈现给您。';

  @override
  String get aboutValue2Title => '满意笑脸';

  @override
  String get aboutValue2Desc => '对我们来说，最大的收获就是邻居满意地离开店铺。您的满意高于一切。';

  @override
  String get aboutValue3Title => '尊重劳动';

  @override
  String get aboutValue3Desc => '家具是宝贵的劳动成果。通过让二手产品焕发新生，我们既保护您的预算，也保护环境。';

  @override
  String get aboutValue4Title => '诚实与信任';

  @override
  String get aboutValue4Desc => '透明诚实的手艺是我们最大的价值。多年来我们一直在同一个地方陪伴着您。';

  @override
  String get aboutMasterHeading => '认识我们的师傅';

  @override
  String get aboutMasterBody =>
      '我们的师傅自1995年起就活跃在这个行业——超过四分之一个世纪。他曾在知名品牌（İstikbal）工作，深入了解家具的特性、部件和细节。\n\n从送货开车、组装安装，到接待客户、搬运运输，他都亲自参与过，积累了全方位的经验。2012年，他决定开自己的店铺，把这些经验带到了 Sağlam Spot。\n\n他的目标是把在那些大公司学到的品质，与街坊手艺人的真诚和用心结合起来，为您提供最好的服务。';

  @override
  String get aboutDeliveryHeading => '我们的送货与安装服务';

  @override
  String get aboutDeliveryFreeTitle => '免费送货与安装';

  @override
  String get aboutDeliveryZonesLabel => '我们的免费服务区域：';

  @override
  String get aboutDeliveryZonesList =>
      '• 我们所在的 İçerenköy 社区\n• Fındıklı、Kayışdağı、Küçükbakkalköy\n• İnönü 和 Bostancı Sanayi 等邻近区域';

  @override
  String get aboutDeliveryNote =>
      '重要提示：为了保护我们师傅的健康，很遗憾我们无法为没有电梯的建筑提供高楼层搬运服务。感谢您的理解。';

  @override
  String get aboutDeliveryPunctual => '⏰ 我们会在约定的时间准时到达您家门口！';

  @override
  String get aboutTransportHeading => '如何到达我们的店铺';

  @override
  String get aboutTransportBusIntro => '如果您乘坐公交车：';

  @override
  String get aboutBusStop1 => 'Ziyapaşa 站（往 Kadıköy 方向）：';

  @override
  String get aboutBusStop2 => 'İçerenköy 站（往 Kayışdağı 方向）：';

  @override
  String get aboutBusStop3 => 'İçerenköy 站（Yeniyol）：';

  @override
  String get aboutContactPhoneLabel => '电话（快速解答）';

  @override
  String get aboutContactAddressLabel => '地址（欢迎来喝茶）';

  @override
  String get aboutContactAddressValue =>
      'İçerenköy Mahallesi\nBuket Sokak No:6';

  @override
  String get aboutContactHoursLabel => '营业时间';

  @override
  String get aboutContactHoursValue => '周一至周六：09:00 - 22:00\n周日：10:00 - 20:00';

  @override
  String get aboutContactHeading => '联系我们';

  @override
  String get aboutCallNowButton => '立即致电';

  @override
  String get aboutViewMapButton => '在地图上查看';

  @override
  String get aboutMapHeading => '我们的店铺就在这里';

  @override
  String get aboutMapSubtext => '点击地图获取路线';

  @override
  String get newProductsBadgeEyebrow => '新品系列';

  @override
  String get newProductsTitle => '新品\n系列';

  @override
  String get productsBadgeLabel => '件产品';

  @override
  String get breadcrumbHome => '首页';

  @override
  String get statTotalProducts => '产品总数';

  @override
  String get statCategoryLabel => '分类';

  @override
  String get statConditionValueNew => '全新';

  @override
  String get statConditionLabel => '状态';

  @override
  String get statRatingLabel => '评分';

  @override
  String get searchBarRichPrefix => '如需详细搜索产品，请按 ';

  @override
  String get searchBarRichOr => ' 或点击 ';

  @override
  String get searchBarRichHereLink => '这里';

  @override
  String get searchBarRichSuffix => '。';

  @override
  String get sortNewProductsDefault => '最新';

  @override
  String get sortSpotProductsDefault => '最新';

  @override
  String get sortPriceLowHigh => '价格：从低到高';

  @override
  String get sortPriceHighLow => '价格：从高到低';

  @override
  String get sortMostPopular => '最受欢迎';

  @override
  String get spotBadgeEyebrow => '特价产品';

  @override
  String get spotHeroTitle => '特价\n产品';

  @override
  String get spotDiscountLabel => '折扣';

  @override
  String get statSpotProductLabel => '特价产品';

  @override
  String get statDiscountLabel => '折扣';

  @override
  String get statSupportLabel => '支持';

  @override
  String get statFreeLabel => '免费';

  @override
  String get statFreeShippingNote => '仅限周边地区，运费';

  @override
  String get statFreeShippingShort => '运费';

  @override
  String get filtersPanelTitle => '筛选';

  @override
  String get priceRangeSectionTitle => '价格区间';

  @override
  String get clearFiltersButton => '清除筛选';

  @override
  String get tryDifferentFiltersShort => '您可以尝试不同的筛选条件';

  @override
  String get spotBadgeTag => '特价';

  @override
  String productLoadError(String error) {
    return '产品加载失败：$error';
  }

  @override
  String get productSpecConditionNew => '全新产品';

  @override
  String get productLocationValue => 'İçerenköy, İstanbul';

  @override
  String get sortFeatured => '精选推荐';

  @override
  String get sortPriceAsc => '价格：从低到高';

  @override
  String get sortPriceDesc => '价格：从高到低';

  @override
  String get languageSelectorTitle => '语言选择';

  @override
  String get languageTooltip => '语言';

  @override
  String get galleryEmptyMessage => '该产品暂未添加照片。';

  @override
  String get productCardNewBadge => '全新';

  @override
  String get sssHelpCenterBadge => '帮助中心';

  @override
  String get sssHeroTitle => '常见\n问题';

  @override
  String get sssHeroSubtitle => '解答您想知道的一切';

  @override
  String get sssCategoryAll => '全部';

  @override
  String get sssCategoryGeneral => '常规';

  @override
  String get sssCategoryProductService => '产品与服务';

  @override
  String get sssCategoryDelivery => '送货与安装';

  @override
  String get sssCategoryPayment => '付款与订购';

  @override
  String get sssCategoryReturns => '退货与保修';

  @override
  String get sssCategorySecondHandBuying => '二手回收流程';

  @override
  String get sssPhoneSupportTitle => '电话支持';

  @override
  String get sssWorkingHoursTitle => '营业时间';

  @override
  String get sssWorkingHoursValue => '09:00 - 22:00';

  @override
  String get sssStoreAddressTitle => '店铺地址';

  @override
  String get sssStoreAddressValue => 'İçerenköy Mahallesi Buket Sok. No:6';

  @override
  String get sssNoAnswerTitle => '没有找到您想要的答案？';

  @override
  String get sssNoAnswerSubtitle => '您可以联系我们';

  @override
  String get sssVisitStoreButton => '参观店铺';

  @override
  String get sssQ1 => '能介绍一下师傅的工作经历和经验吗？';

  @override
  String get sssA1 =>
      '我们的师傅自1995年起就一直活跃在这个行业。从职业生涯的第一步起，他就不断成长。在他的职业生涯中，他曾担任送货司机、搬运、安装、接待客户等多个岗位，积累了全方位的经验。特别是直到2010年，他曾在 İstikbal 工作，在此期间对产品的特性、部件和诀窍有了深入的了解。2010年之后，他在附近的 Işık Çeyiz 工作，进一步提升了行业能力。2012年，他决定开设自己的手艺店铺，从那时起就致力于把优质服务放在首位，把行业经验以最好的方式传递给客户。';

  @override
  String get sssQ2 => 'Sağlam Spot 可靠吗？';

  @override
  String get sssA2 => '自2012年起，我们一直在 İçerenköy 为邻居们服务。我们已经走进了无数个家庭，现在依然如此。';

  @override
  String get sssQ3 => '我可以去店里看看产品吗？';

  @override
  String get sssA3 =>
      '当然可以！我们甚至特别推荐这样做。喝着茶亲眼看看产品、摸一摸、感受是否合心意，是最稳妥的方式。我们随时欢迎您来 İçerenköy 社区的店铺。';

  @override
  String get sssQ4 => '二手产品的状况是如何检查的？';

  @override
  String get sssA4 =>
      '对我们来说，二手并不意味着\'次品\'。每件产品都会经过我们师傅的细致检查；清洁、保养和必要的维修都会完整完成。照片里看到的就是您会拿到的，但我们还是建议您\'亲自来看看\'。亲眼所见永远是最好的。';

  @override
  String get sssQ5 => '家具的材料质量如何？';

  @override
  String get sssA5 =>
      '我们重视透明度。每件产品都有自己的故事和材质。因此我们会在产品描述中清楚地写出所有细节、材料质量和特性。如果您有任何疑问，请随时提问。';

  @override
  String get sssQ6 => '产品价格是如何确定的？';

  @override
  String get sssA6 =>
      '在定价时，我们会公平地兼顾产品质量和市场情况。我们的目标是让您在不给预算带来压力的情况下，买到高质量、耐用的产品。我们只收取合理的价格，不多收。';

  @override
  String get sssQ7 => '您们的产品有颜色可选吗？';

  @override
  String get sssA7 =>
      '由于我们的产品通常是即时、单件的，我们只能按现有的颜色提供。很遗憾我们无法提供不同的颜色选择。您喜欢的产品颜色，就是您看到的颜色。';

  @override
  String get sssQ8 => '你们接受定制订单吗？';

  @override
  String get sssA8 =>
      '我们也希望能做到！但我们主要专注于现有的、精心挑选的产品。目前很遗憾无法接受定制生产或设计订单。建议您看看我们现有的产品。';

  @override
  String get sssQ9 => '在产品描述中我应该注意什么？';

  @override
  String get sssA9 =>
      '我们最重要的建议：卷尺！请仔细将产品描述中的尺寸与您家中要摆放的位置进行比较。提前解决\'到底放不放得下\'这个问题，可以避免以后的麻烦。测量时也别忘了走廊：不仅要测量摆放位置，还要测量家具如何通过门、走廊和楼梯。也请务必阅读材质和状况信息。';

  @override
  String get sssQ10 => '你们送货到没有电梯的楼房或高楼层吗？';

  @override
  String get sssA10 =>
      '这是我们最敏感也最重要的话题之一。我们是一家亲力亲为的小手艺店。我们的师傅经过多年经验积累，已不再年轻，所以我们也必须考虑他的健康。请您理解：在没有电梯的建筑中，对于高楼层（例如2楼及以上），我们完全无法提供搬运上下的服务。请在下单前先明确这一点，我们不希望让您为难。';

  @override
  String get sssQ11 => '你们提供运输服务吗？';

  @override
  String get sssA11 =>
      '当然，我们会帮助邻居。我们主要为 İçerenköy 以及附近的 Fındıklı、Kayışdağı、Küçükbakkalköy、İnönü 和 Bostancı Sanayi 等地区提供免费运输服务。（Bostancı 和 Kozyatağı 的部分地区除外，另外由于师傅年龄原因，我们无法为没有电梯的高楼层搬运，这个我们会另外沟通。）';

  @override
  String get sssQ12 => '送货需要多长时间？';

  @override
  String get sssA12 =>
      '您一下单，我们就会联系您。我们会问\'您什么时候方便？\'，约定一个双方都合适的时间。通常我们会在1-3天内、约定的时间完成送货和安装。';

  @override
  String get sssQ13 => '你们提供安装服务吗？';

  @override
  String get sssA13 =>
      '当然。把家具送到就丢在门口不是我们的风格。所有大件产品都由我们的师傅亲自安装，我们不会为此额外收费。您只需指出位置，剩下的交给我们。';

  @override
  String get sssQ14 => '家具订单多久能送达？';

  @override
  String get sssA14 =>
      '如果产品已备好，我们会在双方约定的时间尽快送达您家门口。安装也不用担心；我们会按照运来的样子组装好，交付时已是成品状态。通常当天就能全部完成。';

  @override
  String get sssQ15 => '我可以赊账下单吗？';

  @override
  String get sssA15 =>
      '在这一点上请您理解。作为一家手艺店，为了维持经营，我们很遗憾无法采用\'赊账\'或\'延后付款\'等方式。产品交付时我们需要收取约定金额的现金。我们更愿意事先说明这条规则，以免让您为难。';

  @override
  String get sssQ16 => '我如何下单？';

  @override
  String get sssA16 =>
      '最稳妥的方式始终是当面。先在网站上记下您喜欢的产品，然后来我们店里。亲眼看看产品，问出您心中的疑问，如果满意，我们就当场完成订单。这样就不会留下任何疑虑。';

  @override
  String get sssQ17 => '你们的退货政策是什么？';

  @override
  String get sssA17 =>
      '由于二手产品的特性以及我们作为手艺店的经营方式，我们很遗憾无法接受退货。所以我们坚持\'请来看看，和我们喝杯茶\'。购买前仔细查看并测量产品才是最正确的做法。在没有十足把握之前，我们不建议完成购买。';

  @override
  String get sssQ18 => '产品有保修期吗？';

  @override
  String get sssA18 =>
      '由于我们的产品是二手的，很遗憾我们没有像品牌那样的正式保修期。但我们不是那种\'卖了就完事\'的商家。我们会确保在送货和安装时一切都能正常运作。';

  @override
  String get sssQ19 => '我想出售家中的物品，你们收购二手吗？';

  @override
  String get sssA19 =>
      '是的，我们会收购那些我们认为可以在店里展示、干净且可以转售的精选产品。但由于我们店铺的空间确实非常小，很遗憾我们在这方面必须非常挑剔。\n\n我们更愿意从一开始就诚实相告：您从我们这里得到的报价，可能会比您自己在 Letgo 等平台上出售能拿到的价格略低。原因是：作为手艺人，我们要花油费去取货，投入人力运输，最重要的是，我们要独自承担在店里展示和出售的整个客户流程（讨价还价、答疑等等）。\n\n而当您自己在那些平台上出售时，这些流程全部要您自己承担。我们则替您承担了这些麻烦。我们的报价也包含了这项服务。感谢您的理解。';

  @override
  String get sssQ20 => '你们收购整套家具（卧室、客厅套装等）吗？';

  @override
  String get sssA20 =>
      '由于我们店铺很小，很遗憾我们无法收购像整套卧室或沙发套装这样的大件套装。我们的空间非常有限。我们更专注于像柜子、衣柜、桌子、椅子这类更容易出售的单件家具。';

  @override
  String get sssQ21 => '我的物品在高楼层，楼里没有电梯。你们还会收购吗？';

  @override
  String get sssA21 =>
      '和送货的情况一样，这是我们最明确的规则。出于师傅健康的考虑，我们完全无法从没有电梯的建筑高楼层往下搬运物品。只有当您的物品靠近一楼/入口楼层，或楼里有货运电梯时，我们才能考虑。';

  @override
  String get sssQ22 => '你们是不是随时都收购物品？';

  @override
  String get sssA22 =>
      '这完全取决于我们店里当时的空间。由于我们店铺很小，我们按照\'卖一件、收一件\'的平衡在运营。有时候我们非常喜欢某件产品，但因为没有空间而无法收购。最好的办法是把您想出售的产品照片发给我们，我们会诚实地告诉您\'现在有空间\'还是\'很遗憾这段时间已经满了\'。';

  @override
  String get navDiscover => '发现';

  @override
  String get navCart => '购物车';

  @override
  String get navProfile => '我的';

  @override
  String get storeHeroEyebrow => '新品系列';

  @override
  String get storeHeroTitle => '家的感觉\n从家具开始';

  @override
  String get storeHeroSubtitle => '优质全新及二手家具，以您满意的价格送到家门口。';

  @override
  String get storeHeroCta => '开始购物';

  @override
  String get sectionCategories => '分类';

  @override
  String get sectionBestSellers => '热销商品';

  @override
  String get sectionNewArrivals => '新品上架';

  @override
  String get seeAll => '查看全部';

  @override
  String get cartTitle => '我的购物车';

  @override
  String get cartEmptyTitle => '购物车是空的';

  @override
  String get cartEmptyDesc => '将喜欢的商品加入购物车，然后一条消息询问所有商品。';

  @override
  String get cartTotalLabel => '合计';

  @override
  String get cartWhatsappCta => '通过WhatsApp发送购物车';

  @override
  String get cartItemRemoved => '已从购物车移除';

  @override
  String get addToCartCta => '加入购物车';

  @override
  String get addedToCartMessage => '已加入购物车';

  @override
  String get alreadyInCartMessage => '该商品已在购物车中';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsLanguageLabel => '语言';

  @override
  String get settingsAccountSection => '账户';

  @override
  String get settingsGeneralSection => '通用';

  @override
  String get settingsContact => '联系方式';

  @override
  String get settingsCallUs => '致电我们';

  @override
  String get settingsAdminLogin => '管理员登录';

  @override
  String get settingsAppVersion => '应用版本';

  @override
  String cartItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件商品',
      one: '1件商品',
      zero: '购物车是空的',
    );
    return '$_temp0';
  }

  @override
  String get settingsRateApp => '给应用评分';

  @override
  String get settingsShareApp => '分享应用';

  @override
  String get settingsPrivacyPolicy => '隐私政策';

  @override
  String get settingsTerms => '使用条款';

  @override
  String get legalContentTurkishOnly => '此内容目前仅提供土耳其语版本。';

  @override
  String get doubleBackToExit => '再次按返回键退出';

  @override
  String get productLinkLabel => '商品链接';

  @override
  String get settingsAppSection => '应用';

  @override
  String get settingsLegalSection => '法律信息';

  @override
  String get recentlyViewedTitle => '最近浏览';

  @override
  String get productTrustBadgeVerified => '认证卖家';

  @override
  String get productTrustBadgeNegotiate => '通过WhatsApp议价';

  @override
  String get productTrustBadgeDelivery => '现场交货';

  @override
  String get howToBuyTitle => '如何购买？';

  @override
  String get howToBuyStep1Title => '在WhatsApp上留言';

  @override
  String get howToBuyStep1Desc => '如果您喜欢该商品，请通过WhatsApp联系我们。';

  @override
  String get howToBuyStep2Title => '商议价格';

  @override
  String get howToBuyStep2Desc => '一起商定价格和交货细节。';

  @override
  String get howToBuyStep3Title => '取货';

  @override
  String get howToBuyStep3Desc => '达成一致后，安全取走您的商品。';

  @override
  String get listedToday => '今天发布';

  @override
  String listedDaysAgo(int days) {
    return '$days天前发布';
  }

  @override
  String listedWeeksAgo(int weeks) {
    return '$weeks周前发布';
  }
}
