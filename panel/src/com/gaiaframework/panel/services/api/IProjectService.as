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
	
	public interface IProjectService extends IEventDispatcher
	{
		function create(project:Project):void;
		function save(uri:String, data:String):void;
		function update(project:Project):String;
		function resize(project:Project, siteXML:XML):void;
		function getMainProperties(project:Project):String;
		function publish(project:Project, publishAllFiles:Boolean = false):void;
		function openProjectFolder(project:Project):void;
	}
}