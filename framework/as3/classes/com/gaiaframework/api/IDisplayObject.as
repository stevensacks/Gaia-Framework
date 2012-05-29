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
	import flash.accessibility.AccessibilityProperties;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;

	/**
	 * This is the interface for the <code>DisplayObjectAsset</code>.  DisplayObjectAsset extends AbstractAsset and is the base asset for SpriteAsset (and thus, MovieClipAsset), BitmapAsset and BitmapSpriteAsset.
	 * 
	 * @see http://www.gaiaflashframework.com/wiki/index.php?title=Assets#DisplayObjectAsset_.28AS3_only.29 DisplayObjectAsset Documentation
	 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html flash.display.DisplayObject
	 * 
	 * @author Steven Sacks
	 */
	public interface IDisplayObject extends IAsset
	{
		/**
		 * Specifies the depth container the asset is assigned to.
		 */
		function get depth():String;
		/**
		 * @private
		 */
		function set depth(value:String):void;
		/**
		 * Returns the loader.
		 */
		function get loader():Loader;
		
		// PROXY PROPERTIES
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#accessibilityProperties flash.display.DisplayObject.accessibilityProperties
		 */
		function get accessibilityProperties():AccessibilityProperties;
		/**
		 * @private
		 */
		function set accessibilityProperties(value:AccessibilityProperties):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#alpha flash.display.DisplayObject.alpha
		 */
		function get alpha():Number;
		/**
		 * @private
		 */
		function set alpha(value:Number):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#blendMode flash.display.DisplayObject.blendMode
		 */
		function get blendMode():String;
		/**
		 * @private
		 */
		function set blendMode(value:String):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#cacheAsBitmap flash.display.DisplayObject.cacheAsBitmap
		 */
		function get cacheAsBitmap():Boolean;
		/**
		 * @private
		 */
		function set cacheAsBitmap(value:Boolean):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#filters flash.display.DisplayObject.filters
		 */
		function get filters():Array;
		/**
		 * @private
		 */
		function set filters(value:Array):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#height flash.display.DisplayObject.height
		 */
		function get height():Number;
		/**
		 * @private
		 */
		function set height(value:Number):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#mask flash.display.DisplayObject.mask
		 */
		function get mask():DisplayObject;
		/**
		 * @private
		 */
		function set mask(value:DisplayObject):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#mouseX flash.display.DisplayObject.mouseX
		 */
		function get mouseX():Number;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#mouseY flash.display.DisplayObject.mouseY
		 */
		function get mouseY():Number;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#name flash.display.DisplayObject.name
		 */
		function get name():String;
		/**
		 * @private
		 */
		function set name(value:String):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#opaqueBackground flash.display.DisplayObject.opaqueBackground
		 */
		function get opaqueBackground():Object;
		/**
		 * @private
		 */
		function set opaqueBackground(value:Object):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#parent flash.display.DisplayObject.parent
		 */
		function get parent():DisplayObjectContainer;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#root flash.display.DisplayObject.root
		 */
		function get root():DisplayObject;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#rotation flash.display.DisplayObject.rotation
		 */
		function get rotation():Number;
		/**
		 * @private
		 */
		function set rotation(value:Number):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#scale9Grid flash.display.DisplayObject.scale9Grid
		 */
		function get scale9Grid():Rectangle;
		/**
		 * @private
		 */
		function set scale9Grid(value:Rectangle):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#scaleX flash.display.DisplayObject.scaleX
		 */
		function get scaleX():Number;
		/**
		 * @private
		 */
		function set scaleX(value:Number):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#scaleY flash.display.DisplayObject.scaleY
		 */
		function get scaleY():Number;
		/**
		 * @private
		 */
		function set scaleY(value:Number):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#scrollRect flash.display.DisplayObject.scrollRect
		 */
		function get scrollRect():Rectangle;
		/**
		 * @private
		 */
		function set scrollRect(value:Rectangle):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#stage flash.display.DisplayObject.stage
		 */
		function get stage():Stage;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#transform flash.display.DisplayObject.transform
		 */
		function get transform():Transform;
		/**
		 * @private
		 */
		function set transform(value:Transform):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#visible flash.display.DisplayObject.visible
		 */
		function get visible():Boolean;
		/**
		 * @private
		 */
		function set visible(value:Boolean):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#width flash.display.DisplayObject.width
		 */
		function get width():Number;
		/**
		 * @private
		 */
		function set width(value:Number):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#x flash.display.DisplayObject.x
		 */
		function get x():Number;
		/**
		 * @private
		 */
		function set x(value:Number):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#y flash.display.DisplayObject.y
		 */
		function get y():Number;
		/**
		 * @private
		 */
		function set y(value:Number):void;
		// PROXY FUNCTIONS
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#getBounds() flash.display.DisplayObject.getBounds()
		 */
		function getBounds(obj:DisplayObject):Rectangle;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#getRect() flash.display.DisplayObject.getRect()
		 */
		function getRect(obj:DisplayObject):Rectangle;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#globalToLocal() flash.display.DisplayObject.globalToLocal()
		 */
		function globalToLocal(point:Point):Point;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#hitTestObject() flash.display.DisplayObject.hitTestObject()
		 */
		function hitTestObject(obj:DisplayObject):Boolean;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#hitTestPoint() flash.display.DisplayObject.hitTestPoint()
		 */
		function hitTestPoint(px:Number, py:Number, shapeFlag:Boolean = false):Boolean;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/DisplayObject.html#localToGlobal() flash.display.DisplayObject.localToGlobal()
		 */
		function localToGlobal(point:Point):Point;
	}
}