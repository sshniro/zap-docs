<a name="examples"></a>Exploring The App
=========================================

Its recommended to explore the web application before performing any scan or attack. The more you explore your App the more 
accurate the results will be. If the application is not explored very well then it will impact or reduce the vulnerabilities ZAP can find.
The following are some of the options to explore the site by using ZAP. You can use multiple approaches in a combination to
get a wide coverage of the application.

* **Traditional Spider (Crawler):** Use this approach to crawl the HTML resources (hyperlinks etc) in the web application

* **Ajax Spider:** Use this feature if the web application heavily relies with Ajax calls.

* **Proxy Regression / Unit tests** This is the recommended approach for security regression testing. Use this approach 
to explore the application, if you already have a test suite or unit tests in place. 

* **Open API/SOAP Definition**: Use this approach if you have a well defined Open API definition.

Using Spider
-------------------

```java
public class Spider {

    private static final String ZAP_ADDRESS = "localhost";
    private static final int ZAP_PORT = 8080;
    private static final String ZAP_API_KEY =
    null; // Change this if you have set the apikey in ZAP via Options / API

    private static final String TARGET = "https://public-firing-range.appspot.com";

    public static void main(String[] args) {
        ClientApi api = new ClientApi(ZAP_ADDRESS, ZAP_PORT, ZAP_API_KEY);

        try {
            // Start spidering the target
            System.out.println("Spider : " + TARGET);
            // Create the
            ApiResponse resp = api.spider.scan(TARGET, null, null, null, null);
            String scanid;
            int progress;

            // The scan now returns a scan id to support concurrent scanning
            scanid = ((ApiResponseElement) resp).getValue();

            // Poll the status until it completes
            while (true) {
                Thread.sleep(1000);
                progress =
                        Integer.parseInt(
                                ((ApiResponseElement) api.spider.status(scanid)).getValue());
                System.out.println("Spider progress : " + progress + "%");
                if (progress >= 100) {
                    break;
                }
            }
            System.out.println("Spider complete");
            System.out.println(api.spider.results(scanid));

        } catch (Exception e) {
            System.out.println("Exception : " + e.getMessage());
            e.printStackTrace();
        }
    }
}
```

```python
#!/usr/bin/env python
# A basic ZAP Python API example which spiders and scans a target URL

import time
from pprint import pprint
from zapv2 import ZAPv2

target = 'http://127.0.0.1'
apikey = 'changeme' # Change to match the API key set in ZAP, or use None if the API key is disabled
#
# By default ZAP API client will connect to port 8080
zap = ZAPv2(apikey=apikey)
# Use the line below if ZAP is not listening on port 8080, for example, if listening on port 8090
# zap = ZAPv2(apikey=apikey, proxies={'http': 'http://127.0.0.1:8090', 'https': 'http://127.0.0.1:8090'})

# Proxy a request to the target so that ZAP has something to deal with
print('Accessing target {}'.format(target))
zap.urlopen(target)
# Give the sites tree a chance to get updated
time.sleep(2)

print('Spidering target {}'.format(target))
scanid = zap.spider.scan(target)
# Give the Spider a chance to start
time.sleep(2)
while (int(zap.spider.status(scanid)) < 100):
    # Loop until the spider has finished
    print('Spider progress %: {}'.format(zap.spider.status(scanid)))
    time.sleep(2)

print ('Spider completed')

while (int(zap.pscan.records_to_scan) > 0):
      print ('Records to passive scan : {}'.format(zap.pscan.records_to_scan))
      time.sleep(2)

print ('Passive Scan completed')

print ('Active Scanning target {}'.format(target))
scanid = zap.ascan.scan(target)
while (int(zap.ascan.status(scanid)) < 100):
    # Loop until the scanner has finished
    print ('Scan progress %: {}'.format(zap.ascan.status(scanid)))
    time.sleep(5)

print ('Active Scan completed')

# Report the results

print ('Hosts: {}'.format(', '.join(zap.core.hosts)))
print ('Alerts: ')
pprint (zap.core.alerts())
```

``` shell
# To start the Spider scan (Response: Scan ID)
$ curl "http://localhost:8080/JSON/spider/action/scan/?apikey=<zapAPIKey>&zapapiformat=JSON&url=https://public-firing-range.appspot.com&contextName=&recurse=true"


# To view the scan status
$ curl "http://localhost:8080/JSON/spider/view/status/?apikey=<zapAPIKey>&scanId=<scan id>"


# To view the scan results
$ curl "http://localhost:8080/JSON/spider/view/results/?apikey=<zapAPIKey>&scanId=<scan id>"


# To stop the scanning
$ curl "http://localhost:8080/JSON/spider/action/stop/?scanId=<scan_id>"
# To pause the scanning
$ curl "http://localhost:8080/JSON/spider/action/pause/?scanId=<scan_id>"
# To resume the scanning
$ curl "http://localhost:8080/JSON/spider/action/resume/?scanId=<scan_id>"

```

