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
* http://www.opensource.org/licenses/mit-license 
*****************************************************************************************************/

import com.gaiaframework.utils.ObservableClass;
import com.gaiaframework.events.PageEvent;
import com.gaiaframework.assets.PageAsset;
import com.gaiaframework.debug.GaiaDebug;
import mx.utils.Delegate;

class com.gaiaframework.core.TransitionController extends ObservableClass
{	
	private var isInterrupted:Boolean;
	private var transitionState:Number;
	private var outPages:Array;
	private var inPages:Array;
	private var outIndex:Number;
	private var inIndex:Number;
	
	private var transitionInDelegate:Function;
	private var transitionOutDelegate:Function;	
	
	function TransitionController()
	{
		super();
		transitionState = 0;
		isInterrupted = false;
		transitionInDelegate = Delegate.create(this, onTransitionInComplete);
		transitionOutDelegate = Delegate.create(this, onTransitionOutComplete);
	}
	public function transitionOut(pages:Array):Void
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
			dispatchEvent(new PageEvent(PageEvent.TRANSITION_OUT_COMPLETE, this));				
		}
	}
	public function transitionIn(pages:Array):Void
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
			dispatchEvent(new PageEvent(PageEvent.TRANSITION_IN_COMPLETE, this));
		}
	}
	private function onTransitionOutComplete(event:PageEvent):Void
	{
		PageAsset(event.target).removeEventListener(PageEvent.TRANSITION_OUT_COMPLETE, transitionOutDelegate);
		if (!isInterrupted && (--outIndex > -1)) 
		{
			pageOut();
			return;
		} 
		transitionState &= 1;
		isInterrupted = false;
		dispatchEvent(event.clone());
	}
	private function onTransitionInComplete(event:PageEvent):Void
	{
		PageAsset(event.target).removeEventListener(PageEvent.TRANSITION_IN_COMPLETE, transitionInDelegate);
		if (!isInterrupted && (++inIndex < inPages.length))
		{			
			pageIn();
			return;
		}
		transitionState &= 2;
		isInterrupted = false;
		dispatchEvent(event.clone());
	}
	private function pageOut():Void
	{
		PageAsset(outPages[outIndex]).addEventListener(PageEvent.TRANSITION_OUT_COMPLETE, transitionOutDelegate);
		PageAsset(outPages[outIndex]).transitionOut();
	}
	private function pageIn():Void
	{
		PageAsset(inPages[inIndex]).addEventListener(PageEvent.TRANSITION_IN_COMPLETE, transitionInDelegate);
		PageAsset(inPages[inIndex]).transitionIn();
	}
	public function interrupt():Void
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