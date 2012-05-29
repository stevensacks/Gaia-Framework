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

package com.gaiaframework.panel.events
{
	import flash.events.Event;

	public class SiteXMLEvent extends Event
	{
		public static const SYNC_PUBLISH_COMPLETE:String = "syncPublishComplete";
		public static const SITE_XML_READY:String = "siteXMLReady";
		
		public var xml:XML;
		
		public function SiteXMLEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, xml:XML = null)
		{
			super(type, bubbles, cancelable);
			this.xml = xml;
		}
		public override function clone():Event
		{
			return new SiteXMLEvent(type, bubbles, cancelable, xml);
		}
		public override function toString():String
		{
			return formatToString("SiteXMLEvent", "type", "bubbles", "cancelable", "eventPhase", "xml");
		}
	}
}