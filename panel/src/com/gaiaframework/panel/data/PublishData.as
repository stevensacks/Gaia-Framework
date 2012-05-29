/*****************************************************************************************************
* Gaia Framework for Adobe Flash ©2007-2009
* Author: Steven Sacks
*
* blog: http://www.stevensacks.net/
* forum: http://www.gaiaflashframework.com/forum/
* wiki: http://www.gaiaflashframework.com/wiki/
* 
* By using the Gaia Framework, you agree to keep the above contact information in the source code.
* 
* Gaia Framework for Adobe Flash is released under the GPL License:
* http://www.opensource.org/licenses/mit-license.php 
*****************************************************************************************************/

package com.gaiaframework.panel.data
{
	import mx.collections.XMLListCollection;
	
	public class PublishData extends XMLListCollection
	{
		public function PublishData(source:XMLList = null)
		{
			if (!source) 
			{
				var xml:XML = <node label="project"/>;
				source = new XMLList(xml);
			}
			super(source);
		}
	}
}