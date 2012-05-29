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
	import com.gaiaframework.api.Gaia;
	import com.gaiaframework.assets.AbstractAsset;
	import com.gaiaframework.assets.AssetCreator;
	import com.gaiaframework.assets.PageAsset;
	import com.gaiaframework.assets.SEOAsset;
	import com.gaiaframework.debug.GaiaDebug;
	import com.gaiaframework.utils.CacheBuster;

	import flash.events.*;
	import flash.net.*;

	// This class loads and parses the site.xml and builds the site tree from it

	public class SiteModel extends EventDispatcher
	{
		private var loader:URLLoader;
		private var domain:String;
		private static var _xml:XML;
		private static var _tree:PageAsset;
		private static var _title:String;
		private static var _delimiter:String;
		private static var _preloader:String;
		private static var _preloaderDepth:String;
		private static var _preloaderDomain:String;
		private static var _menu:Boolean;
		private static var _menuArray:Array;
		private static var _defaultFlow:String;
		private static var _routing:Boolean;
		private static var _routes:Object;
		private static var _history:Boolean;
		private static var _indexFirst:Boolean;
		private static var _indexID:String;
		private static var _assetPath:String;
		private static var _domain:String;
		private static var _version:String;
		
		function SiteModel(d:String)
		{
			super();
			domain = d;
		}
		public function load(path:String):void
		{
			if (path == null) path = "site.xml";
			if (path != "xml/site.xml" && path != "site.xml") GaiaDebug.log("site.xml path = " + path);
			var request:URLRequest = new URLRequest(CacheBuster.create(path));
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.load(request);
		}
		public static function get xml():XML
		{
			return _xml;
		}
		public static function get tree():PageAsset
		{
			return _tree;
		}
		public static function get title():String
		{
			return _title;
		}
		public static function set title(value:String):void
		{
			_title = value;
		}
		public static function get delimiter():String
		{
			return _delimiter;
		}
		public static function set delimiter(value:String):void
		{
			_delimiter = value;
		}
		public static function get preloader():String
		{
			return _preloader;
		}
		public static function get menu():Boolean
		{
			return _menu;
		}
		public static function get menuArray():Array
		{
			return _menuArray;
		}
		public static function get defaultFlow():String
		{
			return _defaultFlow;
		}
		public static function set defaultFlow(value:String):void
		{
			if (value == Gaia.NORMAL || value == Gaia.PRELOAD || value == Gaia.REVERSE || value == Gaia.CROSS) _defaultFlow = value;
		}
		public static function get routing():Boolean
		{
			return _routing;
		}
		public static function get routes():Object
		{
			return _routes;
		}
		public static function get preloaderDepth():String
		{
			return _preloaderDepth;
		}
		public static function get preloaderDomain():String 
		{
			return _preloaderDomain;
		}
		public static function get history():Boolean
		{
			return _history;
		}
		public static function get indexFirst():Boolean
		{
			return _indexFirst;
		}
		public static function get indexID():String 
		{ 
			return _indexID; 
		}
		public static function get domain():String
		{
			return _domain;
		}
		public static function get version():String
		{
			return _version;
		}
		private function onLoadComplete(event:Event):void
		{
			_xml = XML(event.target.data);
			_menuArray = [];
			parseSite();
			parseTree();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		private function onIOError(event:IOErrorEvent):void 
		{
			GaiaDebug.error("ERROR: site.xml failed to load");
			GaiaDebug.error(event);
			dispatchEvent(event);
		}
		private function parseSite():void
		{
			_title = _xml.@title || "";
			_preloader = _xml.@preloader || "preload.swf";
			_menu = (_xml.@menu == "true");
			_delimiter = _xml.@delimiter || ": ";
			_routing = !(_xml.@routing == "false");
			_history = !(_xml.@history == "false");
			_indexFirst = (_xml.@indexFirst == "true");
			_assetPath = _xml.@assetPath || "";
			_version = _xml.@version || "";
			// appDomain
			var appDomain:String = String(_xml.@domain).toLowerCase();
			if (appDomain == Gaia.DOMAIN_CURRENT ||appDomain == Gaia.DOMAIN_NEW) _domain = appDomain;
			else _domain = Gaia.DOMAIN_NULL;
			// preloaderDepth
			var depth:String = String(_xml.@preloaderDepth).toLowerCase();
			if (depth == Gaia.MIDDLE || depth == Gaia.BOTTOM) _preloaderDepth = depth;
			else _preloaderDepth = Gaia.TOP;
			// preloaderDomain
			appDomain = String(_xml.@preloaderDomain).toLowerCase();
			if (appDomain == Gaia.DOMAIN_CURRENT || appDomain == Gaia.DOMAIN_NEW) _preloaderDomain = appDomain;
			else _preloaderDomain = Gaia.DOMAIN_NULL;
			// defaultFlow
			var flow:String = String(_xml.@flow).toLowerCase();
			if (flow == Gaia.PRELOAD || flow == Gaia.REVERSE || flow == Gaia.CROSS) _defaultFlow = flow;
			else _defaultFlow = Gaia.NORMAL;
			if (_routing) _routes = {};
		}
		private function parseTree():void
		{
			var node:XML = _xml.page[0];
			if (node.@id != undefined) _indexID = node.@id;
			_tree = parsePage(node);
		}
		private function parseChildren(parent:PageAsset, childNodes:XMLList):Object
		{
			var children:Object = {};
			var len:int = childNodes.length();
			for (var i:int = 0; i < len; i++) 
			{
				var node:XML = childNodes[i];
				var page:PageAsset = parsePage(node, parent);
				children[page.id] = page;
			}
			return children;
		}
		private function parsePage(node:XML, parent:PageAsset = null):PageAsset
		{
			validateNode(node, true);
			var isIndex:Boolean = (node.@id == _indexID);
			var page:PageAsset = new PageAsset();
			page.node = node;
			page.id = node.@id;
			page.src = node.@src;
			page.title = node.@title;
			page.bytes = node.@bytes;
			page.assetPath = node.@assetPath || _assetPath;
			page.preloadAsset = true;
			page.menu = (node.@menu == "true");
			if (page.menu && page.title.toLowerCase() == "about") GaiaDebug.warn('* Warning * "About" is not permitted in Flash context menus');
			if (page.menu && page.title.length > 0) _menuArray.push(page);
			page.landing = (node.@landing == "true");
			// domain
			var domain:String = String(node.@domain).toLowerCase();
			if (domain == Gaia.DOMAIN_NEW || domain == Gaia.DOMAIN_CURRENT) page.domain = domain;
			else page.domain = _domain;
			// depth
			var depth:String = String(node.@depth).toLowerCase();
			if (!isIndex)
			{
				page.setParent(parent);
				page.external = (node.@src.split(".").pop() != "swf" || node.@src.indexOf("javascript") > -1);
				if (page.external) page.window = node.@window || "_self";
				if (depth == Gaia.TOP || depth == Gaia.BOTTOM || depth == Gaia.NESTED) page.depth = depth;
				else page.depth = Gaia.MIDDLE;
			}
			else
			{
				if (depth == Gaia.TOP || depth == Gaia.MIDDLE) page.depth = depth;
				else page.depth = Gaia.BOTTOM;
			}
			// flow
			var flow:String = String(node.@flow).toLowerCase();
			if (flow == Gaia.NORMAL || flow == Gaia.PRELOAD || flow == Gaia.REVERSE || flow == Gaia.CROSS) page.flow = flow;
			// assets
			if (node.asset.length() > 0 || node.@seo != undefined) page.assets = parseAssets(node.asset, page, node.@seo, int(node.@seoBytes));
			// child pages
			if (node.page.length() > 0) 
			{
				page.defaultChild = node.@defaultChild;
				page.children = parseChildren(page, node.page);
				if (!page.children.hasOwnProperty(page.defaultChild)) page.defaultChild = node.page[0].@id;
			}
			// terminal page
			else
			{
				if (page.src.substr(page.src.length - 4) == ".swf") page.landing = true;
				if (isIndex) GaiaSWFAddress.isSinglePage = true;
			}
			// only add terminal and landing pages to routes
			if (_routing && page.landing)
			{
				var route:String = node.@route || page.title;
				if (isIndex) route = route || page.id;
				page.route = getValidRoute(route, page.id).toLowerCase();
				_routes[page.route] = page.branch;
			}
			return page;
		}
		private function parseAssets(nodes:XMLList, page:PageAsset, seo:String = null, seoBytes:int = 0):Object
		{
			var order:int = 0;
			var assets:Object = {};
			if (seo != null && seo.length > 0)
			{
				var seoSrc:String = (seo == "true") ? page.id + ".html" : GaiaImpl.instance.resolveBinding(seo);
				assets.seo = createSEOAsset(seoSrc, seoBytes);
				if (page.title == "") GaiaDebug.warn("* Warning * Page '" + page.id + "' has seo '" + seoSrc + "' but no title - seo file may not exist");
			}
			var len:int = nodes.length();
			for (var i:int = 0; i < len; i++) 
			{
				var node:XML = nodes[i];
				validateNode(node);
				assets[node.@id] = AssetCreator.create(node, page);
				AbstractAsset(assets[node.@id]).order = ++order;
			}
			return assets;
		}
		private function createSEOAsset(seoSrc:String, seoBytes:int):SEOAsset
		{
			var asset:SEOAsset = new SEOAsset();
			asset.id = "seo";
			asset.src = seoSrc;
			asset.title = "SEO";
			asset.preloadAsset = true;
			asset.showProgress = true;
			asset.bytes = seoBytes;
			asset.order = 0;
			return asset;
		}
		private function getValidRoute(route:String, id:String):String
		{
			if (route == null || route.length == 0) throw new Error("*Invalid Site XML* Terminal page '" + id + "' missing required attribute 'title'");
			if (route.indexOf("&") > -1) route = route.split("&").join("and");
			//
			var validRoute:String = "";
			var len:int = route.length;
			//
			for (var i:int = 0; i < len; i++)
			{
				var charCode:int = route.charCodeAt(i);
				if ((charCode < 47) || (charCode > 57 && charCode < 65) || charCode == 95) validRoute += "-";
				else if ((charCode > 90 && charCode < 97) || (charCode > 122 && charCode < 128)) validRoute += "-";
				else if (charCode > 127)
				{
					if ((charCode > 130 && charCode < 135) || charCode == 142 || charCode == 143 || charCode == 145 || charCode == 146 || charCode == 160 || charCode == 193 || charCode == 225) validRoute += "a";
					else if (charCode == 128 || charCode == 135) validRoute += "c";
					else if (charCode == 130 || (charCode > 135 && charCode < 139) || charCode == 144 || charCode == 201 || charCode == 233) validRoute += "e";
					else if ((charCode > 138 && charCode < 142) || charCode == 161 || charCode == 205 || charCode == 237) validRoute += "i";
					else if (charCode == 164 || charCode == 165) validRoute += "n";
					else if ((charCode > 146 && charCode < 150) || charCode == 153 || charCode == 162 || charCode == 211 || charCode == 214 || charCode == 243 || charCode == 246 || charCode == 336 || charCode == 337) validRoute += "o";
					else if (charCode == 129 || charCode == 150 || charCode == 151 || charCode == 154 || charCode == 163 || charCode == 218 || charCode == 220 || charCode == 250 || charCode == 252 || charCode == 368 || charCode == 369) validRoute += "u";
				}
				else
				{
					validRoute += route.charAt(i);
				}
			}
			validRoute = validRoute.replace(/\-+/g, "-").replace(/\-*$/, "");
			return validRoute.toLowerCase();
		}
		// Site XML Validation
		public static function validateNode(node:XML, isPage:Boolean = false):void
		{
			var error:String = "*Invalid Site XML* " + (isPage ? "Page " : "Asset ");
			if (node.@id == undefined) 
			{
				throw new Error(error + "node missing required attribute 'id'");
			}
			else if (node.@src == undefined)
			{
				throw new Error(error + "node missing required attribute 'src'");
			}
			else if (invalidBinding(node.@src))
			{
				throw new Error(error + node.@id + " 'src' attribute contains invalid binding expression \"" + node.@src + "\"");
			}
			else if (isPage)
			{
				var message:String = validatePage(node);
				if (message != null) throw new Error(error + message);
			}
		}
		private static function validatePage(node:XML):String
		{
			var message:String;
			if ((node.@menu == "true" || node.@landing == "true") && (node.@title == undefined || node.@title.length == 0))
			{
				message = node.@id + " missing required attribute 'title'";
			}
			else if (node.@assetPath != undefined && node.@assetPath.length > 0)
			{
				if (node.@assetPath.charAt(node.@assetPath.length - 1) != "/") 
				{
					message = node.@id + " 'assetPath' attribute must end with /";
				}
				else if (invalidBinding(node.@assetPath))
				{
					message = node.@id + " 'assetPath' attribute contains invalid binding expression \"" + node.@assetPath + "\"";
				}
			}
			else if (node.@seo != undefined && node.@seo.length > 0 && node.@seo != "true")
			{
				if (invalidBinding(node.@seo))
				{
					message = node.@id + " 'seo' attribute contains invalid binding expression \"" + node.@seo + "\"";
				}
			}
			return message;
		}
		private static function invalidBinding(value:String):Boolean
		{
			return ((value.indexOf("}") > -1 && value.indexOf("{") == -1) || (value.indexOf("{") > -1 && value.indexOf("}") == -1));
		}
	}
}
