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
	import flash.text.StyleSheet;
	import flash.text.TextFormat;

	/**
	 * This is the interface for the <code>StyleSheetAsset</code>.
	 * 
	 * @see http://www.gaiaflashframework.com/wiki/index.php?title=Assets#StyleSheetAsset StyleSheetAsset Documentation
	 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/text/StyleSheet.html flash.text.StyleSheet
	 * 
	 * @author Steven Sacks
	 */
	public interface IStyleSheet extends IAsset
	{
		/**
		 * Returns the reference to the StyleSheet
		 */
		function get style():StyleSheet;
		/**
		 * A helper method for a common function with StyleSheets.
		 * <p>
		 * <code>return style.transform(style.getStyle(styleName));</code>
		 * </p>
		 * @param	styleName <string> 
		 * @return  TextFormat
		 */
		function transformStyle(styleName:String):TextFormat;
		// PROXY METHODS
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/text/StyleSheet.html#styleNames
		 */
		function get styleNames():Array
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/text/StyleSheet.html#clear() flash.text.StyleSheet.clear()
		 */
		function clear():void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/text/StyleSheet.html#getStyle() flash.text.StyleSheet.getStyle()
		 */
		function getStyle(styleName:String):Object;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/text/StyleSheet.html#setStyle() flash.text.StyleSheet.setStyle()
		 */
		function setStyle(styleName:String, styleObject:Object):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/text/StyleSheet.html#transform() flash.text.StyleSheet.transform()
		 */
		function transform(formatObject:Object):TextFormat;
	}
}