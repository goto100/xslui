base2.JavaScript.bind(window);
base2.DOM.bind(document);
base2.DOM.EventTarget(window);

document.addEventListener("DOMContentLoaded", initListTable, false);
document.addEventListener("DOMContentLoaded", initMultipleSubmission, false);
document.addEventListener("DOMContentLoaded", initWindow, false);


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

function initWindow() {
	document.querySelectorAll("div.window").forEach(Window.bind);
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

base2.DOM.HTMLElement.prototype.fix = function(dynamics) {
	if (base2.detect("MSIE6")) this.style.position = "absolute";
	else this.style.position = "fixed";
	this.style.top = (document.documentElement.scrollTop + ((document.documentElement.clientHeight || document.body.clientHeight) - this.offsetHeight) / 2) + "px";
	this.style.left = (document.documentElement.scrollLeft + (document.documentElement.clientWidth - this.offsetWidth) / 2) + "px";

	if (dynamics) {
		var node = this;
		function fix() {node.fix();}
		window.addEventListener("resize", fix, false);
		if (base2.detect("MSIE6")) {
			window.attachEvent("onresize", fix, false);
			window.attachEvent("onscroll", fix, false);
		}
	}
}

function Window() {
	this.modal = false;
	this.closable = true;
}

Window.bind = function(node) {
	node.style.display = "none";
	base2.extend(node, new Window());
	node.modal = node.hasClass("modal");
	node.closable = node.hasClass("closable");
}

Window.prototype.show = function() {
	this.style.display = "";
	this.style.zIndex = 2;
	this.fix(true);
	if (this.modal) {
		var overlay = document.createElement("div");
		overlay.className = "overlay";
		overlay.fix(true);
		overlay.style.top = "0px";
		overlay.style.left = "0px";
		overlay.style.zIndex = this.style.zIndex - 1;;
		overlay.style.width = "100%";
		overlay.style.height = "100%";
		this.parentNode.appendChild(overlay);
	}
	if (this.closable) {
		var closeButton = document.createElement("button");
		closeButton.className = "close";
		closeButton.innerHTML = "close";
		var win = this;
		closeButton.addEventListener("click", function() {
			win.style.display = "none";
			base2.DOM.bind(win.parentNode);
			win.parentNode.querySelectorAll("div.overlay").forEach(function(div) {
				div.style.display = "none";
			});
		}, false);
		this.querySelector("h1, h2, h3, h4, h5, h6").appendChild(closeButton);
	}
}
