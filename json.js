(function() {
  var _JSON, _f;

  _f = function(n) {
    if (n < 10) {
      return "0" + n;
    } else {
      return n;
    }
  };

  Date.prototype._toJSON = function(key) {
    if (isFinite(this.valueOf())) {
      return this.getUTCFullYear() + '-' + _f(this.getUTCMonth() + 1) + '-' + _f(this.getUTCDate()) + 'T' + _f(this.getUTCHours()) + ':' + _f(this.getUTCMinutes()) + ':' + _f(this.getUTCSeconds()) + '.' + _f(this.getUTCMilliseconds()) + 'Z';
    } else {
      return null;
    }
  };

  if (!Date.prototype.toJSON) Date.prototype.toJSON = Date.prototype._toJSON;

  String.prototype._toJSON = Number.prototype._toJSON = Boolean.prototype._toJSON = function(key) {
    return this.valueOf();
  };

  if (!String.prototype.toJSON) String.prototype.toJSON = String.prototype._toJSON;

  if (!Number.prototype.toJSON) Number.prototype.toJSON = Number.prototype._toJSON;

  if (!Boolean.prototype.toJSON) {
    Boolean.prototype.toJSON = Boolean.prototype._toJSON;
  }

  _JSON = (function() {

    function _JSON() {}

    _JSON.prototype.parse = function(text) {
      var array, at, ch, error, escapee, next, number, object, result, string, value, white, word;
      if (!text) return;
      at = null;
      ch = ' ';
      escapee = {
        '"': '"',
        '\\': '\\',
        '/': '/',
        b: '\b',
        f: '\f',
        n: '\n',
        r: '\r',
        t: '\t'
      };
      error = function(message) {
        throw new SyntaxError("" + message + " at character #" + at + "(" + ch + "); for text: " + text);
      };
      next = function(c) {
        if (c && c !== ch) error("Expected '" + c + "' instead of '" + ch);
        return ch = text.charAt(at++);
      };
      number = function() {
        var string, _number;
        string = '';
        if (ch === '-') {
          string = '-';
          next('-');
        }
        while (ch >= '0' && ch <= '9') {
          string += ch;
          next();
        }
        if (ch === '.') {
          string += '.';
          while (next() && ch >= '0' && ch <= '9') {
            string += ch;
          }
        }
        if (ch === 'e' || ch === 'E') {
          string += ch;
          next();
          if (ch === '-' || ch === '+') {
            string += ch;
            next();
          }
          while (ch >= '0' && ch <= '9') {
            string += ch;
            next();
          }
        }
        _number = +string;
        if (!isFinite(_number)) {
          error('Bad number');
        } else {
          return _number;
        }
      };
      string = function() {
        var hex, i, uffff, _string;
        _string = '';
        if (ch === '"') {
          while (next()) {
            if (ch === '"') {
              next();
              return _string;
            } else if (ch === '\\') {
              next();
              if (ch === 'u') {
                uffff = 0;
                for (i = 0; i < 4; i++) {
                  hex = parseInt(next(), 16);
                  if (!isFinite(hex)) break;
                  uffff *= 16 + hex;
                }
                _string += String.fromCharCode(uffff);
              } else if (typeof escapee[ch] === 'string') {
                _string += escapee[ch];
              } else {
                break;
              }
            } else {
              _string += ch;
            }
          }
        }
        error('Bad string');
      };
      white = function() {
        while (ch && ch <= ' ') {
          next();
        }
      };
      word = function() {
        switch (ch) {
          case 't':
            next('t');
            next('r');
            next('u');
            next('e');
            true;
            break;
          case 'f':
            next('f');
            next('a');
            next('l');
            next('s');
            next('e');
            false;
            break;
          case 'n':
            next('n');
            next('u');
            next('l');
            next('l');
            null;
        }
        error('Unexpected #{ch}');
      };
      array = function() {
        var _array;
        _array = [];
        if (ch === '[') {
          next('[');
          white();
          if (ch === ']') {
            next(']');
            return _array;
          }
          while (ch) {
            _array.push(value());
            white();
            if (ch === ']') {
              next(']');
              return _array;
            }
            next(',');
            white();
          }
        }
        error('Bad array');
      };
      object = function() {
        var key, _object;
        _object = {};
        if (ch === '{') {
          next('{');
          white();
          if (ch === '}') {
            next('}');
            return _object;
          }
          while (ch) {
            key = string();
            white();
            next(':');
            if (Object.hasOwnProperty.call(_object, key)) {
              error("Duplicate key '" + key);
            }
            _object[key] = value();
            white();
            if (ch === '}') {
              next('}');
              return _object;
            }
            next(',');
            white();
          }
        }
        error('Bad object');
      };
      value = function() {
        white();
        switch (ch) {
          case '{':
            return object();
          case '[':
            return array();
          case '"':
            return string();
          case '-':
            return number;
          default:
            if (ch >= '0' && ch <= '9') {
              return number();
            } else {
              return word();
            }
        }
      };
      result = value();
      white();
      if (ch) error('Syntax error');
      return result;
    };

    _JSON.prototype.stringify = function(value, replacer, space) {
      var escapable, gap, i, indent, max, meta, min, quote, s, str, _ref, _ref2;
      if (replacer == null) replacer = null;
      if (space == null) space = 0;
      gap = '';
      indent = '';
      escapable = /[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g;
      meta = {
        '\b': '\\b',
        '\t': '\\t',
        '\n': '\\n',
        '\f': '\\f',
        '\r': '\\r',
        '"': '\\"',
        '\\': '\\\\'
      };
      max = function(a, b) {
        if (a > b) {
          return a;
        } else {
          return b;
        }
      };
      min = function(a, b) {
        if (a < b) {
          return a;
        } else {
          return b;
        }
      };
      if (typeof space === 'number') {
        for (i = 0, _ref = min(max(space, 0), 10); 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
          indent += ' ';
        }
      } else if (typeof space === 'string') {
        for (s = 0, _ref2 = min(space.length, 10); 0 <= _ref2 ? s < _ref2 : s > _ref2; 0 <= _ref2 ? s++ : s--) {
          indent += space[s];
        }
      }
      if (replacer && typeof replacer !== 'function' && (typeof replacer !== 'object' || typeof replacer.length !== 'number')) {
        throw new Error('JSON.stringify');
      }
      quote = function(string) {
        escapable.lastIndex = 0;
        if (escapable.test(string)) {
          return '"' + string.replace(escapable, function(a) {
            var c;
            c = meta[a];
            if (typeof c === 'string') {
              return c;
            } else {
              return '\\u' + ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
            }
          });
        } else {
          return "\"" + string + "\"";
        }
      };
      str = function(key, holder) {
        var i, k, mind, partial, v, _value;
        mind = gap;
        _value = holder[key];
        if (_value && typeof _value === 'object' && typeof _value._toJSON === 'function') {
          _value = _value._toJSON(key);
        }
        if (typeof replacer === 'function') {
          _value = replacer.call(holder, key, _value);
        }
        switch (typeof _value) {
          case 'string':
            return quote(_value);
          case 'number':
            if (isFinite(_value)) {
              return String(_value);
            } else {
              return 'null';
            }
            break;
          case 'boolean':
          case 'null':
            return String(_value);
          case 'object':
            if (!_value) return 'null';
            gap += indent;
            partial = [];
            if (Object.prototype.toString.apply(_value) === '[object Array]') {
              for (i in _value) {
                partial.push(str(+i, _value) || 'null');
              }
              v = partial.length === 0 ? '[]' : gap ? '[\n' + gap + partial.join(',\n' + gap) + '\n' + mind + ']' : '[' + partial.join(',') + ']';
              gap = mind;
              return v;
            } else {
              if (replacer && typeof replacer === 'object') {
                for (k in replacer) {
                  if (typeof replacer[k] === 'string') {
                    v = str(k, _value);
                    if (v) partial.push(quote(k) + (gap ? ': ' : ':') + v);
                  }
                }
              } else {
                for (k in _value) {
                  if (Object.prototype.hasOwnProperty.call(_value, k)) {
                    v = str(k, _value);
                    if (v) partial.push(quote(k) + (gap ? ': ' : ':') + v);
                  }
                }
              }
              v = partial.length === 0 ? '{}' : gap ? '{\n' + gap + partial.join(',\n' + gap) + '\n' + mind + '}' : '{' + partial.join(',') + '}';
              gap = mind;
              return v;
            }
        }
      };
      return str('', {
        '': value
      });
    };

    return _JSON;

  })();

  this._JSON = new _JSON();

  if (!this.JSON) this.JSON = this._JSON;

}).call(this);
