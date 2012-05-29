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

package com.gaiaframework.flow
{
	public class CrossFlow
	{		
		private static var isInDone:Boolean;
		private static var isOutDone:Boolean;
	
		internal static function start():void
		{
			isInDone = isOutDone = false;
			FlowManager.preload();
		}		
		internal static function afterPreloadDone():void
		{
			FlowManager.transitionOut();
			FlowManager.transitionIn();
		}
		internal static function afterTransitionInDone():void
		{
			isInDone = true;
			checkBothDone();
		}		
		internal static function afterTransitionOutDone():void
		{
			isOutDone = true;
			checkBothDone();
		}
		private static function checkBothDone():void
		{
			if (isInDone && isOutDone)
			{
				isInDone = isOutDone = false;
				FlowManager.complete();
			}
		}
	}
}