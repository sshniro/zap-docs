<a name="welcome"></a>Getting Started
=====================

Overview
--------

Welcome to the ZAP API Documentation! The [OWASP Zed Attack Proxy](https://www.owasp.org/index.php/OWASP_Zed_Attack_Proxy_Project) (**ZAP**) 
is one of the world's most popular free security tools which lets you automatically find security vulnerabilities in your 
web applications. ZAP also has an extremely powerful API that allows you to do nearly everything that possible via the desktop interface.
This allows the developers to automate the security testing of the application in the CI/CD pipeline. If you are looking for
automating the security testing, a series of automation scripts are available in the following [Github repository](https://github.com/zaproxy/community-scripts) 
for advanced automation.


This document provides example guides & API definitions for ZAP APIs. You can view code examples in the dark area to 
the right; switch the programming language of the examples with the tabs on the top right. If anything is missing or seems 
incorrect, please check the [GitHub issues](https://github.com/zaproxy/zaproxy/issues) for existing known issues or create a new issue
in the Github repository.

Following are some of the features provided by ZAP:

* Intercepting Proxy
* Active and Passive Scanners
* Traditional and Ajax Spiders
* Brute Force Scanner
* Fuzzer
* Port Scanner
* Web Sockets

Have a look at the examples below to learn how to use each of these features via ZAP API.

Documentation Structure
---------------

The API documentation is divided in to eight main parts. Following shows the summary of each main section.

* [**Getting Started**](#welcome) section contains introductory information of ZAP and installation guide to setup ZAP for testing.
* [**Exploring The Apps**](#explore) section contains examples on how to explore the web application.
* [**Attacking The Apps**](#attack) section contains examples on how to scan or attack a web application.
* [**Getting The Results**](#results) section contains examples on how to generate Reports/Results from ZAP.
* [**Authentication**](#auth) section contains examples on how to authenticate the web application with ZAP.
* [**Advanced Settings**](#examples) section contains advanced configurations on how to fine tune the ZAP results.
* [**Contributions**](#contribution) section contains guidelines and instruction on how to contribute to ZAPs documentations.
* [**API Catalogue**](#api_catalogue) section contains Open API definitions for ZAP APIs. 

<aside class="notice">
The examples shows some usages with the minimal required arguments. However, this is not a reference, and not all APIs 
nor arguments are shown. View the API catalog to see all the parameters and scope of each APIs.
</aside>


Basics on the API request
-------------------------

The APIs provides access to most of the core ZAP features such as the active scanner and spider. Future versions of ZAP 
will increase the functionality/scope available via the APIs. The API is available via `GET` and `POST` endpoints. 
The API is available in `JSON`, `XML` and `HTML` formats. Based on the use case, you can select the appropriate response type. 
For example, XML/JSON based response can be used to parse the results and HTML based responses can be used to obtain alerts/reports 
that are easily readable.

The API supports:

* Views: Returns information/view
* Action: These control the ZAP

If you are running the ZAP desktop interface then, a simple web UI is also available which allows to explore and use the APIs. 
This web UI is available via the URL ([http://zap/](http://zap/)) when you are proxying via ZAP, or via the host and port ZAP 
is listening on, eg [http://localhost:8080/](http://localhost:8080/). 

By default only the machine ZAP is running on is able to access the APIs. You can allow other machines, that are able to 
use ZAP as a proxy, access to the API. The API can be configured using the Options API screen in the desktop interface.

<aside class="notice">
ZAP requires API Key to perform specific actions via the REST API. The API key must be specified on all API 'actions' and some 'other' operations. 
The API key is used to prevent malicious sites from accessing the ZAP API. It is strongly recommended that you set a key 
unless you are using ZAP in a completely isolated environment.
</aside>

Quick Setup Guide
---------------


> Two ways to start zap (View shell command column)

``` shell
# Option: 1, using "headless" mode
$ <ZAP_HOME>./zap.sh -daemon -config api.key=change-me-9203935709
# Option: 2, using normal/ Desktop interface mode
$ <ZAP_HOME>./zap.sh
```

The quick setup guide focuses on setting up _ZAP_ and a testing application. If you have already setup ZAP then Jump to 
specific [example](#examples) to experiment with specific features. To install ZAP, go to the ZAP 
[home page](https://github.com/zaproxy/zaproxy/wiki/Downloads) and download the installer specific to the 
operating system. After extracting the bundle you can start zap by issuing the following command.

The API key must be specified on all API `actions` and some `other` operations. The API key is used to prevent malicious 
sites from accessing the ZAP API. 

If you are running the desktop interface then the API key can be obtained via navigating to the following tab: `Tools -> Options -> API`

Setup Testing Web-Application
---------------

If you have a website to scan or to perform security testing, then obtain a publicly accessible URL/IP. For the example guides we will be using 
[Google's Firing Range](https://github.com/google/firing-range) and [OWASP Juice Shop](https://github.com/bkimminich/juice-shop).

Firing Range is a test bed for web application security scanners, providing synthetic, wide coverage for array of vulnerabilities. 
A public instance is running at [https://public-firing-range.appspot.com](https://public-firing-range.appspot.com).
The Spidering and Attacking examples will use the public instance of the firing range for security testing. OWASP Juice Shop is used 
to showcase the Authentication examples. Following is a [list](https://www.owasp.org/index.php/OWASP_Vulnerable_Web_Applications_Directory_Project#tab=On-Line_apps) 
of publicly available vulnerable applications that you can also use in conjunction with ZAP.

<aside class="warning">
Do not use ZAP on unauthorized pages. Please be aware that you should only attack applications that you have been 
specifically been given permission to test.
</aside>

Getting help
------------

All available APIs are documented in [API Catalogue](#interface). A [developer forum](https://groups.google.com/d/forum/zaproxy-develop) is 
available to ask questions or feature request. In order to report bug and make feature requests please use our github [zap repository](https://github.com/zaproxy/zaproxy/issues)

Stay tuned on twitter [@zaproxy](https://twitter.com/zaproxy).
