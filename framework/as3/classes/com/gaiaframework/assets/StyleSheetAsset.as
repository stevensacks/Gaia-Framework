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
	import com.gaiaframework.api.IStyleSheet;

	import flash.events.Event;
	import flash.text.StyleSheet;
	import flash.text.TextFormat;

	public class StyleSheetAsset extends TextAsset implements IStyleSheet
	{
		private var _style:StyleSheet;
				
		function StyleSheetAsset() 
		{
			_style = new StyleSheet();
			super();
		}		
		public function get style():StyleSheet 
		{
			return _style;
		}		
		override protected function onComplete(event:Event):void
		{
			super.onComplete(event);
			_style.parseCSS(_data);
		}
		// HELPER METHOD
		public function transformStyle(styleName:String):TextFormat
		{
			return _style.transform(_style.getStyle(styleName));
		}
		// PROXY METHODS
		public function get styleNames():Array
		{
			return _style.styleNames;
		}
		public function clear():void
		{
			_style.clear();
		}
		public function getStyle(styleName:String):Object
		{
			return _style.getStyle(styleName);
		}
		public function setStyle(styleName:String, styleObject:Object):void
		{
			_style.setStyle(styleName, styleObject);
		}
		public function transform(formatObject:Object):TextFormat
		{
			return _style.transform(formatObject);
		}
		override public function toString():String
		{
			return "[StyleSheetAsset] " + _id + " : " + _order + " ";
		}
	}
}