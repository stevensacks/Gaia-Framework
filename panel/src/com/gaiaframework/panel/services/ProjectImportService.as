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
	import com.gaiaframework.panel.events.PanelErrorEvent;
	import com.gaiaframework.panel.utils.PublishDataUtils;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class ProjectImportService extends EventDispatcher
	{
		private var _project:Project;
		
		private var errors:String;
		
		public var path:String;
		
		public function ProjectImportService()
		{
			super();
		}
		public function get project():Project 
		{
			return _project;
		}
		public function load(path:String):void
		{
			errors = "";
			_project = new Project();
			_project.uri = path;
			_project.isImported = true;
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onGaiaXMLComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onXMLError);
			loader.load(new URLRequest(path + "/gaia.xml"));
		}
		private function onGaiaXMLComplete(event:Event):void
		{
			var xml:XML = XML(event.target.data);
			_project.flashPath = xml.source;
			_project.publishPath = xml.deploy;
			_project.domain = xml.domain;
			_project.classesPath = project.flashPath + "/classes";
			loadIndex();
		}
		private function loadIndex():void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onIndexComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIndexError);
			loader.load(new URLRequest(_project.uri + "/" + _project.publishPath + "/index.html"));
		}
		private function onIndexComplete(event:Event):void
		{
			var html:String = String(event.target.data);
			_project.width100 = (html.indexOf("width: 100%;") > -1);
			_project.height100 = (html.indexOf("height: 100%;") > -1);
			loadMain();
		}
		private function loadMain():void
		{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onMainComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onMainError);
			loader.load(new URLRequest(_project.uri + "/" + _project.classesPath + "/Main.as"));
		}
		private function onMainComplete(event:Event):void
		{
			var code:String = String(event.target.data);
			if (code.indexOf("centerSite") > -1) _project.centerX = _project.centerY = true;
			finishImport();
		}
		private function finishImport():void
		{
			if (errors.length == 0)
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
			else
			{
				dispatchEvent(new PanelErrorEvent(PanelErrorEvent.FILE_NOT_FOUND, false, false, "Project failed to import. Check output window for details.", errors));
				_project = null;
				errors = "";
			}
		}
		private function onXMLError(event:IOErrorEvent):void 
		{
			errors = "IMPORT ERROR: gaia.xml not found at: " + (_project.uri + "/gaia.xml");
			finishImport();
		}
		private function onIndexError(event:IOErrorEvent):void 
		{
			errors = "IMPORT ERROR: index.html not found at: " + (_project.uri + "/" + _project.publishPath + "/index.html");
			finishImport();
		}
		private function onMainError(event:IOErrorEvent):void 
		{
			errors = "IMPORT ERROR: Main.as not found at: " + (_project.uri + "/" + _project.classesPath + "/Main.as");
			finishImport();
		}
	}
}