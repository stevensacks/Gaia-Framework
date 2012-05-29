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

import com.gaiaframework.templates.AbstractPage;
import com.gaiaframework.events.PageEvent;
import mx.utils.Delegate;

class PACKAGENAME.Scaffold
{
	private var page:AbstractPage;
	private var isComplete:Boolean = false;
	private var isTransitionIn:Boolean = false;
	
	private var transitionInDelegate:Function;
	private var transitionOutDelegate:Function;
	
	private var SCAFFOLD:MovieClip;
	
	public function Scaffold(ap:MovieClip)
	{
		page = AbstractPage(ap);
		transitionInDelegate = Delegate.create(this, onTransitionIn);
		transitionOutDelegate = Delegate.create(this, onTransitionOut);
		page.addEventListener(PageEvent.TRANSITION_IN, transitionInDelegate);
		page.addEventListener(PageEvent.TRANSITION_OUT, transitionOutDelegate);
		SCAFFOLD = page.createEmptyMovieClip("SCAFFOLD", page.getNextHighestDepth());
		SCAFFOLD.loadMovie("scaffold.swf");
		page.onEnterFrame = Delegate.create(this, pageEnterFrame);
	}
	private function onTransitionIn(event:PageEvent):Void
	{
		page.removeEventListener(PageEvent.TRANSITION_IN, transitionInDelegate);
		isTransitionIn = true;
		transitionIn();
	}
	private function onTransitionOut(event:PageEvent):Void
	{
		page.removeEventListener(PageEvent.TRANSITION_OUT, transitionOutDelegate);
		SCAFFOLD.transitionOut();
	}
	private function pageEnterFrame():Void
	{
		if (SCAFFOLD.getBytesLoaded() == SCAFFOLD.getBytesTotal() && SCAFFOLD.getBytesTotal() > 4)
		{
			isComplete = true;
			page.onEnterFrame = Delegate.create(this, transitionIn);
		}
	}
	private function transitionIn():Void
	{
		if (isComplete && isTransitionIn) 
		{
			SCAFFOLD.transitionIn();
			delete page.onEnterFrame;
		}
	}
}