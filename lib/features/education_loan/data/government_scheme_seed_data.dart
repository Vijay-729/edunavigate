import '../models/government_scheme_model.dart';

/// Representative seed data for major government education-financing
/// schemes. Approximate, illustrative figures — swap for a live
/// `governmentSchemes` Firestore feed later via [LoanRepository].
class GovernmentSchemeSeedData {
  GovernmentSchemeSeedData._();

  static const List<GovtSchemeModel> all = [
    GovtSchemeModel(
      id: 'pm_vidyalaxmi',
      name: 'PM Vidyalaxmi Scheme',
      about:
          'A central government scheme offering collateral-free, guarantor-free '
          'education loans to meritorious students admitted to top-quality '
          'higher education institutions (QHEIs) in India.',
      benefits: [
        'Collateral-free and guarantor-free loans up to ₹7.5L',
        '3% interest subvention for students with family income up to ₹8L/year',
        'Applicable at ~860 top-ranked QHEIs (NIRF-ranked institutes)',
        'Simplified digital application via the PM Vidyalaxmi portal',
      ],
      eligibility:
          'Indian students admitted to a listed Quality Higher Education Institution (QHEI); family income criteria apply for interest subvention.',
      applyUrl: 'https://www.pmvidyalaxmi.co.in',
    ),
    GovtSchemeModel(
      id: 'vidya_lakshmi_portal',
      name: 'Vidya Lakshmi Portal',
      about: 'A national portal for education loans, jointly developed by the '
          'Department of Financial Services, Department of Higher Education, '
          'and Indian Banks\' Association — a single-window platform to apply '
          'to multiple banks with one application.',
      benefits: [
        'Apply to multiple banks/lenders with a single common application form',
        'Track application status across all banks in one dashboard',
        'Link to the Central Sector Interest Subsidy Scheme where eligible',
        'Free to use, no application fee on the portal itself',
      ],
      eligibility:
          'Any Indian student seeking an education loan from a participating bank.',
      applyUrl: 'https://www.vidyalakshmi.co.in',
    ),
    GovtSchemeModel(
      id: 'csis',
      name: 'Central Sector Interest Subsidy (CSIS)',
      about: 'Provides full interest subsidy during the moratorium period '
          '(course duration + 1 year) on education loans for students from '
          'economically weaker sections pursuing technical/professional courses in India.',
      benefits: [
        'Full interest subsidy during moratorium period',
        'Applicable on loans up to ₹10L for professional/technical courses in India',
        'Reduces effective loan burden significantly for eligible families',
      ],
      eligibility:
          'Family annual income up to ₹4.5L; loan taken under the IBA Model Education Loan Scheme for studies in India.',
      applyUrl: 'https://www.vidyalakshmi.co.in',
    ),
    GovtSchemeModel(
      id: 'nsp_central_scholarships',
      name: 'National Scholarship Portal — Central Sector Scholarships',
      about: 'A one-stop platform for various Central Government scholarship '
          'schemes for meritorious students from economically weaker sections, '
          'covering tuition, maintenance, and other allowances.',
      benefits: [
        'Direct benefit transfer (DBT) of scholarship amount to student bank account',
        'Covers multiple central schemes (Central Sector Scheme, Post-Matric, Merit-cum-Means, etc.)',
        'Single registration for multiple scheme applications',
      ],
      eligibility:
          'Varies by scheme — typically merit and/or family income based; check individual scheme criteria on the NSP portal.',
      applyUrl: 'https://scholarships.gov.in',
    ),
    GovtSchemeModel(
      id: 'state_scholarship_umbrella',
      name: 'State Government Scholarships (Umbrella)',
      about: 'Most state governments run their own post-matric and merit '
          'scholarship schemes for domicile students — amounts, eligibility, '
          'and application windows vary significantly by state.',
      benefits: [
        'State-specific tuition fee waivers and maintenance allowances',
        'Often stackable with central scholarships (check for overlap rules)',
        'Category-specific schemes (SC/ST/OBC/EWS/minority) in most states',
      ],
      eligibility:
          'Domicile of the respective state; family income and category criteria vary by state and scheme.',
      applyUrl: 'https://scholarships.gov.in',
    ),
  ];
}
