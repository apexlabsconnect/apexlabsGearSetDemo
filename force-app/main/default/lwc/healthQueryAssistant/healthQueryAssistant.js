import { LightningElement, track } from 'lwc';
import askHealthQuestion from '@salesforce/apex/HealthQueryController.askHealthQuestion';

export default class HealthQueryAssistant extends LightningElement {
    @track query        = '';
    @track responseText = '';
    @track errorMessage = '';
    @track isLoading    = false;

    handleQueryChange(event) {
        this.query = event.target.value;
    }

    handleAsk() {
        const trimmedQuery = this.query?.trim();
        if (!trimmedQuery) {
            this.errorMessage  = 'Please enter a question before submitting.';
            this.responseText  = '';
            return;
        }

        this.isLoading    = true;
        this.errorMessage = '';
        this.responseText = '';

        askHealthQuestion({ query: trimmedQuery })
            .then(result => {
                this.responseText = result?.text ?? 'No answer was returned.';
            })
            .catch(error => {
                this.errorMessage = error?.body?.message ?? 'An unexpected error occurred.';
            })
            .finally(() => {
                this.isLoading = false;
            });
    }
}