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

import com.gaiaframework.events.Event;

class com.gaiaframework.events.SoundGroupEvent extends Event
{
	public static var ALL_SOUNDS_LOADED:String = "allSoundsLoaded";
	
	public function SoundGroupEvent(type:String, target:Object)
	{
		super(type, target);
	}
	public function clone():Event
	{
		return new SoundGroupEvent(type, target);
	}
	public function toString():String
	{
		return formatToString("SoundGroupEvent", "type");
	}
}