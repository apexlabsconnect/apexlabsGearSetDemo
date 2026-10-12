import { LightningElement } from 'lwc';

import askHealthQuestion
    from '@salesforce/apex/HealthKnowledgeController.askHealthQuestion';

export default class HealthKnowledge extends LightningElement {

    query = '';
    answer = '';
    errorMessage = '';
    isLoading = false;


    handleQueryChange(event) {

        this.query = event.target.value;

        this.errorMessage = '';
    }


    async handleAsk() {

        this.errorMessage = '';
        this.answer = '';


        if (!this.query || !this.query.trim()) {

            this.errorMessage =
                'Please enter a question.';

            return;
        }


        this.isLoading = true;


        try {

            const result =
                await askHealthQuestion({
                    query: this.query
                });


            if (result && result.text) {

                this.answer = result.text;

            } else {

                this.errorMessage =
                    'No answer was returned.';
            }


        } catch (error) {

            console.error(
                'Health Knowledge Error:',
                error
            );

            this.errorMessage =
                this.getErrorMessage(error);

        } finally {

            this.isLoading = false;
        }
    }


    getErrorMessage(error) {

        if (
            error &&
            error.body &&
            error.body.message
        ) {

            return error.body.message;
        }


        if (error && error.message) {

            return error.message;
        }


        return 'An unexpected error occurred.';
    }
}