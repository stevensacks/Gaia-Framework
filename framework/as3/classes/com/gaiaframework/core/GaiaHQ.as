/*****************************************************************************************************
* Gaia Framework for Adobe Flash ©2007-2009
* Author: Steven Sacks
*
* blog: http://www.stevensacks.net/
* git: https://github.com/stevensacks/Gaia-Framework
* support: http://gaiaflashframework.tenderapp.com/
* 
* By using the Gaia Framework, you agree to keep the above contact information in the source code.
* 
* Gaia Framework for Adobe Flash is released under the MIT License:
* http://www.opensource.org/licenses/mit-license.php 
*****************************************************************************************************/

package com.gaiaframework.core
{
	import com.gaiaframework.assets.PageAsset;
	import com.gaiaframework.debug.GaiaDebug;
	import com.gaiaframework.events.GaiaEvent;
	import com.gaiaframework.events.GaiaSWFAddressEvent;
	import com.gaiaframework.flow.FlowManager;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	// Events in Gaia get routed through GaiaHQ

	public class GaiaHQ extends EventDispatcher
	{
		public static const TRANSITION_OUT:String = "transitionOut";
		public static const TRANSITION_IN:String = "transitionIn";
		public static const PRELOAD:String = "preload";
		public static const COMPLETE:String = "complete";
		
		private var listeners:Object;		
		private var uniqueID:uint = 0;		
		private var gotoEventObj:Object;
		
		private static var _instance:GaiaHQ;
		
		function GaiaHQ()
		{
			super();
			listeners = {};
			listeners.beforeGoto = {};
			listeners.afterGoto = {};
			listeners.beforeTransitionOut = {};
			listeners.afterTransitionOut = {};
			listeners.beforePreload = {};
			listeners.afterPreload = {};
			listeners.beforeTransitionIn = {};
			listeners.afterTransitionIn = {};
			listeners.afterComplete = {};
		}
		public static function birth():void
		{
			if (_instance == null) _instance = new GaiaHQ();
		}
		public static function get instance():GaiaHQ
		{
			return _instance;
		}
		// Called by GaiaImpl
		public function addListener(eventName:String, target:Function, hijack:Boolean, onlyOnce:Boolean):Function
		{
			if (listeners[eventName] != null) 
			{
				var listener:GaiaHQListener = generateListener(eventName, target);
				if (!listener.hijack && hijack) 
				{
					listener.addEventListener(Event.COMPLETE, onHijackComplete);
				}
				else if (listener.hijack && !hijack)
				{
					listener.removeEventListener(Event.COMPLETE, onHijackComplete);
				}
				listener.hijack = hijack;
				listener.completed = !hijack;
				listener.onlyOnce = onlyOnce;
				addEventListener(eventName, listener.target);
				return (hijack) ? listener.completeCallback : null;
			}
			else
			{
				GaiaDebug.warn("GaiaHQ Error! addListener: " + eventName + " is not a valid event");
				return null;
			}
		}
		public function removeListener(eventName:String, target:Function):void
		{
			if (listeners[eventName] != undefined) 
			{
				for (var id:String in listeners[eventName])
				{
					if (GaiaHQListener(listeners[eventName][id]).target == target) 
					{
						removeListenerByID(eventName, id);
						break;
					}
				}
			}
			else 
			{
				GaiaDebug.warn("GaiaHQ Error! removeListener: " + eventName + " is not a valid event");
			}
		}
		
		// This method is the beginning of the event chain
		public function goto(branch:String, flow:String = null):void
		{
			if (!branch) branch = "index";
			if (branch.substr(0, SiteModel.indexID.length) != SiteModel.indexID) branch = SiteModel.indexID + "/" + branch;
			gotoEventObj = {};
			gotoEventObj.validBranch = BranchTools.getValidBranch(branch);
			gotoEventObj.fullBranch = BranchTools.getFullBranch(branch);
			var page:PageAsset = BranchTools.getPage(gotoEventObj.validBranch);
			gotoEventObj.external = page.external;
			gotoEventObj.src = page.src;
			gotoEventObj.flow = flow;
			gotoEventObj.window = page.window;
			beforeGoto();
		}
		public function onGoto(event:GaiaSWFAddressEvent):void
		{
			goto(event.branch);
		}
		
		// EVENT HIJACKS
		
		// GOTO BEFORE / AFTER
		public function beforeGoto():void
		{
			onEvent(GaiaEvent.BEFORE_GOTO);
		}
		public function beforeGotoDone():void
		{
			gotoEventObj.type = GaiaEvent.GOTO;
			dispatchGaiaEvent();
		}
		public function afterGoto():void
		{
			onEvent(GaiaEvent.AFTER_GOTO);
		}
		public function afterGotoDone():void
		{
			FlowManager.afterGoto();
		}
		
		// TRANSITION OUT BEFORE / AFTER
		public function beforeTransitionOut():void
		{
			onEvent(GaiaEvent.BEFORE_TRANSITION_OUT);
		}
		public function beforeTransitionOutDone():void
		{
			dispatchEvent(new Event(TRANSITION_OUT));
		}
		public function afterTransitionOut():void
		{
			onEvent(GaiaEvent.AFTER_TRANSITION_OUT);
		}
		public function afterTransitionOutDone():void
		{
			FlowManager.afterTransitionOutDone();
		}
		
		// PRELOAD BEFORE / AFTER
		public function beforePreload():void
		{
			onEvent(GaiaEvent.BEFORE_PRELOAD);
		}
		public function beforePreloadDone():void
		{
			dispatchEvent(new Event(PRELOAD));
		}
		public function afterPreload():void
		{
			onEvent(GaiaEvent.AFTER_PRELOAD);
		}
		public function afterPreloadDone():void
		{
			FlowManager.afterPreloadDone();
		}
		
		// TRANSITION IN BEFORE / AFTER
		public function beforeTransitionIn():void
		{
			onEvent(GaiaEvent.BEFORE_TRANSITION_IN);
		}
		public function beforeTransitionInDone():void
		{
			dispatchEvent(new Event(TRANSITION_IN));
		}
		public function afterTransitionIn():void
		{
			onEvent(GaiaEvent.AFTER_TRANSITION_IN);
		}
		public function afterTransitionInDone():void
		{
			FlowManager.afterTransitionInDone();
		}
		
		// AFTER COMPLETE
		public function afterComplete():void
		{
			dispatchEvent(new Event(COMPLETE));
			onEvent(GaiaEvent.AFTER_COMPLETE);
		}
		public function afterCompleteDone():void
		{
			// we're done
		}
		
		// WHEN GAIA EVENTS OCCUR THEY ARE ROUTED THROUGH HERE FOR HIJACKING
		private function onEvent(eventName:String):void
		{
			var eventHasListeners:Boolean = false;
			var eventHasHijackers:Boolean = false;
			for (var id:String in listeners[eventName])
			{
				if (listeners[eventName][id] != null) 
				{
					eventHasListeners = true;
					var listener:GaiaHQListener = listeners[eventName][id];
					if (listener.onlyOnce) listener.dispatched = true;
					if (listener.hijack) eventHasHijackers = true;
				}
			}
			gotoEventObj.type = eventName;
			if (eventHasListeners) dispatchGaiaEvent();
			if (!eventHasHijackers) this[eventName + "Done"]();
			removeOnlyOnceListeners(eventName);
		}
		
		// GENERATES AN EVENT HIJACKER
		private function generateListener(eventName:String, target:Function):GaiaHQListener
		{
			// prevent duplicate listeners
			for (var id:String in listeners[eventName])
			{
				if (GaiaHQListener(listeners[eventName][id]).target == target) 
				{
					removeEventListener(eventName, target);
					return GaiaHQListener(listeners[eventName][id]);
				}
			}
			// new listener
			var listener:GaiaHQListener = new GaiaHQListener();
			listener.event = eventName;
			listener.target = target;
			listeners[eventName][String(++uniqueID)] = listener;
			return listener;
		}
		// REMOVES EVENT LISTENERS BY THEIR UNIQUE ID
		private function removeListenerByID(eventName:String, id:String):void
		{
			GaiaHQListener(listeners[eventName][id]).removeEventListener(Event.COMPLETE, onHijackComplete);
			removeEventListener(eventName, GaiaHQListener(listeners[eventName][id]).target);
			delete listeners[eventName][id];
		}
		// REMOVES EVENT LISTENERS THAT ONLY LISTEN ONCE
		private function removeOnlyOnceListeners(eventName:String):void
		{
			for (var id:String in listeners[eventName])
			{
				var listener:GaiaHQListener = listeners[eventName][id];
				if (listener.onlyOnce && listener.dispatched && !listener.hijack) removeListenerByID(eventName, id);
			}
		}
		// RESET COMPLETED HIJACKERS AFTER ALL HIJACKERS ARE COMPLETE AND REMOVE ONLY ONCE HIJACKERS
		private function resetEventHijackers(eventName:String):void
		{
			for (var id:String in listeners[eventName])
			{
				if (GaiaHQListener(listeners[eventName][id]).hijack)
				{
					if (!GaiaHQListener(listeners[eventName][id]).onlyOnce) 
					{
						GaiaHQListener(listeners[eventName][id]).completed = false;
					}
					else
					{
						removeListenerByID(eventName, id);
					}
				}
			}
		}
		// EVENT RECEIVED FROM EVENT HIJACKERS WHEN WAIT FOR COMPLETE CALLBACK IS CALLED
		private function onHijackComplete(event:Event):void
		{
			var allDone:Boolean = true;
			var eventName:String = GaiaHQListener(event.target).event;
			for (var id:String in listeners[eventName])
			{
				if (!GaiaHQListener(listeners[eventName][id]).completed)
				{
					allDone = false;
					break;
				}
			}
			if (allDone) 
			{
				resetEventHijackers(eventName);
				this[eventName + "Done"]();
			}
		}
		private function dispatchGaiaEvent():void
		{
			dispatchEvent(new GaiaEvent(gotoEventObj.type, false, false, gotoEventObj.validBranch, gotoEventObj.fullBranch, gotoEventObj.external, gotoEventObj.src, gotoEventObj.flow, gotoEventObj.window));
		}
	}
}