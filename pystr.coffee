# Some useful string functions ported from python.

# Regular expressions are only used when finding parts at the front of the string, based on this post about a 
# [Faster JavaScript Trim](http://blog.stevenlevithan.com/archives/faster-trim-javascript).

# Return a copy of the string with all characters lower cased, alias of `toLowerCase`.
String::lower = String::toLowerCase

# Return a copy of the string with all characters upper cased, alias of `toUpperCase`.
String::upper = String::toUpperCase

# Test if the string is lower.
String::islower = -> @ is @lower()

# Test if the string is upper.
String::isupper = -> @ is @upper()

# Test if the string starts with a string.
String::startswith = (s) -> new RegExp("^#{s}").test(@)

# Test if the string ends with a string.
String::endswith = (s) -> return false if s.charAt(s.length-i) isnt @charAt(@length-i) for i in [s.length...0]; return true

# Return a copy of the string with only its first character capitalized.
String::capitalize = -> l = @lower(); (l.charAt(0) or '').upper()+(l.charAt(c) for c in [1...l.length]).join('')

# Return a copy of the string with only the first character of every word capitalized.
String::title = -> (word.capitalize() for word in @split(' ')).join(' ')

# Test if the string is title.
String::istitle = -> @ is @title()

# Return a copy of the string with leading whitespace removed, 
# if characters are passed in thoes characters will be removed instead.
String::lstrip = (s='\\s\\s*') -> @.replace(new RegExp("^#{s}"), '')

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
String::isalnum = -> @match(/[A-z0-9]+/)?[0] is @toString()

# Test if all characters in the string are alphabetic.
String::isalpha = -> @match(/[A-z]+/)?[0] is @toString()

# Test if all characters in the string are digits.
String::isdigit = -> @match(/\d+/)?[0] is @toString()

# Test if all characters in the string are whitespace.
String::isspace = -> @match(/\s+/)?[0] is @toString()

# Return a string which is the concatenation of the strings in an array. 
# The separator between elements is the string.
String::join = (a) -> a.join(@)
