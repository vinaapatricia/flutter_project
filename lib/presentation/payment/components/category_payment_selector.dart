import 'package:flutter/material.dart';
import 'package:flutter_project/configs/theme/app_colors.dart';

class BankPaymentSelector extends StatelessWidget {
  final int selectedBankMethodIndex;
  final ValueChanged<int> onBankMethodSelected;

  const BankPaymentSelector({
    required this.selectedBankMethodIndex,
    required this.onBankMethodSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PaymentChip(
          text: 'BRI',
          isSelected: selectedBankMethodIndex == 0,
          onTap: () => onBankMethodSelected(0),
        ),
        PaymentChip(
          text: 'BCA',
          isSelected: selectedBankMethodIndex == 1,
          onTap: () => onBankMethodSelected(1),
        ),
        PaymentChip(
          text: 'Mandiri',
          isSelected: selectedBankMethodIndex == 2,
          onTap: () => onBankMethodSelected(2),
        ),
      ],
    );
  }
}

class EWalletPaymentSelector extends StatelessWidget {
  final int selectedEWalletMethodIndex;
  final ValueChanged<int> onEWalletMethodSelected;

  const EWalletPaymentSelector({
    required this.selectedEWalletMethodIndex,
    required this.onEWalletMethodSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PaymentChip(
          text: 'OVO',
          isSelected: selectedEWalletMethodIndex == 0,
          onTap: () => onEWalletMethodSelected(0),
        ),
        PaymentChip(
          text: 'GoPay',
          isSelected: selectedEWalletMethodIndex == 1,
          onTap: () => onEWalletMethodSelected(1),
        ),
        PaymentChip(
          text: 'Dana',
          isSelected: selectedEWalletMethodIndex == 2,
          onTap: () => onEWalletMethodSelected(2),
        ),
      ],
    );
  }
}

class PaymentChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentChip({
    required this.text,
    required this.isSelected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 114,
        height: 40,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: ShapeDecoration(
          color: isSelected
              ? AppColors.lightBackground
              : AppColors.lightBackground,
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
      ),
    );
  }
}
