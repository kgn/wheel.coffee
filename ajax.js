(function() {
  var _ajax;
  _ajax = (function() {
    var get;
    function _ajax() {}
    get = function(type, url, callback, async) {
      var xmlhttp;
      xmlhttp = window.ActiveXObject ? new window.ActiveXObject('Microsoft.XMLHTTP') : new window.XMLHttpRequest();
      if (xmlhttp.overrideMimeType) {
        xmlhttp.overrideMimeType = 'application/json';
      }
      if (callback && async) {
        xmlhttp.onreadystatechange = function() {
          if (xmlhttp.readyState === 4) {
            return callback(type === 'xml' ? xmlhttp.responseXML : xmlhttp.responseText);
          }
        };
      }
      xmlhttp.open('GET', url, async);
      xmlhttp.send();
      if (callback && !async) {
        return callback.call(type === 'xml' ? xmlhttp.responseXML : xmlhttp.responseText);
      }
    };
    _ajax.prototype.getText = function(url, callback, async) {
      if (callback == null) {
        callback = null;
      }
      if (async == null) {
        async = true;
      }
      return get('text', url, callback, async);
    };
    _ajax.prototype.getXML = function(url, callback, async) {
      if (callback == null) {
        callback = null;
      }
      if (async == null) {
        async = true;
      }
      return get('xml', url, callback, async);
    };
    return _ajax;
  })();
  if (!this.wh) {
    this.wh = {};
  }
  this.wh.ajax = new _ajax();
}).call(this);
