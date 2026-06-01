import '../models/term_section.dart';

class TermsData {
  static const String mainTitle = 'Términos y Políticas de FuelTrack';
  static const String introText = 'En FuelTrack, la integridad de sus datos es nuestra prioridad. Este documento detalla nuestro compromiso inquebrantable con la seguridad, el cumplimiento normativo internacional y la transparencia operativa para gestores de flotas e industrias globales.';
  static const String updateDate = 'Última actualización: 24 de Mayo, 2024. Versión 4.2.1-Enterprise.';

  static const List<TermSection> sections = [
    TermSection(
      number: 1,
      title: 'Aceptación de Términos',
      content: 'Al acceder o utilizar la plataforma FuelTrack, usted acepta quedar vinculado por estos Términos de Servicio. Estos términos constituyen un acuerdo legalmente vinculante entre su organización y FuelTrack Enterprise. Si no está de acuerdo con alguna parte de estos términos, no podrá utilizar nuestros servicios de gestión logística.',
    ),
    TermSection(
      number: 2,
      title: 'Uso de la Plataforma',
      content: 'La plataforma debe utilizarse exclusivamente para fines profesionales de gestión de combustible y logística. Queda estrictamente prohibido el uso de técnicas de ingeniería inversa, el acceso no autorizado a la API de producción o cualquier actividad que comprometa la estabilidad del sistema para otros usuarios corporativos.',
    ),
    TermSection(
      number: 3,
      title: 'Política de Privacidad\n(Protección JWT)',
      content: 'Implementamos protocolos de seguridad de grado industrial. Todas las sesiones están protegidas mediante JSON Web Tokens (JWT) con rotación automática.',
      bullets: [
        'Encriptación AES-256 en reposo',
        'Autenticación Multifactor (MFA)',
        'Auditorías SOC2 Tipo II anuales',
        'Cumplimiento estricto con GDPR',
      ],
    ),
    TermSection(
      number: 4,
      title: 'Propiedad Intelectual',
      content: 'Todos los algoritmos de optimización de rutas, interfaces de usuario, marcas comerciales y estructuras de bases de datos son propiedad exclusiva de FuelTrack. El cliente mantiene la propiedad total de sus datos operativos cargados, otorgando una licencia limitada para el procesamiento necesario del servicio.',
    ),
    TermSection(
      number: 5,
      title: 'Limitación de\nResponsabilidad',
      content: 'FuelTrack se esfuerza por garantizar una disponibilidad del 99.9%. Sin embargo, no seremos responsables de pérdidas indirectas, lucro cesante o daños derivados de fluctuaciones en el mercado de combustibles o decisiones operativas basadas en las proyecciones de la plataforma.',
    ),
  ];
}