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
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetStream;

	/**
	 * Dispatched when a NetStream object is reporting its status or error condition.
	 * @eventType flash.events.NetStatusEvent.NET_STATUS
	 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/net/NetStream.html#event:netStatus
	 */
	[Event(name = "netStatus", type = "flash.events.NetStatusEvent")]
	/**
	 * Dispatched when the NetStream's onMetaData event is received
	 * @eventType com.gaiaframework.events.NetStreamAssetEvent.METADATA
	 */
	[Event(name = "metaData", type = "com.gaiaframework.events.NetStreamAssetEvent")]
	/**
	 * Dispatched when the NetStream's onCuePoint event is received
	 * @eventType com.gaiaframework.events.NetStreamAssetEvent.CUEPOINT
	 */
	[Event(name = "cuePoint", type = "com.gaiaframework.events.NetStreamAssetEvent")]
	/**
	 * Dispatched when the NetStream's onImageData event is received
	 * @eventType com.gaiaframework.events.NetStreamAssetEvent.IMAGE_DATA
	 */
	[Event(name = "imageData", type = "com.gaiaframework.events.NetStreamAssetEvent")]
	/**
	 * Dispatched when the NetStream's onTextData event is received
	 * @eventType com.gaiaframework.events.NetStreamAssetEvent.TEXT_DATA
	 */
	[Event(name = "textData", type = "com.gaiaframework.events.NetStreamAssetEvent")]
	/**
	 * Dispatched when the NetStream's onXMPData event is received
	 * @eventType com.gaiaframework.events.NetStreamAssetEvent.XMP_DATA
	 */
	[Event(name = "xmpData", type = "com.gaiaframework.events.NetStreamAssetEvent")]
	/**
	 * Dispatched when the NetStream's fires an AsyncErrorEvent
	 * @eventType flash.events.AsyncErrorEvent.ASYNC_ERROR
	 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/net/NetStream.html#event:asyncError
	 */
	[Event(name = "asyncError", type = "flash.events.AsyncErrorEvent")]
	
	/**
	 * This is the interface for the <code>NetStreamAsset</code>.  
	 * 
	 * @see http://www.gaiaflashframework.com/wiki/index.php?title=Assets#NetStreamAsset NetStreamAsset Documentation
	 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/net/NetStream.html flash.net.NetStream
	 * 
	 * @author Steven Sacks
	 */
	public interface INetStream extends IAsset
	{
		/**
		 * Returns the reference to the NetStream
		 */
		function get ns():NetStream;
		/**
		 * Specifies the volume of the NetStream.
		 */
		function get volume():Number;
		/**
		 * @private
		 */
		function set volume(value:Number):void;
		/**
		 * Specifies the pan of the NetStream.
		 */
		function get pan():Number;
		/**
		 * @private
		 */
		function set pan(value:Number):void;
		/**
		 * Adjust the volume over time to a particular value.
		 * 
		 * @param volume A value between 0 and 1.
		 * @param duration The duration of the fade in seconds.
		 * @param onComplete The callback function to call when the fade is complete
		 */
		function fadeTo(volume:Number, duration:Number, onComplete:Function = null):void;
		/**
		 * Adjust the pan over time to a particular value.
		 * 
		 * @param pan A value between -1 and 1.
		 * @param duration The duration of the pan in seconds.
		 * @param onComplete The callback function to call when the pan is complete
		 */
		function panTo(pan:Number, duration:Number, onComplete:Function = null):void;
		/**
		 * Attach the NetStreamAsset to a Video instance. A convenience method for Video.attachNetStream(NetStreamAsset.ns);
		 * 
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/media/Video.html#attachNetStream()
		 * 
		 * @param video A reference to a flash.media.Video instance
		 */
		function attach(video:Video):void;
		
		// PROXY FLV PROPS/FUNCS
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/net/NetStream.html#bufferLength flash.net.NetStream.bufferLength
		 */
		function get bufferLength():Number;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/net/NetStream.html#bufferTime flash.net.NetStream.bufferTime
		 */
		function get bufferTime():Number;
		/**
		 * @private
		 */
		function set bufferTime(bt:Number):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/net/NetStream.html#bytesLoaded flash.net.NetStream.bytesLoaded
		 */
		function get bytesLoaded():int;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/net/NetStream.html#bytesTotal flash.net.NetStream.bytesTotal
		 */
		function get bytesTotal():int;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/net/NetStream.html#client flash.net.NetStream.client
		 */
		function get client():Object;
		/**
		 * @private
		 */
		function set client(value:Object):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/net/NetStream.html#currentFPS flash.net.NetStream.currentFPS
		 */
		function get currentFPS():Number;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/net/NetStream.html#close() flash.net.NetStream.close()
		 */
		function close():void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/net/NetStream.html#pause() flash.net.NetStream.pause()
		 */
		function pause():void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/net/NetStream.html#resume() flash.net.NetStream.resume()
		 */
		function resume():void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/net/NetStream.html#play() flash.net.NetStream.play()
		 */
		function play(start:Number = -2, len:Number = -1):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/net/NetStream.html#seek() flash.net.NetStream.seek()
		 */
		function seek(offset:Number):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/net/NetStream.html#soundTransform flash.net.NetStream.soundTransform
		 */
		function get soundTransform():SoundTransform;
		/**
		 * @private
		 */
		function set soundTransform(value:SoundTransform):void;
		/**
		 * @see http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/net/NetStream.html#time flash.net.NetStream.time
		 */
		function get time():Number;
		/**
		 * Returns the metaData of the NetStream. Available after the metaData is loaded.
		 */
		function get metaData():Object;
		/**
		 * Returns the duration of the NetStream. Available after the meteData is loaded.
		 */
		function get duration():Number;
	}
}