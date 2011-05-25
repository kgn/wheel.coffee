# A simple ajax library.

# Get the root level object
root = @

# Given a dictionary return a encoded url string.
data2url = (data) -> ("#{encodeURIComponent(k)}=#{encodeURIComponent(v)}" for k, v of data).join('&')

# The Ajax Class
# ========

class ajax
    # The main request function, this is private and is called from other exposed methods.
    request = (type, url, callback, async, data) ->
        # Create an `ActiveXObject('Microsoft.XMLHTTP')` object in Internet Explorer and a `XMLHttpRequest()` in all other browsers.
        xmlhttp = if root.ActiveXObject then new root.ActiveXObject('Microsoft.XMLHTTP') else new root.XMLHttpRequest()
        
        # If a callback method was passed in and the request is being handled asynchronously 
        # pass `responseXML` or `responseText` to the callback method.
        if callback and async
            xmlhttp.onreadystatechange = ->
                callback(if type is 'xml' then xmlhttp.responseXML else xmlhttp.responseText) if xmlhttp.readyState is 4
        
        # Preform a **POST** if we have data
        if data?
            # Get the body string
            if typeof data is 'object'
                body = data2url(data)
            else if typeof data is 'string'
                body = data
            
            # If we didn't fill body throw an error.
            throw new Error('Input data was not an object or a string') unless body?
            
            xmlhttp.open('POST', url, async)
            xmlhttp.setRequestHeader('Content-type', 'application/x-www-form-urlencoded')
            xmlhttp.send(body)
        else
            xmlhttp.open('GET', url, async); xmlhttp.send()
        
        # If a callback method was passed in and the request is being handled 
        # synchronously pass `responseXML` or `responseText` to the callback method.
        callback.call(if type is 'xml' then xmlhttp.responseXML else xmlhttp.responseText) if callback and not async

    # GET
    # --------

    # getText
    # --------
    
    # Request text, a callback function can be passed in to be called once the 
    # request has been handled. The `responceText` will be passed to the callback.
    getText: (url, callback, async=true) -> request('text', url, callback, async)
    
    # getXML
    # --------   
    
    # Request XML, a callback function can be passed in to be called once the 
    # request has been handled. The `responceXML` will be passed to the callback. 
    getXML: (url, callback, async=true) -> request('xml', url, callback, async)
    
    # POST
    # --------

    # postText
    # --------
    
    # Post and request text, a callback function can be passed in to be called once the 
    # request has been handled. The `responceText` will be passed to the callback.
    postText: (url, data, callback, async=true) -> request('text', url, callback, async, data)
    
    # postXML
    # --------   
    
    # Post and request XML, a callback function can be passed in to be called once the 
    # request has been handled. The `responceXML` will be passed to the callback. 
    postXML: (url, data, callback, async=true) -> request('xml', url, callback, async, data)

# Exposing the API
# ========

# Register the wheel namespace if it hasn't been done yet.
@wh = {} if not @wh

# Add ajax to wheel.
@wh.ajax = new ajax()

#Add data2url to wheel.
@wh.data2url = data2url
