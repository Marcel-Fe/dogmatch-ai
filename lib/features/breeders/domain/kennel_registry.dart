/// Ein offizieller Zucht-Dachverband mit seiner Zuechter-/Welpen-Suche.
///
/// Die App buendelt bewusst KEINE vollstaendige Zuechter-Datenbank (die gibt
/// es nicht frei lizenzierbar). Stattdessen verlinken wir die autoritativen
/// Quellen: Dort liegen die kompletten, gepruften Listen aller eingetragenen
/// Zuechter samt deren Webseiten.
class KennelRegistry {
  const KennelRegistry({
    required this.countryLabel,
    required this.org,
    required this.url,
  });

  /// Land auf Deutsch, z. B. "Deutschland".
  final String countryLabel;

  /// Verbands-Name/Kuerzel, z. B. "VDH".
  final String org;

  /// Offizielle Zuechter-/Welpensuche oder Verbands-Startseite.
  final String url;
}

/// Offizielle Verbaende, nach Relevanz fuer den deutschsprachigen Raum
/// sortiert. URLs am 2026-06-04 auf Erreichbarkeit geprueft.
const List<KennelRegistry> kKennelRegistries = [
  KennelRegistry(
    countryLabel: 'International',
    org: 'FCI - Federation Cynologique Internationale',
    url: 'https://www.fci.be/en/',
  ),
  KennelRegistry(
    countryLabel: 'Oesterreich',
    org: 'OeKV - Oesterreichischer Kynologenverband',
    url: 'https://www.oekv.at/',
  ),
  KennelRegistry(
    countryLabel: 'Schweiz',
    org: 'SKG - Schweizerische Kynologische Gesellschaft',
    url: 'https://www.skg.ch/',
  ),
  KennelRegistry(
    countryLabel: 'Frankreich',
    org: 'SCC - Societe Centrale Canine',
    url: 'https://www.centrale-canine.fr/',
  ),
  KennelRegistry(
    countryLabel: 'Italien',
    org: 'ENCI',
    url: 'https://www.enci.it/',
  ),
  KennelRegistry(
    countryLabel: 'Spanien',
    org: 'RSCE - Real Sociedad Canina de Espana',
    url: 'https://www.rsce.es/',
  ),
  KennelRegistry(
    countryLabel: 'Niederlande',
    org: 'Raad van Beheer',
    url: 'https://www.raadvanbeheer.nl/',
  ),
  KennelRegistry(
    countryLabel: 'Grossbritannien',
    org: 'The Kennel Club',
    url: 'https://www.thekennelclub.org.uk/',
  ),
  KennelRegistry(
    countryLabel: 'Irland',
    org: 'Irish Kennel Club',
    url: 'https://www.ikc.ie/',
  ),
  KennelRegistry(
    countryLabel: 'Schweden',
    org: 'SKK - Svenska Kennelklubben',
    url: 'https://www.skk.se/',
  ),
  KennelRegistry(
    countryLabel: 'Norwegen',
    org: 'NKK - Norsk Kennel Klub',
    url: 'https://www.nkk.no/',
  ),
  KennelRegistry(
    countryLabel: 'Finnland',
    org: 'Kennelliitto',
    url: 'https://www.kennelliitto.fi/',
  ),
  KennelRegistry(
    countryLabel: 'Polen',
    org: 'ZKwP - Zwiazek Kynologiczny w Polsce',
    url: 'https://www.zkwp.pl/',
  ),
  KennelRegistry(
    countryLabel: 'Tschechien',
    org: 'CMKU',
    url: 'https://www.cmku.cz/',
  ),
  KennelRegistry(
    countryLabel: 'USA',
    org: 'AKC Marketplace',
    url: 'https://marketplace.akc.org/',
  ),
  KennelRegistry(
    countryLabel: 'Kanada',
    org: 'CKC - Canadian Kennel Club',
    url: 'https://www.ckc.ca/',
  ),
  KennelRegistry(
    countryLabel: 'Australien',
    org: 'Dogs Australia (ANKC)',
    url: 'https://www.dogsaustralia.org.au/',
  ),
];
