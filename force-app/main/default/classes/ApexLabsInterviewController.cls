public with sharing class ApexLabsInterviewController {
    
    @AuraEnabled
    public static void sendInterviewEmail(
        String candidateEmail,
        String interviewDateTime
    ) {
        
        if (String.isBlank(candidateEmail)) {
            throw new AuraHandledException('Candidate email is required.');
        }
        
        if (String.isBlank(interviewDateTime)) {
            throw new AuraHandledException('Interview date and time is required.');
        }
        
        // Convert LWC datetime value to Datetime
        Datetime interviewDT;
        
        try {
            interviewDT = (Datetime) JSON.deserialize(
                '"' + interviewDateTime + '"',
                Datetime.class
            );
        } catch (Exception e) {
            throw new AuraHandledException(
                'Invalid interview date and time.'
            );
        }
        
        // Format interview date/time
        String formattedDateTime = interviewDT.format(
            'dd MMM yyyy, hh:mm a',
            UserInfo.getTimeZone().getID()
        );
        
        Messaging.SingleEmailMessage email =
            new Messaging.SingleEmailMessage();
        
        // TO
        email.setToAddresses(
            new List<String>{ candidateEmail }
        );
        
        // CC
        email.setCcAddresses(
            new List<String>{ 'apexlabsconnect@gmail.com' }
        );
        
        // Subject
        email.setSubject(
            'Interview Invitation – APEX LABS Salesforce Training & Internship Program'
        );
        
        // Email Body
        String body = '';
        
        body += 'Dear Candidate,<br/><br/>';
        
        body += 'Greetings from <b>APEX LABS</b>!<br/><br/>';
        
        body +=
            'We are pleased to invite you for an interview as part of the ' +
            '<b>APEX LABS Salesforce Training & Internship Program</b>.<br/><br/>';
        
        body += '<b>Interview Details:</b><br/>';
        
        body += '📅 <b>Date & Time:</b> ' +
            formattedDateTime + '<br/>';
        
        body += '💻 <b>Mode:</b> Google Meet<br/>';
        
        body +=
            '🔗 <b>Meeting Link:</b> ' +
            '<a href="https://meet.google.com/ekb-uncq-qaj">' +
            'https://meet.google.com/ekb-uncq-qaj</a><br/><br/>';
        
        body +=
            'If the scheduled time is not convenient for you, please reply ' +
            'to this email with your preferred time slot between ' +
            '<b>7:00 PM and 9:00 PM</b> on any of the upcoming days.<br/><br/>';
        
        body +=
            'We look forward to speaking with you.<br/><br/>';
        
        body +=
            'Regards,<br/>' +
            '<b>Recruitment Team</b><br/>' +
            '<b>APEX LABS</b>';
        
        email.setHtmlBody(body);
        
        Messaging.sendEmail(
            new List<Messaging.SingleEmailMessage>{ email }
        );
    }
}