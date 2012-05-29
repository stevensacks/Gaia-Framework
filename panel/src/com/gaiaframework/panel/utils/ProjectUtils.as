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

package com.gaiaframework.panel.utils
{
	import com.gaiaframework.panel.data.Project;
	import com.gaiaframework.panel.services.Panel;
	
	public class ProjectUtils
	{
		public static function getFlashPath(project:Project):String
		{
			return project.uri + "/" + project.flashPath;
		}
		public static function getPublishPath(project:Project):String
		{
			return project.uri + "/" + project.publishPath;
		}
		public static function getClassesPath(project:Project):String
		{
			return project.uri + "/" + project.classesPath;
		}
		public static function getSiteXmlPath(project:Project):String
		{
			if (project.siteXmlPath.length == 0) return getPublishPath(project) + "/site.xml";
			return getPublishPath(project) + "/" + project.siteXmlPath + "/site.xml";
		}
		public static function getValidatedFolderPath(project:Project, folderPath:String):String
		{
			var index:int = project.uri.indexOf(folderPath);
			if (index == -1) 
			{
				Panel.api.alert("Folder must be within project folder");
				return null;
			}
			return folderPath.substr(index);
		}
		public static function getTweenMaxPath(project:Project):String
		{
			return getClassesPath(project) + "/gs/TweenMax.as";
		}
	}
}