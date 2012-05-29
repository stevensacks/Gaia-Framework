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
	import flash.utils.ByteArray;

	/**
	 * This is the interface for the <code>ByteArrayAsset</code>.
	 * 
	 * @see http://www.gaiaflashframework.com/wiki/index.php?title=Assets#ByteArrayAsset.28AS3_only.29 ByteArrayAsset Documentation
	 * 
	 * @author Steven Sacks
	 */
	public interface IByteArray extends IAsset
	{
		/**
		 * Returns the ByteArray
		 */
		function get data():ByteArray;
	}
}