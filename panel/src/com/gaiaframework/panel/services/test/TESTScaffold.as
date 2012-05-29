package com.gaiaframework.panel.services.test
{
	import com.gaiaframework.panel.data.Page;
	import com.gaiaframework.panel.data.Project;
	import com.gaiaframework.panel.services.api.IScaffoldService;
	import com.gaiaframework.panel.utils.ProjectUtils;
	import com.gaiaframework.panel.utils.SiteXMLUtils;
	
	public class TESTScaffold extends TESTBase implements IScaffoldService
	{
		public function TESTScaffold()
		{
			super();
		}
		public function scaffold(project:Project, siteXML:XML):Array
		{
			var generatedPages:Array = [];
			var isFirstTime:Boolean = init(project);
			if (isFirstTime)
			{
				generatedPages = ["main.fla", "preload.fla"];
			}
			var nodes:XMLList = siteXML..page.(String(attribute("src").split(".").pop()).toLowerCase() == "swf");
			var len:int = nodes.length();
			for (var i:int = 0; i < len; i++)
			{
				if (createScaffoldFile(project, nodes[i])) 
				{
					var src:String = nodes[i].@src;
					src = src.substr(0, src.length - 3) + "fla";
					generatedPages.push(src);
				}
			}
			deleteScaffoldFile(project);
			if (project.seo) scaffoldSEO(project, siteXML);
			return generatedPages;
		}
		private function scaffoldSEO(project:Project, siteXML:XML):void
		{
			var delimiter:String = siteXML.@delimiter || ": ";
			var siteTitle:String = siteXML.@title ? String(siteXML.@title).split("%PAGE%").join("").split(delimiter).join("") : "";
			var deployPath:String = ProjectUtils.getPublishPath(project);
			//
			var nodes:XMLList = siteXML..page;
			var seoPages:Array = SiteXMLUtils.getSEOPages(nodes);
			var seoMenu:String = SiteXMLUtils.getSeoMenu(seoPages);
			var len:int = seoPages.length;
			for (var i:int = 0; i < len; i++)
			{
				var page:Page = seoPages[i];
				scaffoldSEOFile(project, FRAMEWORK_URI + "/" + project.language + "/__GaiaDeploy/index.html", deployPath, siteTitle, page, seoMenu);
			}
			generateSiteMap(deployPath, SiteXMLUtils.getSiteMap(seoPages, project.domain));
		}
		private function init(project:Project):Boolean
		{
			var isFirstTime:String = runScript(SCAFFOLD_TEST, "scaffoldInit", project.uri, project.language, project.flashPath, project.publishPath, project.classesPath, project.classPackage, project.template);
			return (isFirstTime == "true");
		}
		private function createScaffoldFile(project:Project, node:XML):Boolean
		{
			var success:String = runScript(SCAFFOLD_TEST, "createScaffoldFile", project.uri, project.language, project.flashPath, project.publishPath, project.classesPath, project.classPackage, project.template, node.@src, SiteXMLUtils.initCap(node.@id));
			return (success == "true");
		}
		private function deleteScaffoldFile(project:Project):void
		{
			runScript(SCAFFOLD_TEST, "deleteScaffoldFile", project.uri, project.flashPath);
		}
		private function scaffoldSEOFile(project:Project, indexPath:String, deployPath:String, siteTitle:String, page:Page, seoMenu:String):void
		{
			runScript(SEO_TEST, "scaffoldSEOFile", indexPath, deployPath, page.seo, siteTitle, page.title, page.branch, escape(seoMenu));
		}
		private function generateSiteMap(deployPath:String, siteMap:String):void
		{
			runScript(SEO_TEST, "generateSiteMap", deployPath, escape(siteMap));
		}
	}
}