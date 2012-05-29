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
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;

	import flash.media.SoundMixer;
	import flash.media.SoundTransform;

	public class SoundUtils
	{
		private static var transform:SoundTransform = new SoundTransform(1);
		
		public static function fadeTo(target:*, value:Number, duration:Number, onComplete:Function = null):void
		{
			TweenMax.to(target, duration, {volume:value, ease:Linear.easeNone, onComplete:onComplete, overwrite:false});
		}
		public static function panTo(target:*, value:Number, duration:Number, onComplete:Function = null):void
		{
			TweenMax.to(target, duration, {pan:value, ease:Linear.easeNone, onComplete:onComplete, overwrite:false});
		}
		public static function set volume(value:Number):void
		{
			transform.volume = value;
			SoundMixer.soundTransform = transform;
		}
		public static function get volume():Number
		{
			return transform.volume;
		}
	}
}