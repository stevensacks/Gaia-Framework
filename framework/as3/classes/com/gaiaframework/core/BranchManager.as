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

package com.gaiaframework.core
{
	import com.gaiaframework.assets.PageAsset;

	public class BranchManager
	{	
		private static var activePages:Object = {};
		
		public static function addPage(page:PageAsset):void
		{
			activePages[page.branch] = page;
		}
		public static function getTransitionOutArray(newBranch:String):Array
		{
			cleanup();
			newBranch += "/";
			var transitionOutArray:Array = [];
			for (var a:String in activePages)
			{
				if (newBranch.indexOf(a + "/") == -1) transitionOutArray.push(activePages[a]);
			}
			transitionOutArray.sort(sortByBranchDepth);
			return transitionOutArray;
		}
		public static function cleanup():void
		{
			for (var a:String in activePages)
			{
				if (!activePages[a].active) delete activePages[a];
			}
		}
		private static function sortByBranchDepth(a:PageAsset, b:PageAsset):int
		{
			var aLen:int = a.branch.split("/").length;
			var bLen:int = b.branch.split("/").length;
			if (aLen < bLen)return -1;
			else if (aLen > bLen) return 1;
			else return 0;
		}
	}
}