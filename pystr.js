(function() {
  var endswith, isArray, isCaseable, makeArray,
    __slice = Array.prototype.slice;

  isArray = function(a) {
    return Object.prototype.toString.apply(a) === '[object Array]';
  };

  makeArray = function(a) {
    if (isArray(a)) return a;
    return [a];
  };

  isCaseable = function(c) {
    return c.length && /[A-Za-z]/.test(c);
  };

  endswith = function(s, c) {
    var i, _ref;
    for (i = _ref = c.length; _ref <= 0 ? i < 0 : i > 0; _ref <= 0 ? i++ : i--) {
      if (c.charAt(c.length - i) !== s.charAt(s.length - i)) return false;
    }
    return true;
  };

  String.prototype.lower = String.prototype.toLowerCase;

  String.prototype.upper = String.prototype.toUpperCase;

  String.prototype.islower = function() {
    if (("" + this) === this.lower() && isCaseable(this)) return true;
    return false;
  };

  String.prototype.isupper = function() {
    if (("" + this) === this.upper() && isCaseable(this)) return true;
    return false;
  };

  String.prototype.startswith = function(c, s, e) {
    var a, t, _i, _len, _ref;
    t = this.slice(s, e);
    _ref = makeArray(c);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      a = _ref[_i];
      if (new RegExp("^" + a).test(t)) return true;
    }
    return false;
  };

  String.prototype.endswith = function(c, s, e) {
    var a, t, _i, _len, _ref;
    t = this.slice(s, e);
    _ref = makeArray(c);
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      a = _ref[_i];
      if (endswith(t, a)) return true;
    }
    return false;
  };

  String.prototype.capitalize = function() {
    var c, l;
    l = this.lower();
    return (l.charAt(0) || '').upper() + ((function() {
      var _ref, _results;
      _results = [];
      for (c = 1, _ref = l.length; 1 <= _ref ? c < _ref : c > _ref; 1 <= _ref ? c++ : c--) {
        _results.push(l.charAt(c));
      }
      return _results;
    })()).join('');
  };

  String.prototype.title = function() {
    var word;
    return ((function() {
      var _i, _len, _ref, _results;
      _ref = this.split(' ');
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        word = _ref[_i];
        _results.push(word.capitalize());
      }
      return _results;
    }).call(this)).join(' ');
  };

  String.prototype.istitle = function() {
    if (("" + this) === this.title() && isCaseable(this)) return true;
    return false;
  };

  String.prototype.lstrip = function(s) {
    var ss;
    ss = '\\s\\s*';
    if (s != null) ss = "(" + s + ")+";
    return this.replace(new RegExp("^" + ss), '');
  };

  String.prototype.rstrip = function(s) {
    var ss;
    ss = '\\s*\\s';
    if (s != null) ss = "(" + s + ")+";
    return this.replace(new RegExp("" + ss + "$"), '');
  };

  String.prototype.strip = function(s) {
    if (!s && this.trim) return this.trim();
    return this.lstrip(s).rstrip(s);
  };

  String.prototype.count = function(c, s, e) {
    var _ref;
    return ((_ref = this.slice(s, e).match(new RegExp(c, 'g'))) != null ? _ref.length : void 0) || 0;
  };

  String.prototype.find = function(c, s, e) {
    var i;
    i = this.slice(s, e).indexOf(c);
    if (i === -1) return -1;
    return i + (s || 0);
  };

  String.prototype.isalnum = function() {
    var _ref;
    return ((_ref = this.match(/[A-Za-z0-9]+/)) != null ? _ref[0] : void 0) === ("" + this);
  };

  String.prototype.isalpha = function() {
    var _ref;
    return ((_ref = this.match(/[A-Za-z]+/)) != null ? _ref[0] : void 0) === ("" + this);
  };

  String.prototype.isdigit = function() {
    var _ref;
    return ((_ref = this.match(/\d+/)) != null ? _ref[0] : void 0) === ("" + this);
  };

  String.prototype.isspace = function() {
    var _ref;
    return ((_ref = this.match(/\s+/)) != null ? _ref[0] : void 0) === ("" + this);
  };

  String.prototype.join = function(a) {
    return a.join(this);
  };

  String.prototype.ljust = function(w, c) {
    var t, _ref;
    if (c == null) c = ' ';
    _ref = ["" + c, "" + this], c = _ref[0], t = _ref[1];
    if (!(w && c)) return t;
    while (t.length < w) {
      t = "" + t + c;
    }
    return t;
  };

  String.prototype.rjust = function(w, c) {
    var t, _ref;
    if (c == null) c = ' ';
    _ref = ["" + c, "" + this], c = _ref[0], t = _ref[1];
    if (!(w && c)) return t;
    while (t.length < w) {
      t = "" + c + t;
    }
    return t;
  };

  String.prototype.zfill = function(w) {
    return ("" + this).rjust(w, 0);
  };

  String.prototype.contains = function() {
    var i, s, _i, _len;
    s = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    for (_i = 0, _len = s.length; _i < _len; _i++) {
      i = s[_i];
      if (this.indexOf(i) !== -1) return true;
    }
    return false;
  };

  String.prototype.cformat = function() {
    var args, pad;
    args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    if (!this) return '';
    pad = function(v, l, c) {
      return ("" + v).zfill(l, c);
    };
    return this.replace(/%(s|\.?[0-9]*f|0?[0-9]*d)/g, function(match, type) {
      var arg, fmatch, imatch;
      arg = args.shift();
      if (fmatch = type.match(/(\.?)([0-9]*)f/)) {
        arg = parseFloat(arg);
        if (fmatch[1] === '.' && fmatch[2]) {
          return "" + (arg.toFixed(fmatch[2]));
        } else {
          return "" + arg;
        }
      }
      if (imatch = type.match(/(0?)([0-9]*)d/)) {
        arg = parseInt(arg, 10);
        if (imatch.length > 1 && imatch[2]) {
          return ("" + arg).rjust(imatch[2], imatch[1] || ' ');
        } else {
          return "" + arg;
        }
      }
      return "" + arg;
    });
  };

  String.prototype.hash = function() {
    var hash, i, _ref;
    hash = 0;
    for (i = 0, _ref = this.length; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
      hash = (hash << 5) - hash + this.charCodeAt(i);
      hash = hash & hash;
    }
    return hash;
  };

}).call(this);
