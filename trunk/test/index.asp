<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<!--#include file="lib/XMLDocument.asp" -->
<!--#include file="lib/XMLDao.asp" -->
<!--#include file="lib/HttpRequest.asp" -->
<!--#include file="lib/mvc.asp" -->
<script language="javascript" runat="server">

var XML_PI = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\r\n";

var request = new HttpRequest();
var dao = new XMLDao();
dao.path = Server.MapPath("/xslui/test/data.xml");
dao.load();
var page = new XMLDocument();



if (request.search.path && request.search.path[0] == "new") {
	page.documentElement = page.createElement("xforms:model");
	page.documentElement.setAttribute("xmlns:xforms", "http://www.w3.org/2002/xforms");
	var instance = page.createElement("xforms:instance");
	instance.appendChild(dao.emptyPojoDom);
	var submission = page.createElement("xforms:submission");
	submission.setAttribute("action", "");
	submission.setAttribute("method", "put");
	page.documentElement.appendChild(instance);
	page.documentElement.appendChild(submission);

	pi = page.createProcessingInstruction("xml-stylesheet", "type=\"text/xsl\" href=\"edit.xsl\"");
	page.insertBefore(pi, page.childNodes[0]);	
	Response.ContentType = "text/xml"
	write(XML_PI + page.xml)
} else if (request.search.path && request.search.path[1] == "edit") {
	var article = dao.get(parseInt(request.search.path[0]), true);

	page.documentElement = page.createElement("xforms:model");
	page.documentElement.setAttribute("xmlns:xforms", "http://www.w3.org/2002/xforms");
	var instance = page.createElement("xforms:instance");
	instance.appendChild(article);
	var submission = page.createElement("xforms:submission");
	submission.setAttribute("action", "?" + article.getAttribute("id"));
	submission.setAttribute("method", "post");
	page.documentElement.appendChild(instance);
	page.documentElement.appendChild(submission);

	pi = page.createProcessingInstruction("xml-stylesheet", "type=\"text/xsl\" href=\"edit.xsl\"");
	page.insertBefore(pi, page.childNodes[0]);	
	Response.ContentType = "text/xml"
	write(XML_PI + page.xml)
} else {
	var article = {
		title: "abc",
		summary: "abc"
	}
	dao.save(article);
	dao.update(3, article)
	dao.remove(3)
	
	var articles = dao.list(0, 0, true);

	page.documentElement = page.createElement("rdf:RDF");
	page.documentElement.setAttribute("xmlns:rdf", "http://www.w3.org/1999/02/22-rdf-syntax-ns#");
	page.documentElement.setAttribute("xmlns:dc", "http://purl.org/dc/elements/1.1/");
	for (var i = 0; i < articles.length; i++) {
		page.documentElement.appendChild(articles[i]);
	}

	pi = page.createProcessingInstruction("xml-stylesheet", "type=\"text/xsl\" href=\"index.xsl\"");
	page.insertBefore(pi, page.childNodes[0]);
	Response.ContentType = "text/xml"
	write(XML_PI + page.xml)
}
</script>
