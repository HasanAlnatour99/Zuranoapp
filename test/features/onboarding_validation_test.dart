import 'package:barber_shop_app/features/auth/logic/login_controller.dart';
import 'package:barber_shop_app/features/auth/logic/register_controller.dart';
import 'package:barber_shop_app/features/salon/logic/create_salon_controller.dart';
import 'package:barber_shop_app/l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = AppLocalizationsEn();

  group('LoginFormState', () {
    test('requires a valid email and minimum password length', () {
      const state = LoginFormState(
        email: 'invalid-email',
        password: '123',
        emailTouched: true,
        passwordTouched: true,
      );

      expect(state.emailErrorFor(l10n), l10n.validationEmailInvalid);
      expect(state.passwordErrorFor(l10n), l10n.validationPasswordShort);
      expect(state.isFormValid, isFalse);
    });
  });

  group('RegisterFormState', () {
    test('requires name, valid email, phone, matching passwords (min 6)', () {
      const state = RegisterFormState(
        fullName: '',
        email: 'owner',
        phone: '',
        password: '12345',
        confirmPassword: '99999',
        nameTouched: true,
        emailTouched: true,
        phoneTouched: true,
        passwordTouched: true,
        confirmPasswordTouched: true,
      );

      expect(
        state.nameErrorFor(l10n),
        l10n.validationFieldRequired(l10n.fieldLabelName),
      );
      expect(state.emailErrorFor(l10n), l10n.validationEmailInvalid);
      expect(state.phoneErrorFor(l10n), l10n.validationPhoneRequired);
      expect(state.passwordErrorFor(l10n), l10n.validationPasswordMinSixChars);
      expect(
        state.confirmPasswordErrorFor(l10n),
        l10n.validationConfirmPasswordMismatch,
      );
      expect(state.isFormValid, isFalse);
    });
  });

  group('CreateSalonFormState', () {
    test('requires salon name, business type, country, and address lines', () {
      const state = CreateSalonFormState(
        hasSubmitted: true,
        salonNameTouched: true,
        businessTypeTouched: true,
        countryTouched: true,
        cityTouched: true,
        streetTouched: true,
        buildingTouched: true,
      );

      expect(
        state.salonNameErrorFor(l10n),
        l10n.validationFieldRequired(l10n.fieldLabelSalonName),
      );
      expect(
        state.businessTypeErrorFor(l10n),
        l10n.validationBusinessTypeRequired,
      );
      expect(state.countryErrorFor(l10n), l10n.validationCountryRequired);
      expect(
        state.cityErrorFor(l10n),
        l10n.validationFieldRequired(l10n.fieldLabelCity),
      );
      expect(
        state.streetErrorFor(l10n),
        l10n.validationFieldRequired(l10n.fieldLabelStreet),
      );
      expect(
        state.buildingErrorFor(l10n),
        l10n.validationFieldRequired(l10n.fieldLabelBuildingUnit),
      );
      expect(state.isFormValid, isFalse);
    });
  });
}
