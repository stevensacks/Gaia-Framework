package com.gaiaframework.panel.services.test
{
	import com.gaiaframework.panel.services.api.IOptimizeService;
	import com.gaiaframework.panel.data.OptimizeTypes;
	import com.gaiaframework.panel.data.Project;
	import com.gaiaframework.panel.utils.ProjectUtils;
	import flash.events.Event;
	
	public class TESTOptimize extends TESTBase implements IOptimizeService
	{
		public function TESTOptimize()
		{
			super();
		}
		public function optimize(project:Project):void
		{
			var classPath:String = ProjectUtils.getClassesPath(project) + "/com/gaiaframework";
			runScript(OPTIMIZE_TEST, "optimizeProject", project.language, classPath, project.optimizeTypes.bitmapAsset, project.optimizeTypes.bitmapSpriteAsset, project.optimizeTypes.soundAsset, project.optimizeTypes.soundClipAsset, project.optimizeTypes.netStreamAsset, project.optimizeTypes.textAsset, project.optimizeTypes.xmlAsset, project.optimizeTypes.styleSheetAsset, project.optimizeTypes.jsonAsset);
		}
		public function autoDetect(project:Project, siteXML:XML):void
		{
			var nodes:XMLList = siteXML.descendants().(name() == "page" || name() == "asset");
			//
			project.optimizeTypes.bitmapAsset = nodes.(isBitmap(attribute("src").split(".").pop(), attribute("type"))).length() > 0;
			project.optimizeTypes.bitmapSpriteAsset = nodes.(isBitmapSprite(attribute("src").split(".").pop(), attribute("type"))).length() > 0;
			project.optimizeTypes.soundAsset = nodes.(isSound(attribute("src").split(".").pop(), attribute("type"))).length() > 0;
			project.optimizeTypes.soundClipAsset = nodes.(isSoundClip(attribute("src").split(".").pop(), attribute("type"))).length() > 0;
			project.optimizeTypes.netStreamAsset = nodes.(isNetStream(attribute("src").split(".").pop(), attribute("type"))).length() > 0;
			project.optimizeTypes.textAsset = nodes.(isText(attribute("src").split(".").pop(), attribute("type"))).length() > 0;
			project.optimizeTypes.xmlAsset = nodes.(isXML(attribute("src").split(".").pop(), attribute("type"))).length() > 0;
			project.optimizeTypes.styleSheetAsset = nodes.(isStyleSheet(attribute("src").split(".").pop(), attribute("type"))).length() > 0;
			project.optimizeTypes.jsonAsset = nodes.(isJSON(attribute("src").split(".").pop(), attribute("type"))).length() > 0;
			//
			if (project.optimizeTypes.soundClipAsset) project.optimizeTypes.soundAsset = true;
			if (project.optimizeTypes.jsonAsset || project.optimizeTypes.styleSheetAsset || project.optimizeTypes.xmlAsset) project.optimizeTypes.textAsset = true;
		}
		private function isBitmap(ext:String, type:String):Boolean
		{
			return (ext == "jpg" || ext == "jpeg" || ext == "png" || ext == "gif" || type == "bitmap");
		}
		private function isBitmapSprite(ext:String, type:String):Boolean
		{
			return (type == "sprite");
		}
		private function isSound(ext:String, type:String):Boolean
		{
			return (ext == "mp3" || ext == "wav" || type == "sound");
		}
		private function isSoundClip(ext:String, type:String):Boolean
		{
			return (ext == "swf" && type == "sound");
		}
		private function isNetStream(ext:String, type:String):Boolean
		{
			return (ext == "flv" || ext == "m4a" || type == "netstream");
		}
		private function isStyleSheet(ext:String, type:String):Boolean
		{
			return (ext == "css" || type == "stylesheet");
		}
		private function isJSON(ext:String, type:String):Boolean
		{
			return (ext == "json" || type == "json");
		}
		private function isXML(ext:String, type:String):Boolean
		{
			return (ext == "xml" || type == "xml");
		}
		private function isText(ext:String, type:String):Boolean
		{
			return (ext == "txt" || type == "text");
		}
	}
}