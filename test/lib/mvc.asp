<!--#include file="base2.asp" -->
<script language="javascript" runat="server">
eval(base2.namespace);
JavaScript.bind(this);

function write() {
	var str = "";
	for (var i = 0; i < arguments.length; i++) str += arguments[i] + " ";
	Response.Write(str);
}
function writeln() {
	var str = "";
	for (var i = 0; i < arguments.length; i++) str += arguments[i] + " ";
	Response.Write(str + "<br />");
}
function writebin(bin) {
	write("<pre>");
	Response.BinaryWrite(bin);
	write("</pre>");
}
var test = {};
test.start = function() {
	test.now = Date.now();
}
test.end = function(str) {
	if (!str) str = "";
	writeln(str + (Date.now() - test.now) + "ms");
	test.now = Date.now();
}
</script>
