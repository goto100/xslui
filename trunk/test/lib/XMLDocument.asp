<script language="javascript" runat="server">
function XMLDocument() {
	var dom;
	try {
		dom = new ActiveXObject("MSXML2.DomDocument");
	} catch(e) {
		try {
			dom = new ActiveXObject("MSXML.DomDocument");
		} catch(e) {
			try {
				dom = new ActiveXObject("Microsoft.XMLDom");
			} catch(e) {
				throw new Error(0, "Can't create XML Dom, you need Microsoft.XMLDom object.");
			}
		}
	}
	return dom;
}
</script>