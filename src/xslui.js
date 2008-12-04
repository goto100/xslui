eval(base2.namespace);
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




















// =========================================================================
// ui/Componet.js
// =========================================================================

function Component() {
}
Component.CLOSE = 1;
Component.OK = 1 << 1;
Component.CANCEL = 1 << 2;



// =========================================================================
// ui/Draggable.js
// =========================================================================

function Draggable() {
}

Draggable.bind = function(thing, handle, range, target) {
	if (!handle) handle = thing;
	if (!range) range = document;

	var diffX = 0;
	var diffY = 0;

	function drag(event) {
		thing.style.top = event.clientY - diffY + "px";
		thing.style.left = event.clientX - diffX + "px";
	}

	handle.addEventListener("mousedown", function(event) {
		event.preventDefault();
		diffX = event.clientX - thing.offsetLeft;
		diffY = event.clientY - thing.offsetTop;
		range.addEventListener("mousemove", drag, false);
		range.addEventListener("mouseup", function() {
			range.removeEventListener("mousemove", drag, false);
			range.removeEventListener("mouseup", drag, false);
		}, false);
	}, false);
}



// =========================================================================
// ui/Fixable.js
// =========================================================================

function Fixable() {
}

Fixable.prototype.fix = function(dynamics) {
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

Fixable.bind = function(node) {
	base2.lang.extend(node, new Fixable());
}



// =========================================================================
// ui/Window.js
// =========================================================================

function Window() {
	this.title;
	this.components = Component.CLOSE | Component.OK | Component.CANCEL;
	this.modal = false;
	this.closable = true;
	this.draggable = true;
}

Window.bind = function(node) {
	node.style.display = "none";
	base2.lang.extend(node, new Window());
	node.heading = node.querySelector("h1, h2, h3, h4, h5, h6");
	node.buttonPanel = node.querySelector("div.panel");
	node.modal = node.classList.has("modal");
	node.closable = node.classList.has("closable");
}

Window.prototype.open = function() {
	Fixable.bind(this);
	this.style.display = "";
	this.style.zIndex = 2;
	this.fix(true);
	if (this.modal) {
		var overlay = document.createElement("div");
		Fixable.bind(overlay);
		overlay.className = "overlay";
		overlay.fix(true);
		overlay.style.top = "0px";
		overlay.style.left = "0px";
		overlay.style.zIndex = this.style.zIndex - 1;;
		overlay.style.width = "100%";
		overlay.style.height = "100%";
		this.parentNode.appendChild(overlay);
	}
	if (this.components & Component.CLOSE == Component.CLOSE) {
		var button = document.createElement("button");
		button.className = "close";
		button.innerHTML = "close";
		var win = this;
		button.addEventListener("click", function() { win.close(); }, false);
		this.querySelector("h1, h2, h3, h4, h5, h6").appendChild(button);
	}
	if (this.components & Component.OK == Component.OK) {
		this.okButton = document.createElement("button");
		this.okButton.className = "ok";
		this.okButton.innerHTML = "ok";
		this.buttonPanel.appendChild(this.okButton);
	}
	if (this.components & Component.CANCEL == Component.CANCEL) {
		this.cancelButton = document.createElement("button");
		this.cancelButton.className = "cancel";
		this.cancelButton.innerHTML = "cancel";
		this.buttonPanel.appendChild(this.cancelButton);
	}
	if (this.draggable) {
		Draggable.bind(this, this.heading);
	}
}

Window.prototype.close = function() {
	this.style.display = "none";
	base2.DOM.bind(this.parentNode);
	this.parentNode.querySelectorAll("div.overlay").forEach(function(div) {
		div.style.display = "none";
	});
}

