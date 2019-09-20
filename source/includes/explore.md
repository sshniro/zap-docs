<a name="examples"></a>Exploring The App
=========================================

Its recommended to explore the web application before performing any scan or attack. The more you explore your App the more 
accurate the results will be. If the application is not explored very well then it will impact or reduce the vulnerabilities ZAP can find.
The following are some of the options to explore the site by using ZAP.

* **Traditional Spider (Crawler)**

* **Ajax Spider** 

* **Proxy Regression / Unit tests:** This is the recommended approach, if you already have a test suite or unit tests.

* **Spider SOAP Definition**

Using Spider
-------------------

``` shell
# Start the spider scan 
$ curl "http://localhost:8080/JSON/spider/action/scan/?apikey=zapAPIKey&zapapiformat=JSON&url=https://public-firing-range.appspot.com&contextName=&recurse=true"


# To view the scan status
$ curl "http://localhost:8080/JSON/spider/view/status/?apikey=zapAPIKey&scanId=<scan id>"


# To view the scan results
$ curl "http://localhost:8080/JSON/spider/view/results/?apikey=zapAPIKey&scanId=0"


# To stop the scanning
$ curl "http://localhost:8080/JSON/spider/action/stop/?scanId=<scan_id>"
# To pause the scanning
$ curl "http://localhost:8080/JSON/spider/action/pause/?scanId=<scan_id>"
# To resume the scanning
$ curl "http://localhost:8080/JSON/spider/action/resume/?scanId=<scan_id>"

```

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

The Spider is a tool that is used to automatically discover new resources (URLs) on a particular site. It begins with a 
list of URLs to visit, called the seeds, which depends on how the Spider is started. The Spider then visits these URLs, 
it identifies all the hyperlinks in the page and adds them to the list of URLs to visit, and the process continues 
recursively as long as new resources are found.

During the processing of a URL, the Spider makes a request to fetch the resource and then parses the response, identifying hyperlinks. 
Each response type is processed differently in ZAP. All the available endpoints for the spider can be found in `spider`

### Start the spider

The Spider(s) explore the site and don't actually do any scanning. The scan API will initiate the crawling of the Spiders.
The scan ID will be returned as the response after triggering the Spider.
The request whhich are proxied through the ZAP will be [passively scanned](#passive_scan) by the passive scanner. The passive
scanner all of the requests and responses flowing through ZAP and report the issues they can spot. 

### View Status

The spider scan is a async request and the time to complete the task will vary depending on the complexity of the web application. 
The scan ID returned via starting the spider should be used to query the results. Execute the status API to get the status/ 
percentage of work done by the Spider.

### View Spider Results

The request in the code block will provide a response similar to the below, which will enlist all the resources the spider 
has crawled through.

![spider results](../images/spider_results.png)

### Stop or Pause The Spider

If the scanning takes too much time than expected you can stop or pause the scanning via using the start and pause APIs. 
Additional APIs are available in the API Catalogue to pause/resume/stop All the scanning processes.

Using AJAX Spider
-------------------

```shell
# To start the AJAX Spider
$ curl "http://localhost:8080/JSON/ajaxSpider/action/scan/?url=<URL>&inScope=&contextName=&subtreeOnly="


# To view the status
$ curl "http://localhost:8080/JSON/ajaxSpider/view/status/"

# To view the number of results
$ curl "http://localhost:8080/JSON/ajaxSpider/view/numberOfResults/"
# To view the results
$ curl "http://localhost:8080/JSON/ajaxSpider/view/fullResults/"

# To stop the AJAX Spider
$ curl "http://localhost:8080/JSON/ajaxSpider/action/stop/"
```

 The AJAX Spider allows you to crawl web applications written in AJAX in far more depth than the native Spider. 
 Use the AJAX Spider if you may have web applications written in AJAX. You should also use the native Spider as well for 
 complete coverage of a web application (e.g. to cover HTML comments).

### Start AJAX Spider

Use the command in the right column to start the AJAX Spider. This will start a long running asynchronous task.

### View Status

Unlike the traditional Spider, AJAX Spider does not provide a percentage for the work to be done. Use the `status` endpoint to 
identify whether the Spider is still active or finished.


### View Results

Use the following commands on the right to view the number of results or to obtain the entire results or a limited set of
results.

### Stop the AJAX Spider

Ajax spider does not have an indication on how much resources are left to crawl. Therefor if the Ajax spider takes too much time
than expected, then it can be stopped by using the following command in the right.

View the [advanced settings](#ajax_advanced) on how to enhance the Ajax Spider results.
