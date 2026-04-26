import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PayrollSkeletonLoader extends StatelessWidget {
  const PayrollSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.white,
        child: Column(
          children: [
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _box(72)),
                const SizedBox(width: 8),
                Expanded(child: _box(72)),
                const SizedBox(width: 8),
                Expanded(child: _box(72)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _box(double h) {
    return Container(
      height: h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
