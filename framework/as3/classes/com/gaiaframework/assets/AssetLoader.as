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

package com.gaiaframework.assets
{
	import com.gaiaframework.api.IMovieClip;
	import com.gaiaframework.core.PreloadController;
	import com.gaiaframework.core.SiteController;
	import com.gaiaframework.events.AssetEvent;
	import com.gaiaframework.events.BranchLoaderEvent;

	import flash.events.*;
	import flash.utils.*;

	public class AssetLoader extends EventDispatcher
	{
		private static var _instance:AssetLoader;
		
		private var assets:Dictionary;
		private var totalAssets:int = 0;
		private var completeAssets:int = 0;
		private var loadingAssets:int = 0;
		private var assetQueue:Array = [];
		
		private var eachPerc:Number;
		
		private var preloader:PreloadController;
		
		private var busyTimer:Timer = new Timer(50);
		
		function AssetLoader(asset:IMovieClip)
		{
			super();
			assets = new Dictionary();
			preloader = new PreloadController(asset);
			busyTimer.addEventListener(TimerEvent.TIMER, onCheckBusy);
			addEventListener(BranchLoaderEvent.START, preloader.onStart);
			addEventListener(AssetEvent.ASSET_PROGRESS, preloader.onProgress);
			addEventListener(Event.COMPLETE, preloader.onComplete);
		}
		public static function birth(asset:IMovieClip):void
		{
			if (_instance == null) _instance = new AssetLoader(asset);
		}
		public static function get instance():AssetLoader
		{
			return _instance;
		}
		public function set asset(value:IMovieClip):void
		{
			preloader.asset = value;
		}
		public function get asset():IMovieClip
		{
			return preloader.asset;
		}
		internal function load(asset:AbstractAsset):void
		{
			if (asset.percentLoaded < 1)
			{
				if (asset.showProgress)
				{
					if (!assets[asset])
					{
						if (totalAssets == 0 && !SiteController.busy) dispatchEvent(new BranchLoaderEvent(BranchLoaderEvent.START));
						eachPerc = 1 / ++totalAssets;
						assets[asset] = asset;
						asset.addEventListener(AssetEvent.ASSET_PROGRESS, onProgress, false, 0, true);
						asset.addEventListener(AssetEvent.ASSET_COMPLETE, onComplete, false, 0, true);
						asset.addEventListener(AssetEvent.ASSET_ERROR, onError, false, 0, true);
						assetQueue.push(asset);
						loadNextAsset();
					}
					if (SiteController.busy) busyTimer.start();
				}
				else
				{
					asset.loadOnDemand();
				}
			}
		}
		internal function abort(asset:AbstractAsset):void
		{
			if (assets[asset])
			{
				removeAssetListeners(asset);
				--loadingAssets;
				eachPerc = 1 / --totalAssets;
				delete assets[asset];
				var i:int = assetQueue.length;
				while (i--)
				{
					if (assetQueue[i] == asset)
					{
						assetQueue.splice(i, 1);
						break;
					}
				}
				if (totalAssets == 0) reset();
			}
		}
		private function loadNextAsset():void
		{
			if (assetQueue.length > 0 && loadingAssets < 2)
			{
				loadingAssets++;
				AbstractAsset(assetQueue.shift()).loadOnDemand();
			}
			else if (assetQueue.length == 0)
			{
				reset();
			}
		}
		private function onProgress(event:AssetEvent):void
		{
			var topPerc:Number = 0;
			var totalPerc:Number = 0;
			var topAsset:AbstractAsset = event.target as AbstractAsset;
			var assetPerc:Number;
			var tAsset:AbstractAsset;
			var loadedBytes:int = 0;
			var totalBytes:int = 0;
			for each (tAsset in assets)
			{
				assetPerc = tAsset.percentLoaded;
				if (assetPerc != 1 && assetPerc > topPerc)
				{
					topPerc = assetPerc;
					topAsset = tAsset;
				}
				totalPerc += (assetPerc * eachPerc);
				totalBytes = (tAsset.bytes > 0 && totalBytes > -1) ? totalBytes + tAsset.bytes : -1;
				if (totalBytes > 0) loadedBytes += tAsset.getBytesLoaded();
			}
			if (totalBytes > 0)
			{
				event = new AssetEvent(AssetEvent.ASSET_PROGRESS, false, false, topAsset, loadedBytes, totalBytes, totalPerc, true);
			}
			else
			{
				event = new AssetEvent(AssetEvent.ASSET_PROGRESS, false, false, topAsset, completeAssets, totalAssets, totalPerc);
			}
			if (!SiteController.busy) dispatchEvent(event);
		}
		private function onComplete(event:AssetEvent):void
		{
			var asset:AbstractAsset = (event.target as AbstractAsset);
			removeAssetListeners(asset);
			if (++completeAssets == totalAssets)
			{
				reset();
			}
			else
			{
				--loadingAssets;
				loadNextAsset();
			}
		}
		private function reset():void
		{
			assets = new Dictionary();
			completeAssets = totalAssets = loadingAssets = 0;
			if (!SiteController.busy) 
			{
				busyTimer.reset();
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		private function onError(event:AssetEvent):void
		{
			removeAssetListeners(event.target as AbstractAsset);
			--loadingAssets;
			eachPerc = 1 / --totalAssets;
			loadNextAsset();
		}
		private function removeAssetListeners(asset:AbstractAsset):void
		{
			asset.removeEventListener(AssetEvent.ASSET_PROGRESS, onProgress);
			asset.removeEventListener(AssetEvent.ASSET_COMPLETE, onComplete);
			asset.removeEventListener(AssetEvent.ASSET_ERROR, onError);
		}
		private function onCheckBusy(event:Event):void
		{
			if (!SiteController.busy)
			{
				busyTimer.reset();
				if (totalAssets > 0) dispatchEvent(new BranchLoaderEvent(BranchLoaderEvent.START));
			}
		}
	}
}