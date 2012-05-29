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
	import com.gaiaframework.core.gaia_internal;

	public class AssetTypes
	{
		private static var TYPES:Object = {};
		private static var EXTENSIONS:Object = {};
		
		use namespace gaia_internal;
		
		internal static function getClass(type:String, ext:String):Class
		{
			return TYPES[type] || EXTENSIONS[ext];
		}
		gaia_internal static function add(assetClass:Class, type:String, extensions:Array = null):void
		{
			TYPES[type.toLowerCase()] = assetClass;
			if (extensions)
			{
				var i:int = extensions.length;
				while (i--)
				{
					EXTENSIONS[extensions[i]] = assetClass;
				}
			}
		}
		gaia_internal static function init():void
		{
			add(MovieClipAsset, "movieclip", ["swf"]);
			add(BitmapAsset, "bitmap", ["jpg", "jpeg", "png", "gif"]);
			add(BitmapSpriteAsset, "sprite");
			add(ByteArrayAsset, "bytearray");
			add(JSONAsset, "json", ["json"]);
			add(NetStreamAsset, "netstream", ["flv", "m4a", "f4v"]);
			add(StyleSheetAsset, "stylesheet", ["css"]);
			add(SoundAsset, "sound", ["mp3"]);
			add(TextAsset, "text", ["txt"]);
			add(XMLAsset, "xml", ["xml"]);
		}
	}
}
