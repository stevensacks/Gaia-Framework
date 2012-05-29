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
* http://www.opensource.org/licenses/mit-license 
*****************************************************************************************************/

import com.gaiaframework.events.GaiaSWFAddressEvent;
import com.gaiaframework.events.GaiaEvent;
import com.gaiaframework.events.Event;
import com.gaiaframework.utils.ObservableClass;
import com.gaiaframework.core.GaiaHQListener;
import com.gaiaframework.core.BranchTools;
import com.gaiaframework.assets.PageAsset;
import com.gaiaframework.flow.FlowManager;
import com.gaiaframework.debug.GaiaDebug;
import com.gaiaframework.core.SiteModel;
import mx.utils.Delegate;

// Events in Gaia get routed through GaiaHQ
// Application provides an easy API for hijacking the four primary events

class com.gaiaframework.core.GaiaHQ extends ObservableClass
{
	public static var TRANSITION_OUT:String = "transitionOut";
	public static var TRANSITION_IN:String = "transitionIn";
	public static var PRELOAD:String = "preload";
	public static var COMPLETE:String = "complete";
	
	private var hijackCompleteDelegate:Function;	
	private var listeners:Object;
	private var uniqueID:Number = 0;
	private var gotoEventObj:Object;
	
	private static var _instance:GaiaHQ;
	
	private function GaiaHQ()
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
		hijackCompleteDelegate = Delegate.create(this, onHijackComplete);
	}
	public static function birth():Void
	{
		if (_instance == null) _instance = new GaiaHQ();
	}
	public static function get instance():GaiaHQ
	{
		return _instance;
	}
	// Called by Application
	public function addListener(eventName:String, target:Function, hijack:Boolean, onlyOnce:Boolean):Function
	{
		if (listeners[eventName] != undefined) 
		{
			var listener:GaiaHQListener = generateListener(eventName, target);
			if (!listener.hijack && hijack) 
			{
				listener.addEventListener(Event.COMPLETE, hijackCompleteDelegate);
			}
			else if (listener.hijack && !hijack)
			{
				listener.removeEventListener(Event.COMPLETE, hijackCompleteDelegate);
			}
			listener.hijack = hijack;
			listener.completed = !hijack;
			listener.onlyOnce = onlyOnce;
			addEventListener(eventName, listener.target);
			return (hijack) ? Delegate.create(listener, listener.completeCallback) : null;
		}
		else
		{
			GaiaDebug.warn("GaiaHQ addListener: " + eventName + " is not a valid event");
			return null;
		}
	}
	public function removeListener(eventName:String, target:Function):Void
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
			GaiaDebug.warn("GaiaHQ removeListener: " + eventName + " is not a valid event");
		}
	}
	
	// This method is the beginning of the event chain
	public function goto(branch:String, flow:String):Void
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
	public function onGoto(event:GaiaSWFAddressEvent):Void
	{
		goto(event.branch);
	}
	
	// EVENT HIJACKS
	
	// GOTO BEFORE / AFTER
	public function beforeGoto():Void
	{
		onEvent(GaiaEvent.BEFORE_GOTO);
	}
	public function beforeGotoDone():Void
	{
		gotoEventObj.type = GaiaEvent.GOTO;
		dispatchGaiaEvent();
	}
	public function afterGoto():Void
	{
		onEvent(GaiaEvent.AFTER_GOTO);
	}
	public function afterGotoDone():Void
	{
		FlowManager.afterGoto();
	}
	
	// TRANSITION OUT BEFORE / AFTER
	public function beforeTransitionOut():Void
	{
		onEvent(GaiaEvent.BEFORE_TRANSITION_OUT);
	}
	public function beforeTransitionOutDone():Void
	{
		dispatchEvent(new Event(TRANSITION_OUT, this));
	}
	public function afterTransitionOut():Void
	{
		onEvent(GaiaEvent.AFTER_TRANSITION_OUT);
	}
	public function afterTransitionOutDone():Void
	{
		FlowManager.afterTransitionOutDone();
	}
	
	// PRELOAD BEFORE / AFTER
	public function beforePreload():Void
	{
		onEvent(GaiaEvent.BEFORE_PRELOAD);
	}
	public function beforePreloadDone():Void
	{
		dispatchEvent(new Event(PRELOAD, this));
	}
	public function afterPreload():Void
	{
		onEvent(GaiaEvent.AFTER_PRELOAD);
	}
	public function afterPreloadDone():Void
	{
		FlowManager.afterPreloadDone();
	}
	
	// TRANSITION IN BEFORE / AFTER
	public function beforeTransitionIn():Void
	{
		onEvent(GaiaEvent.BEFORE_TRANSITION_IN);
	}
	public function beforeTransitionInDone():Void
	{
		dispatchEvent(new Event(TRANSITION_IN, this));
	}
	public function afterTransitionIn():Void
	{
		onEvent(GaiaEvent.AFTER_TRANSITION_IN);
	}
	public function afterTransitionInDone():Void
	{
		FlowManager.afterTransitionInDone();
	}
	
	// AFTER COMPLETE
	public function afterComplete():Void
	{
		dispatchEvent(new Event(COMPLETE, this));
		onEvent(GaiaEvent.AFTER_COMPLETE);
	}
	public function afterCompleteDone():Void
	{
		// we're done
	}
	
	// WHEN GAIA EVENTS OCCUR THEY ARE ROUTED THROUGH HERE FOR HIJACKING
	private function onEvent(eventName:String):Void
	{
		var eventHasListeners:Boolean = false;
		var eventHasHijackers:Boolean = false;
		for (var id:String in listeners[eventName])
		{
			if (listeners[eventName][id] != undefined) 
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
			if (listeners[eventName][id].target == target) 
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
	private function removeListenerByID(eventName:String, id:String):Void
	{
		GaiaHQListener(listeners[eventName][id]).removeEventListener("complete", hijackCompleteDelegate);
		this.removeEventListener(eventName, GaiaHQListener(listeners[eventName][id]).target);
		delete listeners[eventName][id];
	}
	// REMOVES EVENT LISTENERS THAT ONLY LISTEN ONCE
	private function removeOnlyOnceListeners(eventName:String):Void
	{
		for (var id:String in listeners[eventName])
		{
			var listener:GaiaHQListener = listeners[eventName][id];
			if (listener.onlyOnce && listener.dispatched && !listener.hijack) removeListenerByID(eventName, id);
		}
	}
	// RESET COMPLETED HIJACKERS AFTER ALL HIJACKERS ARE COMPLETE AND REMOVE ONLY ONCE HIJACKERS
	private function resetEventHijackers(eventName:String):Void
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
	private function onHijackComplete(event:Event):Void
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
	private function dispatchGaiaEvent():Void
	{
		dispatchEvent(new GaiaEvent(gotoEventObj.type, this, gotoEventObj.validBranch, gotoEventObj.fullBranch, gotoEventObj.external, gotoEventObj.src, gotoEventObj.flow, gotoEventObj.window));
	}
}