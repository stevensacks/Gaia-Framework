/*****************************************************************************************************
* Gaia Framework for Adobe Flash ©2007-2012
* Author: Steven Sacks
*
* forum: http://www.gaiaflashframework.com/forum/
* wiki: http://www.gaiaflashframework.com/wiki/
* 
* By using the Gaia Framework, you agree to keep the above contact information in the source code.
* 
* Gaia Framework for Adobe Flash is released under the MIT License:
* http://www.opensource.org/licenses/mit-license.php 
*****************************************************************************************************/

package com.gaiaframework.panel.skin
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import mx.core.UIComponent;

	public class BackgroundTile extends UIComponent
	{		
		[Embed("/assets/flash/gaia_panel_cross_pattern.png")]
		private var Pattern:Class;
		
		private var bitmap:Bitmap;
		private var tile:Shape;
		
		public function BackgroundTile()
		{
			super();
		}
		override protected function createChildren():void
		{
			bitmap = new Pattern() as Bitmap;
			tile = new Shape();
			addChild(tile);
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			tile.graphics.clear();
			tile.graphics.beginBitmapFill(bitmap.bitmapData);
			tile.graphics.drawRect(0, 0, width, height);
			tile.graphics.endFill();
		}
	}
}