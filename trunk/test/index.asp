<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<script language="javascript" runat="server">
function XMLDao() {
	this.dom;
	this.path;
	this.loaded = false;
}

XMLDao.prototype.load = function() {
	try {
		this.dom = new ActiveXObject("MSXML2.DomDocument");
	} catch(e) {
		try {
			this.dom = new ActiveXObject("MSXML.DomDocument");
		} catch(e) {
			try {
				this.dom = new ActiveXObject("Microsoft.XMLDom");
			} catch(e) {
				throw new Error(0, "Can't create XML Dom, you need Microsoft.XMLDom object.");
			}
		}
	}
	this.dom.load(this.path);
	if (this.dom.parseError.errorCode) {
		write(this.dom.parseError.reason)
	}
}

XMLDao.prototype.list = function() {
	if (!this.loaded) this.load();

	var recs = this.dom.documentElement.selectNodes("/rdf:RDF/rdf:Description");
	var pojos = [];
	for (var i = 0; i < recs.length; i++) {
		var pojo = {
			title: recs[i].selectSingleNode("dc:title").text,
			summary: recs[i].selectSingleNode("dc:summary").text,
			description: recs[i].selectSingleNode("dc:description").xml
		}
		pojos.push(pojo);
	}
	return pojos;
}

XMLDao.prototype.save = function(article) {
	if (!this.loaded) this.load();

	var articleDom = this.dom.documentElement.selectSingleNode("/rdf:RDF/rdf:Description").cloneNode();
	articleDom.selectSingleNode("dc:title/text()").nodeValue = "abc";
	articleDom.selectSingleNode("dc:summary/text()").nodeValue = "abc";
	articleDom.selectSingleNode("dc:description/text()").nodeValue = "abc";
	this.dom.documentElement.appendChild();
}






function write(str) {
	Response.Write(str);
}

function writeln(str) {
	Response.Write(str + "<br />");
}

var dao = new XMLDao();
dao.path = Server.MapPath("/xslui/test/data.xml");
dao.load();

var articles = dao.list();

for (var i = 0; i < articles.length; i++) {
	writeln(articles[i].title);
	writeln(articles[i].summary);
}

</script>