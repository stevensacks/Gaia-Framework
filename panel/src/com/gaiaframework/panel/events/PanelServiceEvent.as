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
	import com.gaiaframework.panel.data.Project;
	
	import flash.events.Event;

	public class PanelServiceEvent extends Event
	{
		public static const PROJECT_LOADED:String = "projectLoaded";
		public static const PUBLISH_PROJECT:String = "publishProject";
		
		public var publishAll:Boolean;
		
		public function PanelServiceEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, publishAll:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.publishAll = publishAll;
		}
		public override function clone():Event
		{
			return new PanelServiceEvent(type, bubbles, cancelable, publishAll);
		}
		public override function toString():String
		{
			return formatToString("PanelServiceEvent", "type", "bubbles", "cancelable", "eventPhase", "publishAll");
		}
	}
}