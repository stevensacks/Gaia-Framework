package com.gaiaframework.panel.services.test
{
	import com.gaiaframework.panel.services.api.*;
	
	public class TEST implements IPanelMediator
	{
		private var _base:IBaseService;
		private var _project:IProjectService;
		private var _scaffold:IScaffoldService;
		private var _fileSize:IFileSizeService;
		private var _optimize:IOptimizeService;
		
		public function TEST()
		{
			_base = new TESTBase();
			_project = new TESTProject();
			_scaffold = new TESTScaffold();
			_fileSize = new TESTFileSize();
			_optimize = new TESTOptimize();
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