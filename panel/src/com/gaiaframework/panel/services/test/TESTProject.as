package com.gaiaframework.panel.services.test
{
	import com.gaiaframework.panel.data.Project;
	import com.gaiaframework.panel.services.api.IProjectService;
	import com.gaiaframework.panel.utils.ProjectUtils;
	import com.gaiaframework.panel.utils.PublishDataUtils;
	import com.gaiaframework.panel.utils.SiteXMLUtils;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class TESTProject extends TESTBase implements IProjectService
	{		
		private var publishList:XMLList;
		private var publishIndex:int;
		private var publishDelay:Timer;
		private var publishLeaveOpen:Boolean;
		
		public function TESTProject()
		{
			super();
			publishDelay = new Timer(1, 1);
			publishDelay.addEventListener(TimerEvent.TIMER, onPublishDelay);
		}
		public function create(project:Project):void
		{
			runScript(PROJECT_TEST, "createProject", FRAMEWORK_URI + "/" + project.language.toLowerCase(), project.uri, project.flashPath, project.publishPath, project.classesPath, project.width, project.height, project.width100, project.height100, project.centerX, project.centerY);
			if (project.flashDevelop) trace("create FlashDevelop");
			if (project.language == Project.AS3 && project.flexBuilder) trace("create FlexBuilder");
			PublishDataUtils.addPages(project, ["index.fla", "home.fla", "content/about.fla", "content/contact.fla", "content/portfolio.fla", "nav.fla", "sample.fla", "foo.fla"]);
		}
		public function save(uri:String, xml:String):void
		{
			runScript(PROJECT_TEST, "saveStringFile", uri, escape(xml));
		}
		public function update(project:Project):String
		{
			var updateResult:String = runScript(PROJECT_TEST, "updateFramework", FRAMEWORK_URI + "/" + project.language.toLowerCase(), project.uri, project.publishPath, project.classesPath);
			return updateResult;
		}
		public function resize(project:Project, siteXML:XML):void
		{
			resizeProject(project);
			var nodes:XMLList = siteXML..page.(String(attribute("src").split(".").pop()).toLowerCase() == "swf");
			var i:int = nodes.length();
			while (i--)
			{
				resizeFlashFile(project, ProjectUtils.getFlashPath(project) + "/" + nodes[i].@src);
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
			currentProject = project;
			if (!publishAllFiles) publishList = XML(project.publishData.toXMLString())..node.(attribute("src").length() > 0 && attribute("checked") == 1);
			else publishList = XML(project.publishData.toXMLString())..node.(attribute("src").length() > 0);
			publishIndex = -1;
			publishNextFile();
		}
		public function openProjectFolder(project:Project):void
		{
			//foo
		}
		private function onPublishDelay(event:TimerEvent):void
		{
			publishDelay.reset();
			runScript(PROJECT_TEST, "closeCurrentDocument");
			publishNextFile();
		}
		private function publishNextFile():void
		{
			if (++publishIndex < publishList.length())
			{
				var src:String = publishList[publishIndex].@src;
				if (src == "main.fla") 
				{
					publishNextFile();
				}
				else
				{
					var success:String = runScript(PROJECT_TEST, "openAndPublish", currentProject.uri, ProjectUtils.getFlashPath(currentProject) + "/" + src);
					success = "true";
					if (success != "true")
					{
						alert(src + " did not compile correctly");
					}
					else
					{
						if (!publishLeaveOpen) publishDelay.start();
						else publishNextFile();
					}
				}
			}
			else
			{
				runScript(PROJECT_TEST, "testMain", ProjectUtils.getFlashPath(currentProject) + "/main.fla");
				publishList = null;
				publishIndex = -1;
				publishDelay.reset();
				publishLeaveOpen = false;
			}
		}
		public function getMainProperties(project:Project):String
		{
			return runScript(PROJECT_TEST, "getMainDimensions", ProjectUtils.getFlashPath(project) + "/main.fla");
		}
		private function resizeProject(project:Project):void
		{
			runScript(PROJECT_TEST, "resizeProject", project.uri, project.flashPath, project.classesPath, project.width, project.height);
		}
		private function resizeFlashFile(project:Project, filePath:String):void
		{
			runScript(PROJECT_TEST, "resizeFlashFile", filePath, project.width, project.height, false);
		}
		private function resizeHTML(project:Project, filePath:String):void
		{
			runScript(PROJECT_TEST, "resizeHTML", filePath, project.width, project.height, project.width100, project.height100);
		}
	}
}