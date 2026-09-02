import 'package:flutter/material.dart';
import '../../../../core/ads/widgets/adsense_banner.dart';
import '../../../../core/common/enum/enums.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/util/comminucation_actions.dart';
import '../../../../core/widgets/business_info_showcase.dart';
import '../../../../shared/navigation/widgets/nav_handler.dart';

enum _FaqCategory {
  all,
  general,
  productService,
  delivery,
  payment,
  returns,
  secondHandBuying,
}

class _Faq {
  final _FaqCategory category;
  final String question;
  final String answer;

  const _Faq(
      {required this.category, required this.question, required this.answer});
}

class SSSPage extends StatefulWidget {
  const SSSPage({super.key});

  @override
  State<SSSPage> createState() => _SSSPageState();
}

class _SSSPageState extends State<SSSPage> {
  int? _expandedIndex;
  _FaqCategory _selectedCategory = _FaqCategory.all;

  String _categoryLabel(final BuildContext context, final _FaqCategory cat) {
    switch (cat) {
      case _FaqCategory.all:
        return context.l10n.sssCategoryAll;
      case _FaqCategory.general:
        return context.l10n.sssCategoryGeneral;
      case _FaqCategory.productService:
        return context.l10n.sssCategoryProductService;
      case _FaqCategory.delivery:
        return context.l10n.sssCategoryDelivery;
      case _FaqCategory.payment:
        return context.l10n.sssCategoryPayment;
      case _FaqCategory.returns:
        return context.l10n.sssCategoryReturns;
      case _FaqCategory.secondHandBuying:
        return context.l10n.sssCategorySecondHandBuying;
    }
  }

  List<_Faq> _faqs(final BuildContext context) => [
        // GENEL SORULAR
        _Faq(
            category: _FaqCategory.general,
            question: context.l10n.sssQ1,
            answer: context.l10n.sssA1),
        _Faq(
            category: _FaqCategory.general,
            question: context.l10n.sssQ2,
            answer: context.l10n.sssA2),
        _Faq(
            category: _FaqCategory.general,
            question: context.l10n.sssQ3,
            answer: context.l10n.sssA3),

        // ÜRÜN & HİZMET SORULARI
        _Faq(
            category: _FaqCategory.productService,
            question: context.l10n.sssQ4,
            answer: context.l10n.sssA4),
        _Faq(
            category: _FaqCategory.productService,
            question: context.l10n.sssQ5,
            answer: context.l10n.sssA5),
        _Faq(
            category: _FaqCategory.productService,
            question: context.l10n.sssQ6,
            answer: context.l10n.sssA6),
        _Faq(
            category: _FaqCategory.productService,
            question: context.l10n.sssQ7,
            answer: context.l10n.sssA7),
        _Faq(
            category: _FaqCategory.productService,
            question: context.l10n.sssQ8,
            answer: context.l10n.sssA8),
        _Faq(
            category: _FaqCategory.productService,
            question: context.l10n.sssQ9,
            answer: context.l10n.sssA9),

        // TESLİMAT & MONTAJ SORULARI
        _Faq(
            category: _FaqCategory.delivery,
            question: context.l10n.sssQ10,
            answer: context.l10n.sssA10),
        _Faq(
            category: _FaqCategory.delivery,
            question: context.l10n.sssQ11,
            answer: context.l10n.sssA11),
        _Faq(
            category: _FaqCategory.delivery,
            question: context.l10n.sssQ12,
            answer: context.l10n.sssA12),
        _Faq(
            category: _FaqCategory.delivery,
            question: context.l10n.sssQ13,
            answer: context.l10n.sssA13),
        _Faq(
            category: _FaqCategory.delivery,
            question: context.l10n.sssQ14,
            answer: context.l10n.sssA14),

        // ÖDEME & SİPARİŞ SORULARI
        _Faq(
            category: _FaqCategory.payment,
            question: context.l10n.sssQ15,
            answer: context.l10n.sssA15),
        _Faq(
            category: _FaqCategory.payment,
            question: context.l10n.sssQ16,
            answer: context.l10n.sssA16),

        // İADE & GARANTİ SORULARI
        _Faq(
            category: _FaqCategory.returns,
            question: context.l10n.sssQ17,
            answer: context.l10n.sssA17),
        _Faq(
            category: _FaqCategory.returns,
            question: context.l10n.sssQ18,
            answer: context.l10n.sssA18),

        // İKİNCİ EL ALIM SÜRECİ
        _Faq(
            category: _FaqCategory.secondHandBuying,
            question: context.l10n.sssQ19,
            answer: context.l10n.sssA19),
        _Faq(
            category: _FaqCategory.secondHandBuying,
            question: context.l10n.sssQ20,
            answer: context.l10n.sssA20),
        _Faq(
            category: _FaqCategory.secondHandBuying,
            question: context.l10n.sssQ21,
            answer: context.l10n.sssA21),
        _Faq(
            category: _FaqCategory.secondHandBuying,
            question: context.l10n.sssQ22,
            answer: context.l10n.sssA22),
      ];

