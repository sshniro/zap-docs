Getting started
=====================

Overview
--------

**ZAP** is the open API for building cool stuff with mobility data.


This website documents the REST APIs for ZAP. You can view code examples in the dark area to the right; switch the 
programming language of the examples with the tabs in the top right. If anything is missing or seems incorrect, 
please check the GitHub issues for existing known issues or create a new issue.


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

Have a look at the examples below to learn how to use them.

Quick Start Guide
---------------

### Basic penetration test

All requests that are proxied through ZAP or initialised by tools like the spider are [passively scanned:](https://github.com/zaproxy/zap-core-help/wiki/HelpStartConceptsPscan)
Passive scanning is always performed because it is completely safe - ZAP just looks at the requests and responses rather 
than making any additional requests. This is good for finding problems like missing security headers or missing anti CSRF 
tokens but is no good for finding vulnerabilities like XSS which require malicious requests to be sent - thats the job of 
the active scanner.

The quick start guide focuses on setting up _ZAP_ and perform a passive security scan. Jump to specific example if you 
want to experiment with specific features.

<aside class="notice">
This chapter shows some usages with the minimal required arguments. However, this is not a reference and not all APIs nor 
arguments are shown. View API catalogue to see all the parameters and socpe of each APIs.
</aside>

<aside class="warning">
Do not use on unauthorized pages.
</aside>

First step
---------------
> 2 ways to start zap

``` shell
# Option: 1, using "headless" mode
$ <ZAP_HOME>./zap.sh -daemon
# Option: 2, using normal mode
$ <ZAP_HOME>./zap.sh
```

Go to the ZAP [home page](https://github.com/zaproxy/zaproxy/wiki/Downloads) and download the installer specific to the operating system.

After extracting the bundle you can start zap by issuing the following command.

<aside class="notice">
ZAP requires java to run.
</aside>

Second step
---------------

If you have a website to scan then obtain a publicly accessible URL/IP. Or set up the following site to crawl.


Third step
---------------
``` shell
# In a curl way, with only the required parameters
$ curl "http://localhost:8500/JSON/spider/action/scan/?zapapiformat=JSON&url=http://localhost:8080/Danial/login&contextName=
```



Use the site url/ip and replace the url in the curl

The spider(s) explore the site. They dont actually do any scanning.
The passive scan rules examine all of the requests and responses flowing through ZAP and report the issues they can spot.
The active scan rules dont bother with the things the passive scan rules look for. They also wont explore a site.
If you just try running the active scan rules without exploring a site (either manually or using the spiders) then they wont find anything because there will be nothing to work on.
We try to keep things separate for flexibility, while providing packaged options like the Quick Scan and Baseline scan for those people who want them.


Fourth Step
--------------
``` shell
# In a curl way, with only the required parameters
$ curl "http://localhost:8500/JSON/spider/view/status/?zapapiformat=JSON&scanId=<scan id>"
```

The scan is a async request.To view the scan status. You can view the results via via issuing the following command.

``` shell
$ curl "http://localhost:8500/JSON/core/view/alerts/?zapapiformat=JSON&baseurl=http://localhost:8080/Danial/login&start=&count="
```


<a name="about_data"></a>About the Results
--------------

The results can be obtained via mutiple formats.

- HTML
- XML
- JSON 


Getting help
------------

All available functions are documented in [api catalogue](#interface)

A developer mailing list is available to ask questions or feature request: <a href="mailto:https://groups.google.com/d/forum/zaproxy-develop">https://groups.google.com/d/forum/zaproxy-develop</a>

In order to report bug and make feature requests please use our github zap project
<https://github.com/zaproxy/zaproxy/issues>.

Stay tuned on twitter [@zaproxy](https://twitter.com/zaproxy).