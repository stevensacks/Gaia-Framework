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
	import flash.display.MovieClip;

	/**
	 * This is the interface for the <code>MovieClipAsset</code>.  
	 * 
	 * @see http://www.gaiaflashframework.com/wiki/index.php?title=Assets#MovieClipAsset MovieClipAsset Documentation
	 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/MovieClip.html flash.display.MovieClip
	 * 
	 * @author Steven Sacks
	 */
	public interface IMovieClip extends ISprite
	{
		/**
		 * Returns the loader.content MovieClip.
		 */
		function get content():MovieClip;
		// PROXY PROPERTIES
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/MovieClip.html#currentFrame flash.display.MovieClip.currentFrame
		 */
		function get currentFrame():int;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/MovieClip.html#currentLabel flash.display.MovieClip.currentLabel
		 */
		function get currentLabel():String;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/MovieClip.html#currentLabels flash.display.MovieClip.currentLabels
		 */
		function get currentLabels():Array;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/MovieClip.html#enabled flash.display.MovieClip.enabled
		 */
		function get enabled():Boolean;
		/**
		 * @private
		 */
		function set enabled(value:Boolean):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/MovieClip.html#framesLoaded flash.display.MovieClip.framesLoaded
		 */
		function get framesLoaded():int;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/MovieClip.html#totalFrames flash.display.MovieClip.totalFrames
		 */
		function get totalFrames():int;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/MovieClip.html#trackAsMenu flash.display.MovieClip.trackAsMenu
		 */
		function get trackAsMenu():Boolean;
		/**
		 * @private
		 */
		function set trackAsMenu(value:Boolean):void;
		// PROXY FUNCTIONS
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/MovieClip.html#gotoAndPlay() flash.display.MovieClip.gotoAndPlay()
		 */
		function gotoAndPlay(value:Object):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/MovieClip.html#gotoAndStop() flash.display.MovieClip.gotoAndStop()
		 */
		function gotoAndStop(value:Object):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/MovieClip.html#play() flash.display.MovieClip.play()
		 */
		function play():void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/MovieClip.html#stop() flash.display.MovieClip.stop()
		 */
		function stop():void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/MovieClip.html#nextFrame() flash.display.MovieClip.nextFrame()
		 */
		function nextFrame():void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/display/MovieClip.html#prevFrame() flash.display.MovieClip.prevFrame()
		 */
		function prevFrame():void;
	}
}