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

	public class PanelErrorEvent extends Event
	{
		public static const INVALID_PROJECT:String = "invalidProject";
		public static const INVALID_SITE_XML:String = "invalidSiteXml";
		public static const FILE_NOT_FOUND:String = "fileNotFound";
		public static const INVALID_FIELDS:String = "invalidFields";
		public static const ALL_FIELDS_VALID:String = "allFieldsValid";
		
		public var message:String;
		public var data:String;
		
		public function PanelErrorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, message:String = "", data:String = "")
		{
			super(type, bubbles, cancelable);
			this.message = message;
			this.data = data;
		}
		public override function clone():Event
		{
			return new PanelErrorEvent(type, bubbles, cancelable, message, data);
		}
		public override function toString():String
		{
			return formatToString("PanelErrorEvent", "type", "bubbles", "cancelable", "eventPhase", "message", "data");
		}
	}
}