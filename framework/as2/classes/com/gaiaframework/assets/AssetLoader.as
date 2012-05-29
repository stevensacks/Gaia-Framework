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

import com.gaiaframework.utils.ObservableClass;
import com.gaiaframework.assets.MovieClipAsset;
import com.gaiaframework.assets.AbstractAsset;
import com.gaiaframework.events.BranchLoaderEvent;
import com.gaiaframework.events.AssetEvent;
import com.gaiaframework.events.Event;
import com.gaiaframework.core.PreloadController;
import com.gaiaframework.core.SiteController;
import mx.utils.Delegate;

class com.gaiaframework.assets.AssetLoader extends ObservableClass
{
	private static var _instance:AssetLoader;
	
	private var assets:Object;
	private var totalAssets:Number;
	private var completeAssets:Number;
	private var loadingAssets:Number;
	private var assetQueue:Array;
	
	private var eachPerc:Number;
	
	private var preloader:PreloadController;
	
	private var progressDelegate:Function;
	private var completeDelegate:Function;
	private var preloaderStartDelegate:Function;
	private var preloaderProgressDelegate:Function;
	private var preloaderCompleteDelegate:Function;
	
	private var busyInterval:Number;
	
	private function AssetLoader(asset:MovieClipAsset)
	{
		super();
		assets = {};
		totalAssets = completeAssets = loadingAssets = 0;
		assetQueue = [];
		preloader = new PreloadController(asset);
		progressDelegate = Delegate.create(this, onProgress);
		completeDelegate = Delegate.create(this, onComplete);
		preloaderStartDelegate = Delegate.create(preloader, preloader.onStart);
		preloaderProgressDelegate = Delegate.create(preloader, preloader.onProgress);
		preloaderCompleteDelegate = Delegate.create(preloader, preloader.onComplete);
		addEventListener(BranchLoaderEvent.START, preloaderStartDelegate);
		addEventListener(AssetEvent.ASSET_PROGRESS, preloaderProgressDelegate);
		addEventListener(Event.COMPLETE, preloaderCompleteDelegate);
	}
	public static function birth(asset:MovieClipAsset):Void
	{
		if (_instance == null) _instance = new AssetLoader(asset);
	}
	public static function get instance():AssetLoader
	{
		return _instance;
	}
	public function set asset(value:MovieClipAsset):Void
	{
		preloader.asset = value;
	}
	public function get asset():MovieClipAsset
	{
		return preloader.asset;
	}
	public function load(asset:AbstractAsset):Void
	{
		if (asset.percentLoaded < 1)
		{
			if (asset.showProgress)
			{
				if (!assets[asset.id])
				{
					if (totalAssets == 0 && !SiteController.busy) dispatchEvent(new BranchLoaderEvent(BranchLoaderEvent.START, this));
					eachPerc = 1 / ++totalAssets;
					assets[asset.id] = asset;
					asset.addEventListener(AssetEvent.ASSET_PROGRESS, progressDelegate);
					asset.addEventListener(AssetEvent.ASSET_COMPLETE, completeDelegate);
					assetQueue.push(asset);
					loadNextAsset();
				}
				if (SiteController.busy)
				{
					clearInterval(busyInterval);
					busyInterval = setInterval(Delegate.create(this, onCheckBusy), 50);
				}
			}
			else
			{
				asset.loadOnDemand();
			}
		}
	}
	public function abort(asset:AbstractAsset):Void
	{
		if (assets[asset.id])
		{
			removeAssetListeners(asset);
			--loadingAssets;
			eachPerc = 1 / --totalAssets;
			delete assets[asset.id];
			var i:Number = assetQueue.length;
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
	private function loadNextAsset():Void
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
	private function onProgress(event:AssetEvent):Void
	{
		var topPerc:Number = 0;
		var totalPerc:Number = 0;
		var topAsset:AbstractAsset = AbstractAsset(event.target);
		var assetPerc:Number;
		var loadedBytes:Number = 0;
		var totalBytes:Number = 0;
		for (var a:String in assets)
		{
			assetPerc = assets[a].percentLoaded;
			if (assetPerc != 1 && assetPerc > topPerc)
			{
				topPerc = assetPerc;
				topAsset = assets[a];
			}
			totalPerc += (assetPerc * eachPerc);
			totalBytes = (assets[a].bytes > 0 && totalBytes > -1) ? totalBytes + assets[a].bytes : -1;
			if (totalBytes > 0) loadedBytes += assets[a].getBytesLoaded();
		}
		if (totalBytes > 0)
		{
			event = new AssetEvent(AssetEvent.ASSET_PROGRESS, this, topAsset, loadedBytes, totalBytes, totalPerc, true);
		}
		else
		{
			event = new AssetEvent(AssetEvent.ASSET_PROGRESS, this, topAsset, completeAssets, totalAssets, totalPerc);
		}
		if (!SiteController.busy) dispatchEvent(event);
	}
	private function onComplete(event:AssetEvent):Void
	{
		removeAssetListeners(AbstractAsset(event.target));
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
	private function reset():Void
	{
		assets = {};
		completeAssets = totalAssets = loadingAssets = 0;
		if (!SiteController.busy) 
		{
			clearInterval(busyInterval);
			dispatchEvent(new Event(Event.COMPLETE, this));
		}
	}
	private function removeAssetListeners(asset:AbstractAsset):Void
	{
		asset.removeEventListener(AssetEvent.ASSET_PROGRESS, progressDelegate);
		asset.removeEventListener(AssetEvent.ASSET_COMPLETE, completeDelegate);
	}
	private function onCheckBusy(event:Event):Void
	{
		if (!SiteController.busy)
		{
			clearInterval(busyInterval);
			if (totalAssets > 0) dispatchEvent(new BranchLoaderEvent(BranchLoaderEvent.START, this));
		}
	}
}