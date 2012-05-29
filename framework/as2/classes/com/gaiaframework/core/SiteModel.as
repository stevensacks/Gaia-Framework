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
* http://www.opensource.org/licenses/mit-license 
*****************************************************************************************************/

import com.gaiaframework.utils.ObservableClass;
import com.gaiaframework.core.GaiaSWFAddress;
import com.gaiaframework.assets.AssetCreator;
import com.gaiaframework.assets.PageAsset;
import com.gaiaframework.assets.SEOAsset;
import com.gaiaframework.utils.CacheBuster;
import com.gaiaframework.utils.XML2AS;
import com.gaiaframework.debug.GaiaDebug;
import com.gaiaframework.core.GaiaImpl;
import com.gaiaframework.events.Event;
import com.gaiaframework.api.Gaia;
import mx.utils.Delegate;

// This class loads and parses the site.xml and builds the site tree from it

class com.gaiaframework.core.SiteModel extends ObservableClass
{
	private static var _xml:XML;
	private static var _tree:PageAsset;
	private static var _title:String;
	private static var _delimiter:String;
	private static var _preloader:String;
	private static var _preloaderDepth:String;
	private static var _menu:Boolean;
	private static var _menuArray:Array;
	private static var _defaultFlow:String;
	private static var _routing:Boolean;
	private static var _routes:Object;
	private static var _history:Boolean;
	private static var _indexFirst:Boolean;
	private static var _indexID:String;
	private static var _assetPath:String;
	private static var _version:String;
	
