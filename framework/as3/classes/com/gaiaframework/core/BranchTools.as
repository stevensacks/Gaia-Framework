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

	public class BranchTools
	{
		public static function getPage(branch:String):PageAsset
		{
			var branchArray:Array = branch.split("/");
			var page:PageAsset = SiteModel.tree;
			for (var i:int = 1; i < branchArray.length; i++)
			{
				page = page.children[branchArray[i]];
			}
			return page;
		}
		
		// get valid branch returns a branch that is defined in the site.xml
		public static function getValidBranch(branch:String):String
		{
			var branchArray:Array = branch.split("/");
			var page:PageAsset = SiteModel.tree;
			var validBranch:Array = [];
			if (branchArray[0] != SiteModel.indexID) branchArray.unshift(SiteModel.indexID);
			validBranch.push(branchArray[0]);
			for (var i:int = 1; i < branchArray.length; i++)
			{
				if (page.children != null && page.children[branchArray[i]] != null) 
				{
					page = page.children[branchArray[i]];
					validBranch.push(branchArray[i]);
				} 
				else 
				{
					break;
				}
			}
			var returnBranch:String = validBranch.join("/");
			return getDefaultChildBranch(returnBranch);
		}
		public static function getFullBranch(branch:String):String
		{
			var validBranch:String = getValidBranch(branch);
			if (branch.indexOf(validBranch) > -1) return branch;
			return validBranch;
		}
		public static function getPagesOfBranch(branch:String):Array
		{
			var branchArray:Array = branch.split("/");
			var pageArray:Array = [];
			var page:PageAsset = SiteModel.tree;
			pageArray.push(page);
			for (var i:Number = 1; i < branchArray.length; i++)
			{
				pageArray.push(page = page.children[branchArray[i]]);
			}
			return pageArray;
		}
		public static function getValidRoute(route:String):String
		{
			var routeArray:Array = route.split("/");
			var routes:Object = SiteModel.routes;
			for (var a:String in routes)
			{
				if (a == route) return route;
			}
			routeArray.length--;
			if (routeArray.length == 0) return "";
			return getValidRoute(routeArray.join("/"));
		}
		private static function getDefaultChildBranch(branch:String):String
		{
			var page:PageAsset = getPage(branch);
			if (page.landing || page.defaultChild == null) return branch;
			return getDefaultChildBranch(page.children[page.defaultChild].branch);
		}
	}
}