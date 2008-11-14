<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet type="text/xsl" href="pagebar.xsl"?>
<script language="javascript" runat="server">
	Response.ContentType = "text/xml"
	var page = parseInt(Request.QueryString("page"));
	if (!page) page = 1;
	var page2 = parseInt(Request.QueryString("page2"));
	if (!page2) page2 = 1;
</script>
<root>
	<page current="<%=page%>" total="50" />
	<page current="<%=page2%>" total="100" />
</root>
