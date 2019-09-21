<a name="examples"></a>Attacking The App
=========================================

Before you start attacking the application its recommended to explore the application. If you haven't done that look at the
[explore](#explore) section on how to perform it. The scanning of the App can be classified in to passive scan and active scan.


<aside class="warning">
Do not use ZAP on unauthorized pages. Please be aware that you should only attack applications that you have been 
specifically been given permission to test.
</aside>

<a name="passive_scan"></a>Using Passive Scan
-------------------

```java

```

```python

```

``` shell
# To view the alerts of passive scan
$ curl "http://localhost:8080/JSON/core/view/alerts/?zapapiformat=JSON&apikey=<ZAP_API_KEY>&baseurl=http://localhost:3000&start=&count="
```

All requests that are proxied through ZAP or initialised by tools like the Spider are passively scanned. You do not have 
to manually start the passive scan process, ZAP by default passively scans all HTTP messages (requests and responses) sent 
to the web application being tested. 

Passive scanning does not change the requests nor the responses in any way and is therefore safe to use.
This is good for finding problems like missing security headers or missing anti CSRF tokens but is no good for finding 
vulnerabilities like XSS which require malicious requests to be sent - that's the job of the [active scanner](#active_scan).

### View the status

As the records are passively scanned it will take additional time to complete the full scan. After the crawling is completed 
use the [recordsToScan](#pscan_records_to_scan) API to obtain the number of records left to be scanned. After the scanning 
has completed the alerts can be obtained via the alerts endpoint.

View the [advanced section](#pscan_advanced) to know how to configure additional parameters of Passive Scan.

<a name="active_scan"></a>Using Active Scan
-------------------

Active scanning attempts to find potential vulnerabilities by using known attacks against the selected targets. Active scanning 
is an attack on those targets. You should **NOT** use it on web applications that you do not own. 

### Start Active Scanner

```java

```

```python

```

``` shell
# To view the the active scan
$ curl "http://localhost:8080/JSON/ascan/action/scan/?url=https%3A%2F%2Fpublic-firing-range.appspot.com&recurse=true&inScopeOnly=&scanPolicyName=&method=&postData=&contextId="

# To view the alerts of passive scan
$ curl "http://localhost:8080/JSON/ascan/view/status/?scanId=1"

# To view the alerts of passive scan
$ curl "http://localhost:8080/JSON/core/view/alerts/?zapapiformat=JSON&apikey=<ZAP_API_KEY>&baseurl=http://localhost:3000&start=&count="

# To view the alerts of passive scan
$ curl "http://localhost:8080/JSON/ascan/action/stop/?scanId=1"
```

The [scan](#ascan_scan_api) endpoint runs the active scanner against the given URL and/or Context. Optionally, the `recurse` parameter can be used to scan URLs 
under the given URL, the parameter `inScopeOnly` can be used to constrain the scan to URLs that are in scope (ignored if a Context is specified).
The parameter `scanPolicyName` allows to specify the scan policy (if none is given it uses the default scan policy). 
The parameters `method` and `postData` allow to select a given request in conjunction with the given URL. 

View advanced settings to configure how to configure the [context](#context_advanced), [scope](#scope_advanced), and 
scan policy with ZAP APIs.

### View Status

The status API provides the percentage of attack done for the active scanner. The scan ID returned via starting the spider should be used to query the results. 

### View Results

Similar to the passive scan results the active scan results can be viewed using the alerts endpoint 

### Stop Active Scanning

Use the stop API to stop a long running active scan. Optionally you can use the stopAllScans endpoints or pause endpoints to
stop and pause the active scanning.

It should be noted that active scanning can only find certain types of vulnerabilities. Logical vulnerabilities, such as 
broken access control, will not be found by any active or automated vulnerability scanning. Manual penetration testing should 
always be performed in addition to active scanning to find all types of vulnerabilities.
