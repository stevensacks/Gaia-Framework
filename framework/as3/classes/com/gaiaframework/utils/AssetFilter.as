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

package com.gaiaframework.utils
{
	import com.gaiaframework.api.*;

	public class AssetFilter
	{
		public static function getSWF(assets:Object):Object
		{
			var obj:Object = {};
			for (var a:String in assets)
			{
				if (assets[a] is IMovieClip) obj[a] = assets[a];
			}
			return obj;
		}
		public static function getImage(assets:Object):Object
		{
			var obj:Object = {};
			for (var a:String in assets)
			{
				if (assets[a] is IBitmap) obj[a] = assets[a];
			}
			return obj;
		}
		public static function getSound(assets:Object):Object
		{
			var obj:Object = {};
			for (var a:String in assets)
			{
				if (assets[a] is ISound) obj[a] = assets[a];
			}
			return obj;
		}
		public static function getXML(assets:Object):Object
		{
			var obj:Object = {};
			for (var a:String in assets)
			{
				if (assets[a] is IXml) obj[a] = assets[a];
			}
			return obj;
		}
		public static function getNetStream(assets:Object):Object
		{
			var obj:Object = {};
			for (var a:String in assets)
			{
				if (assets[a] is INetStream) obj[a] = assets[a];
			}
			return obj;
		}
	}
}