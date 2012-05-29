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

import flash.external.ExternalInterface;

class com.gaiaframework.utils.Tracking
{
	private static var eventQueue:Array = [];
	private static var eventQueueDelay:Number = 500;
	private static var eventQueueInterval:Number;
	
	public static function track():Void
	{
		var event:Object = {args:arguments};
		addTrackEventToQueue(event);
	}
	private static function addTrackEventToQueue(event:Object):Void 
	{
		if (eventQueue.length == 0) 
		{
			clearInterval(eventQueueInterval);
			eventQueueInterval = setInterval(executeNextTrackEvent, eventQueueDelay);
		}
		eventQueue.push(event);
	}
	private static function executeNextTrackEvent():Void 
	{
		if (eventQueue.length == 0) 
		{
			clearInterval(eventQueueInterval);
		}
		else
		{
			ExternalInterface.call.apply(ExternalInterface, eventQueue.shift().args.toString().split(","));
		}
	}
}
