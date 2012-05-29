/*****************************************************************************************************
* Gaia Framework for Adobe Flash �2007-2009
* Author: Steven Sacks
*
* blog: http://www.stevensacks.net/
* forum: http://www.gaiaflashframework.com/forum/
* wiki: http://www.gaiaflashframework.com/wiki/
* 
* By using the Gaia Framework, you agree to keep the above contact information in the source code.
* 
* Gaia Framework for Adobe Flash is �2007-2009 Steven Sacks and is released under the GPL License:
* http://www.opensource.org/licenses/mit-license.php 
*****************************************************************************************************/

package com.gaiaframework.panel.data
{	
	import com.gaiaframework.panel.services.Panel;
	
	import flash.net.SharedObject;
	
	import mx.effects.easing.Back;
	
	[Bindable]
	public class Project
	{
		public static const AS3:String = "AS3";
		public static const AS2:String = "AS2";
		public static const ACTIONSCRIPT:String = "Actionscript";
		public static const TIMELINE:String = "Timeline";
		
		// project
		public var name:String = "Gaia Project";
		public var language:String;
		public var version:String = Panel.VERSION;
		public var player:String = "10";
		
		// dimensions & color
		public var width:int = 550;
		public var height:int = 400;
		public var width100:Boolean;
		public var height100:Boolean;
		public var centerX:Boolean;
		public var centerY:Boolean;
		public var bgColor:String = "FFFFFF";
		public var fps:int = 30;
		
		// file Paths
		public var uri:String;
		public var flashPath:String = "lib";
		public var publishPath:String = "bin";
		public var classesPath:String = "src";
		public var siteXmlPath:String = "xml";
		
		// scaffold settings
		public var classPackage:String = "pages";
		public var template:String = ACTIONSCRIPT;
		public var seo:Boolean;
		public var domain:String = "www.domain.com/";
		
		// asset optimization
		public var optimizeTypes:OptimizeTypes = new OptimizeTypes();
		
		// publish settings
		private var _publishData:PublishData = new PublishData();
		
		// project files
		public var flashDevelop:Boolean;
		public var flexBuilder:Boolean;
		
		public var isCreated:Boolean;
		public var isScaffolded:Boolean;
		public var isImported:Boolean;
		
		public var modified:Date = new Date();
		
		private static var so:SharedObject = SharedObject.getLocal("gaiapanel");
		
		public function Project()
		{
			flashPath = so.data.flashPath || flashPath;
			publishPath = so.data.publishPath || publishPath;
			classesPath = so.data.classesPath || classesPath;
			siteXmlPath = so.data.siteXmlPath || siteXmlPath;
			flashDevelop = so.data.flashDevelop || false;
			flexBuilder = so.data.flexBuilder || false;
		}
		public function get publishData():PublishData
		{
			return _publishData;
		}
		public function set publishData(value:PublishData):void
		{
			_publishData = value;
			isCreated = (XML(_publishData.toXMLString())..node.(attribute("src").length() > 0).length() > 0);
			isScaffolded = (XML(_publishData.toXMLString())..node.(attribute("src").length() > 0).length() > 2);
		}
		public function clone():Project
		{
			var p:Project = new Project();
			p.name = name;
			p.language = language;
			p.version = version;
			p.player = player;
			p.width = width;
			p.height = height;
			p.width100 = width100;
			p.height100 = height100;
			p.centerX = centerX;
			p.centerY = centerY;
			p.bgColor = bgColor;
			p.fps = fps;
			p.uri = uri;
			p.flashPath = flashPath;
			p.publishPath = publishPath;
			p.classesPath = classesPath;
			p.siteXmlPath = siteXmlPath;
			p.classPackage = classPackage;
			p.template = template;
			p.seo = seo;
			p.domain = domain;
			return p;
		}
		public function toString():String
		{
			var str:String = "[Project]\n" + name + "\n" + language + " : " + version + "\n" + width + ", " + height + " : " + centerX + ", " + centerY + "\n" + flashPath + "\n" + publishPath + "\n" + classesPath + "\n" + siteXmlPath;
			str += "\n" + optimizeTypes;
			str += "\n" + publishData.toXMLString();
			return str;
		}
	}
}