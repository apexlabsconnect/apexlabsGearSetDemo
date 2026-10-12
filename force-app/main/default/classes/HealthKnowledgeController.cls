public with sharing class HealthKnowledgeController {

    private static final String PROMPT_TEMPLATE_NAME =
        'Knowledge_Answers_based_on_health_pdf';

    private static final String RETRIEVER_ID =
        '1Cxak000000L4a5CAC';


    @AuraEnabled
    public static ResponseWrapper askHealthQuestion(String query) {

        if (String.isBlank(query)) {
            throw new AuraHandledException(
                'Please enter a question.'
            );
        }

        try {

            // -----------------------------------------
            // Query Input
            // -----------------------------------------
            ConnectApi.WrappedValue queryValue =
                new ConnectApi.WrappedValue();

            queryValue.value = query;


            // -----------------------------------------
            // Retriever ID Input
            // -----------------------------------------
            ConnectApi.WrappedValue retrieverValue =
                new ConnectApi.WrappedValue();

            retrieverValue.value = RETRIEVER_ID;


            // -----------------------------------------
            // Prompt Template Inputs
            // -----------------------------------------
            Map<String, ConnectApi.WrappedValue> inputParams =
                new Map<String, ConnectApi.WrappedValue>();

            inputParams.put(
                'Input:Query',
                queryValue
            );

            /*
             * IMPORTANT:
             * The Prompt Template expects:
             *
             * Input.RetrieverIdOrName
             */
            inputParams.put(
                'Input:RetrieverIdOrName',
                retrieverValue
            );


            // -----------------------------------------
            // Prompt Template Configuration
            // -----------------------------------------
            ConnectApi.EinsteinPromptTemplateGenerationsInput templateInput =
                new ConnectApi.EinsteinPromptTemplateGenerationsInput();

            templateInput.additionalConfig =
                new ConnectApi.EinsteinLlmAdditionalConfigInput();

            templateInput.additionalConfig.applicationName =
                'HealthKnowledgeLWC';

            templateInput.isPreview = false;

            templateInput.inputParams = inputParams;


            // -----------------------------------------
            // Execute Prompt Template
            // -----------------------------------------
            ConnectApi.EinsteinPromptTemplateGenerationsRepresentation result =
                ConnectApi.EinsteinLLM.generateMessagesForPromptTemplate(
                    PROMPT_TEMPLATE_NAME,
                    templateInput
                );


            // -----------------------------------------
            // Validate Response
            // -----------------------------------------
            if (result == null ||
                result.generations == null ||
                result.generations.isEmpty()) {

                throw new AuraHandledException(
                    'No response was generated.'
                );
            }


            // -----------------------------------------
            // Get Generated Text
            // -----------------------------------------
            String generatedText =
                result.generations[0].text;

            System.debug(
                'Prompt Template Raw Response: ' +
                generatedText
            );


            // -----------------------------------------
            // Parse JSON
            // -----------------------------------------
            ResponseWrapper response =
                parseResponse(generatedText);

            return response;

        }
        catch (Exception e) {

            System.debug(
                'HealthKnowledgeController Error: ' +
                e.getMessage()
            );

            throw new AuraHandledException(
                'Unable to get an answer: ' +
                e.getMessage()
            );
        }
    }


    // =================================================
    // Parse Prompt Template JSON Response
    // =================================================

    private static ResponseWrapper parseResponse(
        String generatedText
    ) {

        if (String.isBlank(generatedText)) {

            throw new AuraHandledException(
                'The Prompt Template returned an empty response.'
            );
        }


        Map<String, Object> jsonResponse;

        try {

            jsonResponse =
                (Map<String, Object>)
                JSON.deserializeUntyped(
                    generatedText
                );

        }
        catch (Exception e) {

            /*
             * Sometimes the LLM may return JSON
             * inside Markdown code fences.
             *
             * Example:
             *
             * ```json
             * {
             *   "response": {
             *      "text": "..."
             *   }
             * }
             * ```
             */

            String cleanedText =
                generatedText
                    .replace('```json', '')
                    .replace('```', '')
                    .trim();

            try {

                jsonResponse =
                    (Map<String, Object>)
                    JSON.deserializeUntyped(
                        cleanedText
                    );

            }
            catch (Exception ex) {

                throw new AuraHandledException(
                    'The Prompt Template returned an invalid JSON response.'
                );
            }
        }


        // -----------------------------------------
        // Get "response"
        // -----------------------------------------

        Object responseObject =
            jsonResponse.get('response');

        if (responseObject == null) {

            throw new AuraHandledException(
                'The "response" property was not found.'
            );
        }


        Map<String, Object> responseMap =
            (Map<String, Object>)
            responseObject;


        // -----------------------------------------
        // Get "text"
        // -----------------------------------------

        Object textObject =
            responseMap.get('text');

        if (textObject == null) {

            throw new AuraHandledException(
                'The "response.text" property was not found.'
            );
        }


        // -----------------------------------------
        // Create Wrapper
        // -----------------------------------------

        ResponseWrapper wrapper =
            new ResponseWrapper();

        wrapper.text =
            String.valueOf(textObject);


        // -----------------------------------------
        // Optional Source Information
        // -----------------------------------------

        if (responseMap.containsKey('source')) {

            wrapper.source =
                JSON.serialize(
                    responseMap.get('source')
                );
        }


        return wrapper;
    }


    // =================================================
    // Wrapper Class
    // =================================================

    public class ResponseWrapper {

        @AuraEnabled
        public String text;

        @AuraEnabled
        public String source;
    }
}