import 'package:flutter/material.dart';

class PerformerPreviewCard extends StatelessWidget {
  const PerformerPreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PERFORMER VIEW PREVIEW',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            color: Color(0xFFD4C5AB),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFF504532).withValues(alpha: 0.15),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background Accent
              Positioned(
                top: -48,
                right: -48,
                child: Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFBF00).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  // Emulating blur-3xl conceptually
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFFAFF3),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'NEW OPPORTUNITY',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2.0,
                                    color: Color(0xFFFFAFF3),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'The Electric Loft',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFE2E2E2),
                              ),
                            ),
                            const Text(
                              'Downtown Arts District',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFD4C5AB),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF504532)
                                  .withValues(alpha: 0.1),
                            ),
                          ),
                          child: const Text(
                            '\$350+',
                            style: TextStyle(
                              color: Color(0xFFFFBF00),
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Color(0xFF1F1F1F),
                          backgroundImage: NetworkImage(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuCvVe6WjRsDFkbzE9_iOa0ckN66JfQd0X_qkDXAmuLw3326Uz86x3IH7F00sJUq1zcdZjko1ZQGg-fdsW79QYpZK56pvdUlrRU_pNbMZ4Wynkm-P14kAba_JjEeha9is3DghgSltm1gu1SqCS07oVa1wlPdUF_EwZqwgs-wbyUKBkE44Tf2t2apHcV2Db2_ApG5dkuDOdaKwVZzTY8iQ1qLime9yksQ3FyOeKZZfmdPxNM02aC2cvAT_XC3u7PrgBnpIBdZMuJRJ18V',
                          ),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Friday, May 22',
                              style: TextStyle(
                                color: Color(0xFFE2E2E2),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '9:00 PM Performance',
                              style: TextStyle(
                                color: Color(0xFFD4C5AB),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        _buildTag('FOLK'),
                        const SizedBox(width: 8),
                        _buildTag('METAL'),
                        const SizedBox(width: 8),
                        _buildTag('LOAD-IN 7PM'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: Color(0xFFD4C5AB),
        ),
      ),
    );
  }
}
