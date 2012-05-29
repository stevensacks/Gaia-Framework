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
import com.gaiaframework.events.SoundGroupEvent;
import com.gaiaframework.assets.SoundClipAsset;
import com.gaiaframework.assets.SoundAsset;
import mx.utils.Delegate;

class com.gaiaframework.utils.SoundGroup extends ObservableClass
{
	private var assets:Array;
	private var volumes:Array;
	private var pans:Array;
	
	private var _volume:Number;
	private var _pan:Number;	
	private var _transform:Object;
	
	private var fadeCallbackCount:Number;
	private var panCallbackCount:Number;
	private var fadeCallbackFunction:Function;
	private var panCallbackFunction:Function;
	
	private var preloadInterval:Number;
	private var _playWhenLoaded:Boolean = false;
	private var _startTime:Number = 0;
	private var _loops:Number = 0;
	
	private var _index:Number;

	// Pass as many assets as you want in the group
	function SoundGroup()
	{
		super();
		assets = [];
		volumes = [];
		pans = [];
		_index = -1;
		_volume = 1;
		_pan = 0;
		for (var i:Number = 0; i < arguments.length; i++)
		{
			if (arguments[i] instanceof SoundAsset || arguments[i] instanceof SoundClipAsset)
			{
				assets.push(arguments[i]);
				volumes.push(SoundAsset(arguments[i]).getVolume());
				pans.push(SoundAsset(arguments[i]).getPan());
			}
			else
			{
				for (var a:String in arguments[i])
				{
					if (arguments[i][a] instanceof SoundAsset || arguments[i][a] instanceof SoundClipAsset)
					{
						assets.push(arguments[i][a]);
						volumes.push(SoundAsset(arguments[i][a]).getVolume());
						pans.push(SoundAsset(arguments[i][a]).getPan());
					}
				}
			}
		}
	}
	
	// PUBLIC METHODS
	public function get index():Number
	{
		return _index;
	}
	public function addSound(sound:SoundAsset):Void
	{
		var i:Number = assets.length;
		var match:Boolean = false;
		while (i--)
		{
			if (assets[i] == sound)
			{
				match = true;
				break;
			}
		}
		if (!match) 
		{
			assets.push(sound);
			volumes.push(sound.getVolume());
			pans.push(sound.getPan());
		}
	}
	public function removeSound(sound:SoundAsset):Void
	{
		var i:Number = assets.length;
		while (i--)
		{
			if (assets[i] == sound)
			{
				assets.splice(i, 1);
				volumes.splice(i, 1);
				pans.splice(i, 1);
				break;
			}
		}
	}
	
	// Calibrate resets the group volume to 1, current pan to 0, and sets volumes and pans to the current sound asset and pans
	public function calibrate():Void
	{
		var i:Number = assets.length;
		_volume = 1;
		_pan = 0;
		volumes = [];
		pans = [];
		while (i--)
		{
			volumes[i] = assets[i].getVolume();
			pans[i] = assets[i].getPan();
		}
	}
	
	// Load all sounds in group for simultaneous or instant playback
	public function preload(playWhenLoaded:Boolean, startTime:Number, loops:Number):Void
	{
		var i:Number = assets.length;
		var loadedCount:Number = 0;
		while (i--)
		{
			var sound:SoundAsset = assets[i];
			if (sound.percentLoaded == 1 && sound.sound != undefined)
			{
				loadedCount++;
			}
			else
			{
				sound.loadWithoutPlaying();
			}
		}
		if (loadedCount < assets.length)
		{
			_playWhenLoaded = playWhenLoaded;
			_startTime = startTime;
			_loops = loops;
			clearInterval(preloadInterval);
			preloadInterval = setInterval(Delegate.create(this, checkAllSoundsLoaded), 30);
		}
		else
		{
			if (playWhenLoaded) playAll(startTime, loops);
			dispatchEvent(new SoundGroupEvent(SoundGroupEvent.ALL_SOUNDS_LOADED, this));
		}
	}
	
	// Pick a sound at random and play it
	public function playRandom(startTime:Number, loops:Number, repeat:Boolean):SoundAsset
	{
		var sound:SoundAsset = assets[_index = getRandomIndex(repeat)];
		sound.load(startTime, loops);
		return sound;
	}
	// Play next sound in the array - loop back to beginning if at the end
	public function playNext(startTime:Number, loops:Number):SoundAsset
	{
		if (++_index >= assets.length) _index = 0;
		var sound:SoundAsset = assets[_index];
		sound.load(startTime, loops);
		return sound;
	}
	// Play previous sound in the array - loop back to end if at the beginning
	public function playPrevious(startTime:Number, loops:Number):SoundAsset
	{
		if (--_index < 0) _index = assets.length - 1;
		var sound:SoundAsset = assets[_index];
		sound.load(startTime, loops);
		return sound;
	}
		
