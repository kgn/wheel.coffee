# Some useful string functions ported from python.

# Regular expressions are only used when finding parts at the front of the string, based on this post about a
# [Faster JavaScript Trim](http://blog.stevenlevithan.com/archives/faster-trim-javascript).

# Helper functions, these are not exposed.
isArray = (a)-> Object::toString.apply(a) is '[object Array]'
makeArray = (a)-> return a if isArray(a); return [a]
isCaseable = (c)-> c.length and /[A-Za-z]/.test(c)
endswith = (s, c)->
    for i in [c.length...0]
        return false if c.charAt(c.length-i) isnt s.charAt(s.length-i)
    return true

# Return a copy of the string with all characters converted to lowercase, alias of `toLowerCase`.
String::lower = String::toLowerCase

# Return a copy of the string with all characters converted to uppercase, alias of `toUpperCase`.
String::upper = String::toUpperCase

# Test if the string is lower and there is at least one cased character.
String::islower = -> return true if "#{@}" is @lower() and isCaseable(@); return false

# Test if the string is upper and there is at least one cased character.
String::isupper = -> return true if "#{@}" is @upper() and isCaseable(@); return false

# Test if the string starts with a string.
# With optional start, test the string beginning at that position.
# With optional end, stop comparing the string at that position.
# Prefix can also be an array of strings to try.
String::startswith = (c, s, e)->
    t = @slice(s, e)
    for a in makeArray(c)
        return true if new RegExp("^#{a}").test(t)
    return false

# Test if the string ends with a string.
# With optional start, test the string beginning at that position.
# With optional end, stop comparing the string at that position.
# Suffix can also be an array of strings to try.
String::endswith = (c, s, e)->
    t = @slice(s, e)
    for a in makeArray(c)
        return true if endswith(t, a)
    return false

# Return a copy of the string with only its first character capitalized.
String::capitalize = -> l = @lower(); (l.charAt(0) or '').upper()+(l.charAt(c) for c in [1...l.length]).join('')

# Return a copy of the string with only the first character of every word capitalized.
String::title = -> (word.capitalize() for word in @split(' ')).join(' ')

# Test if the string is title and there is at least one cased character.
String::istitle = -> return true if "#{@}" is @title() and isCaseable(@); return false

# Return a copy of the string with leading whitespace removed,
# if characters are passed in thoes characters will be removed instead.
String::lstrip = (s)-> ss = '\\s\\s*'; ss = "(#{s})+" if s?; @replace(new RegExp("^#{ss}"), '')

# Return a copy of the string with trailing whitespace removed,
# if characters are passed in thoes characters will be removed instead.
String::rstrip = (s)-> ss = '\\s*\\s'; ss = "(#{s})+" if s?; @replace(new RegExp("#{ss}$"), '')
    #TODO: implement this without regex:
    #`re = new RegExp(ss); i = @length; continue while re.test(@charAt(--i)); @[0...i+1]`

# Return a copy of the string with leading and trailing whitespace removed,
# if characters are passed in thoes characters will be removed instead.
# Uses the native `trim` if it's available and only whitespace is being stripped.
String::strip = (s)-> return @trim() if not s and @trim; @lstrip(s).rstrip(s)

# Return the number of non-overlapping occurrences of a string in the string.
# Optional arguments start and end are interpreted as in slice notation.
String::count = (c, s, e)-> @slice(s, e).match(new RegExp(c, 'g'))?.length or 0

# Return the lowest index in the string where a string is found.
# Optional arguments start and end are interpreted as in slice notation.
# Return -1 if no match if found.
String::find = (c, s, e)-> i = @slice(s, e).indexOf(c); return -1 if i is -1; i+(s or 0)

# Test if all characters in the string are alphanumeric.
# Use `A-Za-z` instead of `A-z` becuase `A-z` matches `-` for some reason...
String::isalnum = -> @match(/[A-Za-z0-9]+/)?[0] is "#{@}"

# Test if all characters in the string are alphabetic.
String::isalpha = -> @match(/[A-Za-z]+/)?[0] is "#{@}"

# Test if all characters in the string are digits.
String::isdigit = -> @match(/\d+/)?[0] is "#{@}"

# Test if all characters in the string are whitespace.
String::isspace = -> @match(/\s+/)?[0] is "#{@}"

# Return a string which is the concatenation of the strings in an array.
# The separator between elements is the string.
String::join = (a)-> a.join(@)

# Return S left-justified in a string of length width. Padding is
# done using the specified fill character (default is a space).
String::ljust = (w, c=' ')-> [c,t]=["#{c}","#{@}"]; return t unless w and c; t="#{t}#{c}" while(t.length < w); t

# Return S right-justified in a string of length width. Padding is
# done using the specified fill character (default is a space)
String::rjust = (w, c=' ')-> [c,t]=["#{c}","#{@}"]; return t unless w and c; t="#{c}#{t}" while(t.length < w); t

# Pad a numeric string S with zeros on the left, to fill a field
# of the specified width.  The string S is never truncated.
String::zfill = (w)-> "#{@}".rjust(w, 0)

