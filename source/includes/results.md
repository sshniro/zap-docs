#Getting the Results


```python
def zap_get_alerts(zap, baseurl, blacklist, out_of_scope_dict):
    # Retrieve the alerts using paging in case there are lots of them
    st = 0
    pg = 5000
    alert_dict = {}
    alert_count = 0
    alerts = zap.core.alerts(baseurl=baseurl, start=st, count=pg)
    while len(alerts) > 0:
        logging.debug('Reading ' + str(pg) + ' alerts from ' + str(st))
        alert_count += len(alerts)
        for alert in alerts:
            plugin_id = alert.get('pluginId')
            if plugin_id in blacklist:
                continue
            if not is_in_scope(plugin_id, alert.get('url'), out_of_scope_dict):
                continue
            if alert.get('risk') == 'Informational':
                # Ignore all info alerts - some of them may have been downgraded by security annotations
                continue
            if (plugin_id not in alert_dict):
                alert_dict[plugin_id] = []
            alert_dict[plugin_id].append(alert)
        st += pg
        alerts = zap.core.alerts(start=st, count=pg)
    logging.debug('Total number of alerts: ' + str(alert_count))
    return alert_dict
```

```java

```

```shell

```

After the scanning (Active/Passive) completes, ZAP provides the security vulnerabilities in the form of alerts. The alerts
are categorized into high-priority, medium-priority, low-priority and informational priority risks. The priority indicates the degree of risk associated with each alert. 
For an example, a high priority risk means that the issues listed in that category has more threat or risk potential than a medium-priority alert.
 
The alerts endpoint provides all the alerts which are identified by ZAP. View the sample code on the right to retrieve the 
alerts from the alerts endpoit. The results can be used to raise security alerts in the CI/CD pipeline or any custom workflows. 
The alerts summary gets the number of alerts grouped by each risk level, optionally filtering by URL.

A Summary report can be generated using the core module. The following image shows the report generated via the HTML response.
Alerts categories are indicated by different colour flags. Alerts flags can be seen in the bottom left of ZAP window with numbers. The number beside the flags indicate the number 
of potential issues within that category. 

![html report](../images/report_html.png)
