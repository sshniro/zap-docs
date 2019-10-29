# Getting Authenticated

The target application for testing might have portion of the functionality which is only available for a logged in user.
In order to get a full test coverage of the application you need to test the application with a logged user as well.
Therefore it's very important to understand how to perform authenticated scans with ZAP. ZAP has several means to authenticate to your 
application and keep track of authentication state.

- Form-based authentication.
- Script-based authentication
- JSON-based authentication

In general, you should configure which authentication method to use. For example, for form and JSON based authentication, you 
need to provide the login URL and the authentication payload (username & password). ZAP additionally needs hints to identify whether the application 
is authenticated or not. To check authentication is working correctly, ZAP supports logged in/out regexes. These are regex 
patterns that you should configure to match strings in the responses which indicate if the user is logged in or logged out.

Apart from the above configurations you should also set the users (user name, password), and session management 
when configuring the authentication for your application. Currently, ZAP supports cookie based session management and 
HTTP authentication based session management.

The examples below show three authentication workflows. A simple form-based authentication is showcased with the use Bodgeit application.
The second example shows the script-based authentication using the Damn Vulnerable Web Application(DVWA). The third example shows a more complicated authentication
workflow using the JSON and script-based authentication using the OWASP Juice Shop. 

<aside class="info">
It's recommended to configure the authentication using the desktop UI before automating it using the ZAP APIs. The examples
belows shows how to perfom authentication with desktop and provides automation scripts on how to perform the similar using 
ZAP APIs.
</aside>

## Form Based Authentication

```java
public class FormAuth {

    private static final String ZAP_ADDRESS = "localhost";
    private static final int ZAP_PORT = 8090;
    private static final String ZAP_API_KEY = null;
    private static final String contextId = "1";


    private static void setLoggedInIndicator(ClientApi clientApi) throws UnsupportedEncodingException, ClientApiException {
        // Prepare values to set, with the logged in indicator as a regex matching the logout link
        String loggedInIndicator = "<a href=\"logout.jsp\"></a>";

        // Actually set the logged in indicator
        clientApi.authentication.setLoggedInIndicator(ZAP_API_KEY, contextId, java.util.regex.Pattern.quote(loggedInIndicator));

        // Check out the logged in indicator that is set
        System.out.println("Configured logged in indicator regex: "
                + ((ApiResponseElement) clientApi.authentication.getLoggedInIndicator(contextId)).getValue());
    }

    private static void setFormBasedAuthenticationForBodgeit(ClientApi clientApi) throws ClientApiException,
            UnsupportedEncodingException {
        // Setup the authentication method
        
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

        setFormBasedAuthenticationForBodgeit(clientApi);
        System.out.println("-------------");
        setLoggedInIndicator(clientApi);
        System.out.println("-------------");
        setUserAuthConfigForBodgeit(clientApi);
    }
}
```

```python
#!/usr/bin/env python
from urllib.parse import urlencode
from zapv2 import ZAPv2

context_id = 1
apiKey = 'changeMe'

# By default ZAP API client will connect to port 8080
zap = ZAPv2(apikey=apiKey)
# Use the line below if ZAP is not listening on port 8080, for example, if listening on port 8090
# zap = ZAPv2(apikey=apikey, proxies={'http': 'http://127.0.0.1:8090', 'https': 'http://127.0.0.1:8090'})


def set_logged_in_indicator():
    logged_in_regex = '<a href=\"logout.jsp\"></a>'
    zap.authentication.set_logged_in_indicator(context_id, logged_in_regex, apiKey)
    print('Configured logged in indicator regex: ')


def set_form_based_auth():
    login_url = "http://localhost:8080/bodgeit/login.jsp"
    login_request_data = "username={%username%}&password={%password%}"
    form_based_config = 'loginUrl=' + urlencode(login_url) + '&loginRequestData=' + urlencode(login_request_data)
    zap.authentication.set_authentication_method(context_id, 'formBasedAuthentication', form_based_config, apiKey)
    print('Configured form based authentication')


def set_user_auth_config():
    user = 'Test User'
    username = 'test@example.com'
    password = 'weakPassword'

    user_id = zap.users.new_user(context_id, user, apiKey)
    user_auth_config = 'username=' + urlencode(username) + '&password=' + urlencode(password)
    zap.users.set_authentication_credentials(context_id, user_id, user_auth_config, apiKey)
    
    
set_form_based_auth()
set_logged_in_indicator()
set_user_auth_config()
```

