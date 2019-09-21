<a name="welcome"></a>Getting Started
=====================

Overview
--------

Welcome to the ZAP API Documentation! The [OWASP Zed Attack Proxy](https://www.owasp.org/index.php/OWASP_Zed_Attack_Proxy_Project) (**ZAP**) 
is one of the world's most popular free security tools which lets you automatically find security vulnerabilities in your 
web applications. ZAP also has an extremely powerful API that allows you to do nearly everything that possible via the desktop interface.
This allows the developers to automate pentesting and security regression testing of the application in the CI/CD pipeline. 


This document provides example guides & API definitions for ZAP APIs. You can view code examples in the dark area to 
the right; switch the programming language of the examples with the tabs on the top right. If anything is missing or seems 
incorrect, please check the [GitHub issues](https://github.com/zaproxy/zaproxy/issues) for existing known issues or create a new issue
in the Github repository. If you are looking for advanced automation, a series of automation scripts are available 
in the following [Github repository](https://github.com/zaproxy/community-scripts).

Following are some of the features provided by ZAP:

* Intercepting Proxy
* Active and Passive Scanners
* Traditional and Ajax Spiders
* Brute Force Scanner
* Port Scanner
* Web Sockets

Have a look at the examples below to learn how to use each of these features via ZAP API.

Documentation Structure
---------------

The API documentation is divided in to eight main parts. Following shows the summary of each main section.

* [**Getting Started**](#welcome) section contains introductory information of ZAP and installation guide to setup ZAP for testing.
* [**Exploring The Apps**](#explore) section contains examples on how to explore the web application.
* [**Attacking The Apps**](#attack) section contains examples on how to scan or attack a web application.
* [**Getting The Results**](#results) section contains examples on how to retrieve alerts and generate Reports from ZAP.
* [**Authentication**](#auth) section contains examples on how to authenticate the web application with ZAP.
* [**Advanced Settings**](#examples) section contains advanced configurations on how to fine tune the ZAP results.
* [**Contributions**](#contribution) section contains guidelines and instruction on how to contribute to ZAP's documentations.
* [**API Catalogue**](#api_catalogue) section contains Open API definitions for ZAP APIs. 

<aside class="notice">
The examples shows some usages with the minimal required arguments. However, this is not a reference, and not all APIs 
nor arguments are shown. View the API catalog to see all the parameters and scope of each APIs.
</aside>


Basics on the API request
-------------------------

ZAP APIs provides access to most of the core features of ZAP such as the active scanner and spider. The ZAP API is automatically 
enabled if you have started the ZAP in deamon or headless mode. If you are using the ZAP desktop then the API should be enabled
by visiting the following API screen: 

`Tools -> Options -> API`.

![zap_desktop_api](../images/zap_desktop_api.png)

<aside class="notice">
ZAP requires API Key to perform specific actions via the REST API. The API key must be specified on all API 'actions' and some 'other' operations. 
The API key is used to prevent malicious sites from accessing the ZAP API. It is strongly recommended that you set a key 
unless you are using ZAP in a completely isolated environment.
</aside>

Please note that not all the operations which are allowed from the desktop interface are available via the APIs. 
Future versions of ZAP will increase the functionality/scope available via the APIs.

### API URL Format

The API is available via `GET` and `POST` endpoints and the response is available in `JSON`, `XML`, and `HTML` formats. All the 
response formats returns the same information, just in a different format. Based on the use case, choose the appropriate format. 
For example, to generate easily readable reports use the HTML format and use XML/JSON based response to parse the results quickly.

The following shows the API URL format of ZAP:

`http://zap/<format>/<component>/<operation>/<operation name>[/?<parameters>]`

The format can be either `JSON`, `XML` or `HTML`. The operation can be either `view` or `action`. `view` is used to return
information and `action` is used to control the ZAP. For example, view can be used to generated reports or retrive results and 
action can be used to start or stop the Spider. The components, operation names and parameters can all be discovered by 
browsing the [API Catalogue](#api_catalogue).

### Access the API

The REST API can be accessed directly or via one of the [client implementations](#client_sdk) detailed below. If you are 
running the ZAP desktop interface then, a simple web UI is also available which allows to explore and use the APIs. 
This web UI is available via the URL ([http://zap/](http://zap/)) when you are proxying via ZAP, or via the host and port ZAP 
is listening on, eg [http://localhost:8080/](http://localhost:8080/). 

![zap_api_ui](../images/zap_api_ui.png)

By default only the machine ZAP is running on is able to access the APIs. You can allow other machines, that are able to 
use ZAP as a proxy, access to the API. The API can be also configured using the Options API screen using the desktop interface.

### <a name="client_sdk"></a>Client SDKs


ZAP provides official clients for Python, Java, and Node JS. Visit the following link to download the [official SDKs](https://github.com/zaproxy/zaproxy/wiki/ApiDetails) 


Quick Setup Guide
---------------

The quick setup guide focuses on setting up _ZAP_ and a testing application. If you have already setup ZAP then Jump to 
specific [example](#examples) to experiment with specific features.

### Install  ZAP

``` shell
# Option: 1, using "headless/daemon" mode
$ <ZAP_HOME>./zap.sh -daemon -config api.key=change-me-9203935709
# Option: 2, using normal/ Desktop interface mode
$ <ZAP_HOME>./zap.sh
```

``` java
// Option: 1, using "headless/daemon" mode
<ZAP_HOME>./zap.sh -daemon -config api.key=change-me-9203935709
// Option: 2, using normal/ Desktop interface mode
<ZAP_HOME>./zap.sh
```

``` python
# Option: 1, using "headless/daemon" mode
<ZAP_HOME>./zap.sh -daemon -config api.key=change-me-9203935709
# Option: 2, using normal/ Desktop interface mode
<ZAP_HOME>./zap.sh
```

To install ZAP, go to the ZAP [home page](https://github.com/zaproxy/zaproxy/wiki/Downloads) and download the installer specific to the 
operating system. After extracting the bundle you can start zap by issuing the following command shown in the right column.

The API key must be specified on all API `actions` and some `other` operations. The API key is used to prevent malicious 
sites from accessing the ZAP API. 

### Setup a Testing Application

If you already have a website to scan or to perform security testing, then obtain the URL/IP of the application to begin the scanning. 
The example guide uses the [Google's Firing Range](https://github.com/google/firing-range) and 
[OWASP Juice Shop](https://github.com/bkimminich/juice-shop) to perform the security testing. 
The Spidering and Attacking examples uses the [public instance](https://public-firing-range.appspot.com) of the 
firing range and OWASP Juice Shop is used to showcase the Authentication examples of ZAP. Following 
is a [list](https://www.owasp.org/index.php/OWASP_Vulnerable_Web_Applications_Directory_Project#tab=On-Line_apps) 
of publicly available vulnerable applications that you can also use in conjunction with ZAP.

<aside class="warning">
Do not use ZAP on unauthorized pages. Please be aware that you should only attack applications that you have been 
specifically been given permission to test.
</aside>

Getting help
------------

All available APIs are documented in the [API Catalogue](#api_catalogue). If you have come across any issue with ZAP, 
please feel free to raise a question in the [developer forum](https://groups.google.com/d/forum/zaproxy-develop) or 
[Stack Overflow](https://stackoverflow.com/questions/tagged/zap). Also, use the [ZAP's Github repository]((https://github.com/zaproxy/zaproxy/issues)) 
to raise a bug report or to make any feature requests.

Stay tuned on twitter [@zaproxy](https://twitter.com/zaproxy).
