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

import com.gaiaframework.assets.AbstractAsset;
import com.gaiaframework.assets.AssetLoader;
import com.gaiaframework.assets.PageAsset;
import com.gaiaframework.utils.SoundUtils;
import mx.utils.Delegate;

class com.gaiaframework.assets.SoundAsset extends AbstractAsset
{
	private var _content:MovieClip;
	private var _sound:Sound;
	private var isStreaming:Boolean;
	private var isLoadWithoutPlaying:Boolean;
	
	private var startTime:Number;
	private var loops:Number;
	private var pos:Number;
	
	// fading and panning
	private var rate:Number;
	private var currentVolume:Number;
	private var currentPan:Number;
	private var fadeInterval:Number;
	private var panInterval:Number;
	
	// streaming loops
	private var streamLoops:Number;
	private var loopStreamDelegate:Function;
	
	function SoundAsset()
	{
		super();
		rate = 20;
		currentVolume = 100;
		startTime = loops = pos = currentPan = streamLoops = 0;
		isLoadWithoutPlaying = false;
		loopStreamDelegate = Delegate.create(this, loopStreamingSound);
	}
	public function get sound():Sound
	{
		return _sound;
	}
	public function get streaming():Boolean
	{
		return isStreaming;
	}
	public function set streaming(value:Boolean):Void
	{
		isStreaming = value;
	}
	public function init():Void
	{
		isActive = true;
	}
	public function set content(value:MovieClip):Void
	{
		_content = value;
		_sound = new Sound(_content);
		_sound.onLoad = Delegate.create(this, onComplete);
	}
	public function preload():Void
	{
		_sound.loadSound(src, isStreaming);
		if (isStreaming) _sound.stop();
		super.load();
	}
	public function load(startTime:Number, loops:Number):Void
	{
		_sound.stop();
		isLoadWithoutPlaying = false;
		this.startTime = startTime || 0;
		this.loops = streamLoops = loops || 0;
		AssetLoader.instance.load(this);
	}
	public function loadOnDemand():Void
	{
		if (!isLoadWithoutPlaying)
		{
			if (isStreaming)
			{
				setStreamingLoop();
				_sound.loadSound(src, isStreaming);
			}
			else
			{
				if (percentLoaded == 1)
				{
					start(startTime, loops);
				}
				else
				{
					// load event sound and play after
					_sound.onLoad = Delegate.create(this, onEventSoundLoaded);
					this.startTime = startTime;
					if (showProgress) 
					{
						AssetLoader.instance.load(this);
						super.load();
					}
					_sound.loadSound(src);
				}
			}
			_sound.setVolume(currentVolume);
			_sound.setPan(currentPan);
		}
		else
		{
			_sound.stop();
			startTime = 0;
			loops = streamLoops = 0;
			if (isStreaming) setStreamingLoop();
			_sound.loadSound(src, isStreaming);
			_sound.setVolume(currentVolume);
			_sound.setPan(currentPan);
			_sound.stop();
		}
		super.load();
	}
	public function getBytesLoaded():Number
	{
		return _sound.getBytesLoaded() || 0;
	}
	public function getBytesTotal():Number
	{
		return _sound.getBytesTotal() || 0;
	}
	public function destroy():Void
	{
		delete _sound;
		_content.removeMovieClip();
		_content = null;
		super.destroy();
	}
	public function retry():Void
	{
		_sound.loadSound(src, isStreaming);
		_sound.stop();
	}
	public function parseNode(page:PageAsset):Void 
	{
		super.parseNode(page);
		isStreaming = (_node.attributes.streaming == "true");
	}
	private function onEventSoundLoaded():Void
	{
		onComplete();
		sound.start(startTime, loops);
		startTime = 0;
	}
	
	// PUBLIC UTILITY FUNCTIONS
	public function pause(value:Boolean):Void
	{
		if (value)
		{
			pos = sound.position / 1000;
			sound.stop();
		}
		else
		{
			sound.start(pos, loops);
		}
	}
	// SOUND UTILS FUNCTIONS
	public function fadeTo(value:Number, duration:Number, onComplete:Function):Void
	{
		SoundUtils.fadeTo(this, value, duration, onComplete);
	}
	public function panTo(value:Number, duration:Number, onComplete:Function):Void
	{
		SoundUtils.panTo(this, value, duration, onComplete);
	}
	public function set volume(value:Number):Void
	{
		currentVolume = value;
		sound.setVolume(currentVolume);
	}
	public function get volume():Number
	{
		return sound.getVolume() || currentVolume;
	}
	public function set pan(value:Number):Void
	{
		currentPan = value;
		sound.setPan(currentPan);
	}
	public function get pan():Number
	{
		return sound.getPan() || currentPan;
	}
	//
	private function setStreamingLoop():Void
	{
		if (streamLoops > 0) _sound.onSoundComplete = loopStreamDelegate;
		else if (_sound.onSoundComplete == loopStreamDelegate) delete _sound.onSoundComplete;
	}
	private function loopStreamingSound():Void
	{
		_sound.start(0, --streamLoops);
	}
	// used by SoundClipAsset for MTASC compliance (super.super not allowed)
	public function get abstract():AbstractAsset
	{
		return super;
	}
	
	// SOUND GROUP PRELOAD
	public function loadWithoutPlaying():Void
	{
		isLoadWithoutPlaying = true;
		AssetLoader.instance.load(this);
	}
	
	// PROXY SOUND PROPS/FUNCS
	public function loadSound(url:String, stream:Boolean):Void
	{
		isStreaming = stream;
		_sound.loadSound(url, stream);
		_sound.setVolume(currentVolume);
		_sound.setPan(currentPan);
	}
	public function start(startTime:Number, loops:Number):Void
	{
		this.loops = streamLoops = loops;
		if (isStreaming) setStreamingLoop();
		sound.start(startTime, loops);
	}
	public function stop():Void
	{
		sound.stop();
	}
	public function getVolume():Number
	{
		return sound.getVolume() || currentVolume;
	}
	public function setVolume(value:Number):Void
	{
		currentVolume = value;
		sound.setVolume(currentVolume);
	}
	public function get duration():Number
	{
		return sound.duration;
	}
	public function getPan():Number
	{
		return sound.getPan() || currentPan;
	}
	public function setPan(value:Number):Void
	{
		currentPan = value;
		sound.setPan(currentPan);
	}
	public function get position():Number
	{
		return sound.position;
	}
	public function getTransform():Object
	{
		return sound.getTransform();
	}
	public function setTransform(value:Object):Void
	{
		sound.setTransform(value);
	}
	public function get id3():Object
	{
		return sound.id3;
	}	
	public function set onSoundComplete(value:Function):Void
	{
		sound.onSoundComplete = value;
	}
	public function set onLoad(value:Function):Void
	{
		_sound.onLoad = value;
	}
	public function toString():String
	{
		return "[SoundAsset] " + _id;
	}
}