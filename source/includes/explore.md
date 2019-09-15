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

The Spider is a tool that is used to automatically discover new resources (URLs) on a particular site. It begins with a 
list of URLs to visit, called the seeds, which depends on how the Spider is started. The Spider then visits these URLs, 
it identifies all the hyperlinks in the page and adds them to the list of URLs to visit, and the process continues 
recursively as long as new resources are found.

During the processing of a URL, the Spider makes a request to fetch the resource and then parses the response, identifying hyperlinks. 
Each response type is processed differently in ZAP. All the available endpoints for the spider can be found in `spider`

### Start the spider

``` shell
# Start the spider scan 
$ curl "http://localhost:8080/JSON/spider/action/scan/?apikey=zapAPIKey&zapapiformat=JSON&url=https://public-firing-range.appspot.com&contextName=&recurse=true"
```

The Spider(s) explore the site and don't actually do any scanning. The [passive scan](#passive_scan) rules examine all of 
the requests and responses flowing through ZAP and report the issues they can spot. The scan ID will be returned as the response 
after triggering the Spider.


### View Status

``` shell
# To view the scan status
$ curl "http://localhost:8080/JSON/spider/view/status/?apikey=zapAPIKey&scanId=<scan id>"
```

The spider scan is a async request and the time to complete the task will vary depending on the complexity of the web application. 
The scan ID returned via starting the spider should be used to query the results. 
To view the status (percentage of the work done) of the scan you can execute the API call which is shown in right column. 



### View Spider Results

```shell
# To view the scan results
$ curl "http://localhost:8080/JSON/spider/view/results/?apikey=zapAPIKey&scanId=0"
```

The request in the code block will provide a response similar to the below, which will enlist all the resources the spider 
has crawled through.

<div class="center-column"></div>
```json
{
  "results": [
    "https://public-firing-range.appspot.com/address/location.hash/jshref",
    "https://public-firing-range.appspot.com/address/location.hash/formaction",
    "https://public-firing-range.appspot.com/dom/toxicdom/external/sessionStorage/array/eval",
  ]
}
```

<br>


### Stop or Pause The Spider

```shell
# To stop the scanning
$ curl "http://localhost:8080/JSON/spider/action/stop/?scanId=<scan_id>"
# To pause the scanning
$ curl "http://localhost:8080/JSON/spider/action/pause/?scanId=<scan_id>"
# To resume the scanning
$ curl "http://localhost:8080/JSON/spider/action/resume/?scanId=<scan_id>"
```

If the scanning takes too much time than expected you can stop or pause the scanning via using the start and pause APIs. 
Additional APIs are available in the API Catalogue to pause/resume/stop All the scanning processes.

Perform AJAX Spider
-------------------

 The AJAX Spider allows you to crawl web applications written in AJAX in far more depth than the native Spider. 
 Use the AJAX Spider if you may have web applications written in AJAX. You should also use the native Spider as well for 
 complete coverage of a web application (e.g. to cover HTML comments).

### Start AJAX Spider

```shell
# To start the AJAX Spider
$ curl "http://localhost:8080/JSON/ajaxSpider/action/scan/?url=<URL>&inScope=&contextName=&subtreeOnly="
```

Use the command in the right column to start the AJAX Spider. This will start a long running asynchronous task.

### View Status

```shell
# To view the status
$ curl "http://localhost:8080/JSON/ajaxSpider/view/status/"
```

Unlike the traditional Spider, AJAX Spider does not provide a percentage for the work to be done. Use the `status` endpoint to 
identify whether the Spider is still active or finished.


### View Results

```shell
# To view the number of results
$ curl "http://localhost:8080/JSON/ajaxSpider/view/numberOfResults/"
# To view the results
$ curl "http://localhost:8080/JSON/ajaxSpider/view/fullResults/"
```

Use the following commands on the right to view the number of results or to obtain the entire results or a limited set of
results.

### Stop the AJAX Spider

```shell
# To stop the AJAX Spider
$ curl "http://localhost:8080/JSON/ajaxSpider/action/stop/"
```

Ajax spider does not have an indication on how much resources are left to crawl. Therefor if the Ajax spider takes too much time
than expected, then it can be stopped by using the following command in the right.

View the [advanced settings](#ajax_advanced) on how to enhance the Ajax Spider results.
