import { LightningElement, api } from 'lwc';

export default class CommunicationChild extends LightningElement {

    // Parent → Child using @api property
    @api messageFromParent;

    // Parent → Child using @api method
    @api
    showMessage() {
        alert('Parent called the Child @api method!');
    }

    // Child → Parent using Custom Event
    sendMessageToParent() {

        const event = new CustomEvent('childmessage', {
            detail: 'Hello Parent! Message sent from Child.'
        });

        this.dispatchEvent(event);
    }
}