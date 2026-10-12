public with sharing class ExtractPromptResponseText {

    public class Request {
        @InvocableVariable(required=true)
        public String promptResponse;
    }

    public class Result {
        @InvocableVariable
        public String text;
    }

    @InvocableMethod(label='Extract Prompt Response Text')
    public static List<Result> extractText(List<Request> requests) {

        List<Result> results = new List<Result>();

        for (Request request : requests) {

            Result result = new Result();
            result.text = '';

            if (!String.isBlank(request.promptResponse)) {
                try {
                    Map<String, Object> outerResponse =
                        (Map<String, Object>) JSON.deserializeUntyped(
                            request.promptResponse
                        );

                    Map<String, Object> responseData =
                        (Map<String, Object>) outerResponse.get('response');

                    if (responseData != null) {
                        result.text = (String) responseData.get('text');
                    }

                } catch (Exception e) {
                    result.text = '';
                }
            }

            results.add(result);
        }

        return results;
    }
}