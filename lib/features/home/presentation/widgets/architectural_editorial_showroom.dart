import 'dart:ui';
import 'package:flutter/material.dart';

class ArchitecturalEditorialShowroom extends StatefulWidget {
  const ArchitecturalEditorialShowroom({super.key});

  @override
  State<ArchitecturalEditorialShowroom> createState() =>
      _ArchitecturalEditorialShowroomState();
}

class _ArchitecturalEditorialShowroomState
    extends State<ArchitecturalEditorialShowroom>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final Animation<double> _opacityAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _opacityAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.1, 1.0,
          curve: Curves
              .fastLinearToSlowEaseIn), // Gerçek ve geçerli Flutter Syntax'ı
    ));

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isDesktop = size.width > 960;

    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const Text(
                    '01',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w200,
                      color: Color(0xFF0A1628),
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: isDesktop ? 60 : 30,
                    height: 1,
                    color: const Color(0xFF0A1628).withOpacity(0.2),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'RAFİNE ÇİZGİLER / MODERN SHOWROOM',
                      style: TextStyle(
                        fontSize: 9,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Flex(
                direction: isDesktop ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: isDesktop ? 6 : 0,
                    child: Stack(
                      children: [
                        Container(
                          height: isDesktop ? 450 : 280,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF1F5F9),
                            image: DecorationImage(
                              image: AssetImage('assets/images/book_room.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  const Color(0xFF0A1628).withOpacity(0.3),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      width: isDesktop ? 24 : 0, height: isDesktop ? 0 : 16),
                  Expanded(
                    flex: isDesktop ? 4 : 0,
                    child: Padding(
                      padding: EdgeInsets.only(top: isDesktop ? 16.0 : 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sonsuz Dönüşüm\nMimari Estetik',
                            style: TextStyle(
                              fontSize: 24,
                              height: 1.3,
                              color: Color(0xFF0A1628),
                              fontWeight: FontWeight.w300,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Sağlam Spot tasarım felsefesi, mobilyayı yaşam alanının bütünlüğünü tamamlayan mimari bir unsur olarak ele alır.',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.6,
                              color: Color(0xFF475569),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Color(0xFF0A1628), width: 1.5),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'KOLEKSİYONU İNCELE',
                                      style: TextStyle(
                                        fontSize: 10,
                                        letterSpacing: 2,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0A1628),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Icon(Icons.arrow_forward_ios,
                                        size: 10, color: Color(0xFF0A1628)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
