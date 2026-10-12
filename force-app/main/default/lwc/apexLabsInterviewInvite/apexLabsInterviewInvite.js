import { LightningElement } from 'lwc';
import sendInterviewEmail from '@salesforce/apex/ApexLabsInterviewController.sendInterviewEmail';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ApexLabsInterviewInvite extends LightningElement {

    candidateEmail = '';
    interviewDateTime = '';
    isLoading = false;
    message = '';

    handleEmailChange(event) {
        this.candidateEmail = event.target.value;
    }

    handleDateTimeChange(event) {
        this.interviewDateTime = event.target.value;
    }

    async sendEmail() {

        if (!this.candidateEmail || !this.interviewDateTime) {
            this.showToast(
                'Error',
                'Please enter candidate email and interview date/time.',
                'error'
            );
            return;
        }

        this.isLoading = true;

        try {

            await sendInterviewEmail({
                candidateEmail: this.candidateEmail,
                interviewDateTime: this.interviewDateTime
            });

            this.showToast(
                'Success',
                'Interview invitation sent successfully.',
                'success'
            );

            this.candidateEmail = '';
            this.interviewDateTime = '';

        } catch (error) {

            let errorMessage = 'Unable to send email.';

            if (error.body && error.body.message) {
                errorMessage = error.body.message;
            }

            this.showToast(
                'Error',
                errorMessage,
                'error'
            );

        } finally {
            this.isLoading = false;
        }
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        );
    }
}