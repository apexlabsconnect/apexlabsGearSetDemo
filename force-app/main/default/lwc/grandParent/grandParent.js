import { LightningElement, wire } from 'lwc';

import {
    subscribe,
    MessageContext
} from 'lightning/messageService';

import CHILD_MESSAGE from '@salesforce/messageChannel/Child_Message_Channel__c';

export default class GrandParent extends LightningElement {

    receivedMessage = '';
    subscription = null;

    @wire(MessageContext)
    messageContext;

    connectedCallback() {
        this.subscribeToMessage();
    }

    subscribeToMessage() {

        if (!this.subscription) {

            this.subscription = subscribe(
                this.messageContext,
                CHILD_MESSAGE,
                (message) => {
                    this.receivedMessage = message.message;
                }
            );
        }
    }
}