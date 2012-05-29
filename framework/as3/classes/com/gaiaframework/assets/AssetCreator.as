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

package com.gaiaframework.assets
{
	import com.gaiaframework.api.Gaia;
	import com.gaiaframework.api.IPageAsset;
	import com.gaiaframework.core.SiteModel;
	import com.gaiaframework.core.SiteView;
	import com.gaiaframework.debug.GaiaDebug;

	public class AssetCreator
	{
		public static function create(node:XML, page:IPageAsset):AbstractAsset
		{
			var type:String = String(node.@type).toLowerCase();
			var ext:String = String(node.@src.split(".").pop()).toLowerCase();
			try
			{
				var assetClass:Class = AssetTypes.getClass(type, ext);
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
		public static function add(nodes:XMLList, page:IPageAsset):void
		{
			var len:int = nodes.length();
			if (len > 0)
			{
				var order:int = 0;
				var asset:AbstractAsset;
				if (page.assets != null)
				{
					for each (asset in page.assets)
					{
						if (asset.order > order) order = asset.order;
					}
				}
				else
				{
					page.assets = {};
				}
				for (var i:int = 0; i < len; i++) 
				{
					var node:XML = nodes[i];
					SiteModel.validateNode(node);
					if (!page.assets.hasOwnProperty(node.@id))
					{
						page.assets[node.@id] = create(node, page);
						AbstractAsset(page.assets[node.@id]).order = ++order;
						if (AbstractAsset(page).active) 
						{
							AbstractAsset(page.assets[node.@id]).init();
							if (page.assets[node.@id] is DisplayObjectAsset)
							{
								SiteView.instance.addAsset(page.assets[node.@id]);
								if (page.assets[node.@id].depth == Gaia.NESTED)
								{
									if (page.assets[node.@id] is BitmapSpriteAsset) page.content.addChild(BitmapSpriteAsset(page.assets[node.@id]).container);
									else page.content.addChild(DisplayObjectAsset(page.assets[node.@id]).loader);
								}
							}
						}
					}
					else
					{
						GaiaDebug.warn("*Add Asset Warning* Page '" + page.id + "' already has Asset '" + node.@id + "'");
					}
				}
			}
		}
	}
}