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
	import com.gaiaframework.api.ISound;
	import com.gaiaframework.events.AssetEvent;
	import com.gaiaframework.utils.SoundUtils;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	public class SoundAsset extends AbstractAsset implements ISound
	{	
		protected var _sound:Sound;
		protected var _channel:SoundChannel;
		protected var _transform:SoundTransform;
		
		protected var startTime:int = 0;
		protected var loops:int = 0;
		protected var pos:Number = 0;
		
		// fading and panning
		protected var currentVolume:Number = 1;
		protected var currentPan:Number = 0;
		
		protected var isLoadWithoutPlaying:Boolean = false;
		
		protected var completeListener:Function;
		
		public function SoundAsset()
		{
			super();
		}
		public function get sound():Sound
		{
			return _sound;
		}
		override public function init():void
		{
			isActive = true;
			_sound = new Sound();
			addListeners(_sound);
			_transform = new SoundTransform();
			super.init();
		}
		override public function preload():void
		{
			_sound.load(request);
			super.load();
		}
		override public function load(...args):void
		{
			if (_channel != null) _channel.stop();
			startTime = args[0] || 0;
			loops = args[1] || 0;
			isLoadWithoutPlaying = false;
			loadOnDemand();
		}
		override internal function loadOnDemand():void 
		{
			if (percentLoaded < 1)
			{
				_sound.load(request);
			}
			if (!isLoadWithoutPlaying)
			{
				_channel = _sound.play(startTime, loops);
				_transform.volume = currentVolume;
				_transform.pan = currentPan;
				_channel.soundTransform = _transform;
			}
		}
		override protected function onComplete(event:Event):void
		{
			removeListeners(_sound);
			super.onComplete(event);
		}		
		override public function destroy():void
		{
			try 
			{
				_sound.close();
			}
			catch (error:Error)
			{
				// it did not need to be closed so fail gracefully
			}
			removeListeners(_sound);
			if (_channel != null) _channel.stop();
			_transform = null;
			_channel = null;
			_sound = null;
			super.destroy();
		}
		override public function retry():void
		{
			_sound.load(request);
		}
		override public function abort():void
		{
			AssetLoader.instance.abort(this);
			destroy();
		}
		
		// PUBLIC UTILITY FUNCTIONS
		public function pause(flag:Boolean):void
		{
			if (_channel != null)
			{
				if (flag)
				{
					pos = _channel.position % _sound.length;
					loops = 0;
					_channel.stop();
					if (completeListener != null) _channel.removeEventListener(Event.SOUND_COMPLETE, completeListener);
				}
				else
				{
					_channel = _sound.play(pos, loops);
					_channel.soundTransform = _transform;
					if (completeListener != null) _channel.addEventListener(Event.SOUND_COMPLETE, completeListener, false, 0, true);
					pos = 0;
				}
			}
		}
		public function fadeTo(value:Number, duration:Number, onComplete:Function = null):void
		{
			SoundUtils.fadeTo(this, value, duration, onComplete);
		}
		public function panTo(value:Number, duration:Number, onComplete:Function = null):void
		{
			SoundUtils.panTo(this, value, duration, onComplete);
		}
		
		// SOUND GROUP PRELOAD
		public function loadWithoutPlaying():void
		{
			if (_channel != null) _channel.stop();
			startTime = 0;
			loops = 0;
			isLoadWithoutPlaying = true;
			AssetLoader.instance.load(this);
		}
		
		override public function getBytesLoaded():int
		{
			return _sound.bytesLoaded;
		}
		override public function getBytesTotal():int
		{
			return _sound.bytesTotal;
		}
		
		// PROXY SOUND PROPS
		public function get bytesLoaded():int
		{
			return _sound.bytesLoaded;
		}
		public function get bytesTotal():int
		{
			return _sound.bytesTotal;
		}		
		public function get channel():SoundChannel
		{
			return _channel;
		}
		public function get id3():ID3Info
		{
			return _sound.id3;
		}	
		public function get length():Number
		{
			return _sound.length;
		}
		public function get pan():Number
		{
			return transform.pan;
		}
		public function set pan(value:Number):void
		{
			currentPan = Math.min(1, Math.max(-1, value));
			_transform.pan = value;
			transform = _transform;
		}
		public function get position():Number
		{
			if (_channel != null) return _channel.position;
			return 0;
		}		
		public function get transform():SoundTransform
		{
			if (_channel == null) return _transform = new SoundTransform(currentVolume, currentPan);
			return _channel.soundTransform;
		}
		public function set transform(value:SoundTransform):void
		{
			_transform = value;
			if (_channel != null) _channel.soundTransform = _transform;
		}	
		public function get volume():Number
		{
			return transform.volume;
		}
		public function set volume(value:Number):void
		{
			currentVolume = value;
			_transform.volume = value;
			transform = _transform;
		}
		// PROXY SOUND FUNCTIONS
		public function play(startTime:int = 0, loops:int = 0, soundTransform:SoundTransform = null):SoundChannel
		{
			this.startTime = startTime;
			this.loops = loops;
			if (_channel != null) _channel.stop();
			if (completeListener != null) _channel.removeEventListener(Event.SOUND_COMPLETE, completeListener);
			if (soundTransform == null) soundTransform = _transform;
			_channel = _sound.play(startTime, loops, soundTransform);
			if (completeListener != null) _channel.addEventListener(Event.SOUND_COMPLETE, completeListener, false, 0, true);
			_transform = _channel.soundTransform;
			return _channel;
		}
		public function stop():void
		{
			if (_channel != null) _channel.stop();
		}	
		
		// EVENT LISTENER OVERRIDES
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			if (type != AssetEvent.ASSET_PROGRESS && type != AssetEvent.ASSET_COMPLETE && type != AssetEvent.ASSET_ERROR && type != IOErrorEvent.IO_ERROR) 
			{
				if (type == Event.SOUND_COMPLETE) 
				{
					_channel.addEventListener(type, listener, useCapture, priority, useWeakReference);
					completeListener = listener;
				}
				else
				{
					_sound.addEventListener(type, listener, useCapture, priority, useWeakReference);
				}
			}
			else
			{
				super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			}
		}
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			if (type != AssetEvent.ASSET_PROGRESS && type != AssetEvent.ASSET_COMPLETE && type != AssetEvent.ASSET_ERROR && type != IOErrorEvent.IO_ERROR) 
			{
				if (type == Event.SOUND_COMPLETE) 
				{
					_channel.removeEventListener(type, listener, useCapture);
					completeListener = null;
				}
				else
				{
					_sound.removeEventListener(type, listener, useCapture);
				}
			}
			else
			{
				super.removeEventListener(type, listener, useCapture);
			}
		}
		override public function toString():String
		{
			return "[SoundAsset] " + _id;
		}
	}
}