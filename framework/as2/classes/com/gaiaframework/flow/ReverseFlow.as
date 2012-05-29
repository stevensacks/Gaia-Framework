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

import com.gaiaframework.flow.FlowManager;

class com.gaiaframework.flow.ReverseFlow
{		
	public static function start():Void
	{
		FlowManager.preload();
	}	
	public static function afterPreloadDone():Void
	{
		FlowManager.transitionIn();
	}
	public static function afterTransitionInDone():Void
	{
		FlowManager.transitionOut();
	}	
	public static function afterTransitionOutDone():Void
	{
		FlowManager.complete();
	}
}