The Spider is a tool that is used to automatically discover new resources (URLs) on a particular site. It begins with a 
list of URLs to visit, called the seeds, which depends on how the Spider is started. The Spider then visits these URLs, 
it identifies all the hyperlinks in the page and adds them to the list of URLs to visit, and the process continues 
recursively as long as new resources are found. Each response type is processed differently in ZAP. All the available 
endpoints for the spider can be found in [spider](#spider_api) section.

### Start the spider

The Spiders explore the site and they don't actually do any scanning. The [scan](#spider_scan_api) API runs the spider against the given URL. 
Optionally, the 'maxChildren' parameter can be set to limit the number of children scanned and the 'recurse' parameter can 
be used to prevent the spider from seeding recursively. The parameter 'subtreeOnly' allows to restrict the spider under a 
site's subtree (using the specified 'url'). The parameter 'contextName' can be used to constrain the scan to 
a Context. View the [context example](#context_advanced) to understand how to create a context with ZAP API.   

The code sample on the right recursively scans the web application with the provided URL. The scan ID is returns as a reponse
when starting the Spider. Use this scan ID to perform any additional actions or to retrive any views from the Spider API.

### View Status

The spider scan is a async request and the time to complete the task will vary depending on the complexity of the web application. 
The scan ID returned via starting the spider should be used to obtain the results of the crawling. Execute the [status](#spider_status_api) 
API to get the status/percentage of work done by the Spider.

### View Spider Results

The results of the crawling can be obtained via the [results](#spider_results_api) API. The following image shows the JSON sample 
response provided by the results API, enlisitng all the resources crawled by Spider.

![spider results](../images/spider_results.png)

### Stop or Pause The Spider

If the scanning takes too much time than expected you can stop or pause the scanning via using the [stop](#spider_stop_api) 
and [pause](#spider_pause_api) APIs. Additional APIs are available in the API Catalogue to pause or resume or to 
[stop All](#spider_stopAll_api) the scanning processes.

The [advanced section on Spider](#spider_advanced) contains more examples on how to tweak/improve the Spider results.

Using Ajax Spider
-------------------

```shell
# To start the Ajax Spider
$ curl "http://localhost:8080/JSON/AjaxSpider/action/scan/?url=<URL>&inScope=&contextName=&subtreeOnly="


# To view the status
$ curl "http://localhost:8080/JSON/AjaxSpider/view/status/"

# To view the number of results
$ curl "http://localhost:8080/JSON/AjaxSpider/view/numberOfResults/"
# To view the results
$ curl "http://localhost:8080/JSON/AjaxSpider/view/fullResults/"

# To stop the Ajax Spider
$ curl "http://localhost:8080/JSON/AjaxSpider/action/stop/"
```
 
Use the Ajax Spider if you may have web applications written in Ajax. The Ajax Spider allows you to crawl web applications 
written in Ajax in far more depth than the native Spider.You should also use the native Spider as well for complete coverage 
of a web application (e.g. to cover HTML comments).

### Start Ajax Spider

The scan API starts the Ajax Spider to given URL. Similar to the Traditional Spider, Ajax Spider can be also limited to a 
context or scope. The parameter 'contextName' can be used to constrain the scan to a Context, the option 'in scope' is 
ignored if a context was also specified. The parameter 'subtreeOnly' allows to restrict the spider under a site's subtree (using the specified 'url'). 

### View Status

Unlike the traditional Spider, Ajax Spider does not provide a percentage for the work to be done. Use the [status](#spider_status_api) 
endpoint to identify whether the Ajax Spider is still active or finished.


### View Results

Similar to the Traditional Spider, Ajax spider's [results](#aspider_results_api) API can be used to view the resources 
which are crawled by the Ajax Spider.

### Stop the Ajax Spider

Ajax spider does not have an indication on how much resources are left to crawl. Therefor if the Ajax spider takes too much time
than expected, then it can be stopped the [stop](#aspider_stop_api) API.

The [advanced section on Ajax Spider](#spider_advanced) contains more examples on how to tweak/improve the results of the 
Ajax Spider.
