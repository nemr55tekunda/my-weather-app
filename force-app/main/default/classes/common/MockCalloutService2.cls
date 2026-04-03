/**
 * @description       : Mock HTTP Callout Service used for unit testing.
 *                      Implements HttpCalloutMock to simulate HTTP responses
 *                      with a fluent builder pattern.
 * @author            : pelayochristian.dev@gmail.com
 * @last modified on  : 07-13-2022
 * @last modified by  : pelayochristian.dev@gmail.com
 **/
@IsTest
public class MockCalloutService implements HttpCalloutMock {

    // ─── Private Fields ───────────────────────────────────────────────────────

    private String                body;
    private Blob                  blobBody;
    private Integer               statusCode;
    private String                status;
    private Map<String, String>   headers = new Map<String, String>();

    // ─── Builder Methods ──────────────────────────────────────────────────────

    /**
     * @description Sets the string body of the mock HTTP response.
     * @param body  String payload to return in the response.
     * @return      The current MockCalloutService instance (fluent).
     */
    public MockCalloutService setBody(String body) {
        this.body = body;
        return this;
    }

    /**
     * @description    Sets the blob body of the mock HTTP response.
     * @param blobBody Blob payload to return in the response.
     * @return         The current MockCalloutService instance (fluent).
     */
    public MockCalloutService setBlobBody(Blob blobBody) {
        this.blobBody = blobBody;
        return this;
    }

    /**
     * @description      Sets the HTTP status code of the mock response.
     * @param statusCode Integer HTTP status code (e.g. 200, 400, 500).
     * @return           The current MockCalloutService instance (fluent).
     */
    public MockCalloutService setStatusCode(Integer statusCode) {
        this.statusCode = statusCode;
        return this;
    }

    /**
     * @description Sets the HTTP status string of the mock response.
     * @param status Status text (e.g. 'OK', 'Completed', 'Not Found').
     * @return       The current MockCalloutService instance (fluent).
     */
    public MockCalloutService setStatus(String status) {
        this.status = status;
        return this;
    }

    /**
     * @description    Sets the response headers for the mock HTTP response.
     * @param headers  Map of header name-value pairs.
     * @return         The current MockCalloutService instance (fluent).
     */
    public MockCalloutService setHeader(Map<String, String> headers) {
        if (headers != null && !headers.isEmpty()) {
            this.headers = headers;
        }
        return this;
    }

    // ─── HttpCalloutMock Implementation ───────────────────────────────────────

    /**
     * @description    Responds to a mock HTTP request with the configured
     *                 response values. Called automatically by the Salesforce
     *                 test framework when an HTTP callout is made inside
     *                 Test.startTest() / Test.stopTest().
     * @param request  The outbound HttpRequest intercepted by the mock.
     * @return         A fully configured HttpResponse.
     */
    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();

        // Set status code with safe default
        response.setStatusCode(this.statusCode != null ? this.statusCode : 200);

        // Set status text
        if (String.isNotBlank(this.status)) {
            response.setStatus(this.status);
        }

        // Prefer blob body over string body when both are set
        if (this.blobBody != null) {
            response.setBodyAsBlob(this.blobBody);
        } else if (String.isNotBlank(this.body)) {
            response.setBody(this.body);
        }

        // Apply all headers
        for (String headerKey : this.headers.keySet()) {
            response.setHeader(headerKey, this.headers.get(headerKey));
        }

        return response;
    }
}
