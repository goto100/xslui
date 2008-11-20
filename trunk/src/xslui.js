//base2.DOM.bind(document);
function itNode(node) {
	var str = "";
	str += "<" + node.nodeName;
	if (node.attributes) for (var j = 0; j < node.attributes.length; j++) {
		str += " " + node.attributes[j].nodeName + "=\"" + node.attributes[j].textContent + "\"";
	}
	str += ">";
	for(var i = 0; i < node.childNodes.length; i++) {
		str += itNode(node.childNodes[i]);
	}
	str += "</" + node.nodeName + ">";
	return str;
}
//document.addEventListener("DOMContentLoaded", initListTable, false);
//document.addEventListener("DOMContentLoaded", initMultipleSubmission, false);
document.addEventListener("DOMContentLoaded", function() {
	alert(document.evaluate("./descendant::form[contains(concat(' ',@class,' '),' datagrid ')]/descendant::table", document, null, 7, null).snapshotLength);
}, false);

function initListTable() {
	document.querySelectorAll("form.datagrid table").forEach(function(table) {
		table.querySelectorAll("tbody td.delete a").forEach(function(auchor) { // Delete link
			auchor.onclick = function() {
				return confirm("确认删除吗？");
			}
		});
		table.querySelectorAll("tbody th.selection input").forEach(function(input) { // Select row
			input.onclick = function() {
				with (this.parentNode.parentNode) className = this.checked? "selected " + className : className.replace(/selected\s*/ig, "");
			}
			input.onclick();
		});
		table.querySelector("thead th.selection input").onclick = function() { // Select All
			var checked = this.checked;
			table.querySelectorAll("tbody th.selection input").forEach(function(input) {
				input.checked = checked;
				input.onclick();
			});
		}
	});
}

function initMultipleSubmission() {
	document.querySelectorAll("form button[type=submit]").forEach(function(button) {
		button.onclick = function() {
			button.value = button.getAttribute("value");
			if (this.name = "__action") {
				this.removeAttribute("name");
				this.form.action = this.value;
			}
		}
	});
}

var com = {xslui: {}};
com.xslui.Tree = function(element, setting) {
	if (!setting) setting = {};
	if (!setting.classes) setting.classes = {};
	if (!setting.classes.branch) setting.classes.branch = "branch";
	if (!setting.classes.switcher) setting.classes.switcher = "switcher";
	var swither = document.createElement("p");
		switcher.className = "switch";
		switcher.appendChild(document.createTextNode("开关"));
		switcher.onclick = function() {
			ul.childNodes.forEach(function(child) {child.style.display = "none"});
		}
		ul.querySelectorAll("li").forEach(function(li) {
			li.insertBefore(switcher, li.getElementByTagName("h3")[0]);
		});
}

function initTree() {
	document.querySelectorAll("ul.tree").forEach(function(ul) {
		new com.xslui.Tree(ul);
	});
}
