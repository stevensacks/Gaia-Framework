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

package com.gaiaframework.panel.skin
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.ToolTip;
	import mx.core.UIComponent;

	public class StageManager extends UIComponent
	{
		public static const MIN_WIDTH:int = 200;
		public static const MAX_WIDTH:int = 278;
		
		private static const SCROLL_WIDTH:int = 20;
		
		private static var stageRef:Stage;
		
		public function StageManager()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(event:Event):void
		{
			stageRef = stage;
			stage.frameRate = 15;
			stage.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}
		public static function get scrollWidth():int
		{
			return ToolTip.maxWidth = panelWidth - SCROLL_WIDTH;
		}
		public static function get panelWidth():int
		{
			if (stageRef) return ToolTip.maxWidth = Math.min(MAX_WIDTH, Math.max(MIN_WIDTH, stageRef.stageWidth));
			return ToolTip.maxWidth = MAX_WIDTH; 
		}
		private function onMouseLeave(event:Event):void
		{
			stage.frameRate = 4;
			stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			stage.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}
		private function onMouseOver(event:MouseEvent):void
		{
			stage.frameRate = 15;
			stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			stage.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}
	}
}