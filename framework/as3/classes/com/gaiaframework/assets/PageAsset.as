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
	import com.gaiaframework.api.IAsset;
	import com.gaiaframework.api.IPage;
	import com.gaiaframework.api.IPageAsset;
	import com.gaiaframework.core.GaiaImpl;
	import com.gaiaframework.core.GaiaSWFAddress;
	import com.gaiaframework.debug.GaiaDebug;
	import com.gaiaframework.events.GaiaSWFAddressEvent;
	import com.gaiaframework.events.PageEvent;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	public class PageAsset extends MovieClipAsset implements IPageAsset
	{
		private var _parent:IPageAsset;
		private var _children:Object;
		private var _assets:Object;
		private var _external:Boolean;
		private var _menu:Boolean;
		private var _flow:String;
		private var _defaultChild:String;
		private var _route:String;
		private var _assetPath:String;
		private var _window:String;
		private var _landing:Boolean;
		
		private var isTransitionedIn:Boolean;
		
		public function PageAsset()
		{
			super();
			isTransitionedIn = false;
		}
		public function getParent():IPageAsset
		{
			return _parent;
		}
		public function setParent(value:IPageAsset):void
		{
			if (_parent == null) _parent = value;
		}
		public function get branch():String
		{
			if (_parent != null) return _parent.branch + "/" + id;
			return id;
		}
		public function get copy():Object
		{
			if (assets != null && assets.seo != null && assets.seo is SEOAsset) return SEOAsset(assets.seo).copy;
			return null;
		}
		public function transitionIn():void
		{
			try
			{
				if (!isTransitionedIn) 
				{
					initAssets();
					IPage(_loader.content).transitionIn();
				}
				else onTransitionInComplete();
			}
			catch (e:Error)
			{
				GaiaDebug.error(e.getStackTrace());
				onTransitionInComplete();
			}
		}
		public function transitionOut():void
		{
			try
			{
				GaiaSWFAddress.instance.removeEventListener(GaiaSWFAddressEvent.DEEPLINK, onDeeplink);
				if (isTransitionedIn) IPage(_loader.content).transitionOut();
				else onTransitionOutComplete();
			}
			catch (e:Error)
			{
				GaiaDebug.error(e.getStackTrace());
				onTransitionOutComplete();
			}
		}
		override public function destroy():void
		{
			isTransitionedIn = false;
			if (IPage(_loader.content) != null)
			{
				IPage(_loader.content).removeEventListener(PageEvent.TRANSITION_IN_COMPLETE, onTransitionInComplete);
				IPage(_loader.content).removeEventListener(PageEvent.TRANSITION_OUT_COMPLETE, onTransitionOutComplete);
				IPage(_loader.content).page = null;
			}
			GaiaSWFAddress.instance.removeEventListener(GaiaSWFAddressEvent.DEEPLINK, onDeeplink);
			var ia:AbstractAsset;
			for each (ia in assets)
			{
				ia.abort();
				ia.destroy();
			}
			super.destroy();
		}
		private function decorate():void
		{
			IPage(_loader.content).addEventListener(PageEvent.TRANSITION_IN_COMPLETE, onTransitionInComplete);
			IPage(_loader.content).addEventListener(PageEvent.TRANSITION_OUT_COMPLETE, onTransitionOutComplete);
			IPage(_loader.content).page = this;
		}
		private function initAssets():void
		{
			for each (var asset:AbstractAsset in assets)
			{
				if ((asset as DisplayObjectAsset) && DisplayObjectAsset(asset).depth == Gaia.NESTED) 
				{
					if (asset is BitmapSpriteAsset) content.addChild(BitmapSpriteAsset(asset).container);
					else content.addChild(DisplayObjectAsset(asset).loader);
				}
			}
		}
		// EVENT LISTENERS
		private function onTransitionInComplete(event:Event = null):void
		{
			isTransitionedIn = true;
			dispatchEvent(new PageEvent(PageEvent.TRANSITION_IN_COMPLETE));
		}
		private function onTransitionOutComplete(event:Event = null):void
		{
			destroy();
			dispatchEvent(new PageEvent(PageEvent.TRANSITION_OUT_COMPLETE));
		}
		// decorate and make visible (MovieClipAsset default is false)
		override protected function onComplete(event:Event):void
		{
			decorate();
			if (depth == Gaia.NESTED) DisplayObjectContainer(getParent().content).addChild(_loader);
			GaiaSWFAddress.instance.addEventListener(GaiaSWFAddressEvent.DEEPLINK, onDeeplink);
			isTransitionedIn = false;
			super.onComplete(event);
			_loader.content.visible = true;
		}
		// GaiaSWFAddress sends deeplink events to active pages
		private function onDeeplink(event:GaiaSWFAddressEvent):void
		{
			IPage(_loader.content).onDeeplink(event);
		}
		// Interface compliance
		public function get children():Object
		{
			return _children;
		}
		public function set children(value:Object):void
		{
			if (_children == null) _children = value;
		}
		public function get assets():Object
		{
			return _assets;
		}
		public function set assets(value:Object):void
		{
			if (_assets == null) _assets = value;
		}
		public function get assetArray():Array
		{
			var array:Array = [];
			var ia:IAsset;
			for each (ia in _assets)
			{
				array.push(ia);
			}
			array.sortOn("order", Array.NUMERIC);
			return array;
		}
		public function get external():Boolean
		{
			return _external;
		}
		public function set external(value:Boolean):void
		{
			_external = value;
		}
		public function get menu():Boolean
		{
			return _menu;
		}
		public function set menu(value:Boolean):void
		{
			_menu = value;
		}
		public function get flow():String
		{
			return _flow;
		}
		public function set flow(value:String):void
		{
			_flow = value;
		}
		public function get defaultChild():String
		{
			return _defaultChild;
		}
		public function set defaultChild(value:String):void
		{
			_defaultChild = value;
		}
		public function get route():String
		{
			return _route;
		}
		public function set route(value:String):void
		{
			_route = value;
		}
		public function get assetPath():String
		{
			return GaiaImpl.instance.resolveBinding(_assetPath);
		}
		public function set assetPath(value:String):void
		{
			_assetPath = value;
		}
		public function get window():String
		{
			return _window;
		}
		public function set window(value:String):void
		{
			_window = value;
		}
		public function get landing():Boolean
		{
			return _landing;
		}
		public function set landing(value:Boolean):void
		{
			_landing = value;
		}
		override public function toString():String
		{
			return "[PageAsset] " + _id;
		}
	}
}