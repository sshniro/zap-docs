#Getting Authenticated

The application has a portion of functionality that is available only to logged in users. To fully test out your application, 
you need to also test out the logic as a logged in user. Some applications have features exposed without authentication, 
so it's very important to understand how to perform authenticated scans. ZAP has several means to authenticate to your 
application and keep track of authentication state.

- Form based authentication.
- Script based authentication
- JSON based authentication

In general you should configure which authentication method to use. For example for form and json based authentication you 
need to provide the login URL and the authentication payload (username & password). ZAP additionally needs hints to identify whether the application 
is authenticated or not. To check authentication is working correctly ZAP supports logged in/out regexes. These are regex 
patterns that you should configure to match strings in the responses which indicate if the user is logged in or logged out.

In general, apart from these configuration you should also set the users (user name, password), and session management 
when configuring the authentication setup. Currently ZAP supports cookied based session management and HTTP authentication 
based session management.

The examples below shows three authentication workflows. A simple form based authentication is showcased with the bodgeit application.
The second example shows the script based authentication using the DVWP. The third example shows a more complicated authentication
workflow using the JSON and Script based authentication using the OWASP Juice Shop. 

## Form Based Authentication

```java
public class AuthenticationApiExample {

	private static final String ZAP_ADDRESS = "localhost";
	private static final int ZAP_PORT = 8090;
	private static final String ZAP_API_KEY = null;

	private static void listAuthInformation(ClientApi clientApi) throws ClientApiException {
		// Check out which authentication methods are supported by the API
		List<String> supportedMethodNames = new LinkedList<>();
		ApiResponseList authMethodsList = (ApiResponseList) clientApi.authentication.getSupportedAuthenticationMethods();
		for (ApiResponse authMethod : authMethodsList.getItems()) {
			supportedMethodNames.add(((ApiResponseElement) authMethod).getValue());
		}
		System.out.println("Supported authentication methods: " + supportedMethodNames);

		// Check out which are the config parameters of the authentication methods
		for (String methodName : supportedMethodNames) {

			ApiResponseList configParamsList = (ApiResponseList) clientApi.authentication
					.getAuthenticationMethodConfigParams(methodName);

			for (ApiResponse r : configParamsList.getItems()) {
				ApiResponseSet set = (ApiResponseSet) r;
				System.out.println("'" + methodName + "' config param: " + set.getAttribute("name") + " ("
						+ (set.getAttribute("mandatory").equals("true") ? "mandatory" : "optional") + ")");
			}
		}
	}

	private static void listUserConfigInformation(ClientApi clientApi) throws ClientApiException {
		// Check out which are the config parameters required to set up an user with the currently
		// set authentication methods
		String contextId = "1";
		ApiResponseList configParamsList = (ApiResponseList) clientApi.users
				.getAuthenticationCredentialsConfigParams(contextId);

		StringBuilder sb = new StringBuilder("Users' config params: ");
		for (ApiResponse r : configParamsList.getItems()) {
			ApiResponseSet set = (ApiResponseSet) r;
			sb.append(set.getAttribute("name")).append(" (");
			sb.append((set.getAttribute("mandatory").equals("true") ? "mandatory" : "optional"));
			sb.append("), ");
		}
		System.out.println(sb.deleteCharAt(sb.length() - 2).toString());
	}

	private static void setLoggedInIndicator(ClientApi clientApi) throws UnsupportedEncodingException, ClientApiException {
		// Prepare values to set, with the logged in indicator as a regex matching the logout link
		String loggedInIndicator = "<a href=\"logout.jsp\"></a>";
		String contextId = "1";

		// Actually set the logged in indicator
		clientApi.authentication.setLoggedInIndicator(ZAP_API_KEY, contextId, java.util.regex.Pattern.quote(loggedInIndicator));

		// Check out the logged in indicator that is set
		System.out.println("Configured logged in indicator regex: "
				+ ((ApiResponseElement) clientApi.authentication.getLoggedInIndicator(contextId)).getValue());
	}

	private static void setFormBasedAuthenticationForBodgeit(ClientApi clientApi) throws ClientApiException,
			UnsupportedEncodingException {
		// Setup the authentication method
		String contextId = "1";
		String loginUrl = "http://localhost:8080/bodgeit/login.jsp";
		String loginRequestData = "username={%username%}&password={%password%}";

		// Prepare the configuration in a format similar to how URL parameters are formed. This
		// means that any value we add for the configuration values has to be URL encoded.
		StringBuilder formBasedConfig = new StringBuilder();
		formBasedConfig.append("loginUrl=").append(URLEncoder.encode(loginUrl, "UTF-8"));
		formBasedConfig.append("&loginRequestData=").append(URLEncoder.encode(loginRequestData, "UTF-8"));

		System.out.println("Setting form based authentication configuration as: "
				+ formBasedConfig.toString());
		clientApi.authentication.setAuthenticationMethod(ZAP_API_KEY, contextId, "formBasedAuthentication",
				formBasedConfig.toString());

		// Check if everything is set up ok
		System.out
				.println("Authentication config: " + clientApi.authentication.getAuthenticationMethod(contextId).toString(0));
	}

	private static void setUserAuthConfigForBodgeit(ClientApi clientApi) throws ClientApiException, UnsupportedEncodingException {
		// Prepare info
		String contextId = "1";
		String user = "Test User";
		String username = "test@example.com";
		String password = "weakPassword";

		// Make sure we have at least one user
		String userId = extractUserId(clientApi.users.newUser(ZAP_API_KEY, contextId, user));

		// Prepare the configuration in a format similar to how URL parameters are formed. This
		// means that any value we add for the configuration values has to be URL encoded.
		StringBuilder userAuthConfig = new StringBuilder();
		userAuthConfig.append("username=").append(URLEncoder.encode(username, "UTF-8"));
		userAuthConfig.append("&password=").append(URLEncoder.encode(password, "UTF-8"));

		System.out.println("Setting user authentication configuration as: " + userAuthConfig.toString());
		clientApi.users.setAuthenticationCredentials(ZAP_API_KEY, contextId, userId, userAuthConfig.toString());

		// Check if everything is set up ok
		System.out.println("Authentication config: " + clientApi.users.getUserById(contextId, userId).toString(0));
	}

	private static String extractUserId(ApiResponse response) {
		return ((ApiResponseElement) response).getValue();
	}

	/**
	 * The main method.
	 *
	 * @param args the arguments
	 * @throws ClientApiException
	 * @throws UnsupportedEncodingException
	 */
	public static void main(String[] args) throws ClientApiException, UnsupportedEncodingException {
		ClientApi clientApi = new ClientApi(ZAP_ADDRESS, ZAP_PORT);

		listAuthInformation(clientApi);
		System.out.println("-------------");
		setFormBasedAuthenticationForBodgeit(clientApi);
		System.out.println("-------------");
		setLoggedInIndicator(clientApi);
		System.out.println("-------------");
		listUserConfigInformation(clientApi);
		System.out.println("-------------");
		setUserAuthConfigForBodgeit(clientApi);
	}
}
```

