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
	import com.gaiaframework.panel.utils.ProjectUtils;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	[Event(name="siteXMLReady", type="com.gaiaframework.panel.events.SiteXMLEvent")]
	[Event(name="invalidSiteXml", type="com.gaiaframework.panel.events.PanelErrorEvent")]
	public class SiteXMLService extends EventDispatcher
	{
		private var loader:URLLoader;
		private var project:Project;
		
		public function SiteXMLService()
		{
			super();
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onValidateSiteXML);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		public function load(project:Project):void
		{
			this.project = project;
			loader.load(new URLRequest(ProjectUtils.getSiteXmlPath(project)));
		}
		private function onValidateSiteXML(event:Event):void
		{
			try
			{
				var xml:XML = XML(event.target.data);
				var nodes:XMLList = xml.descendants().(name() == "page" || name() == "asset");
				var invalidNodes:XMLList = nodes.(!attribute("id").length() || !attribute("src").length());
				if (invalidNodes.length() > 0)
				{
					dispatchError("Page & Asset nodes must have id and src attributes", invalidNodes);
					return;
				}
				invalidNodes = nodes.(!(/^[a-z_][a-z0-9_]*$/i.test(@id)));
				if (invalidNodes.length() > 0)
				{
					dispatchError("Page & Asset IDs must be alphanumeric and cannot begin with a number", invalidNodes);
					return;
				}
				var packageNodes:XMLList = xml.descendants().(attribute("package").length() > 0);
				if (packageNodes.length() > 0)
				{
					invalidNodes = packageNodes.(!(/^[a-z][\w\.]*\w+$/i.test(attribute("package"))));
					if (invalidNodes.length() > 0)
					{
						var msg:String = "Invalid package attribute";
						if (invalidNodes.length() > 1) msg += "s";
						dispatchError(msg, invalidNodes);
						return;
					}
				}
				dispatchEvent(new SiteXMLEvent(SiteXMLEvent.SITE_XML_READY, false, false, xml));
				project = null;
			}
			catch (e:Error)
			{
				var message:String = "Could not parse site.xml";
				var data:String = e.getStackTrace();
				dispatchEvent(new PanelErrorEvent(PanelErrorEvent.INVALID_SITE_XML, false, false, message, data));
			}
		}
		private function dispatchError(message:String, invalidNodes:XMLList):void
		{
			dispatchEvent(new PanelErrorEvent(PanelErrorEvent.INVALID_SITE_XML, false, false, message, outputInvalidNodes(invalidNodes)));
		}
		private function onIOError(event:IOErrorEvent):void
		{
			var message:String = "site.xml not found";
			var data:String = "The project's site.xml path is not valid.\n";
			data += project.uri + "/" + project.publishPath + "/" + project.siteXmlPath;
			dispatchEvent(new PanelErrorEvent(PanelErrorEvent.INVALID_SITE_XML, false, false, message, data));
		}
		private function outputInvalidNodes(invalidNodes:XMLList):String
		{
			var str:String;
			var len:int = invalidNodes.length();
			for (var i:int = 0; i < len; i++)
			{
				var s:String = invalidNodes[i].toXMLString();
				str += (s.substr(0, s.indexOf(">") + 1) + "\n");
			}
			return str;
		}
	}
}