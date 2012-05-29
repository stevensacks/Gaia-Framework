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

package com.gaiaframework.panel.services.jsfl
{
	import com.gaiaframework.panel.data.Project;
	import com.gaiaframework.panel.services.api.IFileSizeService;
	import com.gaiaframework.panel.utils.ProjectUtils;
	import com.gaiaframework.panel.utils.SiteXMLUtils;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.net.URLLoader;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.Timer;
	
	public class JSFLFileSize extends JSFLBase implements IFileSizeService
	{
		private var stream:URLStream;
		private var externalStream:URLStream;
		private var loader:URLLoader;
		
		private var siteAssetPath:String;
		private var swfNodes:XMLList;
		private var swfIndex:int;
		private var siteXML:XML;
		
		private var xmlAssetPaths:Array;
		private var assetXML:XML;
		
		// Cannot load and save in same thread
		private var saveTimer:Timer = new Timer(100, 1);
		private var saveAssetTimer:Timer = new Timer(100, 1);
		
		private var logString:String;
		
		public function JSFLFileSize()
		{
			super();
			stream = new URLStream();
			externalStream = new URLStream();
			loader = new URLLoader();
			stream.addEventListener(Event.COMPLETE, onStreamComplete);
			externalStream.addEventListener(Event.COMPLETE, onExternalStreamComplete);
			loader.addEventListener(Event.COMPLETE, onLoaderComplete);
			saveTimer.addEventListener(TimerEvent.TIMER, onSaveTimer, false, 0, true);
			saveAssetTimer.addEventListener(TimerEvent.TIMER, onSaveAssetTimer, false, 0, true);
		}
		public function updateBytes(project:Project, siteXML:XML):void
		{
			this.siteXML = siteXML;
			currentProject = project;
			siteAssetPath = siteXML.@assetPath;
			xmlAssetPaths = [];
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
			logString = "** Update File Bytes In XML **\n";
			var len:int = nodes.length();
			for (var i:int = 0; i < len; i++)
			{
				var filePath:String;
				var extension:String = String(nodes[i].@src.split(".").pop()).toLowerCase();
				if (nodes[i].name() == "page")
				{
					if (extension == "swf") filePath = nodes[i].@src;
					else filePath = null;
				}
				else if (extension == "swf" || extension == "jpg" || extension == "jpeg" || extension == "png" || extension == "mp3" || extension == "m4a" || extension == "xml" || extension == "txt" || extension == "css" || extension == "flv" || extension == "json")
				{
					var assetPath:String = (nodes[i].parent().@assetPath || siteAssetPath || "");
					filePath = assetPath + nodes[i].@src;
					if (extension == "xml" && nodes[i].@assets == "true") xmlAssetPaths.push({assetPath:assetPath, filePath:filePath});
				}
				if (filePath)
				{
					var size:int = runScript(PROJECT_JSFL, "getFileSize", ProjectUtils.getPublishPath(project) + "/" + filePath);
					if (size) 
					{
						nodes[i].@bytes = size;
						logString += (filePath + ": " + size + "\n");
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
					var size:int = runScript(PROJECT_JSFL, "getFileSize", filePath);
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
			logString += (swfNodes[swfIndex].@src + ": " + swfNodes[swfIndex].@bytes) + "\n";
			swfIndex++;
			loadNextStream();
		}
		private function saveSiteXML():void
		{
			saveTimer.start();			
		}
		private function onSaveTimer(event:TimerEvent):void
		{
			runScript(PROJECT_JSFL, "saveStringFile", ProjectUtils.getSiteXmlPath(currentProject), escape(siteXML));
			siteXML = null;
			siteAssetPath = null;
			swfNodes = null;
			swfIndex = 0;
			saveTimer.reset();
			updateXMLAssetBytes();
		}
		
		
		// EXTERNAL ASSETS
		private function updateXMLAssetBytes():void
		{
			if (xmlAssetPaths.length > 0)
			{
				var url:String = ProjectUtils.getPublishPath(currentProject) + "/" + xmlAssetPaths[0].filePath;
				logString += "\n** Update External Asset Bytes in " + xmlAssetPaths[0].filePath + "**\n"
				loader.load(new URLRequest(url));
			}
			else
			{
				currentProject = null;
				siteAssetPath = null;
				log(logString);
				logString = "";
			}
		}
		private function onLoaderComplete(event:Event):void
		{
			assetXML = XML(event.target.data);
			var nodes:XMLList = assetXML.descendants().(attribute("id").length() > 0 && attribute("src").length() > 0);
			var assetPath:String = xmlAssetPaths[0].assetPath;
			if (currentProject.language == Project.AS3)
			{
				setExternalAssetBytes(currentProject, nodes, assetPath);
				saveAssetXML();
			}
			else
			{
				var nonSWFNodes:XMLList = nodes.(!isSWF(@src));
				setExternalAssetBytes(currentProject, nonSWFNodes, assetPath);
				swfNodes = nodes.(isSWF(@src));
				swfIndex = 0;
				loadNextExternalStream();
			}
			
		}
		private function setExternalAssetBytes(project:Project, nodes:XMLList, assetPath:String):void
		{
			var len:int = nodes.length();
			for (var i:int = 0; i < len; i++)
			{
				var filePath:String;
				var extension:String = String(nodes[i].@src.split(".").pop()).toLowerCase();
				if (extension == "swf" || extension == "jpg" || extension == "jpeg" || extension == "png" || extension == "mp3" || extension == "m4a" || extension == "xml" || extension == "txt" || extension == "css" || extension == "flv" || extension == "json")
				{
					filePath = assetPath + nodes[i].@src;
					var size:int = runScript(PROJECT_JSFL, "getFileSize", ProjectUtils.getPublishPath(project) + "/" + filePath);
					if (size) 
					{
						nodes[i].@bytes = size;
						logString += (filePath + ": " + size + "\n");
					}
				}
			}
		}
		private function loadNextExternalStream():void
		{
			if (swfIndex < swfNodes.length())
			{
				var filePath:String = xmlAssetPaths[0].assetPath + swfNodes[swfIndex].@src;
				externalStream.load(new URLRequest(ProjectUtils.getPublishPath(currentProject) + "/" + filePath));
			}
			else
			{
				saveAssetXML();
			}
		}
		private function onExternalStreamComplete(event:Event):void 
		{
			var bytes:ByteArray = new ByteArray();
			externalStream.readBytes(bytes);
			bytes.endian = Endian.LITTLE_ENDIAN;
			bytes.position = 4;
			swfNodes[swfIndex].@bytes = bytes.readUnsignedInt();
			logString += (swfNodes[swfIndex].@src + ": " + swfNodes[swfIndex].@bytes) + "\n";
			swfIndex++;
			loadNextExternalStream();
		}
		private function saveAssetXML():void
		{
			saveAssetTimer.start();			
		}
		private function onSaveAssetTimer(event:TimerEvent):void
		{
			runScript(PROJECT_JSFL, "saveStringFile", ProjectUtils.getPublishPath(currentProject) + "/" + xmlAssetPaths[0].filePath, escape(assetXML));
			assetXML = null;
			swfNodes = null;
			swfIndex = 0;
			xmlAssetPaths.shift();
			saveAssetTimer.reset();
			updateXMLAssetBytes();
		}
	}
}