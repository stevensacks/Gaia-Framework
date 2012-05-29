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

import com.gaiaframework.debug.GaiaDebug;
import com.gaiaframework.core.SiteModel;
import com.gaiaframework.core.SiteView;
import com.gaiaframework.api.Gaia;
import com.gaiaframework.assets.*;

class com.gaiaframework.assets.AssetCreator
{	
	public static function create(node:Object, page:PageAsset):AbstractAsset
	{
		var type:String = node.attributes.type.toLowerCase();
		var ext:String = String(node.attributes.src.split(".").pop()).toLowerCase();
		try
		{
			var assetClass:Function = AssetTypes.getClass(type, ext);
			var asset:AbstractAsset = new assetClass();
			asset.node = node;
			asset.parseNode(page);
			return asset;
		}
		catch (e:Error)
		{
			throw new Error("Unknown asset type " + type + " | " + ext);
		}
		return null;
	}
	public static function add(nodes:Array, page:PageAsset):Void
	{
		var len:Number = nodes.length;
		if (len > 0)
		{
			if (page.assets == null) page.assets = {};
			for (var i:Number = 0; i < len; i++) 
			{
				var node:XML = nodes[i];
				SiteModel.validateNode(node);
				if (page.assets[node.attributes.id] == undefined) 
				{
					page.assets[node.attributes.id] = create(node, page);
					if (page.active) 
					{
						page.assets[node.attributes.id].init();
						if (page.assets[node.attributes.id] instanceof MovieClipAsset)
						{
							SiteView.instance.addAsset(page.assets[node.attributes.id]);
						}
					}
				}
				else
				{
					GaiaDebug.warn("*Add Asset Warning* Page '" + page.id + "' already has Asset '" + node.attributes.id + "'");
				}
			}
		}
	}
}