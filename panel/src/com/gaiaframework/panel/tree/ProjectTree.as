package com.gaiaframework.panel.tree
{
	import it.sephiroth.controls.TreeCheckBox;
	import it.sephiroth.renderers.TreecheckboxItemRenderer;
	
	import mx.controls.treeClasses.TreeListData;
	import mx.events.*;
	import mx.managers.PopUpManager;
	
	public class ProjectTree
	{
		[Bindable]
        public var selectedNode:XML;
        
        [Bindable]
        [Embed("/assets/flash/flash_file_icon.png")]
        public var myFlashIcon:Class;
		
		[Bindable]
		[Embed("/assets/flash/main_fla_icon.png")]
        public var myMainIcon:Class;
        
        private var checkClick:Boolean = false;
            
		public function ProjectTree()
		{
			//
		}
		private function treeChanged(event:Event):void 
        {
            selectedNode = TreeCheckBox(event.target).selectedItem as XML;
        }
        private function onItemClick(event:ListEvent):void
        {
        	if (!checkClick && TreeListData(TreecheckboxItemRenderer(event.itemRenderer).listData).hasChildren)
        	{
        		myTree.expandItem(TreecheckboxItemRenderer(event.itemRenderer).data, !TreeListData(TreecheckboxItemRenderer(event.itemRenderer).listData).open, true);
        	} 
        	checkClick = false;
        }
        private function onItemCheck(event:TreeEvent):void
		{
			updateParents(event.item as XML, (event.itemRenderer as TreecheckboxItemRenderer).checkBox.checkState);
			updateChildren(event.item as XML, (event.itemRenderer as TreecheckboxItemRenderer).checkBox.checkState);
			checkClick = true;
		}
		private function updateChildren(item:XML, value:uint):void
        {
	        var middle: Boolean = (value & 2 << 1) == (2 << 1);
	        var selected: Boolean = (value & 1 << 1) == (1 << 1);
        
            if(item.children().length() > 0 && !middle)
            {
                for each(var x:XML in item.node)
                {
                    x.@checked = value == (1 << 1 | 2 << 1) ? "2" : value == (1 << 1) ? "1" : "0";
                    updateChildren(x, value);
                }
            }
        }
        private function updateParents(item:XML, value:uint):void
        {
        	var checkValue: String = (value == (1 << 1 | 2 << 1 ) ? "2" : value == (1 << 1) ? "1" : "0");
            var parentNode: XML = item.parent();
            if(parentNode)
            {
                for each(var x:XML in parentNode.node)
                {
                    if(x.@checked != checkValue) checkValue = "2";
                }
                parentNode.@checked = checkValue;
                updateParents(parentNode, value);
            }
        }
        
        public function init():void
        {
        	PopUpManager.createPopUp(this, DebugWindow, false);
        }
	}
}