	// Play all sounds in the group
	public function play(startTime:Number, loops:Number):Void
	{
		getAllSoundsLoaded() ? playAll(startTime, loops) : preload(true, startTime, loops);
	}
	
	// Stop all sounds in the group
	public function stop():Void
	{
		var i:Number = assets.length;
		while (i--)
		{
			var sound:SoundAsset = assets[i];
			sound.stop();
		}
	}
	
	// Pause all sounds in the group
	public function pause(flag:Boolean):Void
	{
		var i:Number = assets.length;
		while (i--)
		{
			var sound:SoundAsset = assets[i];
			sound.pause(flag);
		}
	}
	
	// Fade all sounds in the group
	public function fadeTo(value:Number, duration:Number, callback:Function):Void
	{
		fadeCallbackCount = assets.length;
		fadeCallbackFunction = callback;
		_volume = Math.round(value) / 100;
		var i:Number = assets.length;
		while (i--)
		{
			var sound:SoundAsset = assets[i];
			var adjVolume:Number = Math.round(volumes[i] * _volume);
			sound.fadeTo(adjVolume, duration, Delegate.create(this, fadeCallback));
		}
	}
	private function fadeCallback():Void
	{
		if (--fadeCallbackCount == 0) fadeCallbackFunction();
	}
	
	// Pan all sounds in the group
	public function panTo(value:Number, duration:Number, callback:Function):Void
	{
		panCallbackCount = assets.length;
		panCallbackFunction = callback;
		_pan = Math.round(Math.min(100, Math.max(-100, value)));
		var i:Number = assets.length;
		while (i--)
		{
			var sound:SoundAsset = assets[i];
			var adjPan:Number = Math.min(100, Math.max(-100, pans[i] + _pan));
			sound.panTo(adjPan, duration, Delegate.create(this, panCallback));
		}
	}
	private function panCallback():Void
	{
		if (--panCallbackCount == 0) panCallbackFunction();
	}
	
	// Adjusts Volume as a percentage of individual asset volumes
	public function setVolume(value:Number):Void
	{
		_volume = value / 100;
		var i:Number = assets.length;
		while (i--)
		{
			var sound:SoundAsset = assets[i];
			var newVolume:Number = Math.round(volumes[i] * _volume);
			sound.setVolume(newVolume);
		}
	}
	public function getVolume():Number
	{
		return _volume * 100;
	}
	
	// Adjusts Pan as an offset of individual asset pans
	public function setPan(value:Number):Void
	{
		_pan = value;
		var i:Number = assets.length;
		while (i--)
		{
			var sound:SoundAsset = assets[i];
			var newPan:Number = Math.min(100, Math.max(-100, pans[i] + _pan));
			sound.setPan(newPan);
		}
	}
	public function getPan():Number
	{
		return _pan;
	}
	
	// Global Transform for all sounds in the group - Must be set before you can get
	public function setTransform(transformObject:Object):Void
	{
		_transform = transformObject;
		var i:Number = assets.length;
		while (i--)
		{
			var sound:SoundAsset = assets[i];
			sound.setTransform(_transform);
		}
	}
	public function getTransform():Object
	{
		return _transform;
	}
	
	// PRIVATE UTILITIES
	private function getRandomIndex(repeat:Boolean):Number
	{
		var rnd:Number = Math.round(Math.random() * (assets.length - 1));
		if (repeat || rnd != _index || assets.length == 1) return rnd;
		return getRandomIndex();
	}
	private function checkAllSoundsLoaded():Void
	{
		if (getAllSoundsLoaded())
		{
			clearInterval(preloadInterval);
			if (_playWhenLoaded) playAll(_startTime, _loops);
			dispatchEvent(new SoundGroupEvent(SoundGroupEvent.ALL_SOUNDS_LOADED, this));
		}
	}
	private function getAllSoundsLoaded():Boolean
	{
		var i:Number = assets.length;
		while (i--)
		{
			var sound:SoundAsset = assets[i];
			if (sound.percentLoaded != 1) return false;
		}
		return true;
	}
	private function playAll(startTime:Number, loops:Number):Void
	{
		var i:Number = assets.length;
		while (i--)
		{
			var sound:SoundAsset = assets[i];
			sound.start(startTime, loops);
		}
	}
}