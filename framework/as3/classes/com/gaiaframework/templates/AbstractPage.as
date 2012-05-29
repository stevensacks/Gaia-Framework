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
	import com.gaiaframework.api.IPage;
	import com.gaiaframework.api.IPageAsset;
	import com.gaiaframework.events.GaiaSWFAddressEvent;

	public class AbstractPage extends AbstractBase implements IPage
	{
		private var _page:IPageAsset;
		
		function AbstractPage()
		{
			super();
		}
		public function get page():IPageAsset
		{
			return _page;
		}
		public function set page(value:IPageAsset):void
		{
			if (_page == null) _page = value;
		}
		public function get assets():Object
		{
			return _page.assets;
		}
		public function get copy():Object
		{
			return _page.copy;
		}
		// IPage Compliance
		public function onDeeplink(event:GaiaSWFAddressEvent):void 
		{
			dispatchEvent(event);
		}
	}
}