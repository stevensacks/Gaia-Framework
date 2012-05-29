package com.gaiaframework.panel.services.test
{
	import com.gaiaframework.panel.data.Project;
	import com.gaiaframework.panel.services.api.IFileSizeService;
	import com.gaiaframework.panel.utils.ProjectUtils;
	import com.gaiaframework.panel.utils.SiteXMLUtils;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.Timer;
	
	public class TESTFileSize extends TESTBase implements IFileSizeService
	{
		private var stream:URLStream;
		
		private var siteAssetPath:String;
		private var swfNodes:XMLList;
		private var swfIndex:int;
		private var siteXML:XML;
		
		// Cannot load and save in same thread
		private var saveTimer:Timer = new Timer(100, 1);
		
		public function TESTFileSize()
		{
			super();
			stream = new URLStream();
			stream.addEventListener(Event.COMPLETE, onStreamComplete);
			saveTimer.addEventListener(TimerEvent.TIMER, onSaveTimer, false, 0, true);
		}
		public function updateBytes(project:Project, siteXML:XML):void
		{
			this.siteXML = siteXML;
			currentProject = project;
			siteAssetPath = siteXML.@assetPath;
			var nodes:XMLList = siteXML.descendants().(name() == "page" || name() == "asset");
			if (project.language == Project.AS3)
			{
				setFileBytes(project, nodes);
				if (project.seo) setSEOBytes();
				saveSiteXML();
			}
			else
			{
				var nonSWFNodes:XMLList = nodes.(name() == "asset" && !isSWF(@src));
				setFileBytes(project, nonSWFNodes);
				currentProject = project;
				swfNodes = nodes.(isSWF(@src));
				swfIndex = 0;
				loadNextStream();
			}
		}
		private function setFileBytes(project:Project, nodes:XMLList):void
		{
			log("** Update File Bytes In XML **");
			var len:int = nodes.length();
			for (var i:int = 0; i < len; i++)
			{
				var filePath:String
				var extension:String = String(nodes[i].@src.split(".").pop()).toLowerCase();
				if (nodes[i].name() == "page")
				{
					if (extension == "swf") filePath = nodes[i].@src;
				}
				else if (extension == "swf" || extension == "jpg" || extension == "jpeg" || extension == "png" || extension == "mp3" || extension == "m4a" || extension == "xml" || extension == "txt" || extension == "css" || extension == "flv" || extension == "json")
				{
					filePath = (nodes[i].parent().@assetPath || siteAssetPath || "") + nodes[i].@src;
				}
				if (filePath)
				{
					var size:int = runScript(PROJECT_TEST, "getFileSize", ProjectUtils.getPublishPath(project) + "/" + filePath);
					if (size) 
					{
						nodes[i].@bytes = size;
						log(filePath + ": " + size);					
					}
				}
			}
		}
		private function setSEOBytes():void
		{
			var nodes:XMLList = siteXML..page.(attribute("seo").length() > 0 || @id == "index");
			var len:int = nodes.length();
			for (var i:int = 0; i < len; i++)
			{
				var seoName:String = SiteXMLUtils.getSEOName(nodes[i]);
				if (seoName != null)
				{
					var filePath:String = ProjectUtils.getPublishPath(currentProject) + "/" + seoName;
					var size:int = runScript(SCAFFOLD_TEST, "getFileSize", filePath);
					if (size) nodes[i].@seoBytes = size;
					else delete nodes[i].@seoBytes;
				}
			}
		}
		private function isSWF(src:String):Boolean
		{
			return (String(src.split(".").pop()).toLowerCase() == "swf");
		}
		private function loadNextStream():void
		{
			if (swfIndex < swfNodes.length())
			{
				var filePath:String;
				if (swfNodes[swfIndex].name() == "page") filePath = swfNodes[swfIndex].@src;
				else filePath = (swfNodes[swfIndex].parent().@assetPath || siteAssetPath || "") + swfNodes[swfIndex].@src;
				stream.load(new URLRequest(ProjectUtils.getPublishPath(currentProject) + "/" + filePath));
			}
			else
			{
				if (currentProject.seo) setSEOBytes();
				saveSiteXML();
			}
		}
		private function onStreamComplete(event:Event):void 
		{
			var bytes:ByteArray = new ByteArray();
			stream.readBytes(bytes);
			bytes.endian = Endian.LITTLE_ENDIAN;
			bytes.position = 4;
			swfNodes[swfIndex].@bytes = bytes.readUnsignedInt();
			log(swfNodes[swfIndex].@src + ": " + swfNodes[swfIndex].@bytes);
			swfIndex++;
			loadNextStream();
		}
		private function saveSiteXML():void
		{
			saveTimer.start();			
		}
		private function onSaveTimer(event:TimerEvent):void
		{
			runScript(PROJECT_TEST, "saveStringFile", ProjectUtils.getSiteXmlPath(currentProject), escape(siteXML));
			siteXML = null;
			currentProject = null;
			siteAssetPath = null;
			swfNodes = null;
			swfIndex = 0;
			saveTimer.reset();
		}
	}
}