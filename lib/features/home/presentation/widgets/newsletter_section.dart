import 'package:flutter/material.dart';
import '../../../../core/common/extentions/app_context_ui_extension.dart';
import '../../../../core/theme/app_colors.dart';

class NewsletterSection extends StatefulWidget {
  const NewsletterSection({super.key});

  @override
  State<NewsletterSection> createState() => _NewsletterSectionState();
}

class _NewsletterSectionState extends State<NewsletterSection> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _subscribe() {
    if (!_formKey.currentState!.validate()) return;
    // TODO: Firestore 'newsletter_subscribers' koleksiyonuna kayıt entegrasyonu
    // burada backend'e bağlanabilir (product_repository ile aynı pattern kullanılarak).
    setState(() => _submitted = true);
    _emailController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bültenimize başarıyla abone oldunuz!')),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 60, vertical: 20),
        padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 60, vertical: isMobile ? 32 : 50),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryVariant],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Flex(
          direction: isMobile ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: isMobile ? 0 : 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Yeni Ürünlerden İlk Siz Haberdar Olun',
                    style: TextStyle(
                        fontFamily: 'Fraunces',
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        height: 1.2),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Spot fırsatlar, yeni koleksiyonlar ve kampanyalar e-posta kutunuza gelsin. Spam yok, sadece işinize yarayacak fırsatlar.',
                    style: TextStyle(
                        fontFamily: 'Inter', color: Colors.white.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
            SizedBox(width: isMobile ? 0 : 40, height: isMobile ? 24 : 0),
            Expanded(
              flex: isMobile ? 0 : 2,
              child: Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'E-posta adresiniz',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.08),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                          ),
                        ),
                        validator: (final value) {
                          if (value == null || value.isEmpty) {
                            return 'E-posta gerekli';
                          }
                          final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                          if (!regex.hasMatch(value)) return 'Geçerli bir e-posta girin';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _subscribe,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.secondary,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Icon(_submitted ? Icons.check_rounded : Icons.arrow_forward_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
