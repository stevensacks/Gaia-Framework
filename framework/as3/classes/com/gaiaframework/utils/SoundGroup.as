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

package com.gaiaframework.utils
{
	import com.gaiaframework.api.ISound;
	import com.gaiaframework.events.SoundGroupEvent;

	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.utils.Timer;

	[Event(name = "allSoundsLoaded", type = "com.gaiaframework.events.SoundGroupEvent")]
	
	public class SoundGroup extends EventDispatcher
	{
		private var assets:Array;
		private var volumes:Array;
		private var pans:Array;
		
		private var _volume:Number;
		private var _pan:Number;	
		private var _transform:SoundTransform;
		
		private var fadeCallbackCount:Number;
		private var panCallbackCount:Number;
		private var fadeCallbackFunction:Function;
		private var panCallbackFunction:Function;
		
		private var preloadTimer:Timer = new Timer(20);
		private var _playWhenLoaded:Boolean = false;
		private var _startTime:int = 0;
		private var _loops:int = 0;
		
		private var _index:Number;

		// Pass as many assets as you want in the group
		function SoundGroup(...args)
		{
			super();
			preloadTimer.addEventListener(TimerEvent.TIMER, checkAllSoundsLoaded);
			assets = [];
			volumes = [];
			pans = [];
			_index = -1;
			volume = 1;
			pan = 0;
			var i:int;
			for (i = 0; i < args.length; i++)
			{
				if (args[i] is ISound)
				{
					assets.push(args[i]);
					volumes.push(ISound(args[i]).volume);
					pans.push(ISound(args[i]).pan);
				}
				else
				{
					for (var a:String in args[i])
					{
						if (args[i][a] is ISound)
						{
							assets.push(ISound(args[i][a]));
							volumes.push(ISound(args[i][a]).volume);
							pans.push(ISound(args[i][a]).pan);
						}
					}
				}
			}
		}
		
		// PUBLIC METHODS
		public function get index():int
		{
			return _index;
		}
		public function addSound(sound:ISound):void
		{
			var i:int = assets.length;
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
				volumes.push(sound.volume);
				pans.push(sound.pan);
			}
		}
		public function removeSound(sound:ISound):void
		{
			var i:int = assets.length;
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
		public function calibrate():void
		{
			var i:int = assets.length;
			volume = 1;
			pan = 0;
			volumes = [];
			pans = [];
			while (i--)
			{
				volumes[i] = ISound(assets[i]).volume;
				pans[i] = ISound(assets[i]).pan;
			}
		}
		
		// Load all sounds in group for simultaneous or instant playback
		public function preload(playWhenLoaded:Boolean = false, startTime:int = 0, loops:int = 0):void
		{
			var i:int = assets.length;
			var loadedCount:int = 0;
			while (i--)
			{
				var sound:ISound = assets[i];
				if (sound.percentLoaded == 1)
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
				preloadTimer.start();
			}
			else
			{
				if (playWhenLoaded) playAll(startTime, loops);
				dispatchEvent(new SoundGroupEvent(SoundGroupEvent.ALL_SOUNDS_LOADED));
			}
		}
		
		// Pick a sound at random and play it
		public function playRandom(startTime:int = 0, loops:int = 0, repeat:Boolean = true):ISound
		{
			var sound:ISound = assets[_index = getRandomIndex(repeat)];
			sound.load(startTime, loops);
			return sound;
		}
		// Play next sound in the array - loop back to beginning if at the end
		public function playNext(startTime:int = 0, loops:int = 0):ISound
		{
			if (++_index >= assets.length) _index = 0;
			var sound:ISound = assets[_index];
			sound.load(startTime, loops);
			return sound;
		}
		// Play previous sound in the array - loop back to end if at the beginning
		public function playPrevious(startTime:int = 0, loops:int = 0):ISound
		{
			if (--_index < 0) _index = assets.length - 1;
			var sound:ISound = assets[_index];
			sound.load(startTime, loops);
			return sound;
		}
			
		// Play all sounds in the group
		public function play(startTime:int = 0, loops:int = 0):void
		{
			getAllSoundsLoaded() ? playAll(startTime, loops) : preload(true, startTime, loops);
		}
		
		// Stop all sounds in the group
		public function stop():void
		{
			var i:Number = assets.length;
			while (i--)
			{
				var sound:ISound = assets[i];
				sound.stop();
			}
		}
		
		// Pause all sounds in the group
		public function pause(flag:Boolean):void
		{
			var i:Number = assets.length;
			while (i--)
			{
				var sound:ISound = assets[i];
				sound.pause(flag);
			}
		}
		
		// Fade all sounds in the group
		public function fadeTo(value:Number, duration:int, callback:Function = null):void
		{
			fadeCallbackCount = assets.length;
			fadeCallbackFunction = callback;
			_volume = value;
			var i:Number = assets.length;
			while (i--)
			{
				var sound:ISound = assets[i];
				var adjVolume:Number = Math.round(Number(volumes[i]) * _volume);
				sound.fadeTo(adjVolume, duration, fadeCallback);
			}
		}
		private function fadeCallback():void
		{
			if (--fadeCallbackCount == 0 && fadeCallbackFunction != null) fadeCallbackFunction();
		}
		
		// Pan all sounds in the group
		public function panTo(value:Number, duration:int, callback:Function = null):void
		{
			panCallbackCount = assets.length;
			panCallbackFunction = callback;
			_pan = Math.min(1, Math.max(-1, value));
			var i:Number = assets.length;
			while (i--)
			{
				var sound:ISound = assets[i];
				var adjPan:Number = Math.min(1, Math.max(-1, Number(pans[i]) + _pan));
				sound.panTo(adjPan, duration, panCallback);
			}
		}
		private function panCallback():void
		{
			if (--panCallbackCount == 0 && panCallbackFunction != null) panCallbackFunction();
		}
		
		// Adjusts Volume as a percentage of individual asset volumes
		public function set volume(value:Number):void
		{
			_volume = value;
			var i:Number = assets.length;
			while (i--)
			{
				var sound:ISound = assets[i];
				var newVolume:Number = Number(volumes[i]) * _volume;
				sound.volume = newVolume;
			}
		}
		public function get volume():Number
		{
			return _volume;
		}
		
		// Adjusts Pan as an offset of individual asset pans
		public function set pan(value:Number):void
		{
			_pan = value;
			var i:Number = assets.length;
			while (i--)
			{
				var sound:ISound = assets[i];
				var newPan:Number = Math.min(1, Math.max(-1, Number(pans[i]) + _pan));
				sound.pan = newPan;
			}
		}
		public function get pan():Number
		{
			return _pan;
		}
		
		// Global Transform for all sounds in the group - Must be set before you can get
		public function set transform(value:SoundTransform):void
		{
			_transform = value;
			var i:Number = assets.length;
			while (i--)
			{
				var sound:ISound = assets[i];
				sound.transform = _transform;
			}
		}
		public function get transform():SoundTransform
		{
			return _transform;
		}
		
		// PRIVATE UTILITIES
		private function getRandomIndex(repeat:Boolean = true):int
		{
			var rnd:int = Math.round(Math.random() * (assets.length - 1));
			if (repeat || rnd != _index || assets.length == 1) return rnd;
			return getRandomIndex();
		}
		private function checkAllSoundsLoaded(event:TimerEvent):void
		{
			if (getAllSoundsLoaded())
			{
				preloadTimer.reset();
				if (_playWhenLoaded) playAll(_startTime, _loops);
				dispatchEvent(new SoundGroupEvent(SoundGroupEvent.ALL_SOUNDS_LOADED));
			}
		}
		private function getAllSoundsLoaded():Boolean
		{
			var i:int = assets.length;
			while (i--)
			{
				var sound:ISound = assets[i];
				if (sound.percentLoaded != 1) return false;
			}
			return true;
		}
		private function playAll(startTime:int = 0, loops:int = 0):void
		{
			var i:int = assets.length;
			while (i--)
			{
				var sound:ISound = assets[i];
				sound.play(startTime, loops);
			}
		}
	}
}