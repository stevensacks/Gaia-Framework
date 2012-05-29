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

package com.gaiaframework.core
{	
	import com.gaiaframework.debug.GaiaDebug;

	import flash.system.ApplicationDomain;
	import flash.text.Font;

	public class GaiaFonts
	{
		private static var _fonts:Object = {};
		private static var _availableFonts:Array = [];
		
		public static function getFontName(className:String):String
		{
			return _fonts[className];
		}
		public static function getAvailableFonts():Array
		{
			return _availableFonts;
		}
		public static function registerFonts(fontDomain:ApplicationDomain, classNames:Array):void
		{
			// extract the font(s) from the swf
			var i:int = classNames.length;
			while (i--)
			{
				var validFont:Boolean = false;
				var className:String = String(classNames[i]);
				if (fontDomain.hasDefinition(className)) 
				{
					var fontClass:Class = fontDomain.getDefinition(className) as Class;
					if (fontClass)
					{
						// this will throw an error if the font class name provided does not extend flash.text.Font
						Font.registerFont(fontClass);
						var font:Font = new fontClass() as Font;
						if (font)
						{
							// font is valid, add to the available fonts
							_fonts[className] = font.fontName;
							_availableFonts.push(className);
							validFont = true;
						}
					}
				}
				if (!validFont) GaiaDebug.warn('Invalid Font "' + className + '"');
			}			
		}
	}
}
