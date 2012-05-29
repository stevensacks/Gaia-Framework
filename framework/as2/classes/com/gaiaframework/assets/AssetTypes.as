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
import com.gaiaframework.assets.*;

class com.gaiaframework.assets.AssetTypes
{
	private static var TYPES:Object = {};
	private static var EXTENSIONS:Object = {};
	
	public static function getClass(type:String, ext:String):Function
	{
		return TYPES[type] || EXTENSIONS[ext];
	}
	public static function add(assetClass:Function, type:String, extensions:Array):Void
	{
		TYPES[type.toLowerCase()] = assetClass;
		if (extensions)
		{
			var i:Number = extensions.length;
			while (i--)
			{
				EXTENSIONS[extensions[i]] = assetClass;
			}
		}
	}
	public static function init():Void
	{
		add(MovieClipAsset, "movieclip", ["swf", "jpg", "jpeg", "png", "gif"]);
		add(NetStreamAsset, "netstream", ["flv", "m4a", "f4v"]);
		add(SoundAsset, "sound", ["mp3"]);
		add(SoundClipAsset, "soundclip");
		add(StyleSheetAsset, "stylesheet", ["css"]);
		add(XMLAsset, "xml", ["xml"]);
	}
}