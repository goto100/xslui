base2.DOM.bind(document);

document.addEventListener("DOMContentLoaded", initListTable, false);
document.addEventListener("DOMContentLoaded", initMultipleSubmission, false);

function initListTable() {
	document.querySelectorAll("form.datagrid table").forEach(function(table) {
		table.querySelectorAll("tbody td.delete a").forEach(function(auchor) { // Delete link
			auchor.onclick = function() {
				return confirm("Delete?");
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
				if (!input.disabled) {
					input.checked = checked;
					input.onclick();
				}
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
		switcher.appendChild(document.createTextNode(""));
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
