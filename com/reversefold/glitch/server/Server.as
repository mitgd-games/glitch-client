package com.reversefold.glitch.server {
	import com.tinyspeck.debug.Console;
	import com.tinyspeck.engine.data.client.Announcement;
	import com.tinyspeck.engine.model.TSModelLocator;
	import com.tinyspeck.engine.net.NetDelegateSocket;
	
	import flash.external.ExternalInterface;
	
	import org.osmf.logging.Log;
	import org.osmf.logging.Logger;

	public class Server {
		private static var log : Logger = Log.getLogger("server.Player");
		
		private static var _instance : Server = null;
		public static function get instance() : Server {
			if (_instance == null) {
				_instance = new Server(new Key());
			}
			return _instance;
		}
		
		//meant to be set only once
		public var socket : NetDelegateSocket;

		public function Server(lock : Key) : void {
			if (lock == null) {
				throw new Error("singleton");
			}
			ExternalInterface.addCallback('apiSendAnnouncement', apiSendAnnouncement);
			ExternalInterface.addCallback('apiSendMsg', apiSendMsg);
			ExternalInterface.addCallback('apiLogAction', apiLogAction);
			ExternalInterface.addCallback('apiAsyncHttpCall', apiAsyncHttpCall);
			ExternalInterface.addCallback('apiFindObject', apiFindObject);
			ExternalInterface.addCallback('apiFindItemPrototype', apiFindItemPrototype);
			ExternalInterface.addCallback('apiCopyHash', apiCopyHash);
		}
		
		// BEGIN api funcs
		
		public function apiSendAnnouncement(ann : Object) : void {
			//We can either store these and add an announcements var to another outgoing message
			//or directly set them using, say
			
			//TODO: is this going to work ok when there are multiple announcements?
			//TODO: does this potentially avoid some other logic that would be accessing the announcements var in the messages?
			TSModelLocator.instance.activityModel.announcements = Announcement.parseMultiple([ann]); // fires trigger when set
		}
		
		public function apiSendMsg(msg : Object) : void {
			sendMessage(msg);
		}
		
		public function apiLogAction(name : String, ... args : Array) : void {
			//TODO: is this supposed to do something other than log?
			log.info(name + ' ' + args.join(' '));
		}
		
		public function apiAsyncHttpCall(url : String, ... args : Array) : void {
			log.warn("apiAsyncHttpCall " + url);
		}
		
		public function apiFindObject(tsid) {
			throw new Error("apiFindObject " + tsid);
		}
		
		public function apiFindItemPrototype(tsid) {
			throw new Error("apiFindItemPrototype " + tsid);
		}
		
		public function apiCopyHash(obj) {
			throw new Error("apiCopyHash " + obj);
		}
		
		// END api funcs

		
		public function sendMessage(msg : Object) : void {
			ExternalInterface.call('sendMessage', msg);
		}
	}
}

class Key {}
