/*****************************************************************************************************
* Gaia Framework for Adobe Flash ©2007-2012
* Author: Steven Sacks
*
* forum: http://www.gaiaflashframework.com/forum/
* wiki: http://www.gaiaflashframework.com/wiki/
* 
* By using the Gaia Framework, you agree to keep the above contact information in the source code.
* 
* Gaia Framework for Adobe Flash is released under the MIT License:
* http://www.opensource.org/licenses/mit-license.php 
*****************************************************************************************************/

package com.gaiaframework.panel.services
{	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	public class VersionService extends EventDispatcher
	{
		private var loader:URLLoader;
		
		private static var _version:String;
		
		private var reloadTimer:Timer = new Timer(5000, 1);
		
		public function VersionService()
		{
			super();
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onVersionLoaded);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			reloadTimer.addEventListener(TimerEvent.TIMER, onReloadTimer);
			reloadTimer.start();
		}
		public static function get version():String
		{
			return _version;
		}
		public function load():void
		{
			loader.load(new URLRequest("http://www.gaiaflashframework.com/downloads/version.txt?nocache=" + String(new Date().getTime()));
		}
		private function onVersionLoaded(event:Event):void
		{
			_version = String(event.target.data);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		private function onIOError(event:IOErrorEvent):void
		{
			reloadTimer.reset();
			reloadTimer.delay = 1800000;
			reloadTimer.start();
		}
		private function onReloadTimer(event:TimerEvent):void 
		{
			reloadTimer.reset();
			load();
		}
	}
}