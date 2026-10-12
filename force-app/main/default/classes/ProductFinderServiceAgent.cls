/**
 * @description Invocable Apex class designed to be called by a Salesforce
 *              Service Agent. It dynamically constructs and executes a SOQL
 *              query against Product2 using customer-provided criteria.
 *
 * IMPORTANT:
 * Replace Product_Type__c, Brand__c, and Specification__c in the dynamic
 * SOQL conditions with the actual Product2 field API names in your org.
 */
public with sharing class ProductFinderServiceAgent {

    /**
     * @description Structure of the data supplied by the Service Agent.
     */
    public class ProductInput {
        @InvocableVariable(required=false)
        public String productName;

        @InvocableVariable(required=false)
        public String brand;

        @InvocableVariable(required=false)
        public String productType;

        @InvocableVariable(required=false)
        public String specification;
    }

    /**
     * @description Structure of the data returned to the Service Agent.
     */
    public class ProductOutput {
        @InvocableVariable(label='Product Name')
        public String name;

        @InvocableVariable(label='Product SKU')
        public String productCode;

        @InvocableVariable(label='Product Description')
        public String description;

        @InvocableVariable(label='Matching Specifications')
        public String matchingSpecs;

        @InvocableVariable(label='Success Message')
        public String message;
    }

    /**
     * @description Finds active Product2 records matching the supplied
     *              customer criteria.
     * @param inputs List of ProductInput objects supplied by the Service Agent.
     * @return List of ProductOutput objects.
     */
    @InvocableMethod(
        label='Find Products by Specification'
        description='Finds matching Product2 records based on customer criteria.'
    )
    public static List<ProductOutput> findMatchingProducts(List<ProductInput> inputs) {
        List<ProductOutput> results = new List<ProductOutput>();

        // The Service Agent normally supplies one input item.
        if (inputs == null || inputs.isEmpty() || inputs[0] == null) {
            return results;
        }

        ProductInput input = inputs[0];
        List<String> conditions = new List<String>();

        // Only active products are eligible for matching.
        conditions.add('IsActive = TRUE');

        // Product type is mandatory for the intended Agent action.
        if (String.isNotBlank(input.productType)) {
            // Replace Product_Type__c with the actual Product2 field API name.
            conditions.add(
                'Product_Type__c LIKE \'%' +
                String.escapeSingleQuotes(input.productType) +
                '%\''
            );
        }

        // Brand is optional.
        if (String.isNotBlank(input.brand)) {
            // Replace Brand__c with the actual Product2 field API name.
            conditions.add(
                'Brand__c = \'' +
                String.escapeSingleQuotes(input.brand) +
                '\''
            );
        }

        // Product name is optional and uses a broad partial match.
        if (String.isNotBlank(input.productName)) {
            conditions.add(
                'Name LIKE \'%' +
                String.escapeSingleQuotes(input.productName) +
                '%\''
            );
        }

        // Specification is optional and uses a case-insensitive partial match.
        if (String.isNotBlank(input.specification)) {
            String specification = String.escapeSingleQuotes(
                input.specification.toLowerCase()
            );

            // Replace Specification__c with the actual Product2 field API name.
            conditions.add(
                'Specification__c LIKE \'%' +
                specification +
                '%\''
            );
        }

        String whereClause = String.join(conditions, ' AND ');
        String soqlQuery =
            'SELECT Name, ProductCode, Description ' +
            'FROM Product2 ' +
            'WHERE ' + whereClause +
            ' LIMIT 5';

        System.debug(LoggingLevel.DEBUG, 'Executing SOQL: ' + soqlQuery);

        try {
            List<Product2> matchingProducts = Database.query(soqlQuery);

            if (matchingProducts.isEmpty()) {
                ProductOutput noMatch = new ProductOutput();
                noMatch.message =
                    'No products were found matching all criteria. ' +
                    'Try refining your search.';
                results.add(noMatch);
                return results;
            }

            for (Product2 product : matchingProducts) {
                ProductOutput output = new ProductOutput();
                output.name = product.Name;
                output.productCode = product.ProductCode;
                output.description = product.Description;
                output.matchingSpecs =
                    'Type: ' + valueOrAny(input.productType) +
                    ', Brand: ' + valueOrAny(input.brand) +
                    ', Specification: ' + valueOrAny(input.specification);
                output.message = 'SUCCESS';
                results.add(output);
            }
        } catch (QueryException queryException) {
            ProductOutput errorOutput = new ProductOutput();
            errorOutput.message =
                'An error occurred during product search: ' +
                queryException.getMessage();
            results.add(errorOutput);
        } catch (Exception exceptionMessage) {
            ProductOutput errorOutput = new ProductOutput();
            errorOutput.message =
                'A system error occurred: ' + exceptionMessage.getMessage();
            results.add(errorOutput);
        }

        return results;
    }

    /**
     * @description Returns the supplied value or a readable fallback label.
     */
    private static String valueOrAny(String value) {
        return String.isNotBlank(value) ? value : 'Any';
    }
}