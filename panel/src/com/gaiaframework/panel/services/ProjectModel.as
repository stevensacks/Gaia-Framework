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

package com.gaiaframework.panel.services
{
	import com.gaiaframework.panel.data.Project;
	import com.gaiaframework.panel.data.PublishData;
	import com.gaiaframework.panel.events.PanelErrorEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	[Event(name="complete", type="flash.events.Event")]
	public class ProjectModel extends EventDispatcher
	{
		private var _project:Project;
		private var projectURI:String;
		
		public function ProjectModel()
		{
			super();
		}
		
		[Bindable]
		public function get project():Project 
		{
			return _project;
		}
		public function set project(value:Project):void
		{
			_project = value;
		}
		
		public function createNewProject(language:String):void
		{
			project = new Project();
			project.language = language;
			project.name = project.language + " " + project.name;
			if (project.language == Project.AS2) project.player = "8";
			dispatchEvent(new Event(Event.COMPLETE));
		}
		public function load(uri:String):void
		{
			projectURI = uri;
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onXMLLoaded);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.load(new URLRequest(uri + "/project.gaia"));
		}
		private function onXMLLoaded(event:Event):void
		{
			var xml:XML;
			try
			{
				xml = XML(event.target.data);
			}
			catch (e:Error)
			{
				xml = null;
				dispatchEvent(new PanelErrorEvent(PanelErrorEvent.INVALID_PROJECT, false, false, "project.gaia is invalid", "Please verify your project.gaia xml is correct"));
			}
			if (xml) 
			{
				xmlToProject(xml);
				if (_project.uri != projectURI) _project.uri = projectURI;
				_project.modified = new Date();
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		private function onError(event:IOErrorEvent):void 
		{
			dispatchEvent(event);
		}
		private function xmlToProject(xml:XML):void
		{
			project = new Project();
			project.name = xml.name[0];
			project.language = xml.language[0];
			if (!xml.player || !xml.player[0]) 
			{
				if (project.language == Project.AS3) project.player = "9";
				else project.player = "8";
			}
			else 
			{
				project.player = xml.player[0];
			}
			project.version = xml.version[0];
			project.width = xml.width[0];
			project.height = xml.height[0];
			project.width100 = (xml.width100[0] == "true");
			project.height100 = (xml.height100[0] == "true");
			project.centerX = (xml.centerX[0] == "true");
			project.centerY = (xml.centerY[0] == "true");
			project.bgColor = xml.bgColor[0];
			project.fps = int(xml.fps[0]);
			project.uri = xml.projectPath[0];
			project.flashPath = xml.flashPath[0];
			project.publishPath = xml.publishPath[0];
			project.classesPath = xml.classesPath[0];
			project.siteXmlPath = xml.siteXmlPath[0];
			project.classPackage = xml.classPackage[0];
			project.template = xml.template[0];
			project.seo = (xml.seo[0] == "true");
			project.domain = xml.domain[0];
			project.isImported = (xml.isImported && xml.isImported[0] == "true");
			project.optimizeTypes.bitmapAsset = (xml.optimizeTypes[0].bitmapAsset[0] == "true");
			project.optimizeTypes.bitmapSpriteAsset = (xml.optimizeTypes[0].bitmapSpriteAsset[0] == "true");
			project.optimizeTypes.soundAsset = (xml.optimizeTypes[0].soundAsset[0] == "true");
			project.optimizeTypes.soundClipAsset = (xml.optimizeTypes[0].soundClipAsset[0] == "true");
			project.optimizeTypes.netStreamAsset = (xml.optimizeTypes[0].netStreamAsset[0] == "true");
			project.optimizeTypes.textAsset = (xml.optimizeTypes[0].textAsset[0] == "true");
			project.optimizeTypes.xmlAsset = (xml.optimizeTypes[0].xmlAsset[0] == "true");
			project.optimizeTypes.styleSheetAsset = (xml.optimizeTypes[0].styleSheetAsset[0] == "true");
			project.optimizeTypes.jsonAsset = (xml.optimizeTypes[0].jsonAsset[0] == "true");
			project.optimizeTypes.byteArrayAsset = (xml.optimizeTypes[0].byteArrayAsset[0] == "true");
			project.publishData = new PublishData(XMLList(xml.publishData[0].node.toXMLString()));		
			project.modified = new Date(int(xml.modified[0]));	
		}
		public function projectToXml():XML
		{
			var xml:XML = <project/>;
			xml.name[0] = _project.name;
			xml.language[0] = _project.language;
			xml.player[0] = _project.player;
			xml.version[0] = _project.version;
			xml.width[0] = _project.width;
			xml.height[0] = _project.height;
			xml.width100[0] = _project.width100;
			xml.height100[0] = _project.height100;
			xml.centerX[0] = _project.centerX;
			xml.centerY[0] = _project.centerY;
			xml.bgColor[0] = _project.bgColor;
			xml.fps[0] = _project.fps;
			xml.uri[0] = _project.uri;
			xml.flashPath[0] = _project.flashPath;
			xml.publishPath[0] = _project.publishPath;
			xml.classesPath[0] = _project.classesPath;
			xml.siteXmlPath[0] = _project.siteXmlPath;
			xml.classPackage[0] = _project.classPackage;
			xml.template[0] = _project.template;
			xml.seo[0] = _project.seo;
			xml.domain[0] = _project.domain;
			xml.modified[0] = project.modified.getTime();
			if (_project.isImported) xml.isImported[0] = _project.isImported;
			//
			var types:XML = <optimizeTypes/>;
			types.bitmapAsset[0] = _project.optimizeTypes.bitmapAsset;
			types.bitmapSpriteAsset[0] = _project.optimizeTypes.bitmapSpriteAsset;
			types.soundAsset[0] = _project.optimizeTypes.soundAsset;
			types.soundClipAsset[0] = _project.optimizeTypes.soundClipAsset;
			types.netStreamAsset[0] = _project.optimizeTypes.netStreamAsset;
			types.textAsset[0] = _project.optimizeTypes.textAsset;
			types.xmlAsset[0] = _project.optimizeTypes.xmlAsset;
			types.styleSheetAsset[0] = _project.optimizeTypes.styleSheetAsset;
			types.jsonAsset[0] = _project.optimizeTypes.jsonAsset;
			types.byteArrayAsset[0] = _project.optimizeTypes.byteArrayAsset;
			xml.appendChild(types);
			//
			var data:XML = <publishData/>;
			data.appendChild(XML(_project.publishData.toXMLString()));
			xml.appendChild(data);
			return xml;
		}
	}
}