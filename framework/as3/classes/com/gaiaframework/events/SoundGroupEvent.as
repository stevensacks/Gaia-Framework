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

package com.gaiaframework.events
{
	import flash.events.Event;

	public class SoundGroupEvent extends Event
	{
		public static const ALL_SOUNDS_LOADED:String = "allSoundsLoaded";
		
		public function SoundGroupEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		public override function clone():Event
		{
			return new SoundGroupEvent(type, bubbles, cancelable);
		}
		public override function toString():String
		{
			return formatToString("SoundGroupEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
	}
}