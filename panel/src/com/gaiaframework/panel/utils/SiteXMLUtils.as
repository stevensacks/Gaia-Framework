/*****************************************************************************************************
* Gaia Framework for Adobe Flash ©2007-2012
* Author: Steven Sacks
*
* forum: http://www.gaiaflashframework.com/forum/
* wiki: http://www.gaiaflashframework.com/wiki/
* 
* By using the Gaia Framework, you agree to keep the above contact information in the source code.
* 
* Gaia Framework for Adobe Flash is released under the MIT License:
* http://www.opensource.org/licenses/mit-license.php 
*****************************************************************************************************/

package com.gaiaframework.panel.utils
{
	import com.gaiaframework.panel.data.Page;
	
	public class SiteXMLUtils
	{
		public static function initCap(s:String):String
		{
			if (s.indexOf("_") == -1)
			{
				var u:String = s.charAt(0).toUpperCase();
				return u + s.substr(1);
			}
			var spl:Array = s.split("_");
			var i:int = spl.length;
			while (i--)
			{
				spl[i] = initCap(spl[i]);
			}
			return spl.join("_");
		}
		public static function getSEOName(node:XML):String
		{
			var seoName:String = "";
			var seo:String = node.@seo;
			if (node.@id == "index") seo = "true";
			if (seo == null) return null;
			if (seo.length == 0 || seo == "true") seoName += node.@id + ".html";
			else seoName += seo;
			return seoName;
		}
		public static function getSEOPages(nodes:XMLList):Array
		{
			var seoPages:Array = [];
			var len:int = nodes.length();
			for (var i:int = 0; i < len; i++)
			{
				var page:Page = new Page();
				page.id = nodes[i].@id;
				page.title = nodes[i].@title;
				page.seo = nodes[i].@seo;
				if (page.id == "index" && !page.title) page.title = "Index";
				else if (!page.seo) continue;
				else if (!page.title) continue;
				page.branch = getPageBranch(nodes[i]);
				page.seo = getSEOName(nodes[i]);
				seoPages.push(page);
			}
			return seoPages;
		}
		public static function getPageBranch(node:XML):String
		{
			var branch:String = node.@id;
			while (node.parent().@id.length() > 0)
			{
				branch = node.parent().@id + "/" + branch;
				node = node.parent();
			}
			return branch;
		}
		public static function getSeoMenu(pages:Array):String
		{
			var indent:String = "    ";
			var html:String = indent + indent + indent + "<ul id=\"sitenav\">\n";
			var len:int = pages.length;
			for (var i:int = 0; i < len; i++)
			{
				var page:Page = pages[i];
				html += indent + indent + indent + indent + "<li><a href=\"" + page.seo + "\">" + page.title + "</a></li>\n";
			}
			html += indent + indent + indent + "</ul>";
			return html;
		}
		public static function getSiteMap(pages:Array, domain:String):String
		{
			var indent:String = "    ";
			var sitemap:String = '<?xml version="1.0" encoding="UTF-8"?>\n';
			sitemap += '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n';
			var validDomain:String = domain;
			if (validDomain.charAt(validDomain.length - 1) != "/") validDomain += "/";
			var len:int = pages.length;
			for (var i:int = 0; i < len; i++)
			{
				var page:Page = pages[i];
				sitemap += indent + '<url>\n';
				sitemap += indent + indent + '<loc>http://' + validDomain + page.seo + '</loc>\n';
				sitemap += indent + '</url>\n';
			}
			sitemap += '</urlset>'
			return sitemap;
		}
		public static function getPageConstants(language:String, nodes:XMLList):String
		{
			var routes:Object = {};
			var constants:String = "\n";
			var len:int = nodes.length();
			for (var i:int = 0; i < len; i++)
			{
				var route:String;
				if (nodes[i].attribute("route").length() > 0) route = getPageRoute(nodes[i].@route);
				else route = getPageRoute(nodes[i].@id);
				if (route)
				{
					if (!routes[route]) routes[route] = 1;
					else route += "_" + routes[route]++;
					//
					if (language == "AS3") constants += ("\t\tpublic static const ");
					else constants += ("\tpublic static var ");
					constants += route + ':String = "' + getPageBranch(nodes[i]) + '";\n';
				}
			}
			return constants;
		}
		private static function getPageRoute(value:String):String
		{
			if (value == null || value.length == 0) return null;
			if (value.indexOf("&") > -1) value = value.split("&").join("and");
			//
			var route:String = "";
			var len:int = value.length;
			//
			for (var i:int = 0; i < len; i++)
			{
				var charCode:int = value.charCodeAt(i);
				if ((charCode < 48) || (charCode > 57 && charCode < 65) || charCode == 95) route += "_";
				else if ((charCode > 90 && charCode < 97) || (charCode > 122 && charCode < 128)) route += "_";
				else if (charCode > 127)
				{
					if ((charCode > 130 && charCode < 135) || charCode == 142 || charCode == 143 || charCode == 145 || charCode == 146 || charCode == 160 || charCode == 193 || charCode == 225) route += "a";
					else if (charCode == 128 || charCode == 135) route += "c";
					else if (charCode == 130 || (charCode > 135 && charCode < 139) || charCode == 144 || charCode == 201 || charCode == 233) route += "e";
					else if ((charCode > 138 && charCode < 142) || charCode == 161 || charCode == 205 || charCode == 237) route += "i";
					else if (charCode == 164 || charCode == 165) route += "n";
					else if ((charCode > 146 && charCode < 150) || charCode == 153 || charCode == 162 || charCode == 211 || charCode == 214 || charCode == 243 || charCode == 246 || charCode == 336 || charCode == 337) route += "o";
					else if (charCode == 129 || charCode == 150 || charCode == 151 || charCode == 154 || charCode == 163 || charCode == 218 || charCode == 220 || charCode == 250 || charCode == 252 || charCode == 368 || charCode == 369) route += "u";
				}
				else
				{
					route += value.charAt(i);
				}
			}
			route = route.replace(/_+/g, "_").replace(/_*$/, "");
			return route.toUpperCase();
		}
	}
}