Getting Started
=====================

Overview
--------

Welcome to the ZAP API Documentation! The OWASP Zed Attack Proxy (**ZAP**) is one of the world's most popular free security 
tools and is actively maintained by hundreds of international volunteers. It can help you automatically find security 
vulnerabilities in your web applications while you are developing and testing your applications. It's also an excellent 
tool for experienced pentesters to use for manual security testing.

Aside from the desktop application, ZAP has an extremely powerful API that allows us to do nearly everything that possible via the desktop interface.
This document provides example use cases & API definition for OWASP ZAP. You can view code examples in the dark area to 
the right; switch the programming language of the examples with the tabs on the top right. If anything is missing or seems 
incorrect, please check the GitHub issues for existing known issues or create a new issue.


ZAP provides the following features:

* Intercepting Proxy
* Automated Scanner
* Passive Scanner
* Brute Force Scanner
* Fuzzer
* Port Scanner
* Spider
* Web Sockets
* REST API

Have a look at the examples below to learn how to use ZAP.

Documentation Structure
---------------

The API documentation is divided in to four main parts. Getting started guide provides

### Section Summary

* **Getting Started:** This section provides introduction to ZAP and installation guide to setup ZAP for testing.
* **Examples:** Contains high-level examples on how to use ZAP APIs to perform specified actions.
* **Contributions:** Guidelines and instruction on how to contribute to ZAPs documentations
* **API Catalogue:** Contains Open API definitions for ZAP APIs. 

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
specific example if you want to experiment with specific features.

To install ZAP, go to the ZAP [home page](https://github.com/zaproxy/zaproxy/wiki/Downloads) and download the installer specific to the 
operating system. After extracting the bundle you can start zap by issuing the following command.

The API key must be specified on all API 'actions' and some 'other' operations. The API key is used to prevent malicious 
sites from accessing the ZAP API. It is strongly recommended that you set a key unless you are using ZAP in a completely 
isolated environment.

<aside class="notice">
ZAP requires Java to run.
</aside>

Configure Testing Application
---------------

```
$ git clone https://github.com/bkimminich/juice-shop.git
$ cd juice-shop 
$ npm install
$ npm start
```

If you have a website to scan then obtain a publicly accessible URL/IP. For quick start guide we will be using OWASP Juice shop.

<aside class="warning">
Do not use on unauthorized pages. Use ZAP on a website only if you have permissions to perform testing on it!
</aside>

OWASP Juice Shop is a modern and sophisticated insecure web application! It can be used in security trainings, 
awareness demos, CTFs and as a guinea pig for security tools! Juice Shop encompasses vulnerabilities from the entire OWASP Top Ten 
along with many other security flaws found in real-world applications!

Set up Juice shop with the following commands in the right column. Then visit `http://localhost:3000` to access the OWASP Juice shop.

![juice-shop](../images/juice-shop.png)


Getting help
------------

All available functions are documented in [API Catalogue](#interface)

A developer mailing list is available to ask questions or feature request: <a href="mailto:https://groups.google.com/d/forum/zaproxy-develop">https://groups.google.com/d/forum/zaproxy-develop</a>

In order to report bug and make feature requests please use our github zap project
<https://github.com/zaproxy/zaproxy/issues>.

Stay tuned on twitter [@zaproxy](https://twitter.com/zaproxy).
