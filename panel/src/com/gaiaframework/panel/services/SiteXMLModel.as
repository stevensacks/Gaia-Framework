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

package com.gaiaframework.panel.services
{
	import com.gaiaframework.panel.data.Project;
	import com.gaiaframework.panel.events.PanelErrorEvent;
	import com.gaiaframework.panel.events.SiteXMLEvent;
	import com.gaiaframework.panel.services.api.IPanelMediator;
	import com.gaiaframework.panel.utils.PublishDataUtils;
	
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	
	[Event(name="siteXMLReady", type="com.gaiaframework.panel.events.SiteXMLEvent")]
	[Event(name="syncPublishComplete", type="com.gaiaframework.panel.events.SiteXMLEvent")]
	[Event(name="invalidSiteXml", type="com.gaiaframework.panel.events.PanelErrorEvent")]
	public class SiteXMLModel extends EventDispatcher
	{
		private var mediator:IPanelMediator;
		private var service:SiteXMLService;
		private var project:Project;
		
		public function SiteXMLModel(mediator:IPanelMediator)
		{
			this.mediator = mediator;
			service = new SiteXMLService();
			service.addEventListener(PanelErrorEvent.INVALID_SITE_XML, onInvalidSiteXML);
		}
		public function load(project:Project):void
		{
			service.addEventListener(SiteXMLEvent.SITE_XML_READY, onSiteXMLReady);
			service.load(project);
		}
		public function syncProjectPublish(project:Project):void
		{
			this.project = project;
			service.addEventListener(SiteXMLEvent.SITE_XML_READY, onReadyToSync);
			service.load(project);
		}
		private function onSiteXMLReady(event:SiteXMLEvent):void
		{
			service.removeEventListener(SiteXMLEvent.SITE_XML_READY, onSiteXMLReady);
			dispatchEvent(event);
		}
		private function onReadyToSync(event:SiteXMLEvent):void
		{
			project.publishData.removeAll();
			var generatedPages:Array = ["main.fla", "preload.fla"];
			var nodes:XMLList = event.xml..page.(String(attribute("src").split(".").pop()).toLowerCase() == "swf");
			var len:int = nodes.length();
			for (var i:int = 0; i < len; i++)
			{
				var src:String = nodes[i].@src;
				src = src.substr(0, src.length - 3) + "fla";
				if (mediator.base.fileExists(project.uri + "/" + project.flashPath + "/" + src)) 
				{
					generatedPages.push(src);
				}
			}
			PublishDataUtils.addPages(project, generatedPages);
			project = null;
			dispatchEvent(new SiteXMLEvent(SiteXMLEvent.SYNC_PUBLISH_COMPLETE));
		}
		private function onInvalidSiteXML(event:PanelErrorEvent):void
		{
			dispatchEvent(event);
		}
	}
}