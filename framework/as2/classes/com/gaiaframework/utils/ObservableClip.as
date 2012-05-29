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

import mx.events.EventDispatcher;

class com.gaiaframework.utils.ObservableClip extends MovieClip
{
	public var addEventListener:Function;
	public var removeEventListener:Function;
	private var dispatchEvent:Function;
	
	function ObservableClip() 
	{
		EventDispatcher.initialize(this);
	}
}