The following example performs a simple form based authentication for the bodgeit vulnerable application.
Its recommended to configure the authentication via the desktop UI before attempting the APIs. Refer the 
[following link](https://github.com/zaproxy/zaproxy/wiki/FAQformauth) to learn to configure form based authentication
via the desktop. 

### Setup Target Application

Bodgeit uses a very simple form based authentication to authenticate the users to the web application. Use the following command to start
a docker instance of the bodgeit application: `docker run --rm -p 8090:8080 -i -t psiinon/bodgeit` 

### Register a User

Register a user in the web application by navigating to the following link: `http://localhost:8090/bodgeit/register.jsp`.
For the purpose of this tutorial, use the following information.

username: test@gmail.com
password: testpass

### Login

After the registration browse to the following URL and login to the application: [http://localhost:8090/bodgeit/login.jsp](http://localhost:8090/bodgeit/login.jsp)
When you login the request will be added to the History in ZAP. Search for the POST that included the login information, 
you should find a POST request to http://localhost:3000/rest/user/login. Right click (or control click) that request in the 
history and in the context menu that prompted click, Right click (or control click) Flag as Context > Default Context : 
Form based Login Request. The will bring up the Context Authentication editor settings. You will notice the post data 
with the authentication information as well as a couple parameters for selecting Username & Password. Go ahead and set 
the username and password parameters to the corresponding JSON attributes.

Now we need to inform ZAP whether the application is logged in or out. For that lets view the login response and select a
response that is only available in when the user is logged in.


Now lets add the user credentials to be authenticated via going to the `context -> users -> Add` section. After this enable 
the forced used to mode in the UI to forcefully authenticate the user before performing any activities in ZAP such as Spider or Active Scan.



After configuring the authentication tab go to the Spider and select the context to perform the authentication.

### Steps to Reproduce via API

If you have configured the authentication via the desktop UI, then export the context and import it via using the 
[importContext](#contextactionimportcontext) API.

#### Step 1: Include in Context

Inorder to proceed with authentication the URL of the webapplication should be added to the context. As the Bodgit is available
via [http://localhost:8090/bodgeit](http://localhost:8090/bodgeit) use the [includeInContext](#contextactionincludeincontext) API to add the
URL to the context.

#### Step 2:  Set Authentication Method

Use the [setAuthenticationMethod](#authenticationactionsetauthenticationmethod) to setup the authentication method and 
the configuration parameters. The setAuthenticationMethod takes contextId, authMethodName, and authMethodConfigParams as

As Bodgeit uses the form based authentication use `formBasedAuthentication` for the authMethodName and use the contextID
which was generated in the Step 1 as the contextId parameter. 

The authMethodConfigParams required the loginUrl and loginRequestData. Inorder to obtain these values observe the network 
tab when login to the webapplication. Juice Shop uses the following URL [http://localhost:3000/rest/user/login](http://localhost:3000/rest/user/login)
to post a XHR request to the back end. The following image shows the data and the response provided by the Juice Shop
for a successful login request. 

Therefore you should set the values to authMethodConfigParams in the following format:

`authMethodConfigParams : loginUrl=http://example.com/login.html&loginRequestData=username%3D%7B%25username%25%7D%26password%3D%7B%25password%25%7D`

The values for authMethodConfigParams parameters must be URL encoded, in this case loginRequestData is username={%username%}&password={%password%}

#### Step 3: Set up login and logout indicators

As per the above image Juice Shops sends the auth token in a JSON format. Therefore for the login indicator a regex to match the successfull response can be 
used to to hint the ZAP for a sucessful authentication.

Following is a regex command to match the successful response for the Juice Shop backend.

`\{"authentication".*\:\{.*\:.*\}\}`

When you login to the Juice Shop a shopping basket will be shown to keep track of your purchases. This feature is not avaiable for
a non authenticated user. Therefore you can use the following feature to hind the ZAP regardding a logout event.

#### Setup Forced User Mode

Use the [SetForcedUserModeEnabled](#forceduseractionsetforcedusermodeenabled) to enable the forced user mode in ZAP.
Add the user credentials via the [forceduseractionsetforceduser](#forceduseractionsetforceduser) API.

## Script Based Authentication

The following example performs a script based authentication for the Damn Vulnerable Web Application.


## JSON Based Authentication


### Register User

Let's go ahead and get first test user registered and setup to test authentication. Browse to http://localhost:3000/#/register & 
register a new user. For the purpose of this tutorial, use the following information.

Email input test@test.com
Password input testtest
Security Question
Select Your eldest siblings middle name
Input test

### Login

With the information you just registered with, browse to the login url http://localhost:3000/#/login. When you login the 
request will be added to the History in ZAP. Search for the POST that included the login information, you should find a POST 
request to http://localhost:3000/rest/user/login. Right click (or control click) that request in the history and in the context 
menu that prompted click, Right click (or control click) Flag as Context > Default Context : JSON-based Auth Login Request 
(if you only see the option for Form-based... that means your version of ZAP is out of date). The will bring up the Context 
Authentication editor settings. You will notice the post data with the authentication information as well as a couple parameters 
for selecting Username & Password. Go ahead and set the username and password parameters to the corresponding JSON attributes.


Exit the context editor and go back to the request, you will notice in the response headers there is no set cookie. In 
the response body you will find the response data.


The request that follows is GET http://localhost:3000/rest/user/whoami which you will notice has a header called Authorization 
which uses the token from the response body of the login request. In body if the response, you should see some info about your 
user.{"user":{"id":9,"email":"test@test.com"}}. If you visit that url directly, with your browser, the content of the page is 
{"user":{}} - the Authorization header is not added to request and there is not authenticated.


This request is initiated as a client side AJAX request using a spec called JWT. Currently ZAP doesn't have a notion of 
the Authorization header for sessions so this is where ZAPs scripting engine will come into play! With ZAP's scripting 
engine, we can easily add to or augment it's functionality.




