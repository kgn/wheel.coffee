(function() {
  String.prototype.lower = String.prototype.toLowerCase;
  String.prototype.upper = String.prototype.toUpperCase;
  String.prototype.islower = function() {
    return this === this.lower();
  };
  String.prototype.isupper = function() {
    return this === this.upper();
  };
  String.prototype.startswith = function(s) {
    return new RegExp("^" + s).test(this);
  };
  String.prototype.endswith = function(s) {
    var i;
    if ((function() {
      var _ref, _results;
      _results = [];
      for (i = _ref = s.length; _ref <= 0 ? i < 0 : i > 0; _ref <= 0 ? i++ : i--) {
        _results.push(s.charAt(s.length - i) !== this.charAt(this.length - i));
      }
      return _results;
    }).call(this)) {
      return false;
    }
    return true;
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
    return this === this.title();
  };
  String.prototype.lstrip = function(s) {
    if (s == null) {
      s = '\\s\\s*';
    }
    return this.replace(new RegExp("^" + s), '');
  };
  String.prototype.rstrip = function(s) {
    var i, re;
    if (s == null) {
      s = '\\s';
    }
    re = new RegExp(s);
    i = this.length;
    while (re.test(this.charAt(--i))) {
      continue;
    }
    return this.slice(0, i + 1);
  };
  String.prototype.strip = function(s) {
    if (!s && this.trim) {
      return this.trim();
    }
    return this.lstrip(s).rstrip(s);
  };
  String.prototype.count = function(s) {
    var t, _ref;
    return t = ((_ref = this.match(new RegExp(s, 'g'))) != null ? _ref.length : void 0) || 0;
  };
  String.prototype.find = String.prototype.indexOf;
  String.prototype.isalnum = function() {
    var _ref;
    return ((_ref = this.match(/[A-z0-9]+/)) != null ? _ref[0] : void 0) === this.toString();
  };
  String.prototype.isalpha = function() {
    var _ref;
    return ((_ref = this.match(/[A-z]+/)) != null ? _ref[0] : void 0) === this.toString();
  };
  String.prototype.isdigit = function() {
    var _ref;
    return ((_ref = this.match(/\d+/)) != null ? _ref[0] : void 0) === this.toString();
  };
  String.prototype.isspace = function() {
    var _ref;
    return ((_ref = this.match(/\s+/)) != null ? _ref[0] : void 0) === this.toString();
  };
  String.prototype.join = function(a) {
    return a.join(this);
  };
}).call(this);