```shell
# To create new context
curl 'http://localhost:8080/JSON/context/action/newContext/?contextName=bodgeit

# To include in context
curl 'http://localhost:8080/JSON/context/action/includeInContext/?contextName=bodgeit&regex=http%3A%2F%2Flocalhost%3A8090.*'

# Set login details (URL Endoded)
curl 'http://localhost:8080/JSON/authentication/action/setAuthenticationMethod/?contextId=1&authMethodName=formBasedAuthentication&authMethodConfigParams=loginUrl%3Dhttp%3A%2F%2Flocalhost%3A8090%2Fbodgeit%2Flogin.jsp%26loginRequestData%3Dusername%253D%257B%2525username%2525%257D%2526password%253D%257B%2525password%2525%257D'

# To set the login indicator
curl 'http://localhost:8080/JSON/authentication/action/setLoggedInIndicator/?contextId=4&loggedInIndicatorRegex=%5CQ%3Ca+href%3D%22logout.jsp%22%3ELogout%3C%2Fa%3E%5CE'

# To create a user
curl 'http://localhost:8080/JSON/users/action/newUser/?contextId=4&name=admin'

# To add the credentials for the user
curl ''

# To enable forced used mode
curl ''
```

The following example performs a simple [form based authentication]((https://github.com/zaproxy/zaproxy/wiki/FAQformauth)) 
using the Bodgeit vulnerable application. Its recommended to configure the authentication via the desktop UI before attempting the APIs. 

### Setup Target Application

Bodgeit uses a very simple form based authentication to authenticate the users to the web application. Use the following command to start
a docker instance of the bodgeit application: `docker run --rm -p 8090:8080 -i -t psiinon/bodgeit` 

### Register a User

Register a user in the web application by navigating to the following link: `http://localhost:8090/bodgeit/register.jsp`.
For the purpose of this example, use the following information.

* username: test@gmail.com
* password: weakPass

### Login

After registering the user browse (proxied via ZAP) to the following URL and login to the application: 
[http://localhost:8090/bodgeit/login.jsp](http://localhost:8090/bodgeit/login.jsp) When you login to the application the 
request will be added to the History in ZAP. Search for the POST request to the following URL: 
[http://localhost:8090/bodgeit/login.jsp](http://localhost:8090/bodgeit/login.jsp). Right-click on the post request in the 
prompted menu select `Flag as Context -> Default Context : Form based Login Request` option. This will open the context
authentication editor. You can notice it has auto selected the form based authentication, auto-filled the login URL and the post data.
Select the correct JSON attribute as the username and password in the dropdown and click Ok.

Now you need to inform ZAP whether the application is logged in or out. The Bodgeit application includes the logout url 
`<a href="logout.jsp">Logout</a>` as the successful response. You can view this by navigating to the response tab of the login request.
Highlight the text and right click  and select the `Flag as Context -> Default Context, Loggedin Indicator` option. This will autofill
the regex needed for the login indicator. Following image shows the completed setpup for the authentication tab of the context menu.

![auth](../images/auth_bodgeit_form_settings.png)

Now lets add the user credentials to be authenticated via going to the `context -> users -> Add` section. After this enable 
the forced used to mode in the UI to forcefully authenticate the user before performing any activities in ZAP such as Spider or Active Scan.

After configuring the authentication tab go to the Spider and select the context to perform the authentication. After this
you should see the Spider crawling all the protected resources.

### Steps to Reproduce via API

If you have configured the authentication via the desktop UI, then export the context and import it via using the 
[importContext](#contextactionimportcontext) API. The steps belows shows how to create configuration via ZAP APIs. 

#### Step 1: Include in Context

Inorder to proceed with authentication the URL of the webapplication should be added to the context. As the Bodgit is available
via [http://localhost:8090/bodgeit](http://localhost:8090/bodgeit) use the [includeInContext](#contextactionincludeincontext) API to add the
URL to the default context.

#### Step 2:  Set Authentication Method

Use the [setAuthenticationMethod](#authenticationactionsetauthenticationmethod) to setup the authentication method and 
the configuration parameters. The setAuthenticationMethod takes contextId, authMethodName, and authMethodConfigParams as
parameters. As Bodgeit uses the form based authentication use `formBasedAuthentication` for the authMethodName and use the contextID
which was generated in the Step 1 as the contextId parameter. 

The authMethodConfigParams requires the loginUrl and loginRequestData. Therefore you should set the values to authMethodConfigParams in the following format:

`authMethodConfigParams : loginUrl=http://localhost:8090/bodgeit/login.jsp&loginRequestData=username%3D%7B%25username%25%7D%26password%3D%7B%25password%25%7D`

The values for authMethodConfigParams parameters must be URL encoded, in this case loginRequestData is username={%username%}&password={%password%}

#### Step 3: Set up login and logout indicators

The Following is a regex command to match the successful response with the Bodgeit application.

`\Q  \E`

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




