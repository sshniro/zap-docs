#Getting Authenticated

The application needs to be authenticated if most of the pages are hidden behind an authentication system. Performing authentication
for modern web-application can be quite complex. ZAP supports multiple ways for authentication. 

- Form based authentication.
- Script based authentication
- JSON based authentication

The OWASP Juice Shop is used in the sample code to perform the form based authentication. Follow the setup guide below 
to install and run OWASP Juice Shop. After the installation navigate to [http://localhost:3000](http://localhost:3000) to 
view the Juice Shop web application.

## Setup WebApplication

The application can be started using node JS or Docker. Docker is recommended approach for quick testing.

### With Docker

Issue the following command to start the docker container: `docker run -d -p 3000:3000 bkimminich/juice-shop`

### With Node JS

- Step 1: Clone the Web Application: `git clone https://github.com/bkimminich/juice-shop.git`

- Step 2: Install the node packages: `npm install`

- Step 3: Run the application: `npm start`


After the setting up the application a user should be created in the Juice Shop to proceed with the ZAP configurations.
A new user can be created by clicking the login button in the web application and clicking the `Not yet a customer?` option.

## Configure ZAP

Its recommended to configure the authentication via the desktop UI before attempting the APIs. Refer the 
[following link](https://github.com/zaproxy/zaproxy/wiki/FAQformauth) to learn to configure form based authentication
via the desktop. The following sections below provides a step by step guide on how to configure authentication for Juice Shop
application.

### Step 1: Include in Context

Inorder to proceed with Authenticaion the URL of the webapplication should be added to the context. As the Juice Shop is available
via [http://localhost:3000](http://localhost:3000) use the [includeInContext](#contextactionincludeincontext) API to add the
URL to the context. If you are using the desktop UI then export the context configs and import them via the 
[importContext](#contextactionimportcontext) API.

### Step 2:  Set Authentication Method

Use the [setAuthenticationMethod](#authenticationactionsetauthenticationmethod) to setup the authentication method and 
the configuration parameters. The setAuthenticationMethod takes contextId, authMethodName, and authMethodConfigParams as

As Juice Shop uses the form based authentication use `formBasedAuthentication` for the authMethodName and use the contextID
which was generated in the Step 1 as the contextId parameter. 

The authMethodConfigParams required the loginUrl and loginRequestData. Inorder to obtain these values observe the network 
tab when login to the webapplication. Juice Shop uses the following URL [http://localhost:3000/rest/user/login](http://localhost:3000/rest/user/login)
to post a XHR request to the back end. The following image shows the data and the response provided by the Juice Shop
for a successful login request. 

Therefore you should set the values to authMethodConfigParams in the following format:

`authMethodConfigParams : loginUrl=http://example.com/login.html&loginRequestData=username%3D%7B%25username%25%7D%26password%3D%7B%25password%25%7D`

The values for authMethodConfigParams parameters must be URL encoded, in this case loginRequestData is username={%username%}&password={%password%}

### Step 3: Set up login and logout indicators

The ZAP needs hints to identify whether the application is authenticated or not. As per the above image Juice Shops 
sends the auth token in a JSON format. Therefore for the login indicator a regex to match the successfull response can be 
used to to hint the ZAP for a sucessful authentication.

Following is a regex command to match the successful response for the Juice Shop backend.

`\{"authentication".*\:\{.*\:.*\}\}`

When you login to the Juice Shop a shopping basket will be shown to keep track of your purchases. This feature is not avaiable for
a non authenticated user. Therefore you can use the following feature to hind the ZAP regardding a logout event.

### Setup Forced User Mode

Use the [SetForcedUserModeEnabled](#forceduseractionsetforcedusermodeenabled) to enable the forced user mode in ZAP.


Add the user credentials via the [forceduseractionsetforceduser](#forceduseractionsetforceduser) API.



