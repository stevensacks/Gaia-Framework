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
	import com.gaiaframework.assets.AbstractAsset;
	import com.gaiaframework.assets.PageAsset;

	// Used by BranchLoader to create an array in order of pages and assets that are part of a particular branch.

	public class BranchIterator
	{
		private static var items:Array;
		private static var index:int;
		
		public static function init(branch:String):int
		{
			var branchArray:Array = branch.split("/");
			items = [];
			index = -1;
			var page:PageAsset = SiteModel.tree;
			addPage(page);
			for (var i:int = 1; i < branchArray.length; i++)
			{
				addPage(page = page.children[branchArray[i]]);
			}
			return items.length;
		}
		public static function next():AbstractAsset
		{
			if (++index < items.length) return items[index];
			return null;
		}
		private static function addPage(page:PageAsset):void
		{
			items.push(page);
			if (page.assets != null) 
			{
				var assets:Array = page.assetArray;
				var len:int = assets.length;
				for (var i:int = 0; i < len; i++)
				{
					items.push(assets[i]);
				}
			}
		}
	}
}