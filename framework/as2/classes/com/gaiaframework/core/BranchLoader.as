
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

import com.gaiaframework.events.BranchLoaderEvent;
import com.gaiaframework.events.AssetEvent;
import com.gaiaframework.events.Event;
import com.gaiaframework.utils.ObservableClass;
import com.gaiaframework.core.BranchIterator;
import com.gaiaframework.assets.AbstractAsset;
import com.gaiaframework.assets.PageAsset;
import com.gaiaframework.debug.GaiaDebug;
import mx.utils.Delegate;

// BranchLoader takes a branch string and uses BranchIterator to load every page and asset for each Branch
// It dispatches the total and individual file progress

class com.gaiaframework.core.BranchLoader extends ObservableClass
{
	private var progressDelegate:Function;
	private var completeDelegate:Function;
	
	private var isBytes:Boolean;
	private var percLoaded:Number;
	private var eachPerc:Number;	
	private var current:Number;
	private var loaded:Number;
	private var total:Number;
	
	private var loadedFiles:Number;
	private var totalFiles:Number;
	private var actualLoaded:Number;
	private var actualTotal:Number;
	
	private var _currentAsset:AbstractAsset;
	
	private var isInterrupted:Boolean = false;
	
	private static var _timeoutLength:Number = 3000;
	private var loadTimeoutInterval:Number;
	private var retryAttempts:Number = 0;
	
	function BranchLoader()
	{
		super();
		progressDelegate = Delegate.create(this, onProgress);
		completeDelegate = Delegate.create(this, onComplete);
	}
	public static function set timeoutLength(value:Number):Void
	{
		_timeoutLength = Math.max(3000, value);
	}
	public function loadBranch(branch:String):Void
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
		isInterrupted = false;
		dispatchEvent(new BranchLoaderEvent(BranchLoaderEvent.START, this));
		loadNext();
	}
	public function get currentAsset():AbstractAsset
	{
		return _currentAsset;
	}
	public function interrupt():Void
	{
		GaiaDebug.log(">>> INTERRUPT PRELOAD <<<");
		isInterrupted = true;
	}
	private function loadNext():Void
	{
		_currentAsset = BranchIterator.next();
		if (!_currentAsset.active) {
			clearInterval(loadTimeoutInterval);
			if (_currentAsset.preloadAsset)
			{
				loadTimeoutInterval = setInterval(Delegate.create(this, loadRetry), _timeoutLength);
				_currentAsset.addEventListener(AssetEvent.ASSET_PROGRESS, progressDelegate);
				_currentAsset.addEventListener(AssetEvent.ASSET_COMPLETE, completeDelegate);
			}
			_currentAsset.init();
			var type:String = (_currentAsset instanceof PageAsset) ? BranchLoaderEvent.LOAD_PAGE : BranchLoaderEvent.LOAD_ASSET;
			dispatchEvent(new BranchLoaderEvent(type, this, _currentAsset));
			if (!_currentAsset.preloadAsset) onComplete(new AssetEvent(AssetEvent.ASSET_COMPLETE, this, _currentAsset));
		}
		else 
		{
			if (isBytes && _currentAsset != null && _currentAsset.preloadAsset) total -= _currentAsset.bytes;
			next(true);
		}
	}
	private function onProgress(event:AssetEvent):Void
	{
		if (isNaN(event.perc)) event.perc = 0;
		if (loadTimeoutInterval != undefined && event.perc > 0) 
		{
			clearInterval(loadTimeoutInterval);
			delete loadTimeoutInterval;
		}
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
	private function onComplete(event:AssetEvent):Void
	{
		removeAssetListeners(event.asset);
		if (isBytes)
		{
			if (event.asset.preloadAsset) loaded += event.asset.bytes;
			current = 0;
		}
		next();
	}
	private function next(skip:Boolean):Void
	{
		clearInterval(loadTimeoutInterval);
		++loadedFiles;
		if (!skip && currentAsset.preloadAsset) ++actualLoaded;
		if (loadedFiles < totalFiles && !isInterrupted) 
		{
			percLoaded = Math.min(1, (isBytes ? loaded / total : actualLoaded * eachPerc));
			if (_currentAsset.preloadAsset) dispatchProgress();
			loadNext();
		} 
		else 
		{
			isInterrupted = false;
			total = loaded;
			totalFiles = loadedFiles;
			actualTotal = actualLoaded;
			dispatchComplete();
		}
	}
	private function dispatchProgress():Void
	{
		if (isBytes) dispatchEvent(new AssetEvent(AssetEvent.ASSET_PROGRESS, this, _currentAsset, loaded + current, total, percLoaded, true));
		else dispatchEvent(new AssetEvent(AssetEvent.ASSET_PROGRESS, this, _currentAsset, actualLoaded - 1, actualTotal, percLoaded, false));
	}
	private function dispatchComplete():Void
	{
		clearInterval(loadTimeoutInterval);
		dispatchEvent(new Event(Event.COMPLETE, this));
	}
	private function removeAssetListeners(asset:AbstractAsset):Void
	{
		asset.removeEventListener(AssetEvent.ASSET_PROGRESS, progressDelegate);
		asset.removeEventListener(AssetEvent.ASSET_COMPLETE, completeDelegate);
	}
	
	private function loadRetry():Void
	{
		GaiaDebug.warn(_currentAsset.id + ".retry(" + ++retryAttempts + ")");
		_currentAsset.retry();
	}
	private function getBranchBytes(branch:String):Number
	{
		var bytes:Number = 0;
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
	private function getActualTotal(branch:String):Number
	{
		var count:Number = 0;
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