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

package com.gaiaframework.panel.utils
{
	import com.gaiaframework.panel.data.Project;
	import com.gaiaframework.panel.data.PublishData;
	import com.gaiaframework.panel.data.PublishNode;
	import com.gaiaframework.panel.services.api.IBaseService;
	
	public class PublishDataUtils
	{
		public static var base:IBaseService;
		
		public static function addPages(project:Project, array:Array):void
		{
			var obj:Object = convertToObject(XML(project.publishData.toXMLString()));
			var len:int = array.length;
			for (var i:int = 0; i < len; i++)
			{
				var src:String = array[i];
				if (src.indexOf("/") > -1)
				{
					var folderSplit:Array = src.split("/");
					var fileName:String = folderSplit.pop();
					var objPath:Object = recurseFolderPath(obj, folderSplit);
					if (folderSplit.length)
					{
						objPath = createFolderPath(objPath, folderSplit);
					}
					objPath[fileName] = new PublishNode();
					objPath[fileName].label = fileName;
					objPath[fileName].checked = "1";
					objPath[fileName].src = src;
				}
				else
				{
					obj[src] = new PublishNode();
					obj[src].label = src;
					obj[src].checked = "1";
					obj[src].src = src;
				}
			}
			var str:String = '<node label="' + project.flashPath + '">' + parseObject(obj) + '</node>';
			var xml:XML = XML(str);
			setIcons(project, xml);
			sortXML(xml);
			deleteEmptyFolders(xml);
			xml.@checked = updateFolderChecks(xml, "0");
			project.publishData = new PublishData(XMLList(xml.toXMLString()));
		}
		public static function removePages(project:Project, array:Array):void
		{
			var xml:XML = XML(project.publishData.toXMLString());
			var len:int = array.length;
			for (var i:int = 0; i < len; i++)
			{
				delete xml..node.(attribute("src") == array[i])[0];
			}
			setIcons(project, xml);
			sortXML(xml);
			deleteEmptyFolders(xml);
			project.publishData = new PublishData(XMLList(xml.toXMLString()));
		}
        private static function deleteEmptyFolders(xml:XML):void
		{
			var nodes:XMLList = xml..node.(!attribute("src").length() && children().length() == 0);
			var i:int = nodes.length();
			while (i--)
			{
				delete nodes[i];
			}
		}
		private static function setIcons(project:Project, xml:XML):void
		{
			var nodes:XMLList = xml..node.(attribute("label").length() > 0);
			var i:int = nodes.length();
			while (i--)
			{
				if (checkPageExists(project, nodes[i].@src)) 
				{
					if (nodes[i].@src != "main.fla") nodes[i].@icon = "flashFileIcon";
					else nodes[i].@icon = "mainFileIcon";
				}
			}
		}
		private static function updateFolderChecks(xml:XML, checkState:String):String
		{
			var folderNodes:XMLList = xml.node.(children().length() > 0);
			var i:int = folderNodes.length();
			if (i == 0) checkState = "1";
			while (i--)
			{
				var node:XML = folderNodes[i];
				var totalFiles:int = node..node.(attribute("src").length() > 0).length();
				var checkedFiles:int = node..node.(attribute("src").length() > 0 && attribute("checked") == "1").length();
				if (checkedFiles == 0 || totalFiles == 0) 
				{
					node.@checked = "0";
					if (checkState != "0") checkState = "2";
				}
				else if (checkedFiles == totalFiles) 
				{
					node.@checked = "1";
					if (checkState == "0") checkState = "1";
				}
				else 
				{
					node.@checked = "2";
					checkState = "2";
				}
				checkState = updateFolderChecks(node, checkState);
			}
			return checkState;
		}
		private static function checkPageExists(project:Project, filePath:String):Boolean
		{
			return (base.fileExists(ProjectUtils.getFlashPath(project) + "/" + filePath));
		}
		private static function convertToObject(xml:XML):Object
		{
			var nodes:XMLList = xml.node;
			var obj:Object = {};
			parseNodes(nodes, obj);
			return obj;
		}
		private static function parseNodes(nodes:XMLList, obj:Object):void
		{
			var len:int = nodes.length();
			for (var i:int = 0; i < len; i++)
			{
				if (nodes[i].node.length() > 0)
				{
					obj[nodes[i].@label] = {};
					parseNodes(nodes[i].node, obj[nodes[i].@label]);
				}
				else
				{
					var data:PublishNode = new PublishNode();
					data.label = nodes[i].@label;
					data.icon = "flashFileIcon";
					data.checked = nodes[i].@checked;
					data.src = nodes[i].@src;
					obj[data.label] = data;
				}
			}
		}
		private static function parseObject(obj:Object):String
		{
			var str:String = "";
			for (var a:String in obj)
			{
				if (obj[a] is PublishNode) 
				{
					str += obj[a];
				}
				else 
				{
					str += ('<node label="' + a + '">');
					str += parseObject(obj[a]);
					str += ("</node>");
				}
			}
			return str;
		}
		private static function recurseFolderPath(obj:Object, folderSplit:Array):Object
		{
			if (folderSplit.length)
			{
				var folderName:String = folderSplit.shift();
				if (obj.hasOwnProperty(folderName))
				{
					return recurseFolderPath(obj[folderName], folderSplit);
				}
				else
				{
					obj[folderName] = {};
					return obj[folderName];
				}
			}
			return obj;
		}
		private static function createFolderPath(obj:Object, folderSplit:Array):Object
		{
			if (folderSplit.length)
			{
				var folderName:String = folderSplit.shift();
				obj[folderName] = {};
				return createFolderPath(obj[folderName], folderSplit);
			}
			return obj;
		}
		private static function sortXML(xml:XML):XML
		{
			var xmlArray:Array = [];
			var item:XML;
			var object:Object;
			for each(item in xml.children())
			{
				if (item.children().length() > 0) item = sortXML(item);
				object = {data:item, label:item.attribute("label"), children:item.children().length()};
				xmlArray.push(object);
			}
			xmlArray.sort(sortFunc);
			var sortedXmlList:XMLList = new XMLList();
			var xmlObject:Object;
			for each(xmlObject in xmlArray)
			{
				sortedXmlList += xmlObject.data;
			}
			return xml.setChildren(sortedXmlList);
		}
		private static function sortFunc(a:Object, b:Object):int
		{
			var aLabel:String = a.label;
			var bLabel:String = b.label;
			var aChildren:int = a.children;
			var bChildren:int = b.children;
			if (aChildren > 0 && bChildren == 0) return -1
			else if (bChildren > 0 && aChildren == 0) return 1;
			else if (aLabel == "main.fla") return 1;
			else if (bLabel == "main.fla") return -1;
			else if (aLabel > bLabel) return 1;
			else if (aLabel < bLabel) return -1;
			return 0;
		}
	}
}