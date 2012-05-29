/*****************************************************************************************************
* Gaia Framework for Adobe Flash ©2007-2012
* Author: Steven Sacks
*
* forum: http://www.gaiaflashframework.com/forum/
* wiki: http://www.gaiaflashframework.com/wiki/
* 
* By using the Gaia Framework, you agree to keep the above contact information in the source code.
* 
* Gaia Framework for Adobe Flash is released under the MIT License:
* http://www.opensource.org/licenses/mit-license.php 
*****************************************************************************************************/

package com.gaiaframework.panel.services.api
{
	import com.gaiaframework.panel.data.Project;
	
	import flash.events.IEventDispatcher;
	
	public interface IBaseService extends IEventDispatcher
	{
		function log(m:String):void;
		function alert(m:String):void;
		function confirm(m:String):void;
		function debug(m:String):void;
		function getFolderPath(msg:String):String;
		function getFilePath(msg:String):String;
		function fileExists(uri:String):Boolean;
		function openFile(uri:String):void;
		function validateProjectPath(project:Project):Boolean;
		function getProjectLanguage(project:Project):String;
		function getPanelXMLPath():String;
		function getFlashVersion():String;
		function openPanelLog():void;
		function clearPanelLog():void;
	}
}