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
	import adobe.utils.MMExecute;
	
	import com.gaiaframework.panel.data.Project;
	import com.gaiaframework.panel.services.api.IProjectService;
	import com.gaiaframework.panel.utils.ProjectUtils;
	import com.gaiaframework.panel.utils.SiteXMLUtils;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class JSFLProject extends JSFLBase implements IProjectService
	{		
		private var publishList:XMLList;
		private var publishIndex:int;
		private var publishDelay:Timer;
		private var publishMain:Boolean;
		
		public function JSFLProject()
		{
			super();
			publishDelay = new Timer(1, 1);
			publishDelay.addEventListener(TimerEvent.TIMER_COMPLETE, onPublishDelay);
		}
		public function create(project:Project):void
		{
			var centerX:Boolean = project.width100 ? project.centerX : false;
			var centerY:Boolean = project.height100 ? project.centerY : false;
			runScript(PROJECT_JSFL, "createProject", FRAMEWORK_URI + "/" + project.language.toLowerCase(), project.uri, project.flashPath, project.publishPath, project.classesPath, project.siteXmlPath, project.width, project.height, project.width100, project.height100, centerX, centerY, project.bgColor, project.fps, project.player);
			if (project.flashDevelop) flashDevelop(project);
			if (project.language == Project.AS3 && project.flexBuilder) flexBuilder(project);
		}
		public function flashDevelop(project:Project):void
		{
			runScript(PROJECT_JSFL, "flashDevelop", GAIA_URI, project.uri, project.language, project.name);
		}
		public function flexBuilder(project:Project):void
		{
			runScript(PROJECT_JSFL, "flexBuilder", GAIA_URI + "/fx", project.uri, project.name, project.flashPath, project.publishPath, project.classesPath);
		}
		public function save(uri:String, str:String):void
		{
			runScript(PROJECT_JSFL, "saveStringFile", uri, escape(str));
		}
		public function update(project:Project):String
		{
			var updateResult:String = runScript(PROJECT_JSFL, "updateFramework", FRAMEWORK_URI + "/" + project.language.toLowerCase(), project.uri, project.publishPath, project.classesPath, project.player, project.flashPath);
			return updateResult;
		}
		public function resize(project:Project, siteXML:XML):void
		{
			resizeProject(project);
			var nodes:XMLList = siteXML..page.(String(attribute("src").split(".").pop()).toLowerCase() == "swf");
			var i:int = nodes.length();
			while (i--)
			{
				var src:String = nodes[i].@src;
				src = src.substr(0, src.length - 3) + "fla";
				resizeFlashFile(project, ProjectUtils.getFlashPath(project) + "/" + src);
			}
			var deployPath:String = ProjectUtils.getPublishPath(project);
			i = nodes.length();
			while (i--)
			{
				resizeHTML(project, deployPath + "/" + SiteXMLUtils.getSEOName(nodes[i]));
			}
		}
		public function publish(project:Project, publishAllFiles:Boolean = false):void
		{
			publishMain = false;
			currentProject = project;
			if (!publishAllFiles) publishList = XML(project.publishData.toXMLString())..node.(attribute("src").length() > 0 && attribute("checked") == 1);
			else publishList = XML(project.publishData.toXMLString())..node.(attribute("src").length() > 0);
			publishIndex = -1;
			publishNextFile();
		}
		public function openProjectFolder(project:Project):void
		{
			runScript(PROJECT_JSFL, "openProjectFolder", project.uri);
		}
		private function onPublishDelay(event:TimerEvent):void
		{
			publishDelay.reset();
			runScript(PROJECT_JSFL, "closeCurrentDocument");
			publishNextFile();
		}
		private function publishNextFile():void
		{
			var flVersion:String = MMExecute('fl.version');
			var canPublishSilently:Boolean = FLASH_VERSION == "11" || flVersion.indexOf("10,0,2") > -1;
			var success:String;
			if (++publishIndex < publishList.length())
			{
				var src:String = publishList[publishIndex].@src;
				if (src == "main.fla") 
				{
					publishMain = true;
					publishNextFile();
				}
				else
				{
					var publishLeaveOpen:Boolean = (runScript(PROJECT_JSFL, "getDocumentOpen", src) == "true");
					var publishFunction:String = "openAndPublish";
					if (!publishLeaveOpen && canPublishSilently) publishFunction = "publishSilently";
					success = runScript(PROJECT_JSFL, publishFunction, currentProject.uri, ProjectUtils.getFlashPath(currentProject) + "/" + src);
					if (success == "true")
					{
						if (!publishLeaveOpen && publishFunction == "openAndPublish") publishDelay.start();
						else publishNextFile();
					}
				}
			}
			else
			{
				if (publishMain) 
				{
					var isMainOpen:Boolean = (runScript(PROJECT_JSFL, "getDocumentOpen", "main.fla") == "true");
					if (!isMainOpen && canPublishSilently)
					{
						success = runScript(PROJECT_JSFL, "publishSilently", currentProject.uri, ProjectUtils.getFlashPath(currentProject) + "/main.fla");
						if (success == "true") runScript(PROJECT_JSFL, "testMainSWF", ProjectUtils.getPublishPath(currentProject) + "/main.swf");
					}
					else
					{
						runScript(PROJECT_JSFL, "testMain", ProjectUtils.getFlashPath(currentProject) + "/main.fla");
					}
				}
				else
				{
					runScript(PROJECT_JSFL, "testMainSWF", ProjectUtils.getPublishPath(currentProject) + "/main.swf");
				}
				publishList = null;
				publishIndex = -1;
				publishDelay.reset();
			}
		}
		public function getMainProperties(project:Project):String
		{
			return runScript(PROJECT_JSFL, "getMainProperties", ProjectUtils.getFlashPath(project) + "/main.fla");
		}
		private function resizeProject(project:Project):void
		{
			var centerX:Boolean = project.width100 ? project.centerX : false;
			var centerY:Boolean = project.height100 ? project.centerY : false;
			runScript(PROJECT_JSFL, "resizeProject", project.uri, project.flashPath, project.classesPath, project.width, project.height, centerX, centerY, project.bgColor, project.fps);
		}
		private function resizeFlashFile(project:Project, filePath:String):void
		{
			runScript(PROJECT_JSFL, "resizeFlashFile", filePath, project.width, project.height, project.bgColor, project.fps);
		}
		private function resizeHTML(project:Project, filePath:String):void
		{
			runScript(PROJECT_JSFL, "resizeHTML", filePath, project.width, project.height, project.width100, project.height100, project.bgColor);
		}
	}
}