<script language="javascript" runat="server">
function XMLDao() {
	this.dom;
	this.path;
	this.loaded = false;
	this.nextId = 0;
	this.emptyPojoDom;
}

XMLDao.prototype.load = function() {
	this.dom = new XMLDocument();
	this.dom.load(this.path);
	if (this.dom.parseError.errorCode) {
		write(this.dom.parseError.reason)
	}
	var items = this.dom.documentElement.getElementsByTagName("rdf:Description");
	this.nextId = parseInt(items[items.length - 1].getAttribute("id"));
	this.nextId++;

	this.emptyPojoDom = this.dom.createElement("rdf:Description");
	this.emptyPojoDom.setAttribute("xmlns:rdf", "http://www.w3.org/1999/02/22-rdf-syntax-ns#");
	this.emptyPojoDom.setAttribute("xmlns:dc", "http://purl.org/dc/elements/1.1/");
	var title = this.dom.createElement("dc:title");
	var date = this.dom.createElement("dc:date");
	var summary = this.dom.createElement("dc:summary");
	var description = this.dom.createElement("dc:description");
	this.emptyPojoDom.setAttribute("id", "");
	this.emptyPojoDom.setAttribute("about", "");
	this.emptyPojoDom.appendChild(title);
	this.emptyPojoDom.appendChild(date);
	this.emptyPojoDom.appendChild(summary);
	this.emptyPojoDom.appendChild(description);
}

XMLDao.prototype.get = function(id, isDom) {
	if (!this.loaded) this.load();

	var articleDom = this.dom.documentElement.selectSingleNode("/rdf:RDF/rdf:Description[@id = " + id + "]").cloneNode(true);
	if (isDom) return articleDom;
}

XMLDao.prototype.list = function(start, end, isDom) {
	if (!this.loaded) this.load();

	var recs = this.dom.documentElement.selectNodes("/rdf:RDF/rdf:Description");
	if (isDom) return recs;
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

	var articleDom = this.dom.documentElement.selectSingleNode("/rdf:RDF/rdf:Description").cloneNode(true);
	articleDom.selectSingleNode("@id").nodeValue = this.nextId++;
	articleDom.selectSingleNode("dc:title/text()").nodeValue = article.title;
	articleDom.selectSingleNode("dc:summary/text()").nodeValue = article.summary;
	// articleDom.selectSingleNode("dc:description/text()").nodeValue = article.description;
	this.dom.documentElement.appendChild(articleDom);
	this.dom.save(this.path);
}

XMLDao.prototype.update = function(id, article) {
	if (!this.loaded) this.load();

	var articleDom = this.dom.documentElement.selectSingleNode("/rdf:RDF/rdf:Description[@id = " + id + "]");
	articleDom.selectSingleNode("dc:title/text()").nodeValue = article.title;
	articleDom.selectSingleNode("dc:summary/text()").nodeValue = article.summary;
	// articleDom.selectSingleNode("dc:description/text()").nodeValue = article.description;
	this.dom.save(this.path);
}

XMLDao.prototype.remove = function(id) {
	if (!this.loaded) this.load();

	var articleDom = this.dom.documentElement.selectSingleNode("/rdf:RDF/rdf:Description[@id = " + id + "]");
	this.dom.documentElement.removeChild(articleDom);
	this.dom.save(this.path);
}
</script>