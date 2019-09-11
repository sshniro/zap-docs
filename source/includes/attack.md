<a name="examples"></a>Attacking The App
=========================================

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor 
in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.

<aside class="notice">
The examples shows some usages with the minimal required arguments. However, this is not a reference, and not all APIs 
nor arguments are shown. View the API catalog to see all the parameters and scope of each APIs.
</aside>

<a name="passive_scan"></a>Perform Passive Scan
-------------------

``` shell
$ curl "http://localhost:8080/JSON/core/view/alerts/?zapapiformat=JSON&apikey=68u5tu85j34dc4g3ushdp847ku&baseurl=http://localhost:3000&start=&count="
```

All requests that are proxied through ZAP or initialised by tools like the spider are passively scanned. 
ZAP by default passively scans all HTTP messages (requests and responses) sent to the web application being tested. 
Passive scanning does not change the requests nor the responses in any way and is therefore safe to use.
This is good for finding problems like missing security headers or missing anti CSRF tokens but is no good for finding 
vulnerabilities like XSS which require malicious requests to be sent - thats the job of the [active scanner](#active_scan).

The (main) behaviour of the passive scanner can be configured using the Options Passive Scanner API.

Passive scanning can also be used for automatically adding tags and raising alerts for potential issues. A set of rules for 
automatic tagging are provided by default. These can be changed, deleted or added to via the Options Passive Scan Tags screen.
The alerts raised by passive scanners can be configured using the Options Passive Scan Rules screen.

The alerts for the passive scan can be obtained via issuing the following commands.




<a name="active_scan"></a>Perform Active Scan
-------------------

Active scanning attempts to find potential vulnerabilities by using known attacks against the selected targets.

Active scanning is an attack on those targets. You should NOT use it on web applications that you do not own.

In order to facilitate identifying ZAP traffic and Web Application Firewall exceptions, ZAP is accompanied by a script "AddZapHeader.js" which can be used to add a specific header to all traffic that passes through or originates from ZAP. eg: X-ZAP-Initiator: 3

It should be noted that active scanning can only find certain types of vulnerabilities. Logical vulnerabilities, such as broken access control, will not be found by any active or automated vulnerability scanning. Manual penetration testing should always be performed in addition to active scanning to find all types of vulnerabilities.

