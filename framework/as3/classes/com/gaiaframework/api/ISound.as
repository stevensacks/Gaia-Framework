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

package com.gaiaframework.api
{
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	/**
	 * This is the interface for the <code>SoundAsset</code>.  
	 * 
	 * @see http://www.gaiaflashframework.com/wiki/index.php?title=Assets#SoundAsset SoundAsset Documentation
	 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/media/Sound.html flash.media.Sound
	 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/media/SoundChannel.html flash.media.SoundChannel
	 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/media/SoundTransform.html flash.media.SoundTransform
	 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/media/ID3Info.html flash.media.ID3Info
	 * 
	 * @author Steven Sacks
	 */
	public interface ISound extends IAsset
	{
		/**
		 * Returns the reference to the Sound
		 */
		function get sound():Sound;
		/**
		 * Pause and unpause the Sound.
		 * 
		 * @param flag <code>true</code> to pause, <code>false</code> to unpause.
		 */
		function pause(flag:Boolean):void;
		/**
		 * Adjust the volume over time to a particular value.
		 * 
		 * @param volume A value between 0 and 1.
		 * @param duration The duration of the fade in seconds.
		 * @param onComplete The callback function to call when the fade is complete
		 */
		function fadeTo(value:Number, duration:Number, onComplete:Function = null):void;
		/**
		 * Adjust the pan over time to a particular value.
		 * 
		 * @param pan A value between -1 and 1.
		 * @param duration The duration of the pan in seconds.
		 * @param onComplete The callback function to call when the pan is complete
		 */
		function panTo(value:Number, duration:Number, onComplete:Function = null):void;
		/**
		 * Used to load an on-demand SoundAsset without playing it.
		 */
		function loadWithoutPlaying():void;
		// PROXY SOUND PROPS
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/media/Sound.html#bytesLoaded flash.media.Sound.bytesLoaded
		 */
		function get bytesLoaded():int;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/media/Sound.html#bytesTotal flash.media.Sound.bytesTotal
		 */
		function get bytesTotal():int;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/media/SoundChannel.html flash.media.SoundChannel
		 */
		function get channel():SoundChannel;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/media/ID3Info.html flash.media.ID3Info
		 */
		function get id3():ID3Info;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/media/Sound.html#length flash.media.Sound.length
		 */
		function get length():Number;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/media/Sound.html#pan flash.media.Sound.pan
		 */
		function get pan():Number;
		/**
		 * @private
		 */
		function set pan(value:Number):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/media/Sound.html#position flash.media.Sound.position
		 */
		function get position():Number;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/media/Sound.html#transform flash.media.Sound.transform
		 */
		function get transform():SoundTransform;
		/**
		 * @private
		 */
		function set transform(value:SoundTransform):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/media/Sound.html#volume flash.media.Sound.volume
		 */
		function get volume():Number;
		/**
		 * @private
		 */
		function set volume(value:Number):void;
		// PROXY SOUND FUNCTIONS
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/media/Sound.html#play() flash.media.Sound.play()
		 */
		function play(startTime:int = 0, loops:int = 0, soundTransform:SoundTransform = null):SoundChannel;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/media/Sound.html#stop() flash.media.Sound.stop()
		 */
		function stop():void;
		

	}
}