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

class com.gaiaframework.utils.XML2AS 
{
	public static function parse(n:Object, r:Object):Void {
		var a:Object, d:Object, k:Object;
		if (r[k=n.nodeName] == null) r = ((a=r[k]=[{}]))[d=0];
		else r = (a=r[k])[d=r[k].push({})-1];
		if (n.hasChildNodes()) {
			if ((k=n.firstChild.nodeType) == 1) {
				r.attributes = n.attributes;
				for (var i:String in k=n.childNodes) XML2AS.parse(k[i], r);
			} else if (k == 3) {
				a[d] = new String(n.firstChild.nodeValue);
				a[d].attributes = n.attributes;
			}
		}else r.attributes = n.attributes;
	}
}