<a name="welcome"></a>Getting Started
=====================

Overview
--------

Welcome to the ZAP API Documentation! The [OWASP Zed Attack Proxy](https://www.owasp.org/index.php/OWASP_Zed_Attack_Proxy_Project) (**ZAP**) 
is one of the world's most popular free security tools and is actively maintained by hundreds of international volunteers. It can help you automatically find security 
vulnerabilities in your web applications while you are developing and testing your applications. It's also an excellent 
tool for experienced pentesters to use for manual security testing. ZAP also has an extremely powerful API that allows you 
to do nearly everything that possible via the desktop interface.

This document provides example guides & API definitions for ZAP APIs. You can view code examples in the dark area to 
the right; switch the programming language of the examples with the tabs on the top right. If anything is missing or seems 
incorrect, please check the GitHub issues for existing known issues or create a new issue.


Following are some of the features provided by ZAP:

* Active Scanner
* Passive Scanner
* Brute Force Scanner
* Fuzzer
* Port Scanner
* Spider
* Web Sockets
* Ajax Spider

Have a look at the examples below to learn how to use each of these features via ZAP API.


Documentation Structure
---------------

The API documentation is divided in to four main parts. Following shows the summary of each main section.

* [**Getting Started:**](#welcome) This section provides introduction to ZAP and installation guide to setup ZAP for testing.
* [**Examples:**](#examples) Contains high-level examples on how to use ZAP APIs to perform specified actions.
* [**Contributions:**](#contribution) Guidelines and instruction on how to contribute to ZAPs documentations
* [**API Catalogue:**](#api_catalogue) Contains Open API definitions for ZAP APIs. 

Basics on the API request
-------------------------

ZAP provides an Application Programming Interface (API) which allows you to interact with ZAP programmatically.

The API is available in the following formats.

- JSON 
- HTML
- XML

A simple web UI which allows you to explore and use the API is available via the URL http://zap/ when you are proxying via ZAP, 
or via the host and port ZAP is listening on, eg [http://localhost:8080/](http://localhost:8080/). By default only the 
machine ZAP is running on is able to access the API. You can allow other machines, that are able to use ZAP as a proxy, 
access to the API. The API is configured using the Options API screen.

The APIs provides access to most of the core ZAP features such as the active scanner and spider. Future versions of ZAP will 
increase the functionality/scope available via the APIs.

<aside class="notice">
The examples shows some usages with the minimal required arguments. However, this is not a reference and not all APIs nor 
arguments are shown. View API catalogue to see all the parameters and socpe of each APIs.
</aside>

Quick Setup Guide
---------------


> 2 ways to start zap

``` shell
# Option: 1, using "headless" mode
$ <ZAP_HOME>./zap.sh -daemon -config api.key=change-me-9203935709
# Option: 2, using normal mode
$ <ZAP_HOME>./zap.sh
```

The quick setup guide focuses on setting up _ZAP_ and a testing application. If you have already setup ZAP then Jump to 
specific [example](#examples) to experiment with specific features. To install ZAP, go to the ZAP 
[home page](https://github.com/zaproxy/zaproxy/wiki/Downloads) and download the installer specific to the 
operating system. After extracting the bundle you can start zap by issuing the following command.

The API key must be specified on all API 'actions' and some 'other' operations. The API key is used to prevent malicious 
sites from accessing the ZAP API. It is strongly recommended that you set a key unless you are using ZAP in a completely 
isolated environment.


Configure Testing Application
---------------

```
$ git clone https://github.com/bkimminich/juice-shop.git
$ cd juice-shop 
$ npm install
$ npm start
```

If you have a website to scan then obtain a publicly accessible URL/IP. For the example guides we will be using OWASP Juice shop.

OWASP Juice Shop is a modern and sophisticated insecure web application! It can be used in security trainings, 
awareness demos, CTFs and as a guinea pig for security tools! Juice Shop encompasses vulnerabilities from the entire OWASP Top Ten 
along with many other security flaws found in real-world applications!

Set up Juice shop with the following commands in the right column. Then visit `http://localhost:3000` to access the OWASP Juice shop.

<aside class="warning">
Do not use on unauthorized ZAP pages. Use ZAP on a websites only if you have permissions to perform testing on it!
</aside>

![juice-shop](../images/juice-shop.png)


Getting help
------------

All available functions are documented in [API Catalogue](#interface)

A developer mailing list is available to ask questions or feature request: https://groups.google.com/d/forum/zaproxy-develop

In order to report bug and make feature requests please use our github [zap repository](https://github.com/zaproxy/zaproxy/issues)

Stay tuned on twitter [@zaproxy](https://twitter.com/zaproxy).
