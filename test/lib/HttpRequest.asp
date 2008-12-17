<!--#include file="base2.asp" -->
<script language="javascript" runat="server">
base2.JavaScript.bind(this);
function HttpRequest() {
	this.search = getSearch();
	this.input = getInput();

	this.method = this.input["__method__"]? this.input["__method__"].toUpperCase() : "GET";
	if (!["GET", "POST", "PUT", "DELETE", "HEAD"].contains(this.method)) {
		this.method = Request.ServerVariables("REQUEST_METHOD");
	}

	this.path = String(Request.ServerVariables("PATH_INFO"));
	this._ip;

	// Request.Form
	function getInput() {
		var input = new base2.Map();
		var name;
		var e = new Enumerator(Request.Form);
		for (var i = 0; !e.atEnd(); e.moveNext(), i++) {
			name = String(e.item());
			input[i] = input[name] = String(Request.Form(name));
		}
		return input;
	}

	// Request.QueryString
	function getSearch() {
		var queryString = String(Request.QueryString);
		var searches = queryString.split("&");
		var search = new base2.Map();
		if (searches[0] && searches[0].indexOf("=") == -1) {
			search.path = searches[0].split("/");
			search.path.toString = function() {
				return this.join("/");
			}
		}
		for (var item, pos, i = 1/* Ignore path */; i < searches.length; i++) {
			pos = searches[i].indexOf("=");
			item = {
				name: searches[i].substr(0, pos),
				value: searches[i].substr(pos + 1)
			}
			var value = search.get(item.name) || [];
			value.push(item.value);
			search.put(item.name, value);
		}
		return search;
	}
}

HttpRequest.prototype.getIP = function() {
	if (this._ip) return this._ip;
	this._ip = String(Request.ServerVariables("HTTP_X_FORWARDED_FOR")).replace(/[^0-9\.,]/g, "");
	if (this._ip.length < 7) this._ip = String(Request.ServerVariables("REMOTE_ADDR")).replace(/[^0-9\.,]/g, "");
	if (this._ip.indexOf(",") > 7) this._ip = this._ip.substr(0, this._ip.indexOf(","));
	return this._ip;
}
</script>