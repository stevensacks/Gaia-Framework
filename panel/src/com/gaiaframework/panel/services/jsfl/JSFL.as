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

package com.gaiaframework.panel.services.jsfl
{
	import com.gaiaframework.panel.services.api.*;
	
	public class JSFL implements IPanelMediator
	{
		private var _base:IBaseService;
		private var _project:IProjectService;
		private var _scaffold:IScaffoldService;
		private var _fileSize:IFileSizeService;
		private var _optimize:IOptimizeService;
		
		public function JSFL()
		{
			_base = new JSFLBase();
			_project = new JSFLProject();
			_scaffold = new JSFLScaffold();
			_fileSize = new JSFLFileSize();
			_optimize = new JSFLOptimize();
		}
		public function get base():IBaseService
		{
			return _base;
		}
		public function get project():IProjectService
		{
			return _project;
		}
		public function get scaffold():IScaffoldService
		{
			return _scaffold;
		}
		public function get fileSize():IFileSizeService
		{
			return _fileSize;
		}
		public function get optimize():IOptimizeService
		{
			return _optimize;
		}
	}
}