# A simple ajax library.

# The Ajax class
# ========

class _ajax
    # 'get' is the main **GET** function, it is private and is called from other methods based on the responce type.
    get = (type, url, callback, async) ->
        # Create an `ActiveXObject('Microsoft.XMLHTTP')` object in Internet Explorer and a `XMLHttpRequest()` in all other browsers.
        xmlhttp = if window.ActiveXObject then new window.ActiveXObject('Microsoft.XMLHTTP') else new window.XMLHttpRequest()
        
        # If a callback method was passed in and the request is being handled asynchronously 
        # pass `responseXML` or `responseText` to the callback method.
        if callback and async
            xmlhttp.onreadystatechange = ->
                callback(if type is 'xml' then xmlhttp.responseXML else xmlhttp.responseText) if xmlhttp.readyState is 4
        # Open a request and send it.
        xmlhttp.open('GET', url, async); xmlhttp.send()
        
        # If a callback method was passed in and the request is being handled 
        # synchronously pass `responseXML` or `responseText` to the callback method.
        callback.call(if type is 'xml' then xmlhttp.responseXML else xmlhttp.responseText) if callback and not async

    # getText
    # --------
    
    # Request text, a callback function can be passed in to be called once the 
    # request has been handled. The `responceText` will be passed to the callback.
    getText: (url, callback=null, async=true) -> get('text', url, callback, async)
    
    # getXML
    # --------   
    
    # Request XML, a callback function can be passed in to be called once the 
    # request has been handled. The `responceXML` will be passed to the callback. 
    getXML: (url, callback=null, async=true) -> get('xml', url, callback, async)

# Exposing the class
# ========

# Register the wheel namespace if it hasn't been done yet.
@wh = {} if not @wh

# Add ajax to wheel.
@wh.ajax = new _ajax()