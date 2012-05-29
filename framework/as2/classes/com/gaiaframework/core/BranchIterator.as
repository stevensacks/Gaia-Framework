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

import com.gaiaframework.assets.AbstractAsset;
import com.gaiaframework.assets.PageAsset;
import com.gaiaframework.core.SiteModel;

// Used by BranchLoader to create an array in order of pages and assets that are part of a particular branch.

class com.gaiaframework.core.BranchIterator
{
	private static var items:Array;
	private static var index:Number;
	
	public static function init(branch:String):Number
	{
		var branchArray:Array = branch.split("/");
		items = [];
		index = -1;
		var page:PageAsset = SiteModel.tree;
		addPage(page);
		for (var i:Number = 1; i < branchArray.length; i++)
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
	private static function addPage(page:PageAsset):Void
	{
		items.push(page);
		if (page.assets != undefined) 
		{
			for (var a:String in page.assets)
			{
				var asset:AbstractAsset = page.assets[a];
				items.push(asset);
			}
		}
	}
}