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
* http://www.opensource.org/licenses/mit-license 
*****************************************************************************************************/

import com.gaiaframework.templates.AbstractPreloader;
import com.gaiaframework.utils.ObservableClip;
import com.gaiaframework.api.Gaia;
import com.gaiaframework.events.*;
import com.greensock.TweenMax;
import mx.utils.Delegate;

class PACKAGENAME.PreloaderScaffold extends ObservableClip
{
	public var TXT_Overall:TextField;
	public var TXT_Asset:TextField;
	public var TXT_Bytes:TextField;
	public var MC_Bar:MovieClip;
	
	public function PreloaderScaffold()
	{
		super();
		_alpha = 0;
		_visible = false;
		Stage.addListener(this);
		onResize();
	}
	public function transitionIn():Void
	{
		TweenMax.to(this, .1, {autoAlpha:100});
	}
	public function transitionOut():Void
	{
		TweenMax.to(this, .1, {autoAlpha:0});
	}	
	public function onProgress(event:AssetEvent):Void
	{
		// if bytes, don't show if loaded = 0, if not bytes, don't show if perc = 0
		// the reason is because all the files might already be loaded so no need to show preloader
		_visible = event.bytes ? (event.loaded > 0) : (event.perc > 0);
		
		// multiply perc (0-1) by 100 and round for overall 
		TXT_Overall.text = "Loading " + Math.round(event.perc * 100) + "%";
		
		// individual asset percentage (0-1) multiplied by 100 and round for display
		var assetPerc:Number = Math.round(event.asset.percentLoaded * 100) || 0;
		TXT_Asset.text = (event.asset.title || event.asset.id) + " " + assetPerc + "%";
		TXT_Asset.autoSize = "left";
		
		// progress bar scale times percentage (0-1)
		MC_Bar._xscale = event.perc * 100;
		
		// if bytes is true, show the actual bytes loaded and total
		TXT_Bytes.text = (event.bytes) ? event.loaded + " / " + event.total : "";
		TXT_Bytes.autoSize = "left";
	}	
	private function onResize():Void
	{
		_x = (Gaia.api.getWidth() - _width) / 2;
		_y = (Gaia.api.getHeight() - _height) / 2;
	}
}