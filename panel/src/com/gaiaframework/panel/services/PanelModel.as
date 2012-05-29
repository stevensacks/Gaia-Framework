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

package com.gaiaframework.panel.services
{
	import com.gaiaframework.panel.data.Project;
	import com.gaiaframework.panel.services.api.IPanelMediator;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.collections.XMLListCollection;
	
	public class PanelModel extends EventDispatcher
	{
		[Bindable]
		public var mediator:IPanelMediator;
		
		private var _projects:XMLListCollection;
		private var loader:URLLoader;
		private var uri:String;
		
		private var saveTimer:Timer;
		
		public function PanelModel()
		{
			super();
			loader = new URLLoader();
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.addEventListener(Event.COMPLETE, onPanelProjectsLoaded);
			saveTimer = new Timer(100, 1);
			saveTimer.addEventListener(TimerEvent.TIMER, onSaveTimer);
		}
		[Bindable]
		public function get projects():XMLListCollection 
		{
			return _projects;
		}
		public function set projects(value:XMLListCollection):void
		{
			_projects = value;
		}
		
		public function load():void
		{
			uri = mediator.base.getPanelXMLPath();
			if (mediator.base.fileExists(uri)) 
			{
				loader.load(new URLRequest(uri));
			}
			else
			{
				projects = new XMLListCollection();
				save();	
			}
			projects = new XMLListCollection();
		}
		public function save():void
		{
			var xml:XML = <panel/>;
			xml.appendChild(XMLList(_projects.toXMLString()));
			mediator.project.save(uri, xml.toXMLString());
		}
		public function addProject(project:Project):void
		{
			var node:XML = <project/>;
			node.@name = project.name;
			node.@uri = project.uri;
			node.@modified = project.modified.getTime();
			projects.addItem(node);
			save();
		}
		public function updateProject(project:Project):void
		{
			var i:int = projects.length;
			var match:Boolean;
			while (i--)
			{
				if (projects[i].@uri == project.uri)
				{
					projects[i].@name = project.name;
					projects[i].@uri = project.uri;
					projects[i].@modified = project.modified.getTime();
					match = true;
					break;
				}
			}
			if (!match) addProject(project);
			sortProjects();
			save();
		}
		public function removeProject(uri:String):void
		{
			var i:int = projects.length;
			var match:Boolean;
			while (i--)
			{
				if (projects[i].@uri == uri)
				{
					projects.removeItemAt(i);
					match = true;
					break;
				}
			}
			if (match) save();
		}
		private function onPanelProjectsLoaded(event:Event):void
		{
			projects = new XMLListCollection();
			var nodes:XMLList = XML(event.target.data)..project;
			var len:int = nodes.length();
			for (var i:int = 0; i < len; i++)
			{
				if (mediator.base.fileExists(nodes[i].@uri + "/project.gaia")) projects.addItem(nodes[i]);
			}
			sortProjects();
			saveTimer.start();
		}
		private function sortProjects():void
		{
			try
			{
				var sort:Sort = new Sort();
				sort.fields = [new SortField("@modified", false, true, Array.NUMERIC)];
				projects.sort = sort;
				projects.refresh();
			}
			catch (e:Error)
			{
				mediator.base.log(e.getStackTrace());
			}
		}
		private function onSaveTimer(event:TimerEvent):void
		{
			saveTimer.reset();
			save();
		}
		private function onIOError(event:IOErrorEvent):void
		{
			mediator.base.log(String(event));
		}
	}
}