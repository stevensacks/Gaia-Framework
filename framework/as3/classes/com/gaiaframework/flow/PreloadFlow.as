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
	public class PreloadFlow
	{		
		internal static function start():void
		{
			FlowManager.preload();
		}			
		internal static function afterPreloadDone():void
		{
			FlowManager.transitionOut();
		}
		internal static function afterTransitionOutDone():void
		{
			FlowManager.transitionIn();
		}		
		internal static function afterTransitionInDone():void
		{
			FlowManager.complete();
		}
	}
}