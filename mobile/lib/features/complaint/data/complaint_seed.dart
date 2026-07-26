import '../../../core/localization/bi.dart';
import 'complaint_models.dart';

/// Seed data mirroring `SEED_EN`/`SEED_MR` in the prototype's ComplaintScreen.
/// A fresh mutable-ready list is produced per call (immutable [Complaint]
/// instances updated via `copyWith` and swapped in the provider's state).
List<Complaint> seedComplaints() => [
      const Complaint(
        id: 'CMP/2026/000131',
        name: Bi('Rahul Pathan', 'राहुल पठाण'),
        mobile: '9812345601',
        category: ComplaintCategory.schemeDelay,
        description: Bi(
          'Scholarship amount for the last academic year has not yet been credited despite approval.',
          'मागील शैक्षणिक वर्षाची शिष्यवृत्ती रक्कम मंजुरी मिळूनही अद्याप जमा झालेली नाही.',
        ),
        fileName: 'bank_passbook.pdf',
        date: Bi('05 Jul 2026', '०५ जुलै २०२६'),
        status: ComplaintStatus.underReview,
      ),
      const Complaint(
        id: 'CMP/2026/000119',
        name: Bi('Ayesha Sheikh', 'आयेशा शेख'),
        mobile: '9823456712',
        category: ComplaintCategory.documents,
        description: Bi(
          'Domicile certificate submitted along with application appears to be missing from records.',
          'अर्जासोबत सादर केलेले अधिवास प्रमाणपत्र नोंदींमध्ये गहाळ असल्याचे दिसते.',
        ),
        fileName: 'domicile_certificate.jpg',
        date: Bi('28 Jun 2026', '२८ जून २०२६'),
        status: ComplaintStatus.rejected,
        rejectionReason: Bi(
          'Duplicate complaint — an identical grievance (Ref: CMP/2026/000102) is already under process with the concerned district office.',
          'दुबार तक्रार — तत्सम तक्रार (संदर्भ: CMP/2026/000102) आधीच संबंधित जिल्हा कार्यालयाकडे प्रक्रियेत आहे.',
        ),
      ),
      Complaint(
        id: 'CMP/2026/000108',
        name: const Bi('Imran Qureshi', 'इम्रान कुरेशी'),
        mobile: '9834567823',
        category: ComplaintCategory.education,
        description: const Bi(
          'Post-Matric scholarship application rejected without valid reason at college level.',
          'महाविद्यालय स्तरावर वैध कारणाशिवाय मॅट्रिकोत्तर शिष्यवृत्ती अर्ज नाकारण्यात आला.',
        ),
        fileName: 'rejection_letter.pdf',
        date: const Bi('19 Jun 2026', '१९ जून २०२६'),
        status: ComplaintStatus.caseOnboard,
        hearing: const Hearing(
          date: '2026-07-18',
          time: '11:30',
          location: Bi('Divisional Commission Office, Nagpur', 'विभागीय आयुक्त कार्यालय, नागपूर'),
          officer: Bi('Mrs. S. R. Kulkarni', 'श्रीमती एस. आर. कुलकर्णी'),
        ),
      ),
      Complaint(
        id: 'CMP/2026/000091',
        name: const Bi('Fatima Ansari', 'फातिमा अन्सारी'),
        mobile: '9845678934',
        category: ComplaintCategory.corruption,
        description: const Bi(
          'Alleged demand of unofficial payment for processing a welfare scheme application.',
          'कल्याण योजना अर्ज प्रक्रियेसाठी अनधिकृत रकमेची मागणी केल्याचा आरोप.',
        ),
        fileName: 'complaint_evidence.pdf',
        date: const Bi('02 Jun 2026', '०२ जून २०२६'),
        status: ComplaintStatus.disposedOf,
        hearing: const Hearing(
          date: '2026-06-08',
          time: '10:00',
          location: Bi('District Collector Office, Pune', 'जिल्हाधिकारी कार्यालय, पुणे'),
          officer: Bi('Mr. A. V. Deshmukh', 'श्री. ए. व्ही. देशमुख'),
        ),
        hearing2: const Hearing(
          date: '2026-06-28',
          time: '11:00',
          location: Bi('State Minority Commission Office, Mumbai', 'राज्य अल्पसंख्याक आयोग कार्यालय, मुंबई'),
          officer: Bi('Mr. A. V. Deshmukh', 'श्री. ए. व्ही. देशमुख'),
        ),
        verdictFile: 'final_verdict_CMP000091.pdf',
      ),
    ];
