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

package com.gaiaframework.debug
{
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;
	import flash.system.Security;

	public class GaiaDebug
	{	
		private static var isBrowser:Boolean = (Capabilities.playerType == "ActiveX" || Capabilities.playerType == "PlugIn");
		private static var isConsole:Boolean = ExternalInterface.available && (Security.sandboxType == "remote" || Security.sandboxType == "localTrusted");
		
		public static function log(...args):void
		{
			try
			{
				if (isBrowser && isConsole) ExternalInterface.call("console.log" , args);
			}
			catch (error:Error)
			{
				//
			}
			trace.apply(null, args);
		}
		public static function error(...args):void
		{
			try
			{
				if (isBrowser && isConsole) ExternalInterface.call("console.error" , args);
			}
			catch (error:Error)
			{
				//
			}
			trace.apply(null, args);
		}
		public static function warn(...args):void
		{
			try
			{
				if (isBrowser && isConsole) ExternalInterface.call("console.warn" , args);
			}
			catch (error:Error)
			{
				//
			}
			trace.apply(null, args);
		}
	}
}