# Some useful string functions ported from python.

# Regular expressions are only used when finding parts at the front of the string, based on this post about a [Faster JavaScript Trim](http://blog.stevenlevithan.com/archives/faster-trim-javascript).

# Lower case all characters in the string, alias of `toLowerCase`.
String::lower = String::toLowerCase

# Upper case all characters in the string, alias of `toUpperCase`.
String::upper = String::toUpperCase

# Test if the string is lower.
String::islower = -> @ is @lower()

# Test if the string is upper.
String::isupper = -> @ is @upper()

# Test if the string starts with a string.
String::startswith = (s) -> new RegExp("^#{s}").test(@)

# Test if the string ends with a string.
String::endswith = (s) -> return false if s.charAt(s.length-i) isnt @charAt(@length-i) for i in [s.length...0]; return true

# Capitalize the first character in the string.
String::capitalize = -> l = @lower(); (l.charAt(0) or '').upper()+(l.charAt(c) for c in [1...l.length]).join('')

# Capitalize every word in the string.
String::title = -> (word.capitalize() for word in @split(' ')).join(' ')

# Test if the string is title.
String::istitle = -> @ is @title()

# Strip characters from the front of the string, if no characters are passed in white space will be stripped.
String::lstrip = (c) -> c = c or '\\s\\s*'; @.replace(new RegExp("^#{c}"), '')

# Strip characters from the end of the string, if no characters are passed in white space will be stripped.
String::rstrip = (c) -> c = c or '\\s'; re = new RegExp(c); i = @length; continue while re.test(@charAt(--i)); @[0...i+1]

# Strip characters from the front and end of the string, if no characters are passed in white space will be stripped.
# Use the native `trim` if it's available and only whitespace is being stripped.
String::strip = (c) -> return @trim() if not c and @trim; c = c or '\\s'; @lstrip(c).rstrip(c)
    