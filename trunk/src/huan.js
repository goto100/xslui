base2.DOM.bind(document);

document.addEventListener("DOMContentLoaded", initListTable, false);
document.addEventListener("DOMContentLoaded", initMultipleSubmission, false);

function initListTable() {
	document.querySelectorAll("table.list").forEach(function(listTable) {
		listTable.querySelectorAll("tbody td.delete a").forEach(function(auchor) { // Delete link
			auchor.onclick = function() {
				return confirm("确认删除吗？");
			}
		});
		listTable.querySelectorAll("tbody th.selection input").forEach(function(input) { // Select row
			input.onclick = function() {
				with (this.parentNode.parentNode) className = this.checked? "selected " + className : className.replace(/selected\s*/ig, "");
			}
			input.onclick();
		});
		listTable.querySelector("thead th.selection input").onclick = function() { // Select All
			var checked = this.checked;
			listTable.querySelectorAll("tbody th.selection input").forEach(function(input) {
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

var com = {huan: {ui: {}}};
function com.huan.ui.Tree(element, setting) {
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
	document.querySelectorAll("ul.tree").formEach(function(ul) {
		new com.huan.ui.Tree(ul);
	});
}
