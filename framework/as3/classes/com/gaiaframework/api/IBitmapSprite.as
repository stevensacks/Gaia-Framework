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

package com.gaiaframework.api
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	/**
	 * This is the interface for the <code>BitmapSpriteAsset</code>.
	 * This is a version of the BitmapAsset that you can add interactivity to because BitmapSpriteAssets are wrapped inside a Sprite container, and the asset provides a proxy to the Sprite methods. Set the <code>type="sprite"</code> in the asset node to turn a BitmapAsset into a BitmapSpriteAsset.
	 * 
	 * @see http://www.gaiaflashframework.com/wiki/index.php?title=Assets#BitmapSpriteAsset_.28AS3_only.29 BitmapSpriteAsset Documentation
	 * 
	 * @author Steven Sacks
	 */
	public interface IBitmapSprite extends ISprite
	{
		/**
		 * Returns the loader.content Bitmap.
		 */
		function get content():Bitmap;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/Bitmap.html#bitmapData flash.display.Bitmap.bitmapData
		 */
		function get bitmapData():BitmapData;
		/**
		 * @private
		 */
		function set bitmapData(value:BitmapData):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/Bitmap.html#pixelSnapping flash.display.Bitmap.pixelSnapping
		 */
		function get pixelSnapping():String;
		/**
		 * @private
		 */
		function set pixelSnapping(value:String):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/Bitmap.html#smoothing flash.display.Bitmap.smoothing
		 */
		function get smoothing():Boolean;
		/**
		 * @private
		 */
		function set smoothing(value:Boolean):void;
	}
}