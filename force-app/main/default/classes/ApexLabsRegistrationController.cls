public without sharing class ApexLabsRegistrationController {

    public String firstName { get; set; }
    public String lastName { get; set; }
    public String phone { get; set; }
    public String email { get; set; }
    public String college { get; set; }
    public String company { get; set; }
    public String address { get; set; }

    public String highestEducationQualification { get; set; }


    public ApexLabsRegistrationController() {
    }


    /*
     * Get Picklist Values dynamically from
     * Lead.Highest_Education_Qualification__c
     */
    public List<SelectOption> getEducationOptions() {

        List<SelectOption> options = new List<SelectOption>();

        // Blank option
        options.add(
            new SelectOption('', '-- Select Qualification --')
        );

        Schema.DescribeFieldResult fieldDescribe =
            Lead.Highest_Education_Qualification__c.getDescribe();

        for (Schema.PicklistEntry entry :
             fieldDescribe.getPicklistValues()) {

            if (entry.isActive()) {

                options.add(
                    new SelectOption(
                        entry.getValue(),
                        entry.getLabel()
                    )
                );
            }
        }

        return options;
    }


    public PageReference submitRegistration() {

        try {

            // Basic validation

            if (String.isBlank(lastName)) {

                ApexPages.addMessage(
                    new ApexPages.Message(
                        ApexPages.Severity.ERROR,
                        'Please enter your last name.'
                    )
                );

                return null;
            }


            if (String.isBlank(email)) {

                ApexPages.addMessage(
                    new ApexPages.Message(
                        ApexPages.Severity.ERROR,
                        'Please enter your email address.'
                    )
                );

                return null;
            }


            // Create Lead

            Lead newLead = new Lead();

            newLead.FirstName = firstName;
            newLead.LastName = lastName;
            newLead.Phone = phone;
            newLead.Email = email;

            newLead.Company =
                String.isBlank(company)
                ? 'Individual'
                : company;

            newLead.LeadSource = 'Web';


            // Custom Lead Fields

            newLead.College__c = college;

            newLead.Address__c = address;

            newLead.Highest_Education_Qualification__c =
                highestEducationQualification;


            insert newLead;


            // Success message

            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.CONFIRM,
                    'Thank you! Your registration has been submitted successfully.'
                )
            );


            // Clear fields

            firstName = null;
            lastName = null;
            phone = null;
            email = null;
            college = null;
            company = null;
            address = null;
            highestEducationQualification = null;


            return null;

        } catch (Exception e) {

            ApexPages.addMessage(
                new ApexPages.Message(
                    ApexPages.Severity.ERROR,
                    'Unable to submit your registration: ' +
                    e.getMessage()
                )
            );

            return null;
        }
    }
}