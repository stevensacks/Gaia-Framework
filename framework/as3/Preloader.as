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

package PACKAGENAME
{
	import com.gaiaframework.templates.AbstractPreloader;
	import com.gaiaframework.events.AssetEvent;
	
	public class Preloader extends AbstractPreloader
	{	
		public var scaffold:PreloaderScaffold;
		
		public function Preloader()
		{
			super();
		}
		override public function transitionIn():void
		{
			scaffold.transitionIn();
			transitionInComplete();
		}		
		override public function transitionOut():void
		{
			scaffold.transitionOut();
			transitionOutComplete();
		}
		override public function onProgress(event:AssetEvent):void
		{
			scaffold.onProgress(event);
		}
	}
}