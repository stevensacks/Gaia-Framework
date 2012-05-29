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
	import com.gaiaframework.api.ISprite;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.ui.ContextMenu;

	public class SpriteAsset extends DisplayObjectAsset implements ISprite
	{
		protected var _container:DisplayObject;
		
		function SpriteAsset()
		{
			super();
		}
		public function get container():DisplayObject
		{
			return _container;
		}
		public function set container(value:DisplayObject):void
		{
			if (_container == null) _container = value;
		}
		public function get domain():String
		{
			return _domain;
		}
		public function set domain(value:String):void
		{
			_domain = value;
		}
		// PROXY SPRITE PROPERTIES
		public function get buttonMode():Boolean
		{
			return Sprite(_container).buttonMode;
		}
		public function set buttonMode(value:Boolean):void
		{
			Sprite(_container).buttonMode = value;
		}
		public function get dropTarget():DisplayObject
		{
			return Sprite(_container).dropTarget;
		}
		public function get graphics():Graphics
		{
			return Sprite(_container).graphics;
		}
		public function get hitArea():Sprite
		{
			return Sprite(_container).hitArea;
		}
		public function set hitArea(value:Sprite):void
		{
			Sprite(_container).hitArea = value;
		}
		public function get soundTransform():SoundTransform
		{
			return Sprite(_container).soundTransform;
		}
		public function set soundTransform(value:SoundTransform):void
		{
			Sprite(_container).soundTransform = value;
		}
		public function get useHandCursor():Boolean
		{
			return Sprite(_container).useHandCursor;
		}
		public function set useHandCursor(value:Boolean):void
		{
			Sprite(_container).useHandCursor = value;
		}
		// PROXY SPRITE FUNCTIONS
		public function startDrag(lockCenter:Boolean = false, bounds:Rectangle = null):void
		{
			Sprite(_container).startDrag(lockCenter, bounds);
		}
		public function stopDrag():void
		{
			Sprite(_container).stopDrag();
		}		
		// PROXY DISPLAY OBJECT CONTAINER PROPERTIES
		public function get mouseChildren():Boolean
		{
			return DisplayObjectContainer(_container).mouseChildren;
		}
		public function set mouseChildren(value:Boolean):void
		{
			DisplayObjectContainer(_container).mouseChildren = value;
		}
		public function get numChildren():int
		{
			return DisplayObjectContainer(_container).numChildren;
		}
		public function get tabChildren():Boolean
		{
			return DisplayObjectContainer(_container).tabChildren;
		}
		public function set tabChildren(value:Boolean):void
		{
			DisplayObjectContainer(_container).tabChildren = value;
		}
		// PROXY DISPLAY OBJECT CONTAINER FUNCTIONS
		public function addChild(child:DisplayObject):DisplayObject
		{
			return DisplayObjectContainer(_container).addChild(child);
		}
		public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return DisplayObjectContainer(_container).addChildAt(child, index);
		}
		public function areInaccessibleObjectsUnderPoint(point:Point):Boolean
		{
			return DisplayObjectContainer(_container).areInaccessibleObjectsUnderPoint(point);
		}
		public function contains(child:DisplayObject):Boolean
		{
			return DisplayObjectContainer(_container).contains(child);
		}
		public function getChildAt(index:int):DisplayObject
		{
			return DisplayObjectContainer(_container).getChildAt(index);
		}
		public function getChildByName(name:String):DisplayObject
		{
			return DisplayObjectContainer(_container).getChildByName(name);
		}
		public function getChildIndex(child:DisplayObject):int
		{
			return DisplayObjectContainer(_container).getChildIndex(child);
		}
		public function getObjectsUnderPoint(point:Point):Array
		{
			return DisplayObjectContainer(_container).getObjectsUnderPoint(point);
		}
		public function removeChild(child:DisplayObject):DisplayObject
		{
			return DisplayObjectContainer(_container).removeChild(child);
		}
		public function removeChildAt(index:int):DisplayObject
		{
			return DisplayObjectContainer(_container).removeChildAt(index);
		}
		public function setChildIndex(child:DisplayObject, index:int):void
		{
			DisplayObjectContainer(_container).setChildIndex(child, index);
		}
		public function swapChildren(child1:DisplayObject, child2:DisplayObject):void
		{
			DisplayObjectContainer(_container).swapChildren(child1, child2);
		}
		public function swapChildrenAt(index1:int, index2:int):void
		{
			DisplayObjectContainer(_container).swapChildrenAt(index1, index2);
		}
		// PROXY INTERACTIVE OBJECT PROPERTIES
		public function get contextMenu():ContextMenu
		{
			return InteractiveObject(_container).contextMenu;
		}
		public function set contextMenu(value:ContextMenu):void
		{
			InteractiveObject(_container).contextMenu = value;
		}
		public function get doubleClickEnabled():Boolean
		{
			return InteractiveObject(_container).doubleClickEnabled;
		}
		public function set doubleClickEnabled(value:Boolean):void
		{
			InteractiveObject(_container).doubleClickEnabled = value;
		}
		public function get focusRect():Object
		{
			return InteractiveObject(_container).focusRect;
		}
		public function set focusRect(value:Object):void
		{
			InteractiveObject(_container).focusRect = value;
		}
		public function get mouseEnabled():Boolean
		{
			return InteractiveObject(_container).mouseEnabled;
		}
		public function set mouseEnabled(value:Boolean):void
		{
			InteractiveObject(_container).mouseEnabled = value;
		}
		public function get tabEnabled():Boolean
		{
			return InteractiveObject(_container).tabEnabled;
		}
		public function set tabEnabled(value:Boolean):void
		{
			InteractiveObject(_container).tabEnabled = value;
		}
		public function get tabIndex():int
		{
			return InteractiveObject(_container).tabIndex;
		}
		public function set tabIndex(value:int):void
		{
			InteractiveObject(_container).tabIndex = value;
		}
		override public function toString():String
		{
			return "[SpriteAsset] " + _id;
		}
	}
}