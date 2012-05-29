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
	import com.gaiaframework.api.IBitmapSprite;

	import flash.accessibility.AccessibilityProperties;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;

	public class BitmapSpriteAsset extends SpriteAsset implements IBitmapSprite
	{
		public function BitmapSpriteAsset()
		{
			super();
		}
		public function get content():Bitmap
		{
			return Bitmap(_loader.content);
		}
		override public function destroy():void 
		{
			super.destroy();
			if (_container != null && container.parent) _container.parent.removeChild(_container);
			_container = null;
		}
		// BITMAP PROXY PROPERTIES
		public function get pixelSnapping():String
		{
			return Bitmap(_loader.content).pixelSnapping;
		}
		public function set pixelSnapping(value:String):void
		{
			Bitmap(_loader.content).pixelSnapping = value;
		}
		public function get bitmapData():BitmapData
		{
			return Bitmap(_loader.content).bitmapData;
		}
		public function set bitmapData(value:BitmapData):void
		{
			Bitmap(_loader.content).bitmapData = value;
		}		
		public function get smoothing():Boolean
		{
			return Bitmap(_loader.content).smoothing;
		}
		public function set smoothing(value:Boolean):void
		{
			Bitmap(_loader.content).smoothing = value;
		}
		// DISPLAY OBJECT OVERRIDE PROXY PROPERTIES
		override public function get accessibilityProperties():AccessibilityProperties
		{
			return _container.accessibilityProperties;
		}
		override public function set accessibilityProperties(value:AccessibilityProperties):void
		{
			_container.accessibilityProperties = value;
		}
		override public function get alpha():Number
		{
			return _container.alpha;
		}
		override public function set alpha(value:Number):void
		{
			_container.alpha = value;
		}
		override public function get blendMode():String
		{
			return _container.blendMode;
		}
		override public function set blendMode(value:String):void
		{
			_container.blendMode = value;
		}
		override public function get cacheAsBitmap():Boolean
		{
			return _container.cacheAsBitmap;
		}
		override public function set cacheAsBitmap(value:Boolean):void
		{
			_container.cacheAsBitmap = value;
		}
		override public function get filters():Array
		{
			return _container.filters;
		}
		override public function set filters(value:Array):void
		{
			_container.filters = value;
		}
		override public function get height():Number
		{
			return _container.height;
		}
		override public function set height(value:Number):void
		{
			_container.height = value;
		}
		override public function get mask():DisplayObject
		{
			return _container.mask;
		}
		override public function set mask(value:DisplayObject):void
		{
			_container.mask = value;
		}
		override public function get mouseX():Number
		{
			return _container.mouseX;
		}
		override public function get mouseY():Number
		{
			return _container.mouseY;
		}		
		override public function get name():String
		{
			return _container.name;
		}
		override public function set name(value:String):void
		{
			_container.name = value;
		}
		override public function get opaqueBackground():Object
		{
			return _container.opaqueBackground;
		}
		override public function set opaqueBackground(value:Object):void
		{
			_container.opaqueBackground = value;
		}
		override public function get parent():DisplayObjectContainer
		{
			return _loader.parent;
		}
		override public function get root():DisplayObject
		{
			return _container.root;
		}
		override public function get rotation():Number
		{
			return _container.rotation;
		}
		override public function set rotation(value:Number):void
		{
			_container.rotation = value;
		}
		override public function get scale9Grid():Rectangle
		{
			return _container.scale9Grid;
		}
		override public function set scale9Grid(value:Rectangle):void
		{
			_container.scale9Grid = value;
		}		
		override public function get scaleX():Number
		{
			return _container.scaleX;
		}
		override public function set scaleX(value:Number):void
		{
			_container.scaleX = value;
		}
		override public function get scaleY():Number
		{
			return _container.scaleY;
		}
		override public function set scaleY(value:Number):void
		{
			_container.scaleY = value;
		}
		override public function get scrollRect():Rectangle
		{
			return _container.scrollRect;
		}
		override public function set scrollRect(value:Rectangle):void
		{
			_container.scrollRect = value;
		}
		override public function get stage():Stage
		{
			return _container.stage;
		}
		override public function get transform():Transform
		{
			return _container.transform;
		}
		override public function set transform(value:Transform):void
		{
			_container.transform = value;
		}
		override public function get visible():Boolean
		{
			return _container.visible;
		}
		override public function set visible(value:Boolean):void
		{
			_container.visible = _loader.content.visible = value;
		}
		override public function get width():Number
		{
			return _container.width;
		}
		override public function set width(value:Number):void
		{
			_container.width = value;
		}
		override public function get x():Number
		{
			return _container.x;
		}
		override public function set x(value:Number):void
		{
			_container.x = value;
		}
		override public function get y():Number
		{
			return _container.y;
		}
		override public function set y(value:Number):void
		{
			_container.y = value;
		}
		// OVERRIDE PROXY FUNCTIONS
		override public function getBounds(obj:DisplayObject):Rectangle
		{
			return _container.getBounds(obj);
		}
		override public function getRect(obj:DisplayObject):Rectangle
		{
			return _container.getRect(obj);
		}
		override public function globalToLocal(point:Point):Point
		{
			return _container.globalToLocal(point);
		}
		override public function hitTestObject(obj:DisplayObject):Boolean
		{
			return content.hitTestObject(obj);
		}
		override public function hitTestPoint(px:Number, py:Number, shapeFlag:Boolean = false):Boolean
		{
			return content.hitTestPoint(px, py, shapeFlag);
		}
		override public function localToGlobal(point:Point):Point
		{
			return _container.localToGlobal(point);
		}
		//
		override public function toString():String
		{
			return "[BitmapSpriteAsset] " + _id;
		}
	}
}