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
	public interface IPanelMediator
	{
		function get base():IBaseService;
		function get project():IProjectService;
		function get scaffold():IScaffoldService;
		function get fileSize():IFileSizeService;
		function get optimize():IOptimizeService;
	}
}