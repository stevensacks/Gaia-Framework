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

import com.gaiaframework.assets.AbstractAsset;
import com.gaiaframework.events.Event;

class com.gaiaframework.events.AssetEvent extends Event
{
	public static var ASSET_PROGRESS:String = "assetProgress";
	public static var ASSET_COMPLETE:String = "assetComplete";
	
	public var asset:AbstractAsset;
	public var loaded:Number;
	public var total:Number;
	public var perc:Number;
	public var bytes:Boolean;
	
	public function AssetEvent(type:String, target:Object, asset:AbstractAsset, loaded:Number, total:Number, perc:Number, bytes:Boolean)
	{
		super(type, target);
		this.asset = asset;
		this.loaded = loaded;
		this.total = total;
		this.perc = perc;
		this.bytes = bytes;
	}
	public function clone():Event
	{
		return new AssetEvent(type, target, asset, loaded, total, perc, bytes);
	}
	public function toString():String
	{
		return formatToString("AssetEvent", "type", "asset", "loaded", "total", "perc", "bytes");
	}
}
