# Some useful string functions ported from python.

# Regular expressions are only used when finding parts at the front of the string, based on this post about a 
# [Faster JavaScript Trim](http://blog.stevenlevithan.com/archives/faster-trim-javascript).

# Helper functions, these are not exposed.
isArray = (a) -> Object::toString.apply(a) is '[object Array]'
makeArray = (a) -> return a if isArray(a); return [a]
isCaseable = (c) -> c.length and /[A-Za-z]/.test(c)
endswith = (s, c) ->
    for i in [c.length...0]
        return false if c.charAt(c.length-i) isnt s.charAt(s.length-i)
    return true

# Return a copy of the string with all characters converted to lowercase, alias of `toLowerCase`.
String::lower = String::toLowerCase

# Return a copy of the string with all characters converted to uppercase, alias of `toUpperCase`.
String::upper = String::toUpperCase

# Test if the string is lower and there is at least one cased character.
String::islower = -> return true if @toString() is @lower() and isCaseable(@); return false

# Test if the string is upper and there is at least one cased character.
String::isupper = -> return true if @toString() is @upper() and isCaseable(@); return false

# Test if the string starts with a string.
# With optional start, test the string beginning at that position.
# With optional end, stop comparing the string at that position.
# Prefix can also be an array of strings to try.
String::startswith = (c, s, e) ->
    t = @slice(s, e)
    for a in makeArray(c)
        return true if new RegExp("^#{a}").test(t)
    return false

# Test if the string ends with a string.
# With optional start, test the string beginning at that position.
# With optional end, stop comparing the string at that position.
# Suffix can also be an array of strings to try.
String::endswith = (c, s, e) -> 
    t = @slice(s, e)
    for a in makeArray(c)
        return true if endswith(t, a)
    return false

# Return a copy of the string with only its first character capitalized.
String::capitalize = -> l = @lower(); (l.charAt(0) or '').upper()+(l.charAt(c) for c in [1...l.length]).join('')

# Return a copy of the string with only the first character of every word capitalized.
String::title = -> (word.capitalize() for word in @split(' ')).join(' ')

# Test if the string is title and there is at least one cased character.
String::istitle = -> return true if @toString() is @title() and isCaseable(@); return false

# Return a copy of the string with leading whitespace removed, 
# if characters are passed in thoes characters will be removed instead.
String::lstrip = (s) -> ss = '\\s\\s*'; ss = "(#{s})+" if s?; @.replace(new RegExp("^#{ss}"), '')

# Return a copy of the string with trailing whitespace removed, 
# if characters are passed in thoes characters will be removed instead.
String::rstrip = (s='\\s') -> re = new RegExp(s); i = @length; continue while re.test(@charAt(--i)); @[0...i+1]

# Return a copy of the string with leading and trailing whitespace removed, 
# if characters are passed in thoes characters will be removed instead.
# Uses the native `trim` if it's available and only whitespace is being stripped.
String::strip = (s) -> return @trim() if not s and @trim; @lstrip(s).rstrip(s)

# Return the number of non-overlapping occurrences of a string in the string.
String::count = (s) -> t = @match(new RegExp(s, 'g'))?.length or 0

# Return the lowest index in the string where a string is found.
# Return -1 if no match if found, alias of `indexOf`.
String::find = String::indexOf

# Test if all characters in the string are alphanumeric.
# Use `A-Za-z` instead of `A-z` becuase `A-z` matches `-` for some reason...
String::isalnum = -> @match(/[A-Za-z0-9]+/)?[0] is @toString()

# Test if all characters in the string are alphabetic.
String::isalpha = -> @match(/[A-Za-z]+/)?[0] is @toString()

# Test if all characters in the string are digits.
String::isdigit = -> @match(/\d+/)?[0] is @toString()

# Test if all characters in the string are whitespace.
String::isspace = -> @match(/\s+/)?[0] is @toString()

# Return a string which is the concatenation of the strings in an array. 
# The separator between elements is the string.
String::join = (a) -> a.join(@)
