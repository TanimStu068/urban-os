import 'package:urban_os/widgets/privacy_policy/policy_section.dart';
import 'package:flutter/material.dart';

final List<PolicySection> sections = const [
  PolicySection(
    icon: Icons.info_outline_rounded,
    title: 'Information We Collect',
    color: Color(0xFF00D4FF),
    content: [
      PolicyPoint(
        title: 'Account Data',
        detail:
            'When you create a UrbanOS account, we collect your name, email address, organization affiliation, and a secure hashed password. This information is used solely for authentication and platform personalization.',
      ),
      PolicyPoint(
        title: 'Usage Analytics',
        detail:
            'We collect anonymized telemetry about which features you use, session durations, and screen interactions to improve platform UX. This data contains no personally identifiable information.',
      ),
      PolicyPoint(
        title: 'City Simulation Data',
        detail:
            'All city configurations, sensor setups, automation rules, and simulation states are stored locally on your device and optionally synced to our encrypted cloud infrastructure if cloud sync is enabled.',
      ),
      PolicyPoint(
        title: 'Device Information',
        detail:
            'Device model, operating system version, and app version are collected for compatibility diagnostics and crash reporting purposes.',
      ),
    ],
  ),
  PolicySection(
    icon: Icons.shield_outlined,
    title: 'How We Use Your Data',
    color: Color(0xFF00FF9D),
    content: [
      PolicyPoint(
        title: 'Platform Operations',
        detail:
            'Your data enables core UrbanOS functionality: authentication, saving city configurations, generating analytics reports, and delivering real-time simulation results.',
      ),
      PolicyPoint(
        title: 'Product Improvement',
        detail:
            'Aggregated, anonymized usage patterns help our engineering team prioritize features, identify performance bottlenecks, and design better UX flows for city operators.',
      ),
      PolicyPoint(
        title: 'Security & Compliance',
        detail:
            'We analyze login patterns and access logs to detect unauthorized access attempts and ensure platform integrity across all operator accounts.',
      ),
      PolicyPoint(
        title: 'Communications',
        detail:
            'We may send you platform updates, security advisories, and feature announcements. All communications can be managed in your notification preferences.',
      ),
    ],
  ),
  PolicySection(
    icon: Icons.lock_outline_rounded,
    title: 'Data Security',
    color: Color(0xFFFFAA00),
    content: [
      PolicyPoint(
        title: 'Encryption Standards',
        detail:
            'All data in transit is protected with TLS 1.3 encryption. Data at rest is encrypted using AES-256. Cloud backups are encrypted with unique per-tenant keys.',
      ),
      PolicyPoint(
        title: 'Access Controls',
        detail:
            'UrbanOS employs role-based access control (RBAC). Only authorized operators can access city configuration data. Anthropic staff cannot access your city simulation data.',
      ),
      PolicyPoint(
        title: 'Incident Response',
        detail:
            'In the event of a security incident, we commit to notifying affected users within 72 hours. A full incident report will be provided within 30 days.',
      ),
      PolicyPoint(
        title: 'Penetration Testing',
        detail:
            'The UrbanOS platform undergoes annual third-party security audits and continuous automated vulnerability scanning.',
      ),
    ],
  ),
  PolicySection(
    icon: Icons.share_outlined,
    title: 'Data Sharing',
    color: Color(0xFFB44FFF),
    content: [
      PolicyPoint(
        title: 'No Third-Party Sales',
        detail:
            'UrbanOS does not sell, rent, or trade your personal data or city configuration data to any third party under any circumstances.',
      ),
      PolicyPoint(
        title: 'Service Providers',
        detail:
            'We engage trusted service providers for infrastructure (cloud hosting, CDN) who are contractually bound to strict data protection standards and cannot use your data for their own purposes.',
      ),
      PolicyPoint(
        title: 'Legal Requirements',
        detail:
            'We may disclose data if required by law, court order, or government regulation. We will notify you before complying unless legally prohibited from doing so.',
      ),
      PolicyPoint(
        title: 'Business Transfers',
        detail:
            'In the event of a merger, acquisition, or asset sale, your data will be protected under the same privacy standards. You will be notified and given the option to delete your data.',
      ),
    ],
  ),
  PolicySection(
    icon: Icons.person_outline_rounded,
    title: 'Your Rights',
    color: Color(0xFFFF6B35),
    content: [
      PolicyPoint(
        title: 'Access & Portability',
        detail:
            'You have the right to request a complete export of all data we hold about you, including account information, usage history, and city configurations, in machine-readable format.',
      ),
      PolicyPoint(
        title: 'Correction',
        detail:
            'You can update or correct your account information at any time through the Profile Settings screen.',
      ),
      PolicyPoint(
        title: 'Deletion',
        detail:
            'You may request complete deletion of your account and all associated data. This process is irreversible and completed within 30 days. City simulations stored locally are not affected.',
      ),
      PolicyPoint(
        title: 'Objection & Restriction',
        detail:
            'You may object to or restrict processing of your data for analytics purposes at any time in Settings > Privacy. Core operational data processing is required for platform functionality.',
      ),
    ],
  ),
  PolicySection(
    icon: Icons.cookie_outlined,
    title: 'Cookies & Tracking',
    color: Color(0xFF00D4FF),
    content: [
      PolicyPoint(
        title: 'Essential Cookies',
        detail:
            'We use essential session cookies to maintain your authenticated state and remember your preferences. These cannot be disabled as they are required for platform functionality.',
      ),
      PolicyPoint(
        title: 'Analytics Cookies',
        detail:
            'Optional analytics cookies help us understand feature usage patterns. These can be disabled in Settings > Privacy without affecting platform performance.',
      ),
      PolicyPoint(
        title: 'No Advertising Trackers',
        detail:
            'UrbanOS contains zero advertising cookies, third-party tracking pixels, or social media embedded tracking. Your activity on our platform is never shared for advertising purposes.',
      ),
    ],
  ),
];