	function SiteModel()
	{
		super();
	}
	public function load(path:String):Void
	{
		if (path == undefined || path == null || path.length == 0)  path = "site.xml";
		if (path != "xml/site.xml" && path != "site.xml") GaiaDebug.log("site.xml path = " + path);
		_xml = new XML();
		_xml.ignoreWhite = true;
		_xml.onLoad = Delegate.create(this, onLoadComplete);
		_xml.load(CacheBuster.create(path));
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
	public static function set title(value:String):Void
	{
		_title = value;
	}
	public static function get delimiter():String
	{
		return _delimiter;
	}
	public static function set delimiter(value:String):Void
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
	public static function set defaultFlow(value:String):Void
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
	public static function get version():String
	{
		return _version;
	}
	private function onLoadComplete():Void
	{
		var xmlObj:Object = {};
		XML2AS.parse(_xml.firstChild, xmlObj);
		parseSite(xmlObj);
		parseTree(xmlObj);
		generateMenuArray();
		dispatchEvent(new Event(Event.COMPLETE, this));
	}
	private function parseSite(xmlObj:Object):Void
	{
		_title = xmlObj.site[0].attributes.title || "";
		_preloader = xmlObj.site[0].attributes.preloader || "preload.swf";
		_menu = (xmlObj.site[0].attributes.menu == "true");
		_delimiter = xmlObj.site[0].attributes.delimiter || ": ";
		_routing = !(xmlObj.site[0].attributes.routing == "false");
		_history = !(xmlObj.site[0].attributes.history == "false");
		_indexFirst = (xmlObj.site[0].attributes.indexFirst == "true");
		_assetPath = xmlObj.site[0].attributes.assetPath || "";
		_version = xmlObj.site[0].attributes.version || "";
		//
		var depth:String = String(xmlObj.site[0].attributes.preloaderDepth).toLowerCase();
		if (depth == Gaia.MIDDLE || depth == Gaia.BOTTOM) _preloaderDepth = depth;
		else _preloaderDepth = Gaia.TOP;
		//
		var flow:String = String(xmlObj.site[0].attributes.flow).toLowerCase();
		if (flow == Gaia.PRELOAD || flow == Gaia.REVERSE || flow == Gaia.CROSS) _defaultFlow = flow;
		else _defaultFlow = Gaia.NORMAL;
		//
		if (_routing) _routes = {};
	}
	private function parseTree(xmlObj:Object):Void
	{
		var node:Object = xmlObj.site[0].page[0];
		if (node.attributes.id != undefined) _indexID = node.attributes.id;
		_tree = parsePage(node);
	}
	private function parseChildren(parent:PageAsset, childNodes:Array):Object
	{
		var children:Object = {};
		var len:Number = childNodes.length;
		for (var i:Number = 0; i < len; i++) 
		{
			var node:Object = childNodes[i];
			var page:PageAsset = parsePage(node, parent);
			children[page.id] = page;
		}
		return children;
	}
	private function parsePage(node:Object, parent:PageAsset):PageAsset
	{
		validateNode(node, true);
		var isIndex:Boolean = (node.attributes.id == _indexID);
		var page:PageAsset = new PageAsset();
		page.node = node;
		page.id = node.attributes.id;
		page.setSrc(node.attributes.src);
		page.title = node.attributes.title;
		page.bytes = Number(node.attributes.bytes || 0);
		page.assetPath = node.attributes.assetPath || _assetPath;
		page.preloadAsset = true;
		page.menu = (node.attributes.menu == "true");
		page.landing = (node.attributes.landing == "true");
		// depth
		var depth:String = String(node.attributes.depth).toLowerCase();
		if (!isIndex)
		{
			page.setParent(parent);
			page.external = (node.attributes.src.split(".").pop() != "swf" || node.attributes.src.indexOf("javascript") > -1);
			if (page.external) page.window = node.attributes.window || "_self";
			if (depth == Gaia.TOP || depth == Gaia.BOTTOM) page.depth = depth;
			else page.depth = Gaia.MIDDLE;
		}
		else
		{
			if (depth == Gaia.TOP || depth == Gaia.MIDDLE) page.depth = depth;
			else page.depth = Gaia.BOTTOM;
		}
		// flow
		var flow:String = String(node.attributes.flow).toLowerCase();
		if (flow == Gaia.NORMAL || flow == Gaia.PRELOAD || flow == Gaia.REVERSE || flow == Gaia.CROSS) page.flow = flow;
		// assets
		if (node.asset.length > 0 || node.attributes.seo != undefined) page.assets = parseAssets(node.asset, page, node.attributes.seo, node.attributes.seoBytes);
		// child pages
		if (node.page.length > 0) 
		{
			page.defaultChild = node.attributes.defaultChild;
			page.children = parseChildren(page, node.page);
			if (page.children[page.defaultChild] == undefined) page.defaultChild = node.page[node.page.length - 1].attributes.id;
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
			var route:String = node.attributes.route || page.title;
			if (isIndex) route = route || page.id;
			page.route = getValidRoute(route);
			_routes[page.route] = page.branch;
		}
		return page;
	}
	private function parseAssets(nodes:Array, page:PageAsset, seo:String, seoBytes:Number):Object
	{
		var assets:Object = {};
		var len:Number = nodes.length;
		for (var i:Number = 0; i < len; i++) 
		{
			var node:Object = nodes[i];
			validateNode(node);
			assets[node.attributes.id] = AssetCreator.create(node, page);
		}
		if (seo != undefined && seo.length > 0)
		{
			var seoSrc:String = (seo == "true") ? page.id + ".html" : GaiaImpl.instance.resolveBinding(seo);
			assets.seo = createSEOAsset(seoSrc, seoBytes);
			if (page.title == undefined || page.title == "") GaiaDebug.warn("* Warning * Page '" + page.id + "' has seo '" + seoSrc + "' but no title - seo file may not exist");
		}
		return assets;
	}
	private function createSEOAsset(seoSrc:String, seoBytes:Number):SEOAsset
	{
		var asset:SEOAsset = new SEOAsset();
		asset.id = "seo";
		asset.setSrc(seoSrc);
		asset.title = "SEO";
		asset.preloadAsset = true;
		asset.showProgress = true;
		asset.bytes = Number(seoBytes || 0);
		return asset;
	}
	private function getValidRoute(route:String, id:String):String
	{
		if (route == null || route.length == 0) throw new Error("*Invalid Site XML* Terminal page '" + id + "' missing required attribute 'title'");
		if (route.indexOf("&") > -1) route = route.split("&").join("and");
		//
		var validRoute:String = "";
		var len:Number = route.length;
		//
		for (var i:Number = 0; i < len; i++)
		{
			var charCode:Number = route.charCodeAt(i);
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
		while (validRoute.indexOf("--") > -1)
		{
			validRoute = validRoute.split("--").join("-");
		}
		while (validRoute.charAt(validRoute.length - 1) == "-")
		{
			validRoute = validRoute.substr(0, validRoute.length - 1);
		}
		return validRoute.toLowerCase();
	}
	// Site XML Validation
	public static function validateNode(node:Object, isPage:Boolean):Void
	{
		var error:String = "*Invalid Site XML* " + (isPage ? "Page " : "Asset ");
		if (node.attributes.id == undefined) 
		{
			throw new Error(error + "node missing required attribute 'id'");
		}
		else if (node.attributes.src == undefined)
		{
			throw new Error(error + "node missing required attribute 'src'");
		}
		else if (invalidBinding(node.attributes.src))
		{
			throw new Error(error + node.attributes.id + " 'src' attribute has invalid binding expression \"" + node.attributes.src + "\"");
		}
		else if (isPage)
		{
			var message:String = validatePage(node);
			if (message != null) throw new Error(error + message);
		}
	}
	private static function validatePage(node:Object):String
	{
		var message:String;
		if ((node.attributes.menu == "true" || node.attributes.landing == "true") && (node.attributes.title == undefined || node.attributes.title.length == 0))
		{
			message = node.attributes.id + " missing required attribute 'title'";
		}
		else if (node.attributes.assetPath != undefined && node.attributes.assetPath.length > 0)
		{
			if (node.attributes.assetPath.charAt(node.attributes.assetPath.length - 1) != "/") 
			{
				message = node.attributes.id + " 'assetPath' attribute must end with /";
			}
			else if (invalidBinding(node.attributes.assetPath))
			{
				message = node.attributes.id + " 'assetPath' attribute has invalid binding expression \"" + node.attributes.assetPath + "\"";
			}
		}
		return message;
	}
	private static function invalidBinding(value:String):Boolean
	{
		return ((value.indexOf("}") > -1 && value.indexOf("{") == -1) || (value.indexOf("{") > -1 && value.indexOf("}") == -1));
	}
	private function generateMenuArray():Void
	{
		_menuArray = [];
		if (_tree.menu && _tree.title.length > 0) _menuArray.push(_tree);
		addPageToMenuArray(_tree);
	}
	private function addPageToMenuArray(page:PageAsset):Void
	{
		var children:Object = page.children;
		for (var a:String in children)
		{
			var childPage:PageAsset = children[a];
			if (childPage.menu && childPage.title.length > 0) _menuArray.push(childPage);
			if (childPage.children) addPageToMenuArray(childPage);
		}
	}
}
