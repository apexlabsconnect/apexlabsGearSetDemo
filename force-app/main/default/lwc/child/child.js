import { LightningElement, wire } from 'lwc';

import {
    publish,
    MessageContext
} from 'lightning/messageService';

import CHILD_MESSAGE from '@salesforce/messageChannel/Child_Message_Channel__c';

export default class Child extends LightningElement {

    message = '';

    @wire(MessageContext)
    messageContext;

    handleChange(event) {
        this.message = event.target.value;
    }

    sendMessage() {

        const payload = {
            message: this.message
        };

        publish(
            this.messageContext,
            CHILD_MESSAGE,
            payload
        );
    }
}