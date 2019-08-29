<a name="some_examples"></a>Examples (In Progress)
=========================================

Nunc lobortis mattis aliquam faucibus purus in massa tempor nec. Quis blandit turpis cursus in hac. Duis tristique 
sollicitudin nibh sit amet commodo nulla facilisi nullam. Vitae semper quis lectus nulla at. Duis at consectetur lorem donec 
massa sapien faucibus. Eu mi bibendum neque egestas congue quisque egestas. Elit eget gravida cum sociis natoque penatibus et 
magnis dis. Nibh nisl condimentum id venenatis a condimentum vitae. Eget dolor morbi non arcu risus. Fermentum iaculis eu non 
diam phasellus vestibulum. At tempor commodo ullamcorper a lacus vestibulum. Nulla facilisi etiam dignissim diam quis. Rutrum 
tellus pellentesque eu tincidunt tortor aliquam nulla. Risus in hendrerit gravida rutrum quisque non tellus. Cursus eget nunc 
scelerisque viverra mauris. Ullamcorper a lacus vestibulum sed arcu non odio. At consectetur lorem donec massa sapien faucibus. 
Tempus urna et pharetra pharetra.

<aside class="notice">
You will have to use your own token with the examples below.
</aside>


Basics on the API request
-------------------------
``` shell
# Web is too shiny: JSON, urlencode and curl forever!
$ curl 'https://zap/v1/coverage/sandbox/stop_areas' -H 'Authorization: 3b036afe-0110-4202-b9ed-99718476c2e0'
```

ZAP provides an Application Programming Interface (API) which allows you to interact with ZAP programmatically.

The API is available in the following formats.

- JSON 
- HTML
- XML

A simple web UI which allows you to explore and use the API is available via the URL http://zap/ when you are proxying via ZAP, 
or via the host and port ZAP is listening on, eg [http://localhost:8080/].

By default only the machine ZAP is running on is able to access the API. You can allow other machines, that are able to use ZAP as a proxy, 
access to the API. The API is configured using the Options API screen.

The API provides access to most of the core ZAP features such as the active scanner and spider. Future versions of ZAP will increase the functionality available via the APi.

<aside class="success">
    Tadaaa!
    </br>
     It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.
    </br>
</aside>

Using Spider
-------------------

The spider is a tool that is used to automatically discover new resources (URLs) on a particular Site. It begins with a list of URLs to visit, called the seeds, which depends on how the Spider is started. The Spider then visits these URLs, it identifies all the hyperlinks in the page and adds them to the list of URLs to visit and the process continues recursively as long as new resources are found.

The Spider can configured and started using the Spider dialogue.

During the processing of an URL, the Spider makes a request to fetch the resource and then parses the response, identifying hyperlinks. It currently has the following behavior when processing types of responses:

### Start the spider

``` shell
# Start the spider scan 
$ curl "http://localhost:8080/JSON/spider/action/scan/?apikey=68u5tu85j34dc4g3ushdp847ku&zapapiformat=JSON&url=http://localhost:3000=&contextName="
```

The spider(s) explore the site. They don't actually do any scanning.
The passive scan rules examine all of the requests and responses flowing through ZAP and report the issues they can spot.
The spider API will return the scan ID as the response. 


### View Status

``` shell
# To view the scan status
$ curl "http://localhost:8080/JSON/spider/view/status/?apikey=68u5tu85j34dc4g3ushdp847ku&scanId=<scan id>"
```

The scan is a async request.To view the scan status. 

The alerts for the passive scan can be obtained via issuing the following commands.

``` shell
$ curl "http://localhost:8080/JSON/core/view/alerts/?zapapiformat=JSON&apikey=68u5tu85j34dc4g3ushdp847ku&baseurl=http://localhost:3000&start=&count="
```

![alerts](../images/alert1.png)


Perform Passive Scan
-------------------
``` shell
$ curl 'https://zap.com/v1/coverage' -H 'Authorization: 3b036afe-0110-4202-b9ed-99718476c2e0'


HTTP/1.1 200 OK

{
    "start_production_date": "20140105",
    "status": "running",
    "shape": "POLYGON((-74.500997 40.344999,-74.500997 41.096999,-73.226 41.096999,-73.226 40.344999,-74.500997 40.344999))",
    "id": "sandbox",
    "end_production_date": "20140406"
}
```

Vitae turpis massa sed elementum tempus egestas sed sed risus. Pellentesque eu tincidunt tortor aliquam nulla facilisi cras. 
Tincidunt tortor aliquam nulla facilisi cras. Tristique senectus et netus et malesuada fames. Feugiat scelerisque varius morbi enim. 
Justo eget magna fermentum iaculis eu non diam. 


Perform Active Scan
-------------------

Active scanning attempts to find potential vulnerabilities by using known attacks against the selected targets.

Active scanning is an attack on those targets. You should NOT use it on web applications that you do not own.

In order to facilitate identifying ZAP traffic and Web Application Firewall exceptions, ZAP is accompanied by a script "AddZapHeader.js" which can be used to add a specific header to all traffic that passes through or originates from ZAP. eg: X-ZAP-Initiator: 3

It should be noted that active scanning can only find certain types of vulnerabilities. Logical vulnerabilities, such as broken access control, will not be found by any active or automated vulnerability scanning. Manual penetration testing should always be performed in addition to active scanning to find all types of vulnerabilities.

Perform AJAX Scan
-------------------

ZAP by default passively scans all HTTP messages (requests and responses) sent to the web application being tested. Passive scanning does not change the requests nor the responses in any way and is therefore safe to use. Scanning is performed in a background thread to ensure that it does not slow down the exploration of an application.

The (main) behaviour of the passive scanner can be configured using the Options Passive Scanner Screen.

Passive scanning can also be used for automatically adding tags and raising alerts for potential issues. A set of rules for automatic tagging are provided by default. These can be changed, deleted or added to via the Options Passive Scan Tags screen.

The alerts raised by passive scanners can be configured using the Options Passive Scan Rules screen.


Perform Authentication
-------------------

Vitae turpis massa sed elementum tempus egestas sed sed risus. Pellentesque eu tincidunt tortor aliquam nulla facilisi cras. 
Tincidunt tortor aliquam nulla facilisi cras. Tristique senectus et netus et malesuada fames. Feugiat scelerisque varius morbi enim. 
Justo eget magna fermentum iaculis eu non diam. 

