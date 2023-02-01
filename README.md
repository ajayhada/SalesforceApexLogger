# SalesforceApexLogger
Simple Salesforce apex logger

Static class implementation of logger, A super simple implementation which you can further extend and add more functionalities. 

key highlights; 
1. You dont need to initlize it and can directly use Logger.debug('debug Log'); Logger.error('Error Log'); statements anywhare in class. 
1. Provides async and sync methods to write logs to table, rest endpoint and eventbus.
1. You can send logs to event bus and from their subscribe using many methods refer. https://developer.salesforce.com/docs/atlas.en-us.platform_events.meta/platform_events/platform_events_subscribe.htm
1. Predefined private methods provided, you can change the implementaion to save/send logs to db or external system.
1. Support line number tracking in debug logs.


Flags: 
1. isDebugEnabled = default is true but you can read this value from custom settings. 
1. trackLineNumbers = default is false but you can read this value from custom settings. 
1. debugforUsers = defauld is null, but you can read tis value from custom settings. 

Usages: 

```

Logger.error('Error Log');
Logger.error('Error Log');
Logger.warn('warning log');
Logger.info('info log');
Logger.debug('warning log');
Logger.saveLog(SendTo.LOG_TABLE_WITH_FUTURE); || Logger.saveLog(SendTo.LOG_TABLE_WITHOUT_FUTURE);
Logger.saveLog(SendTo.PLATFORM_EVENT); || Logger.saveLog(SendTo.REST_CALL);

```

Log Formats 

```
"Execution Started",
"Request URL /apex/demoPage?nextPaga=createNew",
"Request header {\"User-Agent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) ..... \"Accept\":\"application/json\"}",
"Request params {\"param1\":\"value1\",\"param2\":\"value2",\"param3\":\"value3"}
"Request cookies {cookies ..... string}"
"ORDER||TIME_IN_MILIS||ORG_ID||USER_ID||EXECUTION_CONTEXT||TRANSECTION/REQUESTID||DEBUG_LEVEL||LOGDATA_LOGDATA-hello-world1"
"ORDER||TIME_IN_MILIS||ORG_ID||USER_ID||EXECUTION_CONTEXT||TRANSECTION/REQUESTID||DEBUG_LEVEL||LOGDATA_LOGDATA-hello-world2"
"ORDER||TIME_IN_MILIS||ORG_ID||USER_ID||EXECUTION_CONTEXT||TRANSECTION/REQUESTID||DEBUG_LEVEL||LOGDATA_LOGDATA-hello-world3"
"ORDER||TIME_IN_MILIS||ORG_ID||USER_ID||EXECUTION_CONTEXT||TRANSECTION/REQUESTID||DEBUG_LEVEL||LOGDATA_LOGDATA-hello-world4"
"Consumed SOQL queries- 6 out of 100"
"Consumed query rows- 2 out of 50000"
"Consumed SOSL queries- 0 out of 20"
"Consumed DML statements- 0 out of 150"
"Consumed DML rows- 0 out of 10000"
"Maximum CPU time- 185 out of 10000"
"Maximum heap size- 61303 out of 6000000"
"Consumed callouts- 0 out of 100"
"Consumed Email Invocations- 0 out of 10"
"Consumed future calls- 1 out of 50"
"Consumed queueable jobs added to the queue- 0 out of 50"
"Consumed Mobile Apex push calls- 0 out of 10"
"Consumed aggregate queries- 0 out of 300"
"Consumed records returned by the Database.getQueryLocator- 0 out of 10000"
```
