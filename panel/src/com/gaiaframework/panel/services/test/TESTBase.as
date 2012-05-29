package com.gaiaframework.panel.services.test
{
	import com.gaiaframework.panel.data.Project;
	import com.gaiaframework.panel.events.PanelConfirmEvent;
	import com.gaiaframework.panel.services.api.IBaseService;
	import com.gaiaframework.panel.utils.ProjectUtils;
	
	import flash.events.EventDispatcher;
	
	public class TESTBase extends EventDispatcher implements IBaseService
	{
		protected static var CONFIG_URI:String;
		protected static var GAIA_URI:String;
		protected static var FRAMEWORK_URI:String;
		protected static var PROJECT_TEST:String;
		protected static var SCAFFOLD_TEST:String;
		protected static var SEO_TEST:String;
		protected static var OPTIMIZE_TEST:String;
		protected static var FLASH_VERSION:String;
		
		protected var currentProject:Project;
		
		public function TESTBase()
		{
			if (!CONFIG_URI)
			{
				CONFIG_URI = "C:/";
				GAIA_URI = CONFIG_URI + "GaiaFramework";
				FRAMEWORK_URI = GAIA_URI + "/gaia";
				PROJECT_TEST = GAIA_URI + "/GaiaProject.jsfl";				
				SCAFFOLD_TEST = GAIA_URI + "/GaiaScaffold.jsfl";
				SEO_TEST = GAIA_URI + "/GaiaSEO.jsfl";
				OPTIMIZE_TEST = GAIA_URI + "/GaiaOptimize.jsfl";
				FLASH_VERSION = "11";
			}
		}
		public function log(m:String):void
		{
			DebugWindow.debug(m);
		}
		public function alert(m:String):void
		{
			DebugWindow.debug("ALERT: " + m);
		}
		public function debug(m:String):void
		{
			DebugWindow.debug(m);
		}
		public function confirm(m:String):void
		{
			var result:Boolean = true;
			dispatchEvent(new PanelConfirmEvent(PanelConfirmEvent.CONFIRM, false, false, result));
		}
		public function getFolderPath(msg:String):String
		{
			var uri:String = "C:/test";
			if (uri != null && uri != "null" && uri.length > 0) return uri;
			return null;
		}
		public function getFilePath(msg:String):String
		{
			var uri:String = "C:/test.fla";
			if (uri != null && uri != "null" && uri.length > 0) return uri;
			return null;
		}
		public function getPanelXMLPath():String
		{
			return "file:///C|/Documents%20and%20Settings/Administrator/Local%20Settings/Application%20Data/Adobe/Flash%20CS4/en/Configuration/GaiaFramework/panel.gaia";
		}
		public function fileExists(uri:String):Boolean
		{
			return true;
		}
		public function openFile(uri:String):void
		{
			DebugWindow.debug("openFile: " + uri);
		}
		public function validateProjectPath(project:Project):Boolean
		{
			return true;
		}
		public function getProjectLanguage(project:Project):String
		{
			return Project.AS3;
		}
		public function getFlashVersion():String
		{
			return FLASH_VERSION;
		}
		public function openPanelLog():void
		{
			runScript(PROJECT_TEST, "openPanelLog");
		}
		public function clearPanelLog():void
		{
			runScript(PROJECT_TEST, "clearPanelLog");
		}
		protected function runScript(...args):*
		{
			//DebugWindow.debug('fl.runScript("' + args.join('","') + '");');
			DebugWindow.debug("runScript: " + args[0] + ", " + args[1]);
		}
	}
}