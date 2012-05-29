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

import com.gaiaframework.assets.PageAsset;
import com.gaiaframework.core.SiteModel;
import com.gaiaframework.core.GaiaHQ;
import com.asual.swfaddress.SWFAddress;
import mx.utils.Delegate;

class com.gaiaframework.core.GaiaContextMenu
{
	private static var menu:ContextMenu;
	private static var customItems:Array;
	private static var gotoHash:Object;
	private static var separator:Boolean;
	
	public static function init(enable:Boolean):Void
	{
		menu = new ContextMenu();
		menu.hideBuiltInItems();
		customItems = [];
		if (enable)
		{
			gotoHash = {};
			separator = true;
			var title:String = SiteModel.title.split("%PAGE%").join("").split(SiteModel.delimiter).join("");
			var projectName:ContextMenuItem = new ContextMenuItem(title, GaiaContextMenu.deadClick);
			//projectName.enabled = false;
			customItems.push(projectName);
			addCustomMenuItems(SiteModel.menuArray);
		}
		var gaiaLink:ContextMenuItem = new ContextMenuItem("Built with Gaia Framework", GaiaContextMenu.onGaiaClick);
		gaiaLink.separatorBefore = true;
		customItems.push(gaiaLink);
		//
		menu.customItems = customItems;
		_root.menu = menu;
	}
	private static function addCustomMenuItems(pages:Array):Void
	{
		for (var i:Number = 0; i < pages.length; i++)
		{
			addPageToMenu(PageAsset(pages[i]));
		}
	}
	private static function addPageToMenu(page:PageAsset):Void
	{
		gotoHash[page.title] = page.branch;
		var cmi:ContextMenuItem = new ContextMenuItem(page.title);
		cmi.onSelect = Delegate.create(GaiaContextMenu, GaiaContextMenu.onGoto);
		cmi.separatorBefore = separator;
		separator = false;
		customItems.push(cmi);
	}
	private static function onGoto(obj:Object, menuItem:ContextMenuItem):Void
	{
		GaiaHQ.instance.goto(gotoHash[menuItem.caption]);
	}
	private static function onGaiaClick():Void
	{
		SWFAddress.href("http://www.gaiaflashframework.com/", "_blank");
	}
	private static function deadClick():Void {}
}