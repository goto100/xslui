function Window() {
	this.title;
	this.components = Component.CLOSE | Component.OK | Component.CANCEL;
	this.modal = false;
	this.closable = true;
	this.draggable = true;
}

Window.bind = function(node) {
	node.style.display = "none";
	base2.extend(node, new Window());
	node.heading = node.querySelector("h1, h2, h3, h4, h5, h6");
	node.buttonPanel = node.querySelector("div.panel");
	node.modal = node.hasClass("modal");
	node.closable = node.hasClass("closable");
}

Window.prototype.show = function() {
	var win = this;
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
	if (this.components & Component.CLOSE == Component.CLOSE) {
		var button = document.createElement("button");
		button.className = "close";
		button.innerHTML = "close";
		var win = this;
		button.addEventListener("click", function() {
			win.style.display = "none";
			base2.DOM.bind(win.parentNode);
			win.parentNode.querySelectorAll("div.overlay").forEach(function(div) {
				div.style.display = "none";
			});
		}, false);
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
		this.heading.addEventListener("mousedown", function(event) {
			this.addEventListener("mousemove", function(event) {dragging.call(win, event);}, false);
			this.addEventListener("mouseup", function() {
				this.removeEventListener("mousemove", dragging, false);
				this.removeEventListener("mouseup", dragging, false);
			}, false);
		}, false);
	}
}

function dragging(event) {
	this.style.top = event.clientY - (event.clientY - this.offsetTop) + "px";
}