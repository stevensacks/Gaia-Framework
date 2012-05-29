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

class com.gaiaframework.debug.GaiaDebug
{		
	public static var isBrowser:Boolean;
	
	public static function log():Void
	{
		if (!isBrowser || _global.Xray == undefined)
		{
			trace(getTrace(arguments));
		}
		else
		{
			_global.tt.apply(null, arguments);
		}
	}
	public static function error():Void
	{
		if (!isBrowser || _global.Xray == undefined)
		{
			trace(getTrace(arguments));
		}
		else
		{
			_global.Xray.xrayLogger.error.apply(null, arguments);
		}
	}
	public static function warn():Void
	{
		if (!isBrowser || _global.Xray == undefined)
		{
			trace(getTrace(arguments));
		}
		else
		{
			_global.Xray.xrayLogger.warn.apply(null, arguments);
		}
	}
	private static function getTrace(a:Array):String
	{
		var l:Number = a.length;
		var str:String = "";
		for (var i:Number = 0; i < a.length; i++)
		{
			str += a[i] + " :: ";
		}
		return str.substr(0, str.length - 4);
	}
}