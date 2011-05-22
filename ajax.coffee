class _ajax
    get = (type, url, callback, async) ->
        xmlhttp = if window.ActiveXObject then new window.ActiveXObject('Microsoft.XMLHTTP') else new window.XMLHttpRequest()
        xmlhttp.overrideMimeType = 'application/json' if xmlhttp.overrideMimeType
        
        if callback and async
            xmlhttp.onreadystatechange = ->
                callback(if type is 'xml' then xmlhttp.responseXML else xmlhttp.responseText) if xmlhttp.readyState is 4
        xmlhttp.open('GET', url, async); xmlhttp.send()
        
        callback.call(if type is 'xml' then xmlhttp.responseXML else xmlhttp.responseText) if callback and not async
            
    getText: (url, callback=null, async=true) ->
        get('text', url, callback, async)
        
    getXML: (url, callback=null, async=true) ->
        get('xml', url, callback, async)      

#TODO: implement post
#xmlhttp.open("POST","ajax_test.asp",true);
#xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
#xmlhttp.send("fname=Henry&lname=Ford");

# Register the wheel namespace if it hasn't been done yet
@wh = {} if not @wh

# Add ajaz to wheel
@wh.ajax = new _ajax()