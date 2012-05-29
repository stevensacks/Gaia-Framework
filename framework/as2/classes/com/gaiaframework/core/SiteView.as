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

import com.gaiaframework.utils.ObservableClip;
import com.gaiaframework.assets.MovieClipAsset;
import com.gaiaframework.assets.AbstractAsset;
import com.gaiaframework.assets.PageAsset;
import com.gaiaframework.assets.SoundAsset;
import com.gaiaframework.events.Event;
import com.gaiaframework.core.SiteModel;
import com.gaiaframework.api.Gaia;

class com.gaiaframework.core.SiteView extends ObservableClip
{	
	private static var PRELOADER:MovieClip;
	private var BOTTOM:MovieClip;
	private var MIDDLE:MovieClip;
	private var TOP:MovieClip;
	
	private var activePage:PageAsset;
	private var _clip:MovieClip;
	
	private static var depths:Object;
	
	private static var _instance:SiteView;
	
	public function SiteView(mc:MovieClip)
	{
		super();
		_clip = mc;
		BOTTOM = mc.createEmptyMovieClip("BOTTOM", 1);
		MIDDLE = mc.createEmptyMovieClip("MIDDLE", 3);
		TOP = mc.createEmptyMovieClip("TOP", 5);
		var d:Number = 6;
		if (SiteModel.preloaderDepth == Gaia.MIDDLE) d = 4;
		else if (SiteModel.preloaderDepth == Gaia.BOTTOM) d = 2;
		PRELOADER = mc.createEmptyMovieClip("PRELOADER", d);
		depths = {};
		depths[Gaia.PRELOADER] = PRELOADER;
		depths[Gaia.BOTTOM] = BOTTOM;
		depths[Gaia.MIDDLE] = MIDDLE;
		depths[Gaia.TOP] = TOP;
		_instance = this;
	}
	public static function get instance():SiteView
	{
		return _instance;
	}
	public function get clip():MovieClip
	{
		return _clip;
	}
	public static function getDepthContainer(name:String):MovieClip
	{
		return depths[name];
	}
	public static function get preloader():MovieClip
	{
		return PRELOADER;
	}
	public function addPage(page:PageAsset):Void
	{
		activePage = page;
		var targetClipName:String = activePage.branch.split("/").join("_");
		activePage.content = MovieClip(depths[activePage.depth]).createEmptyMovieClip(targetClipName, MovieClip(depths[activePage.depth]).getNextHighestDepth());
	}
	public function addAsset(asset:AbstractAsset):Void
	{
		var assetClipName:String = activePage.branch.split("/").join("_") + "_$" + asset.id;
		var content:MovieClip;
		if (asset instanceof MovieClipAsset) 
		{
			content = MovieClip(depths[MovieClipAsset(asset).depth]).createEmptyMovieClip(assetClipName, MovieClip(depths[MovieClipAsset(asset).depth]).getNextHighestDepth());
			MovieClipAsset(asset).content = content;
		}
		else 
		{
			content = MovieClip(depths[activePage.depth]).createEmptyMovieClip(assetClipName, MovieClip(depths[activePage.depth]).getNextHighestDepth());
			SoundAsset(asset).content = content;
		}
		// asset clips are put off stage until they're done loading (so they don't appear)
		content._x = content._y = 5000;
	}
}