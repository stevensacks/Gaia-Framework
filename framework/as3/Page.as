package PACKAGENAME
{
	import com.gaiaframework.templates.AbstractPage;
	import com.gaiaframework.events.*;
	import com.gaiaframework.debug.*;
	import com.gaiaframework.api.*;
	import flash.display.*;
	import flash.events.*;%IMPORTS%
	
	public class CLASSNAME extends AbstractPage
	{	
		public function CLASSNAME()
		{
			super();%ALPHA%
			new Scaffold(this);
		}
		override public function transitionIn():void 
		{
			super.transitionIn();%TRANSITIONIN%
		}
		override public function transitionOut():void 
		{
			super.transitionOut();%TRANSITIONOUT%
		}
	}
}