(function() {
  var ajax, data2url, root;
  root = this;
  data2url = function(data) {
    var k, v;
    return ((function() {
      var _results;
      _results = [];
      for (k in data) {
        v = data[k];
        _results.push("" + (encodeURIComponent(k)) + "=" + (encodeURIComponent(v)));
      }
      return _results;
    })()).join('&');
  };
  ajax = (function() {
    var request;
    function ajax() {}
    request = function(type, url, callback, async, data) {
      var body, xmlhttp;
      xmlhttp = root.ActiveXObject ? new root.ActiveXObject('Microsoft.XMLHTTP') : new root.XMLHttpRequest();
      if (callback && async) {
        xmlhttp.onreadystatechange = function() {
          if (xmlhttp.readyState === 4) {
            return callback(type === 'xml' ? xmlhttp.responseXML : xmlhttp.responseText);
          }
        };
      }
      if (data != null) {
        if (typeof data === 'object') {
          body = data2url(data);
        } else if (typeof data === 'string') {
          body = data;
        }
        if (body == null) {
          throw new Error('Input data was not an object or a string');
        }
        xmlhttp.open('POST', url, async);
        xmlhttp.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
        xmlhttp.send(body);
      } else {
        xmlhttp.open('GET', url, async);
        xmlhttp.send();
      }
      if (callback && !async) {
        return callback.call(type === 'xml' ? xmlhttp.responseXML : xmlhttp.responseText);
      }
    };
    ajax.prototype.getText = function(url, callback, async) {
      if (async == null) {
        async = true;
      }
      return request('text', url, callback, async);
    };
    ajax.prototype.getXML = function(url, callback, async) {
      if (async == null) {
        async = true;
      }
      return request('xml', url, callback, async);
    };
    ajax.prototype.postText = function(url, data, callback, async) {
      if (async == null) {
        async = true;
      }
      return request('text', url, callback, async, data);
    };
    ajax.prototype.postXML = function(url, data, callback, async) {
      if (async == null) {
        async = true;
      }
      return request('xml', url, callback, async, data);
    };
    return ajax;
  })();
  if (!this.wh) {
    this.wh = {};
  }
  this.wh.ajax = new ajax();
  this.wh.data2url = data2url;
}).call(this);
