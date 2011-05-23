# Adds **JSON** to browsers that don't support it natively.
# `_JSON` and `_toJSON` are also added so this library can be explicitly used.
# More information about JSON can be found at [Using JSON in Firefox](https://developer.mozilla.org/En/Using_JSON_in_Firefox).

# Based on Douglas Crockford's
# [json_parse.js](https://github.com/douglascrockford/JSON-js/blob/master/json_parse.js) and 
# [json2.js](https://github.com/douglascrockford/JSON-js/blob/master/json2.js).

# A helper function to format integers to have at least two digits.
_f = (n) -> if n < 10 then "0#{n}" else n

# toJSON methods
# ========

# Add `_toJSON` methods to standard types, and alias `toJSON` if native functions don't exist.

#Add `_toJSON` to date objects.
Date::_toJSON = (key) ->
    if isFinite(@valueOf()) then (
        @getUTCFullYear()         + '-' +
        _f(@getUTCMonth() + 1)    + '-' +
        _f(@getUTCDate())         + 'T' +
        _f(@getUTCHours())        + ':' +
        _f(@getUTCMinutes())      + ':' +
        _f(@getUTCSeconds())      + '.' +
        _f(@getUTCMilliseconds()) + 'Z'
    ) else null
if not Date::toJSON
    Date::toJSON = Date::_toJSON

#Add `_toJSON` to strings, numbers and booleans.
String::_toJSON = Number::_toJSON = Boolean::_toJSON = (key) -> @valueOf()
String::toJSON = String::_toJSON if not String::toJSON
Number::toJSON = Number::_toJSON if not Number::toJSON
Boolean::toJSON = Boolean::_toJSON if not Boolean::toJSON

# The JSON class
# ========

