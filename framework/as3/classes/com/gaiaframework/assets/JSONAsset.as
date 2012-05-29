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

package com.gaiaframework.assets
{
	import com.gaiaframework.api.IJson;
	import com.serialization.json.JSON;

	public class JSONAsset extends TextAsset implements IJson
	{
		function JSONAsset()
		{
			super();
		}
		public function get json():Object
		{			
			return JSON.deserialize(_data);
		}
		override public function toString():String
		{
			return "[JSONAsset] " + _id + " : " + _order + " ";
		}
	}
}