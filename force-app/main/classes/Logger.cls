public without sharing class Logger {
    
    private Logger() {}

    private static List<String> logList = new List<String>();
    
    private static Integer order = 0;
	private static Integer charLimit = 0;
    private static Boolean isDebugEnabled = true;
    private static Boolean trackLineNumbers = false; // set true to enable debug line number tracking. 
    private static String restAuthToken = '';
    private static String restEndpoint = '';

    /*
    NONE	No logging.
    ERROR	Error and exception logging.
    WARN	Warning logging.
    INFO	Informational logging.
    DEBUG	User-specified debug logging.
    */
    private static Integer currentOrgLoggingLevel = 4;

    private static void logExecutionContext(){
        String debugLine = '';
        if(currentOrgLoggingLevel>=1){
			logList.add('Execution Started');
            if (ApexPages.currentPage() != null) {
				logList.add('Request URL ' + ApexPages.currentPage().getUrl());
				logList.add('Request header ' + JSON.serialize(ApexPages.currentPage().getHeaders()));
				logList.add('Request params ' + JSON.serialize(ApexPages.currentPage().getParameters()));
				logList.add('Request cookies ' + ApexPages.currentPage().getCookies());
			}else if(RestContext.request != null){
				RestRequest req = RestContext.request;
				logList.add('Request URL ' + req.requestURI);
				logList.add('Request header ' + JSON.serialize(req.headers));
				logList.add('Request params ' + JSON.serialize(req.params));
				logList.add('Request params ' + req.requestBody);
				logList.add('Request remoteAddress ' + req.remoteAddress);
			}else{
				logList.add('Is Future=' + System.isFuture());
				logList.add('Is Queueable=' + System.isQueueable());
				logList.add('Is Scheduled=' + System.isScheduled());
				logList.add('Is Batch=' + System.isBatch());
			}
		}	 
    }

    public static String getConsumedLimits(){
    	String consumedLimits = '';
    	if(currentOrgLoggingLevel>0){
            List<String> limitList = new List<String>();
            limitList.add('Consumed DML rows- '+Limits.getDMLRows()+' out of ' + Limits.getLimitDMLRows());
            limitList.add('Consumed DML statements- '+Limits.getDMLStatements()+' out of '+ Limits.getLimitDMLStatements());
            limitList.add('Consumed query rows- '+Limits.getQueryRows()+' out of '+ Limits.getLimitQueryRows());
            limitList.add('Consumed SOQL queries- '+Limits.getQueries()+' out of '+ Limits.getLimitQueries());
            limitList.add('Consumed SOSL queries- '+Limits.getSoslQueries()+' out of '+Limits.getLimitSoslQueries());
            limitList.add('Consumed aggregate queries- '+Limits.getAggregateQueries()+' out of '+ Limits.getLimitAggregateQueries());
            limitList.add('Consumed callouts- '+Limits.getCallouts()+' out of '+ Limits.getLimitCallouts());
            limitList.add('Consumed Email Invocations- '+Limits.getEmailInvocations()+' out of '+ Limits.getLimitEmailInvocations());
            limitList.add('Consumed future calls- '+Limits.getFutureCalls()+' out of '+ Limits.getLimitFutureCalls());
            limitList.add('Consumed queueable jobs added to the queue- '+Limits.getQueueableJobs()+' out of '+ Limits.getLimitQueueableJobs());
            limitList.add('Consumed Mobile Apex push calls- '+Limits.getMobilePushApexCalls()+' out of '+ Limits.getLimitMobilePushApexCalls());
            limitList.add('Consumed CPU time- '+Limits.getCpuTime()+' out of '+ Limits.getLimitCpuTime());
            limitList.add('Consumed heap size- '+Limits.getHeapSize()+' out of '+ Limits.getLimitHeapSize());
            // You can add more statements here to add remianing limits 
            try{
                consumedLimits = JSON.serialize(limitList);
            }catch (Exception e) {
                consumedLimits = '["Exception occured: failed to fetch log limits"]';
            }
    	}
    	return consumedLimits;
    }

    public static void info(Object message) {
		if(currentOrgLoggingLevel>=3){
			try {
				if(message!=null && message instanceof Exception) {
					Exception ex = (Exception)message;
					log(LoggingLevel.INFO, ex.getMessage());
					log(LoggingLevel.INFO, 'Stack Trace of Exception | '+  ex.getStackTraceString());
				}else{
					if (message == null) {
						log(LoggingLevel.INFO, 'null');
						return;
					}
                    if(trackLineNumbers){
                        throw new CustomException(JSON.serialize(message));
                    }else{
                        log(LoggingLevel.INFO, JSON.serialize(message));
                    }
				}
			} catch (Exception e) {
				String l = e.getStackTraceString();
				String debugLine = l.split('column 1')[1].substringBetween('Class.', ',');
				log(LoggingLevel.INFO, debugLine +'||'+  e.getMessage());
			}
		}	    	
    }

    public static void debug(Object message) {
		if(currentOrgLoggingLevel>=4){
			try {
				if(message!=null && message instanceof Exception) {
					Exception ex = (Exception)message;
					log(LoggingLevel.DEBUG, ex.getMessage());
					log(LoggingLevel.DEBUG, 'Stack Trace of Exception | '+  ex.getStackTraceString());
				}else{
					if (message == null) {
						log(LoggingLevel.DEBUG, 'null');
						return;
					}
					if(trackLineNumbers){
                        throw new CustomException(JSON.serialize(message));
                    }else{
                        log(LoggingLevel.INFO, JSON.serialize(message));
                    }
				}
			} catch (Exception e) {
				String l = e.getStackTraceString();
				String debugLine = l.split('column 1')[1].substringBetween('Class.', ',');
				log(LoggingLevel.DEBUG, debugLine +'||'+  e.getMessage());
			}
		}	    	
    }

    public static void warn(Object message) {
		if(currentOrgLoggingLevel>=2){
			try {
				if(message!=null && message instanceof Exception) {
					Exception ex = (Exception)message;
					log(LoggingLevel.WARN, ex.getMessage());
					log(LoggingLevel.WARN, 'Stack Trace of Exception | '+  ex.getStackTraceString());
				}else{
					if (message == null) {
						log(LoggingLevel.WARN, 'null');
						return;
					}
					if(trackLineNumbers){
                        throw new CustomException(JSON.serialize(message));
                    }else{
                        log(LoggingLevel.INFO, JSON.serialize(message));
                    }
				}
			} catch (Exception e) {
				String l = e.getStackTraceString();
				String debugLine = l.split('column 1')[1].substringBetween('Class.', ',');
				log(LoggingLevel.WARN, debugLine +'||'+  e.getMessage());
			}
		}	    	
    }

    public static void error(Object message) {
		if(currentOrgLoggingLevel>=1){
			try {
				if(message!=null && message instanceof Exception) {
					Exception ex = (Exception)message;
					log(LoggingLevel.ERROR, ex.getMessage());
					log(LoggingLevel.ERROR, 'Stack Trace of Exception | '+  ex.getStackTraceString());
				}else{
					if (message == null) {
						log(LoggingLevel.ERROR, 'null');
						return;
					}
					if(trackLineNumbers){
                        throw new CustomException(JSON.serialize(message));
                    }else{
                        log(LoggingLevel.INFO, JSON.serialize(message));
                    }
				}
			} catch (Exception e) {
				String l = e.getStackTraceString();
				String debugLine = l.split('column 1')[1].substringBetween('Class.', ',');
				log(LoggingLevel.ERROR, debugLine +'||'+  e.getMessage());
			}
		}	    	
    }

    public static void error(String message, Exception ex) {
		if(currentOrgLoggingLevel>=1){
			log(LoggingLevel.ERROR, (message!=null)? message : 'null');
			if(ex!=null) {
				log(LoggingLevel.ERROR, ex.getMessage());
				log(LoggingLevel.ERROR, 'Stack Trace of Exception | '+  ex.getStackTraceString());
			}
		}
    }

    @testVisible 
    private static void log(LoggingLevel level, Object message) {
		if(level==null){
			level = LoggingLevel.DEBUG;
		}
		if(message==null){
			message = 'NULL';
		}
		if(logList.size()<1){
            logExecutionContext();
        }
		order++;
		String logString  = 
		logString = order + '||'+ System.currentTimeMillis() + '||' + 
                    UserInfo.getOrganizationId() +'||'+ UserInfo.getUserId()  +'||'+ 
                    Request.getCurrent().getQuiddity().name() +'||'+ 
                    Request.getCurrent().getRequestId() +'||'+ 
                    level.name() + '||' + 
                    JSON.serialize(message);
		
		charLimit = charLimit + logString.length();
		if(charLimit>130000){
			saveLogs(null);
		}else{
			logList.add(logString);
		}
    }

    public static void saveLogs(SendTo destination) {
    	if (logList != null && logList.size() > 0 && currentOrgLoggingLevel>0) {
			logList.add(getConsumedLimits());
    		try {

                switch on destination {
                    when LOG_TABLE_WITH_FUTURE {
                        SendToTableByFuture(JSON.serialize(logList));
                    }
                    when LOG_TABLE_WITHOUT_FUTURE {
                        SendToTable(JSON.serialize(logList));
                    }
                    when PLATFORM_EVENT {
                        SendToPlatformEvent(JSON.serialize(logList));
                    }
                    when REST_CALL {
                        SendToRestEndpoint(JSON.serialize(logList));
                    }
                    when else {
                        SendToTable(JSON.serialize(logList));
                    }
                }
				logList = new List<String>();
    		} catch (Exception ex) {
				System.debug('Exception in saveLogs - ' + ex.getStackTraceString());
    		}
    	}
		charLimit = 0;
    }
    
	private static void SendToTable(String logText){   
		try {
			Logs__c newLogRecord = new Logs__c(Type__c = Request.getCurrent().getQuiddity().name(), requestId__c=Request.getCurrent().getRequestId(), Log_text__c = logText);
			SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.CREATABLE, newLogRecord);

		} catch (Exception e) {
			System.debug('saveDebugLogs Exception -  '  + e.getStackTraceString());
		}
    }

    @future
    private static void SendToTableByFuture(String logText){   
		try {
			Logs__c newLogRecord = new Logs__c(Type__c = Request.getCurrent().getQuiddity().name(), requestId__c=Request.getCurrent().getRequestId(), Log_text__c = logText);
            SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.CREATABLE, newLogRecord);
			
		} catch (Exception e) {
			System.debug('saveDebugLogsByFuture Exception -  '  + e.getStackTraceString());
		}
    }

    private static void SendToPlatformEvent(String logText){   
		try {
			EventBus.publish(new Logs__e(
                Type__c = Request.getCurrent().getQuiddity().name(),
                requestId__c=Request.getCurrent().getRequestId(),
                Log_text__c = logText);
            ));

		} catch (Exception e) {
			System.debug('SendToPlatformEvent Exception -  '  + e.getStackTraceString());
		}
    }

    private static void SendToRestEndpoint(String logText){   
		try {
			Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(restEndpoint);
            req.setHeader('Authorization', 'Bearer ' + restAuthToken);
            req.setHeader('Content-Type', 'application/json');
            req.setMethod('POST');
            resObj = http.send(req);
		} catch (Exception e) {
			System.debug('SendToRestEndpoint Exception -  '  + e.getStackTraceString());
		}
    }
}