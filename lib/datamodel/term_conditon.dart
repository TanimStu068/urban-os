import 'package:urban_os/widgets/term_condition/term_section.dart';
import 'package:flutter/material.dart';

final List<TermSection> sections = const [
  TermSection(
    number: '01',
    title: 'Acceptance of Terms',
    color: Color(0xFF00D4FF),
    icon: Icons.handshake_outlined,
    highlight: 'By accessing UrbanOS, you agree to be bound by these terms.',
    content:
        'By accessing, installing, or using the UrbanOS Smart City Platform ("Platform"), you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions ("Terms"). These Terms constitute a legally binding agreement between you ("User" or "Operator") and UrbanOS Technologies.\n\nIf you do not agree with any provision of these Terms, you must discontinue use of the Platform immediately. Continued use constitutes acceptance of any updated Terms, which will be communicated through in-app notifications.',
  ),
  TermSection(
    number: '02',
    title: 'Platform License',
    color: Color(0xFF00FF9D),
    icon: Icons.verified_outlined,
    highlight:
        'You receive a limited, non-exclusive, non-transferable license to operate the Platform.',
    content:
        'Subject to these Terms, UrbanOS grants you a limited, non-exclusive, revocable, non-transferable license to access and operate the Platform for legitimate smart city management, research, and educational purposes.\n\nThis license does not include: the right to sublicense or redistribute the Platform; modification, decompilation, or reverse engineering of any Platform component; using the Platform to develop a competing product; or accessing Platform APIs in unauthorized ways. All rights not expressly granted are reserved by UrbanOS Technologies.',
  ),
  TermSection(
    number: '03',
    title: 'Permitted Use',
    color: Color(0xFFFFAA00),
    icon: Icons.rule_rounded,
    highlight:
        'The Platform is designed for city simulation and management. Misuse is strictly prohibited.',
    content:
        'The Platform is intended exclusively for: authorized city authority personnel operating smart city infrastructure; urban planning research and academic study; IoT system testing and validation; and authorized developer integration testing.\n\nProhibited uses include: attempting to use simulation data for fraudulent city management decisions; accessing other operators\' city data without authorization; injecting malicious data into shared simulation environments; using the Platform for surveillance or privacy violations; and any use that violates applicable local, national, or international laws.',
  ),
  TermSection(
    number: '04',
    title: 'Simulation Disclaimer',
    color: Color(0xFFB44FFF),
    icon: Icons.science_outlined,
    highlight:
        'UrbanOS is a simulation platform. No real-world infrastructure decisions should be based solely on simulation outputs.',
    content:
        'UrbanOS operates entirely through virtual simulation. All sensor readings, automation triggers, actuator states, and city metrics are simulated approximations of real-world systems. They do not represent actual physical infrastructure states.\n\nUrbanOS Technologies expressly disclaims any liability arising from: decisions made based solely on simulation data; discrepancies between simulation outputs and real-world city conditions; simulation failures or inaccuracies; or any action taken in reliance on automation rule outputs without human verification. Users operating real city infrastructure must independently verify all decisions through certified physical systems.',
  ),
  TermSection(
    number: '05',
    title: 'Data & Intellectual Property',
    color: Color(0xFFFF6B35),
    icon: Icons.copyright_rounded,
    highlight:
        'You own your city configurations. UrbanOS retains all rights to Platform software and algorithms.',
    content:
        'You retain full ownership of all city configurations, automation rules, sensor layouts, and simulation scenarios you create within the Platform ("User Content"). By using the Platform, you grant UrbanOS a limited license to process User Content for the sole purpose of providing Platform services.\n\nUrbanOS Technologies retains all intellectual property rights in the Platform, including but not limited to: the simulation engine architecture; automation rule evaluation algorithms; UI/UX designs and visual assets; analytics and prediction models; and all Platform documentation. You may not claim ownership of or reproduce any Platform component.',
  ),
  TermSection(
    number: '06',
    title: 'Limitation of Liability',
    color: Color(0xFF00D4FF),
    icon: Icons.balance_rounded,
    highlight:
        'UrbanOS liability is limited to the amount paid for the Platform in the preceding 12 months.',
    content:
        'To the maximum extent permitted by applicable law, UrbanOS Technologies shall not be liable for any indirect, incidental, consequential, punitive, or exemplary damages arising from your use of the Platform, including but not limited to: loss of data; system downtime; inaccurate simulation results; or any decisions made based on Platform outputs.\n\nIn no event shall UrbanOS Technologies\' total liability exceed the greater of (a) the total fees you paid for Platform access in the 12 months preceding the claim, or (b) USD 100. Some jurisdictions do not allow limitation of liability, so these limitations may not apply to you.',
  ),
  TermSection(
    number: '07',
    title: 'Termination',
    color: Color(0xFFFF3B5C),
    icon: Icons.cancel_outlined,
    highlight:
        'Either party may terminate this agreement. Your data can be exported before deletion.',
    content:
        'UrbanOS may terminate or suspend your access immediately, without prior notice or liability, for any breach of these Terms, including unauthorized use, violation of applicable laws, or activities that compromise Platform security or other users.\n\nUpon termination, your right to access the Platform ceases immediately. You may request a full data export within 30 days of termination. After 30 days, all account data will be permanently deleted. Provisions of these Terms that by their nature should survive termination (including ownership, disclaimers, and limitations of liability) shall survive.',
  ),
  TermSection(
    number: '08',
    title: 'Governing Law',
    color: Color(0xFF00FF9D),
    icon: Icons.gavel_rounded,
    highlight:
        'These Terms are governed by the laws of your jurisdiction of use.',
    content:
        'These Terms shall be governed by and construed in accordance with the laws of the jurisdiction in which you operate the Platform, without regard to conflict of law principles. Any dispute arising under these Terms shall be subject to the exclusive jurisdiction of the courts of your local jurisdiction.\n\nFor international operators, disputes shall be governed by internationally recognized arbitration principles. UrbanOS Technologies reserves the right to seek injunctive or other equitable relief in any court of competent jurisdiction to prevent unauthorized use, infringement, or breach of confidentiality obligations.',
  ),
];
