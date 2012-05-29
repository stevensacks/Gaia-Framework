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
* http://www.opensource.org/licenses/mit-license.php 
*****************************************************************************************************/

package com.gaiaframework.core
{
	import com.gaiaframework.api.IMovieClip;
	import com.gaiaframework.api.IPreloader;
	import com.gaiaframework.assets.MovieClipAsset;
	import com.gaiaframework.events.AssetEvent;
	import com.gaiaframework.events.BranchLoaderEvent;
	import com.gaiaframework.events.PageEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class PreloadController extends EventDispatcher
	{
		public static const READY:String = "ready";
		
		private static var timerDelay:int = 150;
		
		private var showTimer:Timer = new Timer(150, 1);

		private var isComplete:Boolean = false;
		
		private var _default:IMovieClip;
		private var _current:IMovieClip;
		private var _preloader:IPreloader;
		
		function PreloadController(value:IMovieClip = null)
		{
			super();
			init(value);
			showTimer.addEventListener(TimerEvent.TIMER, onShow);
		}
		public static function set delay(value:int):void
		{
			timerDelay = value;
		}
		public function get clip():IPreloader
		{
			return _preloader;
		}
		public function get asset():IMovieClip
		{
			return _current;
		}
		public function set asset(value:IMovieClip):void
		{
			if (value == null)
			{
				if (_preloader != IPreloader(_default.content))
				{
					removeTransitionOutListener();
					_preloader = IPreloader(_default.content);
					_current = _default;
					addTransitionOutListener();
				}
			}
			else if (value.content as IPreloader != null) 
			{
				removeTransitionOutListener();
				_preloader = IPreloader(value.content);
				_current = value;
				addTransitionOutListener();
			}
			else
			{
				invalidPreloader(value);
			}
		}
		public function onStart(event:BranchLoaderEvent):void
		{
			if (_preloader == null) _preloader = IPreloader(_default.content);
			isComplete = false;
			showTimer.delay = Math.max(1, timerDelay);
			showTimer.start();
		}
		public function onProgress(event:AssetEvent):void
		{
			_preloader.onProgress(event);
		}
		public function onComplete(event:Event):void
		{
			isComplete = true;
			_preloader.transitionOut();
		}
		private function onTransitionOutComplete(event:PageEvent):void
		{
			showTimer.reset();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		private function onShow(event:TimerEvent):void
		{
			showTimer.reset();
			if (!isComplete) _preloader.transitionIn();
			else onTransitionOutComplete(new PageEvent(PageEvent.TRANSITION_OUT_COMPLETE));
		}
		private function init(value:IMovieClip = null):void
		{
			if (value == null)
			{
				var defaultAsset:MovieClipAsset = new MovieClipAsset();
				defaultAsset = new MovieClipAsset();
				defaultAsset.id = "DefaultPreloader";
				defaultAsset.src = SiteModel.preloader;
				defaultAsset.depth = "PRELOADER";
				defaultAsset.domain = SiteModel.preloaderDomain;
				defaultAsset.addEventListener(AssetEvent.ASSET_COMPLETE, onDefaultLoaded);
				defaultAsset.init();
				defaultAsset.preload();
				_default = _current = defaultAsset;
			}
			else
			{
				if (value.content as IPreloader != null) 
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
		private function onDefaultLoaded(event:AssetEvent):void
		{
			_default.content.visible = true;
			_default.removeEventListener(AssetEvent.ASSET_COMPLETE, onDefaultLoaded);
			_preloader = IPreloader(_default.content);
			addTransitionOutListener();
			dispatchEvent(new Event(READY));
		}
		private function addTransitionOutListener():void
		{
			_preloader.addEventListener(PageEvent.TRANSITION_OUT_COMPLETE, onTransitionOutComplete, false, 0, true);
		}
		private function removeTransitionOutListener():void
		{
			_preloader.removeEventListener(PageEvent.TRANSITION_OUT_COMPLETE, onTransitionOutComplete);
		}
		private function invalidPreloader(value:IMovieClip):void
		{
			throw new Error(value.id + " does not implement IPreloader");
		}
	}
}