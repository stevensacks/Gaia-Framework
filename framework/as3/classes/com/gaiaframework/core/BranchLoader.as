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
	import com.gaiaframework.api.IAsset;
	import com.gaiaframework.assets.AbstractAsset;
	import com.gaiaframework.assets.PageAsset;
	import com.gaiaframework.debug.GaiaDebug;
	import com.gaiaframework.events.AssetEvent;
	import com.gaiaframework.events.BranchLoaderEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	// BranchLoader takes a branch string and uses BranchIterator to load every page and asset for each Branch
	// It dispatches the total and individual file progress

	public class BranchLoader extends EventDispatcher
	{		
		private var isBytes:Boolean;
		private var percLoaded:Number;
		private var eachPerc:Number;	
		private var current:int;
		private var loaded:int;
		private var total:int;
		
		private var loadedFiles:int;
		private var totalFiles:int;
		private var actualLoaded:int;
		private var actualTotal:int;
		
		private var _currentAsset:AbstractAsset;
		
		private static var _timeoutLength:int = 10000;
		private static var loadTimeoutTimer:Timer;
		private var retryAttempts:Number = 0;
		
		function BranchLoader()
		{
			super();
			loadTimeoutTimer = new Timer(_timeoutLength);
			loadTimeoutTimer.addEventListener(TimerEvent.TIMER, loadRetry, false, 0, true);
		}
		public static function set timeoutLength(value:int):void
		{
			_timeoutLength = Math.max(3000, value);
			loadTimeoutTimer.delay = _timeoutLength;
		}
		public function loadBranch(branch:String):void
		{
			percLoaded = eachPerc = loaded = total = loadedFiles = totalFiles = actualLoaded = actualTotal = retryAttempts = 0;
			total = getBranchBytes(branch);
			totalFiles = BranchIterator.init(branch);
			if (total > 0)
			{
				isBytes = true;
			}
			else
			{
				actualTotal = getActualTotal(branch);
				totalFiles = BranchIterator.init(branch);
				isBytes = false;
				current = -1;
				eachPerc = 1 / actualTotal;
			}
			dispatchEvent(new BranchLoaderEvent(BranchLoaderEvent.START));
			loadNext();
		}
		public function get currentAsset():AbstractAsset
		{
			return _currentAsset;
		}
		public function interrupt():void
		{
			GaiaDebug.log(">>> INTERRUPT PRELOAD <<<");
			_currentAsset.abort();
			_currentAsset.destroy();
			total = loaded;
			totalFiles = loadedFiles;
			actualTotal = actualLoaded;
			dispatchComplete();
		}
		private function loadNext():void
		{
			_currentAsset = BranchIterator.next();
			if (_currentAsset && !_currentAsset.active) {
				if (_currentAsset.preloadAsset)
				{
					loadTimeoutTimer.start();
					_currentAsset.addEventListener(AssetEvent.ASSET_PROGRESS, onProgress);
					_currentAsset.addEventListener(AssetEvent.ASSET_COMPLETE, onComplete);
					_currentAsset.addEventListener(AssetEvent.ASSET_ERROR, onError);
				}
				_currentAsset.init();
				var type:String = (_currentAsset is PageAsset) ? BranchLoaderEvent.LOAD_PAGE : BranchLoaderEvent.LOAD_ASSET;
				dispatchEvent(new BranchLoaderEvent(type, false, false, _currentAsset));
				if (!_currentAsset.preloadAsset) onComplete(new AssetEvent(AssetEvent.ASSET_COMPLETE, false, false, _currentAsset));
			}
			else 
			{
				if (isBytes && _currentAsset && _currentAsset.preloadAsset) total -= _currentAsset.bytes;
				next(true);
			}
		}
		private function onProgress(event:AssetEvent):void
		{
			if (isNaN(event.perc)) event.perc = 0;
			if (event.perc > 0) loadTimeoutTimer.reset();
			if (isBytes)
			{
				current = (event.loaded <= event.total) ? event.loaded : 0;
				percLoaded = Math.min(1, (loaded + current) / total);
			}
			else
			{
				percLoaded = (actualLoaded * eachPerc) + (eachPerc * event.perc);
			}
			dispatchProgress();
		}
		private function onComplete(event:AssetEvent):void
		{
			removeAssetListeners(event.asset);
			if (isBytes)
			{
				if (event.asset.preloadAsset) loaded += event.asset.bytes;
				current = 0;
			}
			next();
		}
		private function onError(event:AssetEvent):void
		{
			removeAssetListeners(_currentAsset);
			if (isBytes) loaded += _currentAsset.bytes;
			next();
		}
		private function next(skip:Boolean = false):void
		{
			loadTimeoutTimer.reset();
			++loadedFiles;
			if (!skip && _currentAsset.preloadAsset) ++actualLoaded;
			if (loadedFiles < totalFiles) 
			{
				percLoaded = Math.min(1, (isBytes ? loaded / total : actualLoaded * eachPerc));
				if (_currentAsset && _currentAsset.preloadAsset) dispatchProgress();
				loadNext();
			}
			else 
			{
				total = loaded;
				totalFiles = loadedFiles;
				actualTotal = actualLoaded;
				dispatchComplete();
			}
		}
		private function dispatchProgress():void
		{
			if (isBytes) dispatchEvent(new AssetEvent(AssetEvent.ASSET_PROGRESS, false, false, _currentAsset, loaded + current, total, percLoaded, true));
			else dispatchEvent(new AssetEvent(AssetEvent.ASSET_PROGRESS, false, false, _currentAsset, actualLoaded - 1, actualTotal, percLoaded, false));
		}
		private function dispatchComplete():void
		{
			loadTimeoutTimer.reset();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		private function removeAssetListeners(asset:IAsset):void
		{
			asset.removeEventListener(AssetEvent.ASSET_PROGRESS, onProgress);
			asset.removeEventListener(AssetEvent.ASSET_COMPLETE, onComplete);
			asset.removeEventListener(AssetEvent.ASSET_ERROR, onError);
		}
		private function loadRetry(event:TimerEvent):void
		{
			GaiaDebug.warn(_currentAsset.id + ".retry(" + ++retryAttempts + ")");
			_currentAsset.retry();
		}
		private function getBranchBytes(branch:String):int
		{
			var bytes:int = 0;
			BranchIterator.init(branch);
			var asset:AbstractAsset;
			while (true)
			{
				asset = BranchIterator.next();
				if (asset == null) break;
				if (asset.bytes == 0)
				{
					bytes = 0;
					break;
				}
				else if (asset.preloadAsset)
				{
					bytes += asset.bytes;
				}
			}
			return bytes;
		}
		private function getActualTotal(branch:String):int
		{
			var count:int = 0;
			BranchIterator.init(branch);
			var asset:AbstractAsset;
			while (true)
			{
				asset = BranchIterator.next();
				if (asset == null) break;
				else if (asset.preloadAsset && !asset.active) count++;
			}
			return count;
		}
	}
}