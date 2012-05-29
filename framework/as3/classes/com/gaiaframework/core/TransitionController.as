/*****************************************************************************************************
* Gaia Framework for Adobe Flash ©2007-2009
* Author: Steven Sacks
*
* blog: http://www.stevensacks.net/
* git: https://github.com/stevensacks/Gaia-Framework
* support: http://gaiaflashframework.tenderapp.com/
* 
* By using the Gaia Framework, you agree to keep the above contact information in the source code.
* 
* Gaia Framework for Adobe Flash is released under the MIT License:
* http://www.opensource.org/licenses/mit-license.php 
*****************************************************************************************************/

package com.gaiaframework.core
{
	import com.gaiaframework.assets.PageAsset;
	import com.gaiaframework.debug.GaiaDebug;
	import com.gaiaframework.events.PageEvent;

	import flash.events.EventDispatcher;

	public class TransitionController extends EventDispatcher
	{	
		private var isInterrupted:Boolean;
		private var transitionState:int;
		private var outPages:Array;
		private var inPages:Array;
		private var outIndex:int;
		private var inIndex:int;
		
		public function TransitionController()
		{
			super();
		}
		internal function transitionOut(pages:Array):void
		{
			transitionState |= 2;
			isInterrupted = false;
			if (pages.length > 0) 
			{
				outPages = pages;
				outIndex = pages.length - 1;
				pageOut();				
			}
			else
			{
				dispatchEvent(new PageEvent(PageEvent.TRANSITION_OUT_COMPLETE));				
			}
		}
		internal function transitionIn(pages:Array):void
		{
			transitionState |= 1;
			isInterrupted = false;	
			if (pages.length > 0)
			{
				inPages = pages;
				inIndex = 0;
				pageIn();
			}
			else
			{
				dispatchEvent(new PageEvent(PageEvent.TRANSITION_IN_COMPLETE));
			}
		}
		private function onTransitionOutComplete(event:PageEvent):void
		{
			PageAsset(event.target).removeEventListener(PageEvent.TRANSITION_OUT_COMPLETE, onTransitionOutComplete);
			if (!isInterrupted && (--outIndex > -1)) 
			{
				pageOut();
				return;
			} 
			transitionState &= 1;
			isInterrupted = false;
			dispatchEvent(event.clone());
		}
		private function onTransitionInComplete(event:PageEvent):void
		{
			PageAsset(event.target).removeEventListener(PageEvent.TRANSITION_IN_COMPLETE, onTransitionInComplete);
			if (!isInterrupted && (++inIndex < inPages.length))
			{			
				pageIn();
				return;
			}
			transitionState &= 2;
			isInterrupted = false;
			dispatchEvent(event.clone());
		}
		private function pageOut():void
		{
			PageAsset(outPages[outIndex]).addEventListener(PageEvent.TRANSITION_OUT_COMPLETE, onTransitionOutComplete);
			PageAsset(outPages[outIndex]).transitionOut();
		}
		private function pageIn():void
		{
			PageAsset(inPages[inIndex]).addEventListener(PageEvent.TRANSITION_IN_COMPLETE, onTransitionInComplete);
			PageAsset(inPages[inIndex]).transitionIn();
		}
		internal function interrupt():void
		{
			if (!isInterrupted && transitionState > 0) 
			{
				isInterrupted = true;
				var transitionDirection:String = "";
				if (transitionState & 1) transitionDirection = "IN";
				if (transitionState & 2) transitionDirection += "OUT";
				if (transitionDirection == "INOUT") transitionDirection = "CROSS";
				GaiaDebug.log(">>> INTERRUPT " + transitionDirection + " <<<");
			}
		}
	}
}