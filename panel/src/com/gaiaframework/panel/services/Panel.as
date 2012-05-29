/*****************************************************************************************************
* Gaia Framework for Adobe Flash ©2007-2012
* Author: Steven Sacks
*
* git: https://github.com/stevensacks/Gaia-Framework
* wiki: http://www.gaiaflashframework.com/wiki/
* 
* By using the Gaia Framework, you agree to keep the above contact information in the source code.
* 
* Gaia Framework for Adobe Flash is released under the MIT License:
* http://www.opensource.org/licenses/mit-license.php 
*****************************************************************************************************/

package com.gaiaframework.panel.services
{
	import com.gaiaframework.panel.events.GaiaPanelEvent;
	import com.gaiaframework.panel.events.PanelConfirmEvent;
	import com.gaiaframework.panel.events.PanelErrorEvent;
	import com.gaiaframework.panel.events.PanelServiceEvent;
	import com.gaiaframework.panel.events.SiteXMLEvent;
	import com.gaiaframework.panel.services.api.IPanelMediator;
	import com.gaiaframework.panel.utils.ProjectUtils;
	import com.gaiaframework.panel.utils.PublishDataUtils;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	
	[Event(name="complete", type="flash.events.Event")]
	public class Panel
	{	
		public static const VERSION:String = "3.3.0";
		
		private var impl:IPanelMediator;
		
		private var importService:ProjectImportService;
		private var versionService:VersionService;
		
		private var siteXMLModel:SiteXMLModel;
		private var _panelModel:PanelModel;
		private var _model:ProjectModel;
		
		private var callback:Function;
		
		private var scaffoldPublishTimer:Timer;
		
		private static var _api:Panel;
		
		public function Panel()
		{
			super();
			importService = new ProjectImportService();
			importService.addEventListener(Event.COMPLETE, onImportComplete);
			importService.addEventListener(PanelErrorEvent.FILE_NOT_FOUND, onImportFailed);
			versionService = new VersionService();
			versionService.addEventListener(Event.COMPLETE, onVersionComplete);
			scaffoldPublishTimer = new Timer(500, 1);
			scaffoldPublishTimer.addEventListener(TimerEvent.TIMER, onScaffoldPublishTimer);
			ExternalInterface.addCallback("publishProject", publishExternal);
			_api = this;
		}
		public static function get api():Panel
		{
			return _api;
		}
		
		[Bindable]
		public function get model():ProjectModel
		{
			return _model;
		}
		public function set model(value:ProjectModel):void
		{
			_model = value;
			_model.addEventListener(IOErrorEvent.IO_ERROR, onProjectFileNotFound);
		}
		
		[Bindable]
		public function get panelModel():PanelModel
		{
			return _panelModel;
		}
		public function set panelModel(value:PanelModel):void
		{
			_panelModel = value;
			_panelModel.mediator = impl;
			_panelModel.load();
		}
		
		public function set mediator(value:IPanelMediator):void
		{
			impl = value;
			PublishDataUtils.base = impl.base;
			siteXMLModel = new SiteXMLModel(impl);
			siteXMLModel.addEventListener(PanelErrorEvent.INVALID_SITE_XML, onInvalidSiteXML);
			siteXMLModel.addEventListener(SiteXMLEvent.SYNC_PUBLISH_COMPLETE, onSyncPublishComplete);
		}
		public function getFlashVersion():String
		{
			return impl.base.getFlashVersion();
		}
		public function getFolderPath(msg:String):String
		{
			return impl.base.getFolderPath(msg);
		}
		public function getFilePath(msg:String):String
		{
			return impl.base.getFilePath(msg);
		}
		public function alert(m:String):void
		{
			impl.base.alert(m);
		}
		public function confirm(m:String, confirmListener:Function):void
		{
			impl.base.addEventListener(PanelConfirmEvent.CONFIRM, confirmListener);
			impl.base.confirm(m);
		}
		public function load(uri:String):void
		{
			try
			{
				_model.addEventListener(Event.COMPLETE, onProjectLoaded);
				_model.load(uri);
			}
			catch (e:Error)
			{
				impl.base.debug(e.getStackTrace());
			}
		}	
		private function onProjectLoaded(event:Event):void 
		{
			dispatchEvent(new PanelServiceEvent(PanelServiceEvent.PROJECT_LOADED));
		}
		private function onProjectCorrupt(event:PanelErrorEvent):void
		{
			impl.base.alert(event.message);
			impl.base.log(event.data);
		}
		public function create():void
		{
			try
			{
				impl.project.create(_model.project);
				PublishDataUtils.addPages(_model.project, ["main.fla", "preload.fla"]);
				dispatchEvent(new GaiaPanelEvent(GaiaPanelEvent.CREATE_PROJECT));
				save();
			}
			catch (e:Error)
			{
				impl.base.debug(e.getStackTrace());
			}
			impl.base.log(_model.project.name + " created");
		}
		public function save():void
		{
			try
			{
				impl.project.save(model.project.uri + "/project.gaia", model.projectToXml().toXMLString());
				_panelModel.updateProject(model.project);
			}
			catch (e:Error)
			{
				impl.base.debug(e.getStackTrace());
			}
		}
		public function update():void
		{
			try
			{
				var updateResult:String = impl.project.update(_model.project);
				_model.project.version = VERSION;
				save();
				if (updateResult.split(",")[0] > 0) 
				{
					impl.base.alert("Project updated to Gaia v" + VERSION);
					impl.base.log(unescape(updateResult.split(",")[1]));
				}
				else 
				{
					impl.base.alert("This project is already using v" + VERSION);
				}
			}
			catch (e:Error)
			{
				impl.base.debug(e.getStackTrace());
			}
		}
		public function openProject():void
		{
			var path:String = impl.base.getFolderPath("Select Existing Gaia Project Folder");
			if (path)
			{
				if (impl.base.fileExists(path + "/project.gaia"))
				{
					load(path);
				}
				else if (impl.base.fileExists(path + "/gaia.xml"))
				{
					importService.path = path;
					impl.base.addEventListener(PanelConfirmEvent.CONFIRM, onConfirmImport);
					impl.base.confirm("Import Gaia 2.x Project? (project will be updated to " + VERSION + ")");
				}
				else
				{
					impl.base.alert("Could not locate a project.gaia or gaia.xml file.");
				}
			}
		}
		public function closeProject():void
		{
			if (model.project.isCreated) 
			{
				impl.base.addEventListener(PanelConfirmEvent.CONFIRM, onConfirmSave);
				impl.base.confirm("Save " + _model.project.name + "?");
			}
			else dispatchEvent(new GaiaPanelEvent(GaiaPanelEvent.CLOSE_PROJECT));
		}
		private function onConfirmSave(event:PanelConfirmEvent):void
		{
			impl.base.removeEventListener(PanelConfirmEvent.CONFIRM, onConfirmSave);
			if (event.result) 
			{
				try
				{
					save();
					model.project = null;
				}
				catch (e:Error)
				{
					//
				}
			}
			dispatchEvent(new GaiaPanelEvent(GaiaPanelEvent.CLOSE_PROJECT));
		}
		public function openFile(src:String):void
		{
			impl.base.openFile(ProjectUtils.getFlashPath(_model.project) + "/" + src);
		}
		public function resize():void
		{
			if (impl.base.validateProjectPath(_model.project))
			{
				impl.base.addEventListener(PanelConfirmEvent.CONFIRM, onConfirmResize);
				impl.base.confirm("Apply changes to " + _model.project.name + "?");
			}
		}
		public function scaffold():void
		{
			if (impl.base.validateProjectPath(_model.project))
			{
				impl.base.addEventListener(PanelConfirmEvent.CONFIRM, onConfirmScaffold);
				impl.base.confirm("Scaffold into package " + _model.project.classPackage + "?");
			}
		}
		public function updateBytes():void
		{
			if (impl.base.validateProjectPath(_model.project))
			{
				siteXMLModel.addEventListener(SiteXMLEvent.SITE_XML_READY, onUpdateBytes);
				siteXMLModel.load(_model.project);
			}
		}
		public function optimize():void
		{
			if (impl.base.validateProjectPath(_model.project))
			{
				try
				{
					impl.optimize.optimize(_model.project);
					save();
					impl.base.log("Optimization Complete");
				}
				catch (e:Error)
				{
					impl.base.debug(e.getStackTrace());
				}
			}
		}
		public function optimizeAutoDetect(cb:Function = null):void
		{
			callback = cb;
			if (impl.base.validateProjectPath(_model.project))
			{
				siteXMLModel.addEventListener(SiteXMLEvent.SITE_XML_READY, onAutoDetect);
				siteXMLModel.load(_model.project);
			}
		}
		public function publish(publishAllFiles:Boolean = false):void
		{
			try
			{
				save();
				impl.project.publish(_model.project, publishAllFiles);
			}
			catch (e:Error)
			{
				impl.base.debug(e.getStackTrace());
			}
		}
		public function syncProjectPublish(cb:Function = null):void
		{
			callback = cb;
			siteXMLModel.syncProjectPublish(_model.project);
		}
		public function openPanelLog():void
		{
			impl.base.openPanelLog();
		}
		public function clearPanelLog():void
		{
			impl.base.clearPanelLog();
		}
		public function openProjectFolder():void
		{
			impl.project.openProjectFolder(_model.project);
		}
		private function onConfirmResize(event:PanelConfirmEvent):void
		{
			impl.base.removeEventListener(PanelConfirmEvent.CONFIRM, onConfirmResize);
			if (event.result) 
			{
				siteXMLModel.addEventListener(SiteXMLEvent.SITE_XML_READY, onResize);
				siteXMLModel.load(_model.project);
			}
		}
		private function onConfirmScaffold(event:PanelConfirmEvent):void
		{
			impl.base.removeEventListener(PanelConfirmEvent.CONFIRM, onConfirmScaffold);
			if (event.result) 
			{
				siteXMLModel.addEventListener(SiteXMLEvent.SITE_XML_READY, onScaffold);
				siteXMLModel.load(_model.project);
			}
		}
		private function onConfirmImport(event:PanelConfirmEvent):void
		{
			impl.base.removeEventListener(PanelConfirmEvent.CONFIRM, onConfirmImport);
			if (event.result) importService.load(importService.path);
			else importService.path = null;
		}
		private function onResize(event:SiteXMLEvent):void
		{
			siteXMLModel.removeEventListener(SiteXMLEvent.SITE_XML_READY, onResize);
			impl.project.resize(_model.project, event.xml);
			publish(true);
		}
		private function onScaffold(event:SiteXMLEvent):void 
		{
			try
			{
				siteXMLModel.removeEventListener(SiteXMLEvent.SITE_XML_READY, onScaffold);
				var generatedPages:Array = impl.scaffold.scaffold(_model.project, event.xml);
				if (generatedPages.length > 0) 
				{
					PublishDataUtils.addPages(_model.project, generatedPages);
					dispatchEvent(new GaiaPanelEvent(GaiaPanelEvent.SCAFFOLD_PROJECT));
					scaffoldPublishTimer.reset();
					scaffoldPublishTimer.start();
				}
			}
			catch (e:Error)
			{
				impl.base.debug(e.getStackTrace());
			}
		}
		private function onScaffoldPublishTimer(event:TimerEvent):void
		{
			scaffoldPublishTimer.reset();
			publish(false);
		}
		private function onUpdateBytes(event:SiteXMLEvent):void
		{
			try
			{
				siteXMLModel.removeEventListener(SiteXMLEvent.SITE_XML_READY, onUpdateBytes);
				impl.fileSize.updateBytes(_model.project, event.xml);
			}
			catch (e:Error)
			{
				impl.base.debug(e.getStackTrace());
			}
		}
		private function onAutoDetect(event:SiteXMLEvent):void
		{
			try
			{
				siteXMLModel.removeEventListener(SiteXMLEvent.SITE_XML_READY, onUpdateBytes);
				impl.optimize.autoDetect(_model.project, event.xml);
				if (callback != null) callback();
				callback = null;
			}
			catch (e:Error)
			{
				impl.base.debug(e.getStackTrace());
			}
		}
		private function onImportComplete(event:Event):void 
		{
			try
			{
				importService.project.language = impl.base.getProjectLanguage(importService.project);
				var properties:String = impl.project.getMainProperties(importService.project);
				if (properties.indexOf(",") > -1)
				{
					var p:Array = properties.split(",");
					importService.project.width = int(p[0]);
					importService.project.height = int(p[1]);
					importService.project.bgColor = String(p[2]).substr(1).toUpperCase();
					importService.project.fps = int(p[3]);
				}
				model.project = importService.project;
			}
			catch (e:Error)
			{
				impl.base.debug(e.getStackTrace());
			}
			update();
			if (impl.base.fileExists(ProjectUtils.getSiteXmlPath(model.project)))
			{
				syncProjectPublish(onImportSyncComplete);
			}
			else
			{
				load(model.project.uri);
				impl.base.alert("Could not find site.xml. Enter valid site.xml path to Finish Import.");
			}
		}
		private function onImportSyncComplete():void
		{
			load(model.project.uri);
		}
		private function onSyncPublishComplete(event:SiteXMLEvent):void
		{
			model.project.isImported = false;
			if (callback != null) callback();
			callback = null;
			save();
			impl.base.log("Sync complete");
		}
		private function onVersionComplete(event:Event):void 
		{
			if (VersionService.version > VERSION)
			{
				impl.base.addEventListener(PanelConfirmEvent.CONFIRM, onConfirmUpgrade);
				impl.base.confirm("A new version of Gaia is available. Upgrade to " + VersionService.version + "?");
			}
		}
		private function onConfirmUpgrade(event:PanelConfirmEvent):void
		{
			impl.base.removeEventListener(PanelConfirmEvent.CONFIRM, onConfirmUpgrade);
			if (event.result) 
			{
				var url:String = "http://www.gaiaflashframework.com/downloads/";
				if (VersionService.version.indexOf("beta") == -1) url += "update.html";
				else url += "betaupdate.html";
				navigateToURL(new URLRequest(url), "_blank");
			}
		}
		private function onInvalidSiteXML(event:PanelErrorEvent):void 
		{
			impl.base.alert(event.message);
			impl.base.log(event.data);
		}
		private function onImportFailed(event:PanelErrorEvent):void 
		{
			impl.base.alert(event.message);
			impl.base.log(event.data);
		}
		private function onProjectFileNotFound(event:IOErrorEvent):void 
		{
			impl.base.alert("Could not locate the Gaia project file");
		}
		private function publishExternal():void
		{
			if (model)
			{
				if (!model.project)
				{
					alert("Gaia Framework panel does not have an open project.");
				}
				else if(!model.project.isScaffolded)
				{
					alert(model.project.name + " has not been scaffolded yet.");
				}
				else
				{
					publish();
				}
			}
		}
	}
}
