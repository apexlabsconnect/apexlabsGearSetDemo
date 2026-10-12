import { LightningElement, api } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import PARTS_OBJECT from '@salesforce/schema/Parts_Requirement__c';
import NAME_FIELD from '@salesforce/schema/Parts_Requirement__c.Name';
import QUANTITY_FIELD from '@salesforce/schema/Parts_Requirement__c.Quantity__c';
import SERVICE_APPOINTMENT_FIELD from '@salesforce/schema/Parts_Requirement__c.Service_Appointment__c';

export default class PartsRequirement extends LightningElement {

    @api recordId;

    partName = '';
    quantity;

    handlePartNameChange(event) {
        this.partName = event.target.value;
    }

    handleQuantityChange(event) {
        this.quantity = event.target.value;
    }

    handleSave() {

        if (!this.partName || !this.quantity) {
            this.showToast(
                'Error',
                'Please enter Part Name and Quantity.',
                'error'
            );
            return;
        }

        const fields = {};

        fields[NAME_FIELD.fieldApiName] = this.partName;
        fields[QUANTITY_FIELD.fieldApiName] = this.quantity;
        fields[SERVICE_APPOINTMENT_FIELD.fieldApiName] = this.recordId;

        const recordInput = {
            apiName: PARTS_OBJECT.objectApiName,
            fields: fields
        };

        createRecord(recordInput)
            .then(() => {

                this.showToast(
                    'Success',
                    'Part requirement created successfully.',
                    'success'
                );

                this.partName = '';
                this.quantity = '';

            })
            .catch(error => {

                this.showToast(
                    'Error',
                    error.body?.message || 'Error creating part requirement.',
                    'error'
                );
            });
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