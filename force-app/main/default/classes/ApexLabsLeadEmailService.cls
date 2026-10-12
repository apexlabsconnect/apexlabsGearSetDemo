public without sharing class ApexLabsLeadEmailService {

    public static void sendNewLeadEmails(List<Lead> newLeads) {

        List<Messaging.SingleEmailMessage> emails =
            new List<Messaging.SingleEmailMessage>();

        // Salesforce org URL
        String salesforceBaseUrl =
            URL.getOrgDomainUrl().toExternalForm();

        for (Lead lead : newLeads) {

            String fullName =
                ((lead.FirstName == null) ? '' : lead.FirstName + ' ') +
                ((lead.LastName == null) ? '' : lead.LastName);

            String subject =
                'New Apex Labs Registration - ' + fullName.trim();

            /*
             * Logo
             *
             * Upload the Apex Labs logo as a Static Resource
             * with the name:
             *
             * ApexLabsLogo
             *
             * Recommended format: PNG
             */
            String logoUrl =
                salesforceBaseUrl +
                '/resource/ApexLabsLogo';

            /*
             * Salesforce Lead URL
             */
            String leadUrl =
                salesforceBaseUrl +
                '/' + lead.Id;

            /*
             * HTML EMAIL
             */
            String htmlBody = '';

            htmlBody += '<!DOCTYPE html>';
            htmlBody += '<html>';
            htmlBody += '<head>';
            htmlBody += '<meta charset="UTF-8">';
            htmlBody += '</head>';

            htmlBody += '<body style="margin:0;padding:0;background-color:#f3f7fb;font-family:Arial,Helvetica,sans-serif;">';

            // Main container
            htmlBody += '<table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#f3f7fb;padding:30px 15px;">';
            htmlBody += '<tr>';
            htmlBody += '<td align="center">';

            htmlBody += '<table width="650" cellpadding="0" cellspacing="0" border="0" style="max-width:650px;width:100%;background:#ffffff;border-radius:14px;overflow:hidden;box-shadow:0 4px 18px rgba(0,0,0,0.08);">';

            // =========================================
            // HEADER
            // =========================================

            htmlBody += '<tr>';
            htmlBody += '<td style="background:linear-gradient(135deg,#2563eb,#0f766e);padding:28px 35px;text-align:center;">';

            htmlBody += '<img src="' + logoUrl + '" ';
            htmlBody += 'alt="Apex Labs" ';
            htmlBody += 'style="max-width:180px;max-height:70px;margin-bottom:15px;">';

            htmlBody += '<div style="color:#ffffff;font-size:24px;font-weight:bold;">';
            htmlBody += 'New Registration Received';
            htmlBody += '</div>';

            htmlBody += '<div style="color:#dff7f4;font-size:14px;margin-top:7px;">';
            htmlBody += 'Apex Labs Salesforce Basics Session';
            htmlBody += '</div>';

            htmlBody += '</td>';
            htmlBody += '</tr>';

            // =========================================
            // INTRO
            // =========================================

            htmlBody += '<tr>';
            htmlBody += '<td style="padding:30px 35px 10px 35px;">';

            htmlBody += '<p style="margin:0;color:#374151;font-size:15px;line-height:1.6;">';
            htmlBody += 'A new participant has registered through the Apex Labs registration form.';
            htmlBody += '</p>';

            htmlBody += '</td>';
            htmlBody += '</tr>';

            // =========================================
            // PERSONAL INFORMATION
            // =========================================

            htmlBody += '<tr>';
            htmlBody += '<td style="padding:15px 35px;">';

            htmlBody += '<div style="font-size:18px;font-weight:bold;color:#1f2937;margin-bottom:15px;">';
            htmlBody += 'Personal Information';
            htmlBody += '</div>';

            htmlBody += '<table width="100%" cellpadding="8" cellspacing="0" border="0" style="font-size:14px;">';

            htmlBody += createRow('First Name', lead.FirstName);
            htmlBody += createRow('Last Name', lead.LastName);
            htmlBody += createRow('Email', lead.Email);
            htmlBody += createRow('Phone', lead.Phone);

            htmlBody += '</table>';

            htmlBody += '</td>';
            htmlBody += '</tr>';

            // =========================================
            // EDUCATION
            // =========================================

            htmlBody += '<tr>';
            htmlBody += '<td style="padding:15px 35px;">';

            htmlBody += '<div style="font-size:18px;font-weight:bold;color:#1f2937;margin-bottom:15px;">';
            htmlBody += 'Education Information';
            htmlBody += '</div>';

            htmlBody += '<table width="100%" cellpadding="8" cellspacing="0" border="0" style="font-size:14px;">';

            htmlBody += createRow(
                'College',
                lead.College__c
            );

            htmlBody += createRow(
                'Highest Education Qualification',
                lead.Highest_Education_Qualification__c
            );

            htmlBody += '</table>';

            htmlBody += '</td>';
            htmlBody += '</tr>';

            // =========================================
            // PROFESSIONAL INFORMATION
            // =========================================

            htmlBody += '<tr>';
            htmlBody += '<td style="padding:15px 35px;">';

            htmlBody += '<div style="font-size:18px;font-weight:bold;color:#1f2937;margin-bottom:15px;">';
            htmlBody += 'Professional Information';
            htmlBody += '</div>';

            htmlBody += '<table width="100%" cellpadding="8" cellspacing="0" border="0" style="font-size:14px;">';

            htmlBody += createRow(
                'Company',
                lead.Company
            );

            htmlBody += '</table>';

            htmlBody += '</td>';
            htmlBody += '</tr>';

            // =========================================
            // ADDRESS
            // =========================================

            htmlBody += '<tr>';
            htmlBody += '<td style="padding:15px 35px;">';

            htmlBody += '<div style="font-size:18px;font-weight:bold;color:#1f2937;margin-bottom:15px;">';
            htmlBody += 'Address';
            htmlBody += '</div>';

            htmlBody += '<div style="background:#f8fafc;border-left:4px solid #14b8a6;padding:14px;color:#4b5563;font-size:14px;line-height:1.6;">';

            htmlBody += escapeHtml(
                String.valueOf(lead.Address__c)
            );

            htmlBody += '</div>';

            htmlBody += '</td>';
            htmlBody += '</tr>';

            // =========================================
            // LEAD INFORMATION
            // =========================================

            htmlBody += '<tr>';
            htmlBody += '<td style="padding:15px 35px;">';

            htmlBody += '<div style="font-size:18px;font-weight:bold;color:#1f2937;margin-bottom:15px;">';
            htmlBody += 'Lead Information';
            htmlBody += '</div>';

            htmlBody += '<table width="100%" cellpadding="8" cellspacing="0" border="0" style="font-size:14px;">';

            htmlBody += createRow(
                'Lead ID',
                String.valueOf(lead.Id)
            );

            htmlBody += createRow(
                'Lead Source',
                lead.LeadSource
            );

            htmlBody += createRow(
                'Status',
                lead.Status
            );

            htmlBody += '</table>';

            htmlBody += '</td>';
            htmlBody += '</tr>';

            // =========================================
            // BUTTON
            // =========================================

            htmlBody += '<tr>';
            htmlBody += '<td align="center" style="padding:25px 35px 35px 35px;">';

            htmlBody += '<a href="' + leadUrl + '" ';
            htmlBody += 'style="display:inline-block;background:#2563eb;color:#ffffff;text-decoration:none;';
            htmlBody += 'font-size:15px;font-weight:bold;padding:14px 28px;border-radius:8px;">';

            htmlBody += 'View Lead in Salesforce';

            htmlBody += '</a>';

            htmlBody += '</td>';
            htmlBody += '</tr>';

            // =========================================
            // FOOTER
            // =========================================

            htmlBody += '<tr>';
            htmlBody += '<td style="background:#f8fafc;padding:20px 35px;text-align:center;border-top:1px solid #e5e7eb;">';

            htmlBody += '<div style="font-size:13px;color:#6b7280;">';
            htmlBody += 'This notification was generated automatically by Apex Labs.';
            htmlBody += '</div>';

            htmlBody += '<div style="font-size:12px;color:#9ca3af;margin-top:6px;">';
            htmlBody += 'Salesforce Registration System';
            htmlBody += '</div>';

            htmlBody += '</td>';
            htmlBody += '</tr>';

            htmlBody += '</table>';
            htmlBody += '</td>';
            htmlBody += '</tr>';
            htmlBody += '</table>';

            htmlBody += '</body>';
            htmlBody += '</html>';

            // =========================================
            // CREATE EMAIL
            // =========================================

            Messaging.SingleEmailMessage email =
                new Messaging.SingleEmailMessage();

            email.setToAddresses(
                new List<String>{
                    'apexlabsconnect@gmail.com'
                }
            );

            email.setSubject(subject);

            email.setHtmlBody(htmlBody);

            // Plain-text fallback
            email.setPlainTextBody(
                'New Apex Labs Registration\n\n' +
                'Name: ' + fullName + '\n' +
                'Email: ' + String.valueOf(lead.Email) + '\n' +
                'Phone: ' + String.valueOf(lead.Phone) + '\n' +
                'College: ' + String.valueOf(lead.College__c) + '\n' +
                'Highest Education: ' +
                    String.valueOf(
                        lead.Highest_Education_Qualification__c
                    ) + '\n' +
                'Company: ' + String.valueOf(lead.Company) + '\n' +
                'Address: ' + String.valueOf(lead.Address__c) + '\n\n' +
                'View Lead in Salesforce:\n' +
                leadUrl
            );

            emails.add(email);
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }


    // =========================================
    // HELPER: CREATE TABLE ROW
    // =========================================

    private static String createRow(
        String label,
        String value
    ) {

        String safeValue =
            escapeHtml(String.valueOf(value));

        return
            '<tr>' +
            '<td width="40%" style="color:#6b7280;font-weight:600;border-bottom:1px solid #eef2f7;">' +
            escapeHtml(label) +
            '</td>' +
            '<td style="color:#111827;border-bottom:1px solid #eef2f7;">' +
            safeValue +
            '</td>' +
            '</tr>';
    }


    // =========================================
    // HELPER: HTML ESCAPING
    // =========================================

    private static String escapeHtml(String value) {

        if (value == null) {
            return '';
        }

        String result = value;

        result = result.replace('&', '&amp;');
        result = result.replace('<', '&lt;');
        result = result.replace('>', '&gt;');
        result = result.replace('"', '&quot;');
        result = result.replace('\'', '&#39;');

        return result;
    }
}