#Getting Authenticated (Content In Progress)

The application needs to be authenticated if most of the pages are hidden behind an authentication system. Performing authentication
for modern web-application can be quite complex. ZAP supports multiple ways for authentication. 

- Form based authentication.
- Script based authentication
- JSON based authentication

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

Its recommended to configure the authentication via the desktop UI before attempting the APIs. Refer the 
[following link](https://github.com/zaproxy/zaproxy/wiki/FAQformauth) to learn to configure form based authentication
via the desktop. The following sections below provides a step by step guide on how to configure authentication for Juice Shop
application.

### Setup Target Application

Damn Vulnerable Web App (DVWA) is used for the form based authentication example. Use the following command to start
a docker instance of the target application: `docker run --rm -it -p 80:3000 vulnerables/web-dvwa` 

Refer the [following link](#https://github.com/ethicalhack3r/DVWA) on how to setup the webapplication from source.

### Step 1: Include in Context

Inorder to proceed with authentication the URL of the webapplication should be added to the context. As the DVWA is available
via [http://localhost:3000](http://localhost:3000) use the [includeInContext](#contextactionincludeincontext) API to add the
URL to the context. If you are using the desktop UI then export the context configs and import them via the 
[importContext](#contextactionimportcontext) API.

### Step 2:  Set Authentication Method

Use the [setAuthenticationMethod](#authenticationactionsetauthenticationmethod) to setup the authentication method and 
the configuration parameters. The setAuthenticationMethod takes contextId, authMethodName, and authMethodConfigParams as

As DVWA uses the form based authentication use `formBasedAuthentication` for the authMethodName and use the contextID
which was generated in the Step 1 as the contextId parameter. 

The authMethodConfigParams required the loginUrl and loginRequestData. Inorder to obtain these values observe the network 
tab when login to the webapplication. Juice Shop uses the following URL [http://localhost:3000/rest/user/login](http://localhost:3000/rest/user/login)
to post a XHR request to the back end. The following image shows the data and the response provided by the Juice Shop
for a successful login request. 

Therefore you should set the values to authMethodConfigParams in the following format:

`authMethodConfigParams : loginUrl=http://example.com/login.html&loginRequestData=username%3D%7B%25username%25%7D%26password%3D%7B%25password%25%7D`

The values for authMethodConfigParams parameters must be URL encoded, in this case loginRequestData is username={%username%}&password={%password%}

### Step 3: Set up login and logout indicators

The ZAP needs hints to identify whether the application is authenticated or not. To check authentication is working correctly 
ZAP supports logged in/out regexes. These are regex patterns that you should configure to match strings in the responses 
which indicate if the user is logged in or logged out.

As per the above image Juice Shops sends the auth token in a JSON format. Therefore for the login indicator a regex to match the successfull response can be 
used to to hint the ZAP for a sucessful authentication.

Following is a regex command to match the successful response for the Juice Shop backend.

`\{"authentication".*\:\{.*\:.*\}\}`

When you login to the Juice Shop a shopping basket will be shown to keep track of your purchases. This feature is not avaiable for
a non authenticated user. Therefore you can use the following feature to hind the ZAP regardding a logout event.

### Setup Forced User Mode

Use the [SetForcedUserModeEnabled](#forceduseractionsetforcedusermodeenabled) to enable the forced user mode in ZAP.


Add the user credentials via the [forceduseractionsetforceduser](#forceduseractionsetforceduser) API.


## Script Based Authentication

1. Using a Zest server side script, which is what you are currently trying
2. Using a Zest client side script, which launches a browser
3. Using an authentication script written in any of the other supported languages
