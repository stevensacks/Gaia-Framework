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

class com.gaiaframework.flow.CrossFlow
{		
	private static var isInDone:Boolean;
	private static var isOutDone:Boolean;
	
	public static function start():Void
	{
		isInDone = isOutDone = false;
		FlowManager.preload();
	}	
	public static function afterPreloadDone():Void
	{
		FlowManager.transitionOut();
		FlowManager.transitionIn();
	}
	public static function afterTransitionInDone():Void
	{
		isInDone = true;
		checkBothDone();
	}	
	public static function afterTransitionOutDone():Void
	{
		isOutDone = true;
		checkBothDone();
	}
	private static function checkBothDone():Void
	{
		if (isInDone && isOutDone)
		{
			isInDone = isOutDone = false;
			FlowManager.complete();
		}
	}
}