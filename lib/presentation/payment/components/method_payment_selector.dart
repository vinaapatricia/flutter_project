import 'package:flutter/material.dart';
import '../../../configs/theme/app_colors.dart';

class CategoryPaymentSelector extends StatelessWidget {
  final int selectedPaymentCategoryIndex;
  final ValueChanged<int> onPaymentCategorySelected;

  const CategoryPaymentSelector({
    required this.selectedPaymentCategoryIndex,
    required this.onPaymentCategorySelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            onPaymentCategorySelected(0);
          },
          child: CategoryChip(
            text: 'Bank',
            isSelected: selectedPaymentCategoryIndex == 0,
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () {
            onPaymentCategorySelected(1);
          },
          child: CategoryChip(
            text: 'E-Wallet',
            isSelected: selectedPaymentCategoryIndex == 1,
          ),
        ),
      ],
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String text;
  final bool isSelected;

  const CategoryChip({
    required this.text,
    required this.isSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 114,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: ShapeDecoration(
        color:
            isSelected ? AppColors.lightBackground : AppColors.lightBackground,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: isSelected ? AppColors.primary : AppColors.lightBackground,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? AppColors.primary : Colors.black54,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
