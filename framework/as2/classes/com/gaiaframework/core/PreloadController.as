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

import com.gaiaframework.api.IPreloader;
import com.gaiaframework.utils.ObservableClass;
import com.gaiaframework.assets.MovieClipAsset;	
import com.gaiaframework.events.BranchLoaderEvent;	
import com.gaiaframework.events.AssetEvent;	
import com.gaiaframework.events.PageEvent;
import com.gaiaframework.events.Event;
import com.gaiaframework.core.SiteView;
import com.gaiaframework.core.SiteModel;
import mx.utils.Delegate;

class com.gaiaframework.core.PreloadController extends ObservableClass
{
	public static var READY:String = "ready";
	
	private static var showDelay:Number = 150;
		
	private var showInterval:Number;
	
	private var isComplete:Boolean = false;
	
	private var _default:MovieClipAsset;
	private var _current:MovieClipAsset;
	private var _preloader:IPreloader;
	
	private var loadInterval:Number;
	
	private var defaultLoadedDelegate:Function;
	
	function PreloadController(asset:MovieClipAsset)
	{
		super();
		defaultLoadedDelegate = Delegate.create(this, onDefaultLoaded);
		init(asset);
	}
	public static function set delay(value:Number):Void
	{
		showDelay = Math.max(1, value);
	}
	public function get clip():IPreloader
	{
		return _preloader;
	}
	public function get asset():MovieClipAsset
	{
		return _current;
	}
	public function set asset(value:MovieClipAsset):Void
	{
		if (value == undefined || value == null)
		{
			if (_preloader != IPreloader(_default.content))
			{
				removeTransitionOutListener();
				_preloader = IPreloader(_default.content);
				_current = _default;
				addTransitionOutListener();
			}
		}
		else if (IPreloader(value.content).onProgress != undefined)
		{
			removeTransitionOutListener();
			_preloader = IPreloader(value.content);
			_current = value;
			addTransitionOutListener();
		}
		else
		{
			invalidPreloader();
		}
	}
	public function onStart(event:BranchLoaderEvent):Void
	{
		if (_preloader == undefined) _preloader = IPreloader(_default.content);
		isComplete = false;
		clearInterval(showInterval);
		showInterval = setInterval(Delegate.create(this, onShow), showDelay);
	}
	public function onProgress(event:AssetEvent):Void
	{
		_preloader.onProgress(event);
	}
	public function onComplete(event:Event):Void
	{
		isComplete = true;
		_preloader.transitionOut();
	}
	private function onTransitionOutComplete(event:PageEvent):Void
	{
		clearInterval(showInterval);
		dispatchEvent(new Event(Event.COMPLETE, this));
	}
	private function onShow():Void
	{
		clearInterval(showInterval);
		if (!isComplete) _preloader.transitionIn();
		else onTransitionOutComplete(new PageEvent(PageEvent.TRANSITION_OUT_COMPLETE, this));
	}
	private function init(value:MovieClipAsset):Void
	{
		if (value == undefined)
		{
			_default = new MovieClipAsset();
			_default.id = "DefaultPreloader";
			_default.src = SiteModel.preloader;
			_default.depth = "PRELOADER";
			_default.addEventListener(AssetEvent.ASSET_COMPLETE, defaultLoadedDelegate);
			_default.init();
			_default.content = SiteView.preloader.createEmptyMovieClip("DefaultPreloader", SiteView.preloader.getNextHighestDepth());
			_default.preload();
			_current = _default;
		}
		else
		{				
			if (IPreloader(value.content).onProgress != undefined)
			{
				_default = _current = value;
				_preloader = IPreloader(_default.content);
				addTransitionOutListener();
			}
			else
			{
				invalidPreloader(value);
			}
		}
	}
	private function onDefaultLoaded(event:AssetEvent):Void
	{
		_default.content._visible = true;
		_default.removeEventListener(AssetEvent.ASSET_COMPLETE, defaultLoadedDelegate);
		_preloader = IPreloader(_default.content);
		addTransitionOutListener();
		dispatchEvent(new Event(READY, this));
	}
	private function addTransitionOutListener():Void
	{
		_preloader["addEventListener"](PageEvent.TRANSITION_OUT_COMPLETE, Delegate.create(this, onTransitionOutComplete));
	}
	private function removeTransitionOutListener():Void
	{
		_preloader["removeEventListener"](PageEvent.TRANSITION_OUT_COMPLETE, Delegate.create(this, onTransitionOutComplete));
	}
	private function invalidPreloader(value:MovieClipAsset):Void
	{
		throw new Error(value.id + " does not implement IPreloader");
	}
}