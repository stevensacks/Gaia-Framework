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

import com.gaiaframework.assets.AssetLoader;
import com.gaiaframework.assets.SoundAsset;
import mx.utils.Delegate;

class com.gaiaframework.assets.SoundClipAsset extends SoundAsset
{		
	private var checkLoadInterval:Number;
	
	function SoundClipAsset()
	{
		super();
	}
	public function get sound():Sound
	{
		return _content.sound;
	}
	public function set content(value:MovieClip):Void
	{
		_content = value;
	}
	public function preload():Void
	{
		loadSoundClip();
		super.load();
	}
	public function load(startTime:Number, loops:Number):Void
	{
		this.startTime = startTime;
		this.loops = loops;
		isLoadWithoutPlaying = false;
		AssetLoader.instance.load(this);
	}
	public function loadOnDemand():Void
	{
		if (!isLoadWithoutPlaying)
		{
			if (percentLoaded == 1)
			{
				start(startTime, loops);
			}
			else
			{
				clearInterval(checkLoadInterval);
				checkLoadInterval = setInterval(Delegate.create(this, checkSoundLoaded), 30, true);			
				loadSoundClip();
				super.abstract.load();
			}
		}
		else
		{
			loadSoundClip();
			super.abstract.load();
		}
	}
	private function checkSoundLoaded(playAfter:Boolean):Void
	{
		if (percentLoaded == 1 && sound != undefined)
		{
			clearInterval(checkLoadInterval);
			clearInterval(progressInterval);
			onComplete();
			if (playAfter) sound.start(startTime, loops);
			startTime = 0;
		}
	}
	public function getBytesLoaded():Number
	{
		return _content.getBytesLoaded() || 0;
	}
	public function getBytesTotal():Number
	{
		return _content.getBytesTotal() || 0;
	}
	public function retry():Void
	{
		_content.loadMovie(src);
	}
	// SOUND GROUP PRELOAD
	public function loadWithoutPlaying():Void
	{
		sound.stop();
		startTime = 0;
		loops = 0;
		super.loadWithoutPlaying();
	}
	private function loadSoundClip():Void
	{
		clearInterval(checkLoadInterval);
		checkLoadInterval = setInterval(Delegate.create(this, checkSoundLoaded), 30, false);
		_content.loadMovie(src);
	}
	public function toString():String
	{
		return "[SoundClipAsset] " + _id;
	}
}