import { LightningElement } from 'lwc';

export default class ParentChildDemo extends LightningElement {

    parentMessage = 'Hello Child! Message sent from Parent.';

    childMessage = 'No message received yet.';

    // Parent → Child
    // Calling child's @api method
    callChildMethod() {

        const child = this.template.querySelector(
            'c-communication-child'
        );

        child.showMessage();
    }

    // Change property passed to child
    changeMessage() {

        this.parentMessage =
            'Message changed by Parent!';
    }

    // Child → Parent
    // Handle Custom Event
    handleChildMessage(event) {

        this.childMessage = event.detail;

        console.log('Message from Child:', event.detail);
    }
}