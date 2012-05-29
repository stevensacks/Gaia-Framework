/*****************************************************************************************************
* Gaia Framework for Adobe Flash ©2007-2012
* Author: Steven Sacks
*
* git: https://github.com/stevensacks/Gaia-Framework
* wiki: http://www.gaiaflashframework.com/wiki/
* 
* By using the Gaia Framework, you agree to keep the above contact information in the source code.
* 
* Gaia Framework for Adobe Flash is released under the MIT License:
* http://www.opensource.org/licenses/mit-license.php 
*****************************************************************************************************/

package com.gaiaframework.panel.controls
{
	import flash.events.Event;
	
	import mx.controls.colorPickerClasses.*;
	import mx.controls.ColorPicker;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	public class GaiaColorPicker extends ColorPicker
	{
		public function GaiaColorPicker()
		{
			super();
		}
		override mx_internal function displayDropdown(show:Boolean, trigger:Event = null):void
		{
			super.displayDropdown(show, trigger);
			var dropdown:SwatchPanel = getDropdown();
			if (dropdown) dropdown.x -= (x - 2);
		}
	}
}