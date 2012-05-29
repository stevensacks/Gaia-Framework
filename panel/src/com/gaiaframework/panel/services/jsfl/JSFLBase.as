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
	import com.gaiaframework.panel.events.PanelConfirmEvent;
	import com.gaiaframework.panel.services.api.IBaseService;
	import com.gaiaframework.panel.utils.ProjectUtils;
	
	import flash.events.EventDispatcher;
	
	public class JSFLBase extends EventDispatcher implements IBaseService
	{
		protected static var CONFIG_URI:String;
		protected static var GAIA_URI:String;
		protected static var FRAMEWORK_URI:String;
		protected static var PROJECT_JSFL:String;
		protected static var SCAFFOLD_JSFL:String;
		protected static var SEO_JSFL:String;
		protected static var OPTIMIZE_JSFL:String;
		protected static var FLASH_VERSION:String;
		
		protected var currentProject:Project;
		
		public function JSFLBase()
		{
			if (!CONFIG_URI)
			{
				CONFIG_URI = MMExecute("fl.configURI");
				GAIA_URI = CONFIG_URI + "GaiaFramework";
				FRAMEWORK_URI = GAIA_URI + "/gaia";
				PROJECT_JSFL = GAIA_URI + "/GaiaProject.jsfl";				
				SCAFFOLD_JSFL = GAIA_URI + "/GaiaScaffold.jsfl";
				SEO_JSFL = GAIA_URI + "/GaiaSEO.jsfl";
				OPTIMIZE_JSFL = GAIA_URI + "/GaiaOptimize.jsfl";
				FLASH_VERSION = MMExecute('fl.version').split(" ")[1].split(",")[0];
			}
		}
		public function log(m:String):void
		{
			runScript(PROJECT_JSFL, "log", escape(m));
		}
		public function alert(m:String):void
		{
			MMExecute('alert("' + m + '");');
		}
		public function debug(m:String):void
		{
			runScript(PROJECT_JSFL, "debug", escape(m));
		}
		public function confirm(m:String):void
		{
			var result:Boolean = (runScript(PROJECT_JSFL, "doConfirm", escape(m)) == "true");
			dispatchEvent(new PanelConfirmEvent(PanelConfirmEvent.CONFIRM, false, false, result));
		}
		public function getFolderPath(msg:String):String
		{
			var uri:String = MMExecute('fl.browseForFolderURL("' + msg + '");');
			if (uri != null && uri != "null" && uri.length > 0) return uri;
			return null;
		}
		public function getFilePath(msg:String):String
		{
			var uri:String = MMExecute('fl.browseForFileURL("' + msg + '");');
			if (uri != null && uri != "null" && uri.length > 0) return uri;
			return null;
		}
		public function getPanelXMLPath():String
		{
			return GAIA_URI + "/panel.gaia";
		}
		public function fileExists(uri:String):Boolean
		{
			return (MMExecute('fl.fileExists("' + uri + '");') == "true");
		}
		public function openFile(uri:String):void
		{
			if (fileExists(uri)) MMExecute('fl.openDocument("' + uri + '");');
		}
		public function validateProjectPath(project:Project):Boolean
		{
			return fileExists(ProjectUtils.getClassesPath(project) + "/com/gaiaframework/core/GaiaMain.as") || fileExists(ProjectUtils.getFlashPath(project) + "/gaia.swc");
		}
		public function getProjectLanguage(project:Project):String
		{
			return (fileExists(ProjectUtils.getClassesPath(project) + "/com/gaiaframework/core/gaia_internal.as") ? Project.AS3 : Project.AS2);
		}
		public function getFlashVersion():String
		{
			return FLASH_VERSION;
		}
		public function openPanelLog():void
		{
			runScript(PROJECT_JSFL, "openPanelLog");
		}
		public function clearPanelLog():void
		{
			runScript(PROJECT_JSFL, "clearPanelLog");
		}
		protected function runScript(...args):*
		{
			return MMExecute('fl.runScript("' + args.join('","') + '");');
		}
	}
}