log = {
		info: function(msg) { console.log("INFO " + msg); if (arguments.length > 1) { console.log(arguments.slice(1, arguments.length + 1)); } }
}

config = {}

function sendMessage(msg) {
	processMessageInner(msg);

	pc.performPostProcessing(msg);
}

function swf() {
	return document.getElementById("flashContent");
}

function apiSendAnnouncement(ann) {
	return swf().apiSendAnnouncement(ann);
}

function apiSendMsg(ann) {
	return swf().apiSendMsg(ann);
}

function apiLogAction() {
	return swf().apiLogAction.apply(null, arguments);
}

function apiAsyncHttpCall() {
	return swf().apiAsyncHttpCall.apply(null, arguments);
}

function apiFindObject(tsid) {
	return swf().apiFindObject(tsid);
}

function apiFindItemPrototype(tsid) {
	return swf().apiFindItemPrototype(tsid);
}

function apiCopyHash(obj) {
	return swf().apiCopyHash(obj);
}
