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

package com.gaiaframework.templates
{
	import com.gaiaframework.api.IPreloader;
	import com.gaiaframework.events.AssetEvent;

	public class AbstractPreloader extends AbstractBase implements IPreloader
	{
		public function AbstractPreloader()
		{
			super();
		}
		public function onProgress(event:AssetEvent):void 
		{
			dispatchEvent(event);
		}
	}
}
