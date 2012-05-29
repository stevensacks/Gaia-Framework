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

package com.gaiaframework.utils
{
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;

	public class Tracking
	{
		private static var queue:Array = [];
		private static var timer:Timer = new Timer(50);
		
		public static function track(...args):void
		{
			var obj:Object = {args:args};
			addToQueue(obj);
		}
		private static function addToQueue(obj:Object):void 
		{
			if (queue.length == 0) 
			{
				timer.addEventListener(TimerEvent.TIMER, Tracking.executeNext);
				timer.start();
			}
			queue.push(obj);
		}
		private static function executeNext(event:TimerEvent):void 
		{
			if (queue.length == 0) 
			{
				timer.reset();
				timer.removeEventListener(TimerEvent.TIMER, Tracking.executeNext);
			}
			else
			{
				ExternalInterface.call.apply(ExternalInterface, queue.shift().args.toString().split(","));
			}
		}
	}
}