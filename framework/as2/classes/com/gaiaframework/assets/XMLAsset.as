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
import com.gaiaframework.assets.AssetLoader;
import com.gaiaframework.utils.CacheBuster;
import com.gaiaframework.utils.XML2AS;
import mx.utils.Delegate;

class com.gaiaframework.assets.XMLAsset extends AbstractAsset
{
	private var _xml:XML;
	private var _obj:Object;
	private var isSrcXml:Boolean;
	
	function XMLAsset()
	{
		super();
	}
	public function get xml():XML
	{
		return _xml;
	}
	public function get obj():Object
	{
		if (!_obj) 
		{
			_obj = {};
			XML2AS.parse(xml.firstChild, _obj);
		}
		return _obj;
	}
	public function init():Void
	{
		isActive = true;
		_xml = new XML();
		_xml.ignoreWhite = true;
		isSrcXml = Boolean(String(src.split(".").pop()).toLowerCase() == "xml");
	}
	public function preload():Void
	{
		var s:String = isSrcXml ? CacheBuster.create(src) : src;
		_xml.onLoad = Delegate.create(this, onComplete);
		_xml.load(s);
		super.load();
	}
	public function load():Void
	{
		AssetLoader.instance.load(this);
	}
	public function loadOnDemand():Void
	{
		preload();
	}
	public function getBytesLoaded():Number
	{
		return _xml.getBytesLoaded() || 0;
	}
	public function getBytesTotal():Number
	{
		return _xml.getBytesTotal() || 0;
	}
	public function destroy():Void
	{
		delete _xml;
		delete _obj;
		super.destroy();
	}
	public function retry():Void
	{
		var s:String = isSrcXml ? CacheBuster.create(src) : src;
		_xml.load(s);
	}
	public function toString():String
	{
		return "[XMLAsset] " + _id;
	}
}