# Test if the string contains any of the passed in strings.
# Python strings do not have a 'contains' function, but javascript doesn't have a way of saying `'foo' in 'foobar'`.
# With this method the python `in` check would be written like this: `'foobar'.contains('foo')`
String::contains = (s...)-> (return true if @indexOf(i) isnt -1) for i in s; return false

# C style string formatting
# `'%d %s and %d %s'.cformat(2, 'cats', 6, 'dogs')` --> '2 cats and 6 dogs'
# `'%.2f liters'.cformat(2.2483545345)` --> '2.25 liters'
# `'%02d:%02d.%02d'.cformat(9, 36, 28)` --> 09:36.28
String::cformat = (args...)->
    return '' unless @
    pad = (v,l,c)-> "#{v}".zfill(l, c)
    @replace(/%(s|\.?[0-9]*f|0?[0-9]*d)/g, (match, type)->
        arg = args.shift()
        if fmatch = type.match(/(\.?)([0-9]*)f/)
            arg = parseFloat(arg)
            if fmatch[1] is '.' and fmatch[2]
                return "#{arg.toFixed(fmatch[2])}"
            else
                return "#{arg}"
        if imatch = type.match(/(0?)([0-9]*)d/)
            arg = parseInt(arg, 10)
            if imatch.length > 1 and imatch[2]
                return "#{arg}".rjust(imatch[2], imatch[1] or ' ')
            else
                return "#{arg}"
        return "#{arg}"
    )

# Return an integer hash of the string
String::hash = ()->
    hash = 0
    for i in [0...@length]
        hash= (hash<<5)-hash+@charCodeAt(i)
        hash= hash & hash # Convert to 32bit integer
    return hash

# TODO: implement these

# S.center(width[, fillchar])-> string
#
# Return S centered in a string of length width. Padding is
# done using the specified fill character (default is a space)
# String::center = ->

# S.decode([encoding[,errors]])-> object
#
# Decodes S using the codec registered for encoding. encoding defaults
# to the default encoding. errors may be given to set a different error
# handling scheme. Default is 'strict' meaning that encoding errors raise
# a UnicodeDecodeError. Other possible values are 'ignore' and 'replace'
# as well as any other name registered with codecs.register_error that is
# able to handle UnicodeDecodeErrors.
# String::decode = ->

# S.encode([encoding[,errors]])-> object
#
# Encodes S using the codec registered for encoding. encoding defaults
# to the default encoding. errors may be given to set a different error
# handling scheme. Default is 'strict' meaning that encoding errors raise
# a UnicodeEncodeError. Other possible values are 'ignore', 'replace' and
# 'xmlcharrefreplace' as well as any other name registered with
# codecs.register_error that is able to handle UnicodeEncodeErrors.
# String::encode = ->

# S.expandtabs([tabsize])-> string
#
# Return a copy of S where all tab characters are expanded using spaces.
# If tabsize is not given, a tab size of 8 characters is assumed.
# String::expandtabs = ->

# S.format(*args, **kwargs)-> unicode
# String::format = ->

# S.index(sub [,start [,end]])-> int
#
# Like S.find() but raise ValueError when the substring is not found.
# String::index = ->

# S.partition(sep)-> (head, sep, tail)
#
# Search for the separator sep in S, and return the part before it,
# the separator itself, and the part after it.  If the separator is not
# found, return S and two empty strings.
# String::partition = ->

# S.replace (old, new[, count])-> string
#
# Return a copy of string S with all occurrences of substring
# old replaced by new.  If the optional argument count is
# given, only the first count occurrences are replaced.
# String::replace = ->

# S.rfind(sub [,start [,end]])-> int
#
# Return the highest index in S where substring sub is found,
# such that sub is contained within s[start:end].  Optional
# arguments start and end are interpreted as in slice notation.
#
# Return -1 on failure.
# String::rfind = ->

# S.rindex(sub [,start [,end]])-> int
#
# Like S.rfind() but raise ValueError when the substring is not found.
# String::rindex = ->

# S.rpartition(sep)-> (tail, sep, head)
#
# Search for the separator sep in S, starting at the end of S, and return
# the part before it, the separator itself, and the part after it.  If the
# separator is not found, return two empty strings and S.
# String::rpartition = ->

# S.rsplit([sep [,maxsplit]])-> list of strings
#
# Return a list of the words in the string S, using sep as the
# delimiter string, starting at the end of the string and working
# to the front.  If maxsplit is given, at most maxsplit splits are
# done. If sep is not specified or is None, any whitespace string
# is a separator.
# String::rsplit = ->

# S.splitlines([keepends])-> list of strings
#
# Return a list of the lines in S, breaking at line boundaries.
# Line breaks are not included in the resulting list unless keepends
# is given and true.
# String::splitlines = ->

# S.swapcase()-> string
#
# Return a copy of the string S with uppercase characters
# converted to lowercase and vice versa.
# String::swapcase = ->

# S.translate(table [,deletechars])-> string
#
# Return a copy of the string S, where all characters occurring
# in the optional argument deletechars are removed, and the
# remaining characters have been mapped through the given
# translation table, which must be a string of length 256.
# String::translate = ->
