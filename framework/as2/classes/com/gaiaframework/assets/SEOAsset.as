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

import com.gaiaframework.assets.XMLAsset;
import com.gaiaframework.debug.GaiaDebug;
import mx.utils.Delegate;

class com.gaiaframework.assets.SEOAsset extends XMLAsset
{
	private var _copy:Object;
	
	function SEOAsset()
	{
		super();
	}
	public function get copy():Object
	{
		return _copy;
	}
	public function init():Void
	{
		super.init();
		var ext:String = String(src.split(".").pop()).toLowerCase();
		isSrcXml = Boolean(ext == "html" || ext == "htm");
	}
	private function onComplete():Void
	{
		_copy = {};
		var body:Object = obj.html[0].body[0];
		var div:Object = findCopyDiv(body.div);
		var i:Number = div.p.length;
		while (i--)
		{
			_copy[div.p[i].attributes.id] = div.p[i].toString();
		}
		var raw:String = xml.toString();
		var start:Number = raw.indexOf('<div id="copy">');
		start = raw.indexOf('<p', start);
		var end:Number = raw.indexOf('</div>', start);
		_copy.innerHTML = raw.substring(start, end);	
		super.onComplete();
	}
	private function findCopyDiv(nodes:Array):Object
	{
		var div:Object;
		var i:Number = nodes.length;
		var a:String;
		while (i--)
		{
			if (nodes[i].attributes.id == "copy")
			{
				div = nodes[i];
				break;
			}
			else
			{
				if (nodes[i].div.length > 0)
				{
					div = findCopyDiv(nodes[i].div);
					if (div != undefined) break;
				}
			}
		}
		return div;
	}
	public function toString():String
	{
		return "[SEOAsset] " + _id;
	}
}