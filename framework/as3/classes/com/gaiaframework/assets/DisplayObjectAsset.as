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
	import com.gaiaframework.api.Gaia;
	import com.gaiaframework.api.IDisplayObject;
	import com.gaiaframework.api.IPageAsset;
	import com.gaiaframework.core.SiteModel;
	import com.gaiaframework.debug.GaiaDebug;
	import com.gaiaframework.events.AssetEvent;
	import com.gaiaframework.events.PageEvent;

	import flash.accessibility.AccessibilityProperties;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class DisplayObjectAsset extends AbstractAsset implements IDisplayObject
	{
		protected var _depth:String;		
		protected var _loader:Loader;
		protected var _domain:String;
		protected var loaderContext:LoaderContext;
		
		public function DisplayObjectAsset()
		{
			super();
		}
		public function get loader():Loader
		{
			return _loader;
		}
		override public function init():void
		{
			if (_loader != null) destroy();
			_loader = new Loader();
			_loader.visible = false;
			_loader.mouseEnabled = false;
			addListeners(_loader.contentLoaderInfo);
			super.init();
		}
		override public function preload():void
		{
			try 
			{
				if (_domain == Gaia.DOMAIN_NEW) loaderContext = new LoaderContext(true, new ApplicationDomain());
				else if (_domain == Gaia.DOMAIN_CURRENT) loaderContext = new LoaderContext(true, ApplicationDomain.currentDomain);
				else loaderContext = new LoaderContext(true);
				loaderContext.checkPolicyFile = true;
				_loader.load(request, loaderContext);
			}
			catch (error:Error)
			{
				GaiaDebug.error(this + ".preload()", error.name + " :: " + error.message);
			}
			super.load();
		}
		override public function load(...args):void
		{
			AssetLoader.instance.load(this);
		}
		override internal function loadOnDemand():void 
		{
			preload();
		}
		override public function parseNode(page:IPageAsset):void 
		{
			super.parseNode(page);
			var d:String = String(_node.@domain).toLowerCase();
			if (d == Gaia.DOMAIN_NEW || d == Gaia.DOMAIN_CURRENT) _domain = d;
			else _domain = SiteModel.domain;
			d = String(_node.@depth).toLowerCase();
			if (d == Gaia.TOP || d == Gaia.BOTTOM || d == Gaia.MIDDLE || d == Gaia.PRELOADER || d == Gaia.NESTED) _depth = d;
			else _depth = page.depth;
		}
		override public function destroy():void 
		{
			if (_loader != null)
			{
				removeListeners(_loader.contentLoaderInfo);
				if (_loader.parent) _loader.parent.removeChild(_loader);
				try
				{
					_loader["unloadAndStop"]();
				}
				catch (e:Error)
				{
					try
					{
						_loader.unload();
					}
					catch (e:Error)
					{
						// fail gracefully
					}
				}
				_loader = null;
			}
			super.destroy();
		}
		override public function abort():void
		{
			AssetLoader.instance.abort(this);
			try 
			{
				_loader.close();
			}
			catch (error:Error)
			{
				// it did not need to be closed so fail gracefully
			}
		}
		override public function retry():void
		{
			abort();
			try 
			{
				_loader.load(request, loaderContext);
			}
			catch (error:Error)
			{
				GaiaDebug.error(this + ".retry()", error.name + " :: " + error.message); 
			}
		}
		override protected function onComplete(event:Event):void
		{
			removeListeners(_loader.contentLoaderInfo);
			_loader.content.visible = false;
			_loader.visible = true;
			super.onComplete(event);
		}
		override public function getBytesLoaded():int
		{
			return _loader.contentLoaderInfo.bytesLoaded || 0;
		}
		override public function getBytesTotal():int
		{
			return _loader.contentLoaderInfo.bytesTotal || 0;
		}
		public function get depth():String
		{
			return _depth;
		}
		public function set depth(value:String):void
		{
			_depth = value;
		}
		
		// PROXY PROPERTIES
		public function get accessibilityProperties():AccessibilityProperties
		{
			return _loader.content.accessibilityProperties;
		}
		public function set accessibilityProperties(value:AccessibilityProperties):void
		{
			_loader.content.accessibilityProperties = value;
		}
		public function get alpha():Number
		{
			return _loader.content.alpha;
		}
		public function set alpha(value:Number):void
		{
			_loader.content.alpha = value;
		}
		public function get blendMode():String
		{
			return _loader.content.blendMode;
		}
		public function set blendMode(value:String):void
		{
			_loader.content.blendMode = value;
		}
		public function get cacheAsBitmap():Boolean
		{
			return _loader.content.cacheAsBitmap;
		}
		public function set cacheAsBitmap(value:Boolean):void
		{
			_loader.content.cacheAsBitmap = value;
		}
		public function get filters():Array
		{
			return _loader.content.filters;
		}
		public function set filters(value:Array):void
		{
			_loader.content.filters = value;
		}
		public function get height():Number
		{
			return _loader.content.height;
		}
		public function set height(value:Number):void
		{
			_loader.content.height = value;
		}
		public function get mask():DisplayObject
		{
			return _loader.content.mask;
		}
		public function set mask(value:DisplayObject):void
		{
			_loader.content.mask = value;
		}
		public function get mouseX():Number
		{
			return _loader.content.mouseX;
		}
		public function get mouseY():Number
		{
			return _loader.content.mouseY;
		}		
		public function get name():String
		{
			return _loader.content.name;
		}
		public function set name(value:String):void
		{
			_loader.content.name = value;
		}
		public function get opaqueBackground():Object
		{
			return _loader.content.opaqueBackground;
		}
		public function set opaqueBackground(value:Object):void
		{
			_loader.content.opaqueBackground = value;
		}
		public function get parent():DisplayObjectContainer
		{
			return _loader.parent;
		}
		public function get root():DisplayObject
		{
			return _loader.content.root;
		}
		public function get rotation():Number
		{
			return _loader.content.rotation;
		}
		public function set rotation(value:Number):void
		{
			_loader.content.rotation = value;
		}
		public function get scale9Grid():Rectangle
		{
			return _loader.content.scale9Grid;
		}
		public function set scale9Grid(value:Rectangle):void
		{
			_loader.content.scale9Grid = value;
		}		
		public function get scaleX():Number
		{
			return _loader.content.scaleX;
		}
		public function set scaleX(value:Number):void
		{
			_loader.content.scaleX = value;
		}
		public function get scaleY():Number
		{
			return _loader.content.scaleY;
		}
		public function set scaleY(value:Number):void
		{
			_loader.content.scaleY = value;
		}
		public function get scrollRect():Rectangle
		{
			return _loader.content.scrollRect;
		}
		public function set scrollRect(value:Rectangle):void
		{
			_loader.content.scrollRect = value;
		}
		public function get stage():Stage
		{
			return _loader.content.stage;
		}
		public function get transform():Transform
		{
			return _loader.content.transform;
		}
		public function set transform(value:Transform):void
		{
			_loader.content.transform = value;
		}
		public function get visible():Boolean
		{
			return _loader.content.visible;
		}
		public function set visible(value:Boolean):void
		{
			_loader.content.visible = value;
		}
		public function get width():Number
		{
			return _loader.content.width;
		}
		public function set width(value:Number):void
		{
			_loader.content.width = value;
		}
		public function get x():Number
		{
			return _loader.content.x;
		}
		public function set x(value:Number):void
		{
			_loader.content.x = value;
		}
		public function get y():Number
		{
			return _loader.content.y;
		}
		public function set y(value:Number):void
		{
			_loader.content.y = value;
		}
		// PROXY FUNCTIONS
		public function getBounds(obj:DisplayObject):Rectangle
		{
			return _loader.content.getBounds(obj);
		}
		public function getRect(obj:DisplayObject):Rectangle
		{
			return _loader.content.getRect(obj);
		}
		public function globalToLocal(point:Point):Point
		{
			return _loader.content.globalToLocal(point);
		}
		public function hitTestObject(obj:DisplayObject):Boolean
		{
			return _loader.content.hitTestObject(obj);
		}
		public function hitTestPoint(px:Number, py:Number, shapeFlag:Boolean = false):Boolean
		{
			return _loader.content.hitTestPoint(px, py, shapeFlag);
		}
		public function localToGlobal(point:Point):Point
		{
			return _loader.content.localToGlobal(point);
		}
		
		// EVENT LISTENER OVERRIDES
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			if (type != AssetEvent.ASSET_PROGRESS && type != AssetEvent.ASSET_COMPLETE && type != AssetEvent.ASSET_ERROR && type != IOErrorEvent.IO_ERROR && type != PageEvent.TRANSITION_IN_COMPLETE && type != PageEvent.TRANSITION_OUT_COMPLETE)
			{
				if (this is BitmapSpriteAsset) _loader.parent.addEventListener(type, listener, useCapture, priority, useWeakReference);
				else _loader.content.addEventListener(type, listener, useCapture, priority, useWeakReference);
			}
			else
			{
				super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			}
		}
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			if (type != AssetEvent.ASSET_PROGRESS && type != AssetEvent.ASSET_COMPLETE && type != AssetEvent.ASSET_ERROR && type != IOErrorEvent.IO_ERROR && type != PageEvent.TRANSITION_IN_COMPLETE && type != PageEvent.TRANSITION_OUT_COMPLETE)
			{
				if (this is BitmapSpriteAsset) _loader.parent.removeEventListener(type, listener, useCapture);
				else _loader.content.removeEventListener(type, listener, useCapture);
			}
			else
			{
				super.removeEventListener(type, listener, useCapture);
			}
		}
	}
}