  List<_Faq> _filteredFaqs(final BuildContext context) {
    final all = _faqs(context);
    if (_selectedCategory == _FaqCategory.all) return all;
    return all.where((final faq) => faq.category == _selectedCategory).toList();
  }

  @override
  Widget build(final BuildContext context) {
    if (context.isMobile) return _buildMobileScaffold(context);

    return CustomScrollView(
      slivers: [
        // Hero Section
        _buildHeroSection(context),

        // Category Filters
        _buildCategoryFilters(context),

        // Quick Help
        _buildQuickHelp(context),

        // FAQ List
        _buildFAQList(context),

        // Canlı harita + gerçek zamanlı Açık/Kapalı rozeti + çalışma
        // saatleri — bu sayfada daha önce hiç gerçek harita/saat bilgisi
        // yoktu, sadece "mağazayı ziyaret et" butonu vardı.
        const SliverToBoxAdapter(child: BusinessInfoShowcase()),

        // Contact CTA
        _buildContactCTA(context),

        const SliverToBoxAdapter(child: SizedBox(height: 60)),
        const SliverToBoxAdapter(
            child: AdsenseBanner(height: 100, type: AdUnitType.multiplex)),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════
  // MOBİL TASARIM — teal/sage paleti, gerçek Scaffold + geri butonu +
  // alt navigasyon çubuğu, sıkıştırılmış tek-sütun akordeon SSS listesi.
  // ════════════════════════════════════════════════════════════

  Widget _buildMobileScaffold(final BuildContext context) {
    final filteredFaqs = _filteredFaqs(context);

    return Scaffold(
      backgroundColor: AppColors.mobileBackground,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildMobileHeader(context)),
            SliverToBoxAdapter(child: _buildMobileCategoryChips(context)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (final context, final index) =>
                      _buildMobileFaqCard(context, filteredFaqs[index], index),
                  childCount: filteredFaqs.length,
                ),
              ),
            ),
            SliverToBoxAdapter(child: _buildMobileContactCard(context)),
            const SliverToBoxAdapter(
                child: Padding(
                    padding: EdgeInsets.only(top: 14),
                    child: BusinessInfoShowcase())),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileHeader(final BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 20, 4),
        child: Row(
          children: [
            IconButton(
              onPressed: () => NavigationHandler.smartGoBack(context),
              icon: Icon(Icons.arrow_back_rounded,
                  color: AppColors.mobileTextPrimary),
            ),
            Expanded(
              child: Text(
                context.l10n.sssHeroTitle,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: AppColors.mobileTextPrimary,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildMobileCategoryChips(final BuildContext context) {
    final allFaqs = _faqs(context);
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _FaqCategory.values.length,
        separatorBuilder: (final _, final __) => const SizedBox(width: 8),
        itemBuilder: (final context, final index) {
          final category = _FaqCategory.values[index];
          final isSelected = _selectedCategory == category;
          final count = category == _FaqCategory.all
              ? allFaqs.length
              : allFaqs.where((final f) => f.category == category).length;

          return GestureDetector(
            onTap: () => setState(() {
              _selectedCategory = category;
              _expandedIndex = null;
            }),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.mobilePrimary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.mobilePrimary
                      : AppColors.mobileBorder,
                ),
              ),
              child: Text(
                '${_categoryLabel(context, category)} ($count)',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color:
                      isSelected ? Colors.white : AppColors.mobileTextSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMobileFaqCard(
      final BuildContext context, final _Faq faq, final int index) {
    final isExpanded = _expandedIndex == index;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded ? AppColors.mobilePrimary : AppColors.mobileBorder,
          width: isExpanded ? 1.6 : 1,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () =>
                setState(() => _expandedIndex = isExpanded ? null : index),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      faq.question,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: isExpanded
                            ? AppColors.mobilePrimary
                            : AppColors.mobileTextPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.remove_circle_outline_rounded
                        : Icons.add_circle_outline_rounded,
                    color: isExpanded
                        ? AppColors.mobilePrimary
                        : AppColors.mobileTextTertiary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  faq.answer,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppColors.mobileTextSecondary,
                    height: 1.55,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMobileContactCard(final BuildContext context) => Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.mobilePrimaryGradient,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Icon(Icons.support_agent_rounded,
                color: Colors.white, size: 36),
            const SizedBox(height: 12),
            Text(
              context.l10n.sssNoAnswerTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              context.l10n.sssNoAnswerSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.85), fontSize: 12.5),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => SaglamSpotCommunication.makeCall(),
                    icon: const Icon(Icons.call_rounded,
                        size: 16, color: Colors.white),
                    label: Text(context.l10n.contactUs,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12.5)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white70),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => SaglamSpotCommunication.launchWhatsApp(
                        message: context.l10n.defaultWhatsappGreeting),
                    icon: const Icon(Icons.chat_bubble_rounded, size: 16),
                    label: Text(context.l10n.whatsappCta,
                        style: const TextStyle(fontSize: 12.5)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.mobilePrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _buildHeroSection(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: context.responsive(
          mobile: const EdgeInsets.all(16),
          desktop: const EdgeInsets.all(24),
        ),
        height: context.responsive(mobile: 250, desktop: 350),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            context.responsive(mobile: 24.0, desktop: 32.0),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.sage, AppColors.sageDark],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -50,
              bottom: -50,
              child: Icon(
                Icons.help_outline_rounded,
                size: context.responsive(mobile: 200, desktop: 300),
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            Padding(
              padding: context.responsive(
                mobile: const EdgeInsets.all(24),
                desktop: const EdgeInsets.all(60),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(24)),
                    child: Text(context.l10n.sssHelpCenterBadge,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                context.responsive(mobile: 12, desktop: 14),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5)),
                  ),
                  const SizedBox(height: 24),
                  Text(context.l10n.sssHeroTitle,
                      style: TextStyle(
                          fontFamily: 'Fraunces',
                          color: Colors.white,
                          fontSize: context.responsive(mobile: 32, desktop: 52),
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                          letterSpacing: -1)),
                  const SizedBox(height: 20),
                  Text(context.l10n.sssHeroSubtitle,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: context.responsive(mobile: 16, desktop: 20),
                          fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilters(final BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: context.responsive(
          mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        padding: context.responsive(
          mobile: const EdgeInsets.all(16),
          desktop: const EdgeInsets.all(24),
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(
            context.responsive(mobile: 16.0, desktop: 24.0),
          ),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2))
          ],
        ),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _FaqCategory.values.map((final category) {
            final isSelected = _selectedCategory == category;
            final allFaqs = _faqs(context);
            final count = category == _FaqCategory.all
                ? allFaqs.length
                : allFaqs.where((final f) => f.category == category).length;

            return FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_categoryLabel(context, category)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textTertiary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      count.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color:
                            isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              selected: isSelected,
              onSelected: (final selected) {
                setState(() {
                  _selectedCategory = category;
                  _expandedIndex = null;
                });
              },
              backgroundColor: AppColors.background,
              selectedColor: AppColors.primary.withOpacity(0.15),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: context.responsive(mobile: 14, desktop: 16),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
              ),
              padding: context.responsive(
                mobile:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                desktop:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildQuickHelp(final BuildContext context) {
    final children = [
      Expanded(
        child: _buildQuickHelpCard(
          context,
          Icons.phone_outlined,
          context.l10n.sssPhoneSupportTitle,
          '+90 5392019961',
          AppColors.success,
        ),
      ),
      SizedBox(
        width: context.responsive(mobile: 0, desktop: 16),
        height: context.responsive(mobile: 16, desktop: 0),
      ),
      Expanded(
        child: _buildQuickHelpCard(
          context,
          Icons.access_time_outlined,
          context.l10n.sssWorkingHoursTitle,
          context.l10n.sssWorkingHoursValue,
          AppColors.info,
        ),
      ),
      SizedBox(
        width: context.responsive(mobile: 0, desktop: 16),
        height: context.responsive(mobile: 16, desktop: 0),
      ),
      Expanded(
        child: _buildQuickHelpCard(
          context,
          Icons.location_on_outlined,
          context.l10n.sssStoreAddressTitle,
          context.l10n.sssStoreAddressValue,
          AppColors.secondary,
        ),
      ),
    ];

    return SliverToBoxAdapter(
      child: Container(
        margin: context.responsive(
          mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        child: context.responsive<Widget>(
          mobile: Column(children: children),
          desktop: Row(children: children),
        ),
      ),
    );
  }

  Widget _buildQuickHelpCard(
    final BuildContext context,
    final IconData icon,
    final String title,
    final String subtitle,
    final Color color,
  ) {
    return Container(
      padding: context.responsive(
        mobile: const EdgeInsets.all(16),
        desktop: const EdgeInsets.all(24),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          context.responsive(mobile: 16.0, desktop: 20.0),
        ),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color,
              size: context.responsive(mobile: 28, desktop: 32),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: context.responsive(mobile: 14, desktop: 16),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: context.responsive(mobile: 14, desktop: 14),
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQList(final BuildContext context) {
    final filteredFaqs = _filteredFaqs(context);

    return SliverPadding(
      padding: context.responsive(
        mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (final context, final index) {
            final faq = filteredFaqs[index];
            final isExpanded = _expandedIndex == index;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(
                  context.responsive(mobile: 16.0, desktop: 20.0),
                ),
                border: Border.all(
                  color: isExpanded ? AppColors.primary : AppColors.border,
                  width: isExpanded ? 2 : 1,
                ),
                boxShadow: isExpanded
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _expandedIndex = isExpanded ? null : index;
                      });
                    },
                    borderRadius: BorderRadius.circular(
                      context.responsive(mobile: 16.0, desktop: 20.0),
                    ),
                    child: Padding(
                      padding: context.responsive(
                        mobile: const EdgeInsets.all(16),
                        desktop: const EdgeInsets.all(24),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(faq.category)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _categoryLabel(context, faq.category),
                              style: TextStyle(
                                fontSize: context.captionSize,
                                fontWeight: FontWeight.w600,
                                color: _getCategoryColor(faq.category),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              faq.question,
                              style: TextStyle(
                                fontSize: context.titleSize,
                                fontWeight: FontWeight.w600,
                                color: isExpanded
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Icon(
                            isExpanded
                                ? Icons.expand_less_rounded
                                : Icons.expand_more_rounded,
                            color: isExpanded
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isExpanded)
                    Container(
                      padding: context.responsive(
                        mobile: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        desktop: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(height: 1),
                          const SizedBox(height: 20),
                          Text(
                            faq.answer,
                            style: TextStyle(
                              fontSize: context.bodySize,
                              color: AppColors.textSecondary,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
          childCount: filteredFaqs.length,
        ),
      ),
    );
  }

  Widget _buildContactCTA(final BuildContext context) {
    final buttonPadding = context.responsive(
      mobile: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      desktop: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
    );
    final buttonTextStyle = TextStyle(
      fontSize: context.responsive(mobile: 16, desktop: 18),
      fontWeight: FontWeight.bold,
    );

    final buttons = [
      FilledButton(
        onPressed: () => _launchPhone(),
        style: FilledButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primary,
          padding: buttonPadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.phone),
            const SizedBox(width: 12),
            Text(context.l10n.contactUs, style: buttonTextStyle),
          ],
        ),
      ),
      SizedBox(
        height: context.responsive(mobile: 12, desktop: 16),
        width: context.responsive(mobile: 0, desktop: 16),
      ),
      OutlinedButton(
        onPressed: () => _launchMaps(),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          padding: buttonPadding,
          side: const BorderSide(color: Colors.white, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map_outlined),
            const SizedBox(width: 12),
            Text(
              context.l10n.sssVisitStoreButton,
              style: buttonTextStyle.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    ];

    return SliverToBoxAdapter(
      child: Container(
        margin: context.responsive(
          mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          desktop: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        ),
        padding: context.responsive(
          mobile: const EdgeInsets.all(24),
          desktop: const EdgeInsets.all(48),
        ),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(
            context.responsive(mobile: 24.0, desktop: 32.0),
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.support_agent_outlined,
              size: context.responsive(mobile: 48, desktop: 80),
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.sssNoAnswerTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.responsive(mobile: 24, desktop: 32),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.sssNoAnswerSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: context.responsive(mobile: 16, desktop: 18),
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            context.responsive<Widget>(
              mobile: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: buttons,
              ),
              desktop: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: buttons,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchPhone() async {
    await SaglamSpotCommunication.makeCall();
  }

  Future<void> _launchMaps() async {
    await SaglamSpotCommunication.openStoreLocation();
  }

  Color _getCategoryColor(final _FaqCategory category) {
    switch (category) {
      case _FaqCategory.general:
        return AppColors.primary;
      case _FaqCategory.productService:
        return AppColors.info;
      case _FaqCategory.delivery:
        return AppColors.success;
      case _FaqCategory.payment:
        return AppColors.warning;
      case _FaqCategory.returns:
        return AppColors.secondary;
      case _FaqCategory.secondHandBuying:
        return AppColors.textPrimary;
      case _FaqCategory.all:
        return AppColors.textSecondary;
    }
  }
}
