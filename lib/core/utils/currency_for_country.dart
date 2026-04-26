/// ISO 3166-1 alpha-2 → ISO 4217 currency (salon defaults).
String currencyCodeForCountryIso(String iso) {
  switch (iso.trim().toUpperCase()) {
    case 'QA':
      return 'QAR';
    case 'AE':
      return 'AED';
    case 'SA':
      return 'SAR';
    case 'KW':
      return 'KWD';
    case 'BH':
      return 'BHD';
    case 'OM':
      return 'OMR';
    case 'EG':
      return 'EGP';
    case 'GB':
      return 'GBP';
    case 'CA':
      return 'CAD';
    case 'AU':
      return 'AUD';
    case 'JO':
      return 'JOD';
    default:
      return 'USD';
  }
}
