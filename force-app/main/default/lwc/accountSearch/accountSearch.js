import { LightningElement, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountSearchController.getAccounts';

const COLUMNS = [
    {
        label: 'Account Name',
        fieldName: 'Name'
    },
    {
        label: 'Industry',
        fieldName: 'Industry'
    },
    {
        label: 'Phone',
        fieldName: 'Phone',
        type: 'phone'
    },
    {
        label: 'Website',
        fieldName: 'Website',
        type: 'url'
    }
];

export default class AccountSearch extends LightningElement {

    accountName = '';

    columns = COLUMNS;

    @wire(getAccounts, { accountName: '$accountName' })
    accounts;

    handleAccountNameChange(event) {
        this.accountName = event.target.value;
    }
}