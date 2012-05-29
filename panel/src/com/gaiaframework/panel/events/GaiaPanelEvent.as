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

	public class GaiaPanelEvent extends Event
	{
		public static const CREATE_PROJECT:String = "createProject";
		public static const SCAFFOLD_PROJECT:String = "scaffoldProject";
		public static const CLOSE_PROJECT:String = "closeProject";
		
		public function GaiaPanelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		public override function clone():Event
		{
			return new GaiaPanelEvent(type, bubbles, cancelable);
		}
		public override function toString():String
		{
			return formatToString("GaiaPanelEvent", "type", "bubbles", "cancelable", "eventPhase");
		}
	}
}