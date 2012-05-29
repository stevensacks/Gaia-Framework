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

import com.gaiaframework.utils.ObservableClip;
import com.gaiaframework.events.PageEvent;	
import com.gaiaframework.api.IBase;

class com.gaiaframework.templates.AbstractBase extends ObservableClip implements IBase
{
	function AbstractBase()
	{
		super();
	}
	public function transitionIn():Void
	{
		dispatchEvent(new PageEvent(PageEvent.TRANSITION_IN, this));
	}
	public function transitionOut():Void
	{
		dispatchEvent(new PageEvent(PageEvent.TRANSITION_OUT, this));
	}
	public function transitionInComplete():Void
	{
		dispatchEvent(new PageEvent(PageEvent.TRANSITION_IN_COMPLETE, this));
	}
	public function transitionOutComplete():Void
	{
		dispatchEvent(new PageEvent(PageEvent.TRANSITION_OUT_COMPLETE, this));
	}
}