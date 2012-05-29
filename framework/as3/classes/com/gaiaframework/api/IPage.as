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

package com.gaiaframework.api
{
	import com.gaiaframework.events.GaiaSWFAddressEvent;

	/**
	 * This is the interface implemented by <code>PageAsset</code>.  It contains the three page properties and the onDeeplink event listener.
	 * 
	 * @see http://www.gaiaflashframework.com/wiki/index.php?title=Pages Pages Documentation
	 * 
	 * @author Steven Sacks
	 */
	public interface IPage extends IBase
	{
		/**
		 * [read-only] Returns the PageAsset instance associated with the page .fla file.
		 */
		function get page():IPageAsset;
		/**
		 * @private
		 */
		function set page(value:IPageAsset):void;
		/**
		 * If a page has assets in the site.xml, they are stored in this object by their id.
		 */
		function get assets():Object;
		/**
		 * If a page has SEO turned on in the site.xml and an XHTML page has been generated for this page, the p tag values will be available in the copy Object.
		 */
		function get copy():Object;
		/**
		 * There is an optional page method for deeplink functionality that works with SWFAddress. 
		 * <p>When a deeplink event occurs from SWFAddress, the deeplink will be passed to your page swf via this method. The event has the deeplink property. Gaia handles this for you so you don't have to deal with adding and removing pages as listeners to the deeplink event manually.</p>
		 * 
		 * @param	event Recieves a GaiaSWFAddressEvent with a String property called deeplink.
		 */
		function onDeeplink(event:GaiaSWFAddressEvent):void;
	}
}