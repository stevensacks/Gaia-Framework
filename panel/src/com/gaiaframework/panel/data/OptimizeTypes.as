/*****************************************************************************************************
* Gaia Framework for Adobe Flash ©2007-2009
* Author: Steven Sacks
*
* blog: http://www.stevensacks.net/
* forum: http://www.gaiaflashframework.com/forum/
* wiki: http://www.gaiaflashframework.com/wiki/
* 
* By using the Gaia Framework, you agree to keep the above contact information in the source code.
* 
* Gaia Framework for Adobe Flash is released under the GPL License:
* http://www.opensource.org/licenses/mit-license.php 
*****************************************************************************************************/

package com.gaiaframework.panel.data
{
	[Bindable]
	public class OptimizeTypes
	{
		public var bitmapAsset:Boolean = true;
		public var bitmapSpriteAsset:Boolean = true;
		public var soundAsset:Boolean = true;
		public var soundClipAsset:Boolean = true;
		public var netStreamAsset:Boolean = true;
		public var styleSheetAsset:Boolean = true;
		public var jsonAsset:Boolean = true;
		public var xmlAsset:Boolean = true;
		public var textAsset:Boolean = true;
		public var byteArrayAsset:Boolean = true;
		
		public function OptimizeTypes()
		{
			//
		}
		public function toString():String
		{
			var str:String = "bitmapAsset: " + bitmapAsset;
			str += "\nbitmapSpriteAsset: " + bitmapSpriteAsset;
			str += "\nsoundAsset: " + soundAsset;
			str += "\nsoundClipAsset: " + soundClipAsset;
			str += "\nnetStreamAsset: " + netStreamAsset;
			str += "\ntextAsset: " + textAsset;
			str += "\nstyleSheetAsset: " + styleSheetAsset;
			str += "\njsonAsset: " + jsonAsset;
			str += "\nxmlAsset: " + xmlAsset;
			str += "\nbyteArrayAsset: " + byteArrayAsset;
			return str;
		}
	}
}