class _JSON
    # JSON.parse
    # --------
    
    # To convert a JSON string into a JavaScript object, you simply pass the JSON into the `JSON.parse()` method, like this:
    
    # `var jsObject = JSON.parse(jsonString);`
    parse: (text) ->
        return if not text
        at = null; ch = ' '
        escapee = '"': '"', '\\': '\\', '/': '/', b: '\b', f: '\f', n: '\n', r: '\r', t: '\t'
        error = (message) -> throw new SyntaxError("#{message} at character ##{at}(#{ch}); for text: #{text}")
        next = (c) ->
            error("Expected '#{c}' instead of '#{ch}") if c and c isnt ch
            ch = text.charAt(at++)#null is converted to 0, then we start iterating from there
            
        # Parse a number.
        number = ->
            string = ''
            if ch is '-'
                string = '-'; next('-')
            while ch >= '0' and ch <= '9'
                string += ch; next()
            if ch is '.'
                string += '.'
                string += ch while next() and ch >= '0' and ch <= '9'
            if ch is 'e' or ch is 'E'
                string += ch; next()
                if ch is '-' or ch is '+'
                    string += ch; next()
                while ch >= '0' and ch <= '9'
                    string += ch; next()
            _number = +string
            if not isFinite(_number)
                error('Bad number')
            else
                return _number
            return
            
        # Parse a string.
        string = ->
            _string = ''
            if ch is '"'
                while next()
                    if ch is '"'
                        next(); return _string
                    else if ch is '\\'
                        next()
                        if ch is 'u'
                            uffff = 0
                            for i in [0...4]
                                hex = parseInt(next(), 16)
                                break if not isFinite(hex)
                                uffff *= 16 + hex
                            _string += String.fromCharCode(uffff)
                        else if typeof escapee[ch] is 'string'
                            _string += escapee[ch]
                        else  
                            break
                    else
                        _string += ch
            error('Bad string'); return
            
        # Skip whitespace.
        white = -> next() while ch and ch <= ' '; return
        
        # Parse true, false, or null.
        word = ->
            switch ch
                when 't'
                    next('t'); next('r'); next('u'); next('e'); true
                when 'f'
                    next('f'); next('a'); next('l'); next('s'); next('e'); false
                when 'n'
                    next('n'); next('u'); next('l'); next('l'); null
            error('Unexpected #{ch}'); return
            
        # Parse an array.
        array = ->
            _array = []
            if ch is '['
                next('['); white()
                if ch is ']'
                    next(']'); return _array
                while ch
                    _array.push(value()); white()
                    if ch is ']'
                        next(']'); return _array
                    next(','); white()
            error('Bad array'); return
            
        # Parse an object.
        object = ->
            _object = {}
            if ch is '{'
                next('{'); white()
                if ch is '}'
                    next('}'); return _object
                while ch
                    key = string(); white(); next(':')
                    if Object.hasOwnProperty.call(_object, key)
                        error("Duplicate key '#{key}")
                    _object[key] = value(); white()
                    if ch is '}'
                        next('}'); return _object
                    next(','); white()
            error('Bad object'); return
            
        # Parse a JSON value. It could be an object, an array, a string, a number, or a word.
        value = ->
            white()
            switch ch
                when '{'
                    return object()
                when '['
                    return array()
                when '"'
                    return string()
                when '-'
                    return number
                else        
                    return if ch >= '0' && ch <= '9' then number() else word()
        
        # Kick off the parser and return the results.
        result = value(); white()
        error('Syntax error') if ch
        result
    
    # JSON.stringify
    # --------
    
    # To convert a JavaScript object into a JSON string, pass the object into the `JSON.stringify()` method:
    
    # `var jsonString = JSON.stringify({'user': 'John Doe', 'time': new Date(), 'hobies': ['fishing', 'skiing', 'sailing']});`
    
    # `JSON.stringify()` offers additional customization capabilities through the use of optional parameters. The syntax is:
    
    # * **value**: The JavaScript object to convert into a JSON string.
    # * **replacer**: A function that alters the behavior of the stringification process, or an array of String and Number objects that serve as a whitelist for selecting the properties of the value object to be included in the JSON string. If this value is null or not provided, all properties of the object are included in the resulting JSON string.
    # * **space**: A String or Number object that's used to insert white space into the output JSON string for readability purposes. If this is a Number, it indicates the number of space characters to use as white space; this number is capped at 10 if it's larger than that. Values less than 1 indicate that no space should be used. If this is a String, the string (or the first 10 characters of the string, if it's longer than that) is used as white space. If this parameter is not provided (or is null), no white space is used.
    stringify: (value, replacer=null, space=0) ->
        gap = ''; indent = ''
        escapable = /[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g
        meta = '\b': '\\b', '\t': '\\t', '\n': '\\n', '\f': '\\f', '\r': '\\r', '"' : '\\"', '\\': '\\\\'
        max = (a, b) -> if a > b then a else b
        min = (a, b) -> if a < b then a else b
        if typeof space is 'number'
            indent += ' ' for i in [0...min(max(space, 0), 10)]
        else if typeof space is 'string'
            indent += space[s] for s in [0...min(space.length, 10)]
        throw new Error('JSON.stringify') if replacer and typeof replacer isnt 'function' and (typeof replacer isnt 'object' or typeof replacer.length isnt 'number')
        
        quote = (string) ->
            escapable.lastIndex = 0
            return if escapable.test(string) then '"' + string.replace(escapable, (a) ->
                c = meta[a]; if typeof c is 'string' then c else '\\u' + ('0000' + a.charCodeAt(0).toString(16)).slice(-4)
            ) else "\"#{string}\""
            
        str = (key, holder) ->
            mind = gap
            _value = holder[key]
            # Use `_toJSON` so we fully use this library.
            _value = _value._toJSON(key) if _value and typeof _value is 'object' and typeof _value._toJSON is 'function'
            # If a replacer function was passed in run the key and value through it.
            _value = replacer.call(holder, key, _value) if typeof replacer is 'function'
            
            switch typeof _value
                when 'string'
                    quote(_value)
                when 'number'
                    if isFinite(_value) then String(_value) else 'null'
                when 'boolean', 'null'
                    String(_value)
                when 'object'
                    return 'null' if not _value
                    gap += indent; partial = []
                    if Object::toString.apply(_value) is '[object Array]'
                        for i of _value
                            partial.push(str(+i, _value) or 'null')
                        v = if partial.length is 0 then '[]' else
                            if gap then '[\n' + gap + partial.join(',\n' + gap) + '\n' + mind + ']' 
                            else '[' + partial.join(',') + ']'                
                        gap = mind; v
                    else
                        if replacer and typeof replacer is 'object'
                            for k of replacer
                                if typeof replacer[k] is 'string'
                                    v = str(k, _value)
                                    partial.push(quote(k) + (if gap then ': ' else ':') + v) if v
                        else
                            for k of _value
                                if Object.prototype.hasOwnProperty.call(_value, k)
                                    v = str(k, _value)
                                    partial.push(quote(k) + (if gap then ': ' else ':') + v) if v
                        v = if partial.length is 0 then '{}' else 
                            if gap then '{\n' + gap + partial.join(',\n' + gap) + '\n' + mind + '}'
                            else '{' + partial.join(',') + '}'
                        gap = mind; v
        # Kick off the stringification and return the result.
        str('', {'': value})

# Exposing the class
# ========

# Make `_JSON` avalible incase we want to use this object instead of the native one.
@_JSON = new _JSON()

# Alias `JSON` if it's not nativly supported.
@JSON = @_JSON if not @JSON
