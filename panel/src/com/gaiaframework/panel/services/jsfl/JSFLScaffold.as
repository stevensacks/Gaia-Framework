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
	import com.gaiaframework.panel.data.Page;
	import com.gaiaframework.panel.data.Project;
	import com.gaiaframework.panel.services.api.IScaffoldService;
	import com.gaiaframework.panel.utils.ProjectUtils;
	import com.gaiaframework.panel.utils.SiteXMLUtils;
	
	public class JSFLScaffold extends JSFLBase implements IScaffoldService
	{
		public function JSFLScaffold()
		{
			super();
		}
		public function scaffold(project:Project, siteXML:XML):Array
		{
			var generatedPages:Array = [];
			init(project);
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
			updatePagesClass(project, SiteXMLUtils.getPageConstants(project.language, siteXML..page));
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
			log("*Scaffold SEO Pages*");
			for (var i:int = 0; i < len; i++)
			{
				var page:Page = seoPages[i];
				log("> " + page.seo);
				scaffoldSEOFile(project, FRAMEWORK_URI + "/" + project.language + "/__GaiaDeploy/index.html", deployPath, siteTitle, page, seoMenu);
			}
			generateSiteMap(deployPath, SiteXMLUtils.getSiteMap(seoPages, project.domain));
		}
		private function init(project:Project):void
		{
			runScript(SCAFFOLD_JSFL, "scaffoldInit", project.uri, project.language, project.flashPath, project.publishPath, project.classesPath, project.classPackage, project.template);
		}
		private function createScaffoldFile(project:Project, node:XML):Boolean
		{
			var pagePackage:String = "";
			if (node.attribute("package").length() > 0) pagePackage = "." + node.attribute("package");
			var success:String = runScript(SCAFFOLD_JSFL, "createScaffoldFile", project.uri, project.language, project.flashPath, project.publishPath, project.classesPath, project.classPackage, pagePackage, project.template, node.@src, SiteXMLUtils.initCap(node.@id));
			return (success == "true");
		}
		private function deleteScaffoldFile(project:Project):void
		{
			runScript(SCAFFOLD_JSFL, "deleteScaffoldFile", project.uri, project.flashPath);
		}
		private function scaffoldSEOFile(project:Project, indexPath:String, deployPath:String, siteTitle:String, page:Page, seoMenu:String):void
		{
			runScript(SEO_JSFL, "scaffoldSEOFile", indexPath, deployPath, page.seo, siteTitle, page.title, page.branch, escape(seoMenu));
		}
		private function generateSiteMap(deployPath:String, siteMap:String):void
		{
			runScript(SEO_JSFL, "generateSiteMap", deployPath, escape(siteMap));
		}
		private function updatePagesClass(project:Project, constants:String):void
		{
			var pagesPath:String = project.uri + "/" + project.classesPath + "/" + (project.classPackage.split(".").join("/")) + "/Pages.as";
			var success:Boolean = runScript(SCAFFOLD_JSFL, "updatePagesClass", pagesPath, project.language, escape(constants)) == "true";
			if (!success)
			{
				var frameworkPagesPath:String = FRAMEWORK_URI + "/" + project.language + "/templates/Pages.as";
				runScript(SCAFFOLD_JSFL, "initPagesClass", frameworkPagesPath, project.uri, project.classesPath, project.classPackage);
				runScript(SCAFFOLD_JSFL, "updatePagesClass", pagesPath, project.language, escape(constants));
			}
		}
	}
}