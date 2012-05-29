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

package com.gaiaframework.events
{
	import flash.events.Event;

	public class NetStreamAssetEvent extends Event
	{
		public static const METADATA:String = "metaData";
		public static const CUEPOINT:String = "cuePoint";
		public static const IMAGE_DATA:String = "imageData";
		public static const TEXT_DATA:String = "textData";
		public static const XMP_DATA:String = "xmpData";
		
		public var info:Object;
		
		public function NetStreamAssetEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, info:Object = null)
		{
			super(type, bubbles, cancelable);
			this.info = info;
		}
		public override function clone():Event
		{
			return new NetStreamAssetEvent(type, bubbles, cancelable, info);
		}
		public override function toString():String
		{
			return formatToString("NetStreamAssetEvent", "type", "bubbles", "cancelable", "eventPhase", "info");
		}
	}
}