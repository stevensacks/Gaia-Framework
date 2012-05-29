/**
 * VERSION: 11.65
 * DATE: 2011-01-18
 * AS2 (AS3 version is also available)
 * UPDATES AND DOCS AT: http://www.greensock.com
 **/
import com.greensock.core.*;
import com.greensock.plugins.*;

/**
 * 	TweenLite is an extremely fast, lightweight, and flexible tweening engine that serves as the foundation of 
 * 	the GreenSock Tweening Platform. A TweenLite instance handles tweening one or more numeric properties of any
 *  object over time, updating them on every frame. Sounds simple, but there's a wealth of capabilities and conveniences
 *  at your fingertips with TweenLite. With plenty of other tweening engines to choose from, here's why you might 
 *  want to consider TweenLite:
 * 	<ul>
 * 		<li><b> SPEED </b>- TweenLite has been highly optimized for maximum performance. See some speed comparisons yourself at 
 * 			 <a href="http://www.greensock.com/tweening-speed-test/">http://www.greensock.com/tweening-speed-test/</a></li>
 * 		  
 * 		<li><b> Feature set </b>- In addition to tweening ANY numeric property of ANY object, TweenLite can tween filters, 
 * 		  	 hex colors, volume, tint, frames, and even do bezier tweening, plus LOTS more. TweenMax extends 
 * 		  	 TweenLite and adds even more capabilities like repeat, yoyo, repeatDelay, on-the-fly 
 * 			 destination value updates, rounding and more. Overwrite management is an important consideration in 
 * 			 a tweening engine as well which is another area where the GreenSock Tweening Platform shines. 
 * 			 You have options for AUTO overwriting or you can manually define how each tween will handle overlapping 
 * 			 tweens of the same object.</li>
 * 		  
 * 		<li><b> Expandability </b>- With its plugin architecture, you can activate as many (or as few) features as your 
 * 		  	 project requires. Write your own plugin to handle particular special properties in custom ways. Minimize bloat, and
 * 		  	 maximize performance.</li>
 * 		  
 * 		<li><b> Sequencing, grouping, and management features </b>- TimelineLite and TimelineMax make it surprisingly 
 * 			 simple to create complex sequences or groups of tweens that you can control as a whole. play(), pause(), restart(), 
 * 			 or reverse(). You can even tween a timeline's <code>currentTime</code> or <code>currentProgress</code> property 
 * 			 to fastforward or rewind the entire timeline. Add labels, gotoAndPlay(), change the timeline's timeScale, nest 
 * 			 timelines within timelines, and lots more.</li>
 * 		  
 * 		<li><b> Ease of use </b>- Designers and Developers alike rave about how intuitive the platform is.</li>
 * 		
 * 		<li><b> Updates </b>- Frequent updates and feature additions make the GreenSock Tweening Platform reliable and robust.</li>
 * 		
 * 		<li><b> AS2 and AS3 </b>- Most other engines are only developed for AS2 or AS3 but not both.</li>
 * 	</ul>
 * 
 * <hr />	
 * <b>SPECIAL PROPERTIES (no plugins required):</b>
 * <br /><br />
 * 
 * Any of the following special properties can optionally be passed in through the vars object (the third parameter):
 * 
 * <ul>
 * 	<li><b> delay : Number</b>			Amount of delay before the tween should begin (in seconds).</li>
 * 	
 * 	<li><b> useFrames : Boolean</b>		If useFrames is set to true, the tweens's timing mode will be based on frames. 
 * 										Otherwise, it will be based on seconds/time. NOTE: a tween's timing mode is 
 * 										always determined by its parent timeline. </li>
 * 	
 * 	<li><b> ease : Function</b>			Use any standard easing equation to control the rate of change. For example, 
 * 										Elastic.easeOut. The Default is Regular.easeOut.</li>
 * 	
 * 	<li><b> easeParams : Array</b>		An Array of extra parameters to feed the easing equation. This can be useful when 
 * 										using an ease like Elastic and want to control extra parameters like the amplitude 
 * 										and period.	Most easing equations, however, don't require extra parameters so you 
 * 										won't need to pass in any easeParams.</li>
 * 	
 * 	<li><b> onInit : Function</b>		A function that should be called just before the tween inits (renders for the first time).
 * 										Since onInit runs before the start/end values are recorded internally, it is a good place to run
 * 										code that affects the target's initial position or other tween-related properties. onStart, by
 * 										contrast, runs AFTER the tween inits and the start/end values are recorded internally. onStart
 * 										is called every time the tween begins which can happen more than once if the tween is restarted
 * 										multiple times.</li>
 * 	
 *  <li><b> onInitParams : Array</b>	An Array of parameters to pass the onInit function.</li>	
 * 
 *  <li><b> onStart : Function</b>		A function that should be called when the tween begins (when its currentTime is at 0 and 
 * 										changes to some other value which can happen more than once if the tween is restarted multiple times).</li>
 * 	
 * 	<li><b> onStartParams : Array</b>	An Array of parameters to pass the onStart function.</li>
 * 	
 * 	<li><b> onStartScope: Object</b>	Defines the scope of the onStart function (what "this" refers to inside that function).</li>
 * 	
 * 	<li><b> onUpdate : Function</b>		A function that should be called every time the tween's time/position is updated 
 * 										(on every frame while the timeline is active)</li>
 * 	
 * 	<li><b> onUpdateParams : Array</b>	An Array of parameters to pass the onUpdate function</li>
 * 	
 * 	<li><b> onUpdateScope: Object</b>	Defines the scope of the onUpdate function (what "this" refers to inside that function).</li>
 * 	
 * 	<li><b> onComplete : Function</b>	A function that should be called when the tween has finished </li>
 * 	
 * 	<li><b> onCompleteParams : Array</b> An Array of parameters to pass the onComplete function</li>
 * 	
 * 	<li><b> onCompleteScope: Object</b>	Defines the scope of the onComplete function (what "this" refers to inside that function).</li>
 * 	
 * 	<li><b> onReverseComplete : Function</b> A function that should be called when the tween has reached its starting point again after having been reversed. </li>
 * 	
 * 	<li><b> onReverseCompleteParams : Array</b> An Array of parameters to pass the onReverseComplete function</li>
 * 
 *  <li><b> onReverseCompleteScope: Object</b>	Defines the scope of the onReverseComplete function (what "this" refers to inside that function).</li>
 * 	
 * 	<li><b> immediateRender : Boolean</b> Normally when you create a tween, it begins rendering on the very next frame (when 
 * 											the Flash Player dispatches an ENTER_FRAME event) unless you specify a "delay". This 
 * 											allows you to insert tweens into timelines and perform other actions that may affect 
 * 											its timing. However, if you prefer to force the tween to render immediately when it is 
 * 											created, set immediateRender to true. Or to prevent a tween with a duration of zero from
 * 											rendering immediately, set this to false.</li>
 * 	
 * 	<li><b> overwrite : Number</b>		Controls how (and if) other tweens of the same target are overwritten by this tween. There are
 * 										several modes to choose from, but only the first two are available in TweenLite unless 
 * 										<code>OverwriteManager.init()</code> has been called (please see 
 * 										<a href="http://www.greensock.com/overwritemanager/">http://www.greensock.com/overwritemanager/</a> 
 * 										for details and a full explanation of the various modes):
 * 										<ul>
 * 			  								<li>NONE (0) (or false) </li>
 * 											
 * 											<li>ALL_IMMEDIATE (1) (or true) - this is the default mode in TweenLite</li>
 * 													
 * 											<li>AUTO (2) - this is the default mode if TweenMax, TimelineLite, or TimelineMax is used in the swf. (requires OverwriteManager)</li>
 * 												
 * 											<li>CONCURRENT (3) (requires OverwriteManager)</li>
 * 												
 * 											<li>ALL_ONSTART (4) (requires OverwriteManager)</li>
 * 												
 * 											<li>PREEXISTING (5) (requires OverwriteManager)</li>
 * 
 * 										</ul></li>
 * 	</ul>		
 * 
 * <b>PLUGINS:</b><br /><br />
 * 
 * 	There are many plugins that add capabilities through other special properties. Some examples are "tint", 
 * 	"volume", "frame", "frameLabel", "bezier", "blurFilter", "colorMatrixFilter", "hexColors", and many more.
 * 	Adding the capabilities is as simple as activating the plugin with a single line of code, like 
 * 	TweenPlugin.activate([TintPlugin]); Get information about all the plugins at 
 *  <a href="http://www.TweenLite.com">http://www.TweenLite.com</a><br /><br />
 * 
 * <b>EXAMPLES:</b> <br /><br />
 * 
 * 	Tween the the MovieClip "mc" to an _alpha value of 50 and an x-coordinate of 120 
 * 	over the course of 1.5 seconds like so:<br /><br />
 * 	
 * <code>
 * 		import com.greensock.TweenLite;<br /><br />
 * 		TweenLite.to(mc, 1.5, {_alpha:50, _x:120});
 * 	</code><br /><br />
 *  
 * 	To tween the "mc" MovieClip's _alpha property to 50, its _x property to 120 using the <code>Back.easeOut</code> easing 
 *  function, delay starting the whole tween by 2 seconds, and then call a function named <code>onFinishTween</code> when it 
 *  has completed (it will have a duration of 5 seconds) and pass a few parameters to that function (a value of 
 *  5 and a reference to the mc), you'd do so like:<br /><br />
 * 		
 * 	<code>
 * 		import com.greensock.TweenLite;<br />
 * 		import com.greensock.easing.Back;<br /><br />
 * 		TweenLite.to(mc, 5, {_alpha:50, _x:120, ease:Back.easeOut, delay:2, onComplete:onFinishTween, onCompleteParams:[5, mc]});<br />
 * 		function onFinishTween(param1:Number, param2:MovieClip):Void {<br />
 * 			trace("The tween has finished! param1 = " + param1 + ", and param2 = " + param2);<br />
 * 		}
 * 	</code><br /><br />
 *  
 * 	If you have a MovieClip on the stage that is already in it's end position and you just want to animate it into 
 * 	place over 5 seconds (drop it into place by changing its _y property to 100 pixels higher on the screen and 
 * 	dropping it from there), you could:<br /><br />
 * 	
 *  <code>
 * 		import com.greensock.TweenLite;<br />
 * 		import com.greensock.easing.Elastic;<br /><br />
 * 		TweenLite.from(mc, 5, {_y:"-100", ease:Elastic.easeOut});		
 *  </code><br /><br />
 * 
 * <b>NOTES:</b><br /><br />
 * <ul>
 * 	<li> The base TweenLite class adds about 4.5kb to your Flash file, but if you activate the plugins
 * 	  that were activated by default in versions prior to 11 (tint, removeTint, frame, endArray, visible, and autoAlpha), 
 * 	  it totals about 7k.</li>
 * 	  
 * 	<li> Passing values as Strings will make the tween relative to the current value. For example, if you do
 * 	  <code>TweenLite.to(mc, 2, {_x:"-20"});</code> it'll move the mc._x to the left 20 pixels which is the same as doing
 * 	  <code>TweenLite.to(mc, 2, {_x:mc._x - 20});</code> You could also cast it like: <code>TweenLite.to(mc, 2, {_x:String(myVariable)});</code></li>
 * 	  
 * 	<li> You can change the <code>TweenLite.defaultEase</code> function if you prefer something other than <code>Regular.easeOut</code>.</li>
 * 	
 * 	<li> Kill all tweens for a particular object anytime with the <code>TweenLite.killTweensOf(mc); </code>
 * 	  function. If you want to have the tweens forced to completion, pass true as the second parameter, 
 * 	  like <code>TweenLite.killTweensOf(mc, true);</code></li>
 * 	  
 * 	<li> You can kill all delayedCalls to a particular function using <code>TweenLite.killDelayedCallsTo(myFunction);</code>
 * 	  This can be helpful if you want to preempt a call.</li>
 * 	  
 * 	<li> Use the <code>TweenLite.from()</code> method to animate things into place. For example, if you have things set up on 
 * 	  the stage in the spot where they should end up, and you just want to animate them into place, you can 
 * 	  pass in the beginning _x and/or _y and/or _alpha (or whatever properties you want).</li>
 * 	  
 * 	<li> If you find this class useful, please consider joining Club GreenSock which not only contributes
 * 	  to ongoing development, but also gets you bonus classes (and other benefits) that are ONLY available 
 * 	  to members. Learn more at <a href="http://www.greensock.com/club/">http://www.greensock.com/club/</a></li>
 * </ul>
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */ 
class com.greensock.TweenLite extends TweenCore {
		
		/**
		 * @private
		 * Initializes the class, activates default plugins, and starts the root timelines. This should only 
		 * be called internally. It is technically public only so that other classes in the GreenSock Tweening 
		 * Platform can access it, but again, please avoid calling this method directly.
		 */
		public static function initClass():Void {
			
			
			//ACTIVATE PLUGINS HERE...
			/*
			TweenPlugin.activate([
							
				AutoAlphaPlugin,			//tweens _alpha and then toggles "_visible" to false if/when _alpha is zero
				EndArrayPlugin,				//tweens numbers in an Array
				FramePlugin,				//tweens MovieClip frames
				RemoveTintPlugin,			//allows you to remove a tint
				TintPlugin,					//tweens tints
				VisiblePlugin,				//tweens a target's "_visible" property
				VolumePlugin,				//tweens the volume of a MovieClip or Sound
				
				BevelFilterPlugin,			//tweens BevelFilters
				BezierPlugin,				//enables bezier tweening
				BezierThroughPlugin,		//enables bezierThrough tweening
				BlurFilterPlugin,			//tweens BlurFilters
				ColorMatrixFilterPlugin,	//tweens ColorMatrixFilters (including hue, saturation, colorize, contrast, brightness, and threshold)
				DropShadowFilterPlugin,		//tweens DropShadowFilters
				GlowFilterPlugin,			//tweens GlowFilters
				HexColorsPlugin,			//tweens hex colors
				ShortRotationPlugin,		//tweens rotation values in the shortest direction
				
				ColorTransformPlugin,		//tweens advanced color properties like exposure, brightness, tintAmount, redOffset, redMultiplier, etc.
				FrameLabelPlugin,			//tweens a MovieClip to particular label
				QuaternionsPlugin,			//tweens 3D Quaternions
				ScalePlugin,				//Tweens both the _xscale and _yscale properties
				ScrollRectPlugin,			//tweens the scrollRect property of a MovieClip
				SetSizePlugin,				//tweens the width/height of components via setSize()
				TransformMatrixPlugin,		//Tweens the transform.matrix property of any MovieClip
					
				//DynamicPropsPlugin,			//tweens to dynamic end values. You associate the property with a particular function that returns the target end value **Club GreenSock membership benefit**
				//MotionBlurPlugin,			//applies a directional blur to a MovieClip based on the velocity and angle of movement. **Club GreenSock membership benefit**
				//Physics2DPlugin,			//allows you to apply basic physics in 2D space, like velocity, angle, gravity, friction, acceleration, and accelerationAngle. **Club GreenSock membership benefit**
				//PhysicsPropsPlugin,			//allows you to apply basic physics to any property using forces like velocity, acceleration, and/or friction. **Club GreenSock membership benefit**
				//TransformAroundCenterPlugin,//tweens the scale and/or rotation of MovieClips using the MovieClip's center as the registration point **Club GreenSock membership benefit**
				//TransformAroundPointPlugin,	//tweens the scale and/or rotation of MovieClips around a particular point (like a custom registration point) **Club GreenSock membership benefit**
				
				
			{}]);
			*/
			
			rootFrame = 0;
			rootTimeline = new SimpleTimeline(null);
			rootFramesTimeline = new SimpleTimeline(null);
			rootTimeline.autoRemoveChildren = rootFramesTimeline.autoRemoveChildren = true;
			
			rootTimeline.cachedStartTime = getTimer() * 0.001;
			rootTimeline.cachedTotalTime = rootFramesTimeline.cachedTotalTime = 0;
			rootFramesTimeline.cachedStartTime = rootFrame;
			
			if (overwriteManager == undefined) {
				overwriteManager = {mode:1, enabled:false};
			}
			
			jumpStart(_root);
		}
		
		/** @private **/
		public static var version:Number = 11.65;
		/** @private When plugins are activated, the class is added (named based on the special property) to this object so that we can quickly look it up in the initTweenVals() method.**/
		public static var plugins:Object = {}; 
		/** @private For notifying plugins of significant events like when the tween finishes initializing, when it is disabled/enabled, and when it completes (some plugins need to take actions when those events occur) **/
		public static var onPluginEvent:Function;
		/** @private **/
		public static var killDelayedCallsTo:Function = TweenLite.killTweensOf;
		/** Provides an easy way to change the default easing equation.**/
		public static var defaultEase:Function = TweenLite.easeOut; 
		/** @private Makes it possible to integrate OverwriteManager for adding various overwriting capabilities. **/
		public static var overwriteManager:Object; 
		/** @private Gets updated on every frame. This syncs all the tweens and prevents drifting of the startTime that happens under heavy loads with most other engines.**/
		public static var rootFrame:Number; 
		/** @private All tweens get associated with a timeline. The rootTimeline is the default for all time-based tweens.**/
		public static var rootTimeline:SimpleTimeline; 
		/** @private All tweens get associated with a timeline. The rootFramesTimeline is the default for all frames-based tweens.**/
		public static var rootFramesTimeline:SimpleTimeline;
		/** @private Holds references to all our tween instances organized by target for quick lookups (for overwriting).**/
		public static var masterList:Object = {}; 
		/** @private Drives all our onEnterFrame events.**/
		private static var _timingClip:MovieClip; 
		/** @private Used to assign IDs to targets **/
		private static var _cnt:Number = -16000;
		/** @private Lookup for all of the reserved "special property" keywords.**/
		private static var _reservedProps:Object = {ease:1, delay:1, overwrite:1, onComplete:1, onCompleteParams:1, useFrames:1, runBackwards:1, startAt:1, onUpdate:1, onUpdateParams:1, onStart:1, onStartParams:1, onReverseComplete:1, onReverseCompleteParams:1, onRepeat:1, onRepeatParams:1, proxiedEase:1, easeParams:1, yoyo:1, onCompleteListener:1, onUpdateListener:1, onStartListener:1, orientToBezier:1, timeScale:1, immediateRender:1, repeat:1, repeatDelay:1, timeline:1, data:1, paused:1};
		
		
		/** Target object whose properties this tween affects. This can be ANY object, not just a MovieClip. **/
		public var target:Object; 
		/** @private Lookup object for PropTween objects. For example, if this tween is handling the "_x" and "_y" properties of the target, the propTweenLookup object will have an "_x" and "_y" property, each pointing to the associated PropTween object. This can be very helpful for speeding up overwriting. This is a public variable, but should almost never be used directly. **/
		public var propTweenLookup:Object; 
		/** @private result of _ease(this.currentTime, 0, 1, this.duration). Usually between 0 and 1, but not always (like with Elastic.easeOut). **/
		public var ratio:Number;
		/** @private First PropTween instance - all of which are stored in a linked list for speed. Traverse them using nextNode and prevNode. Typically you should NOT use this property (it is made public for speed and file size purposes). **/
		public var cachedPT1:PropTween; 
	
		/** @private Easing method to use which determines how the values animate over time. Examples are Elastic.easeOut and Strong.easeIn. Many are found in the fl.motion.easing package or com.greensock.easing. **/
		private var _ease:Function;
		/** @private Target ID (a way to identify each end target, i.e. "t1", "t2", "t3") **/
		private var _targetID:String;
		/** @private 0 = NONE, 1 = ALL, 2 = AUTO 3 = CONCURRENT, 4 = ALL_AFTER **/
		private var _overwrite:Number;
		/** @private When other tweens overwrite properties in this tween, the properties get added to this object. Remember, sometimes properties are overwritten BEFORE the tween inits, like when two tweens start at the same time, the later one overwrites the previous one. **/
		private var _overwrittenProps:Object; 
		/** @private If this tween has any TweenPlugins, we set this to true - it helps speed things up in onComplete **/
		private var _hasPlugins:Boolean; 
		/** @private If this tween has any TweenPlugins that need to be notified of a change in the "enabled" status, this will be true. (speeds things up in the enabled setter) **/
		private var _notifyPluginsOfEnabled:Boolean;
		
		
		/**
		 * Constructor
		 *  
		 * @param target Target object whose properties this tween affects. This can be ANY object, not just a MovieClip. 
		 * @param duration Duration in seconds (or in frames if the tween's timing mode is frames-based)
		 * @param vars An object containing the end values of the properties you're tweening. For example, to tween to _x=100, _y=100, you could pass {_x:100, _y:100}. It can also contain special properties like "onComplete", "ease", "delay", etc.
		 */
		public function TweenLite(target:Object, duration:Number, vars:Object) {
			super(duration, vars);
			
			if (_timingClip.onEnterFrame != updateAll) { //subloaded swfs in Flash Lite restrict access to _root.createEmptyMovieClip(), so we find the subloaded swf MovieClip to createEmptyMovieClip(), but if it gets unloaded, the onEnterFrame will stop running so we need to check each time a tween is created.
				jumpStart(_root);
			}
			
			this.ratio = 0;
			this.target = target;
			_targetID = getID(target, true);
			if (this.vars.timeScale != undefined && this.target instanceof TweenCore) { //if timeScale is in the vars object and the target is a TweenCore, this tween's timeScale must be adjusted (in TweenCore's constructor, it was set to whatever the vars.timeScale was)
				this.cachedTimeScale = 1;
			}
			propTweenLookup = {};
			_ease = defaultEase; //temporarily - we'll check the vars object for an ease property in the init() method. We set it to the default initially for speed purposes.
						
			//handle overwriting (if necessary) and add the tween to the Dictionary for future
			_overwrite = (vars.overwrite == undefined || (!overwriteManager.enabled && vars.overwrite > 1)) ? overwriteManager.mode : Number(vars.overwrite);
			var a:Array = masterList[_targetID].tweens;
			if (a.length == 0) {
				a[0] = this;
			} else {
				if (_overwrite == 1) { //overwrite all other existing tweens of the same object (ALL mode)
					var i:Number = a.length;
					while (--i > -1) {
						if (!a[i].gc) {
							a[i].setEnabled(false, false);
						}
					}
					masterList[_targetID].tweens = [this];
				} else {
					a[a.length] = this;
				}
			}
			
			if (this.active || this.vars.immediateRender) {
				renderTime(0, false, true);
			}
		}
		
		/**
		 * @private
		 * Initializes the property tweens, determining their start values and amount of change. 
		 * Also triggers overwriting if necessary and sets the _hasUpdate variable.
		 */
		private function init():Void {
			if (this.vars.onInit) {
				this.vars.onInit.apply(null, this.vars.onInitParams);
			}
			var p:String, i:Number, plugin:Object, prioritize:Boolean, siblings:Array;
			if (typeof(this.vars.ease) == "function") {
				_ease = this.vars.ease;
			}
			if (this.vars.easeParams != undefined) {
				this.vars.proxiedEase = _ease;
				_ease = easeProxy;
			}
			this.cachedPT1 = undefined;
			this.propTweenLookup = {};
			for (p in this.vars) {
				if (_reservedProps[p] && !(p == "timeScale" && this.target instanceof TweenCore)) { 
					//ignore
				} else if (plugins[p] && (plugin = new plugins[p]()).onInitTween(this.target, this.vars[p], this)) {
					this.cachedPT1 = new PropTween(plugin, 
												    "changeFactor", 
												    0, 
												    1, 
												    (plugin.overwriteProps.length == 1) ? plugin.overwriteProps[0] : "_MULTIPLE_",
												    true,
												    this.cachedPT1);
					
					if (this.cachedPT1.name == "_MULTIPLE_") {
						i = plugin.overwriteProps.length;
						while (--i > -1) {
							this.propTweenLookup[plugin.overwriteProps[i]] = this.cachedPT1;
						}
					} else {
						this.propTweenLookup[this.cachedPT1.name] = this.cachedPT1;
					}
					if (plugin.priority) {
						this.cachedPT1.priority = plugin.priority;
						prioritize = true;
					}
					if (plugin.onDisable || plugin.onEnable) {
						_notifyPluginsOfEnabled = true;
					}
					_hasPlugins = true;
					
				} else {
					this.cachedPT1 = new PropTween(this.target, 
												    p, 
												    Number(this.target[p]), 
												    (typeof(this.vars[p]) == "number") ? Number(this.vars[p]) - this.target[p] : Number(this.vars[p]),
												    p,
												    false,
												    this.cachedPT1);
					this.propTweenLookup[p] = this.cachedPT1;
				}
			}
			if (prioritize) {
				onPluginEvent("onInitAllProps", this); //reorders the linked list in order of priority. Uses a static TweenPlugin method in order to minimize file size in TweenLite
			}
			if (this.vars.runBackwards) {
				var pt:PropTween = this.cachedPT1;
				while (pt) {
					pt.start += pt.change;
					pt.change = -pt.change;
					pt = pt.nextNode;
				}
			}
			_hasUpdate = Boolean(typeof(this.vars.onUpdate) == "function");
			if (_overwrittenProps) { //another tween may have tried to overwrite properties of this tween before init() was called (like if two tweens start at the same time, the one created second will run first)
				killVars(_overwrittenProps);
				if (this.cachedPT1 == undefined) { //if all tweening properties have been overwritten, kill the tween.
					this.setEnabled(false, false);
				}
			}
			if (_overwrite > 1 && this.cachedPT1 && (siblings = masterList[_targetID].tweens) && siblings.length > 1) {
				if (overwriteManager.manageOverwrites(this, this.propTweenLookup, siblings, _overwrite)) {
					//one of the plugins had activeDisable set to true, so properties may have changed when it was disabled meaning we need to re-init()
					init();
				}
			}
			this.initted = true;
		}
		
		/**
		 * Renders the tween at a particular time (or frame number for frames-based tweens). 
		 * The time is based simply on the overall duration. For example, if a tween's duration
		 * is 3, renderTime(1.5) would render it at the halfway finished point.
		 * 
		 * @param time time (or frame number for frames-based tweens) to render.
		 * @param suppressEvents If true, no events or callbacks will be triggered for this render (like onComplete, onUpdate, onReverseComplete, etc.)
		 * @param force Normally the tween will skip rendering if the time matches the cachedTotalTime (to improve performance), but if force is true, it forces a render. This is primarily used internally for tweens with durations of zero in TimelineLite/Max instances.
		 */
		public function renderTime(time:Number, suppressEvents:Boolean, force:Boolean):Void {
			var isComplete:Boolean, prevTime:Number = this.cachedTime;
			if (time >= this.cachedDuration) {
				this.cachedTotalTime = this.cachedTime = this.cachedDuration;
				this.ratio = 1;
				isComplete = true;
				if (this.cachedDuration == 0) { //zero-duration tweens are tricky because we must discern the momentum/direction of time in order to determine whether the starting values should be rendered or the ending values. If the "playhead" of its timeline goes past the zero-duration tween in the forward direction or lands directly on it, the end values should be rendered, but if the timeline's "playhead" moves past it in the backward direction (from a postitive time to a negative time), the starting values must be rendered.
					if ((time == 0 || _rawPrevTime < 0) && _rawPrevTime != time) {
						force = true;
					}		
					_rawPrevTime = time;
				}
				
			} else if (time <= 0) {
				this.cachedTotalTime = this.cachedTime = this.ratio = 0;
				if (time < 0) {
					this.active = false;
					if (this.cachedDuration == 0) { //zero-duration tweens are tricky because we must discern the momentum/direction of time in order to determine whether the starting values should be rendered or the ending values. If the "playhead" of its timeline goes past the zero-duration tween in the forward direction or lands directly on it, the end values should be rendered, but if the timeline's "playhead" moves past it in the backward direction (from a postitive time to a negative time), the starting values must be rendered.
						if (_rawPrevTime >= 0) {
							force = true;
							isComplete = true;
						}
						_rawPrevTime = time;
					}
				}
				if (this.cachedReversed && prevTime != 0) {
					isComplete = true;
				}
				
			} else {
				this.cachedTotalTime = this.cachedTime = time;
				this.ratio = _ease(time, 0, 1, this.cachedDuration);
			}
			
			if (this.cachedTime == prevTime && !force) {
				return;
			} else if (!this.initted) {
				init();
				if (!isComplete && this.cachedTime) { //_ease is initially set to defaultEase, so now that init() has run, _ease is set properly and we need to recalculate the ratio. Overall this is faster than using conditional logic earlier in the method to avoid having to set ratio twice because we only init() once but renderTime() gets called VERY frequently.
					this.ratio = _ease(this.cachedTime, 0, 1, this.cachedDuration);
				}
			}
			if (!this.active && !this.cachedPaused) {
				this.active = true;  //so that if the user renders a tween (as opposed to the timeline rendering it), the timeline is forced to re-render and align it with the proper time/frame on the next rendering cycle. Maybe the tween already finished but the user manually re-renders it as halfway done.
			}
			if (prevTime == 0 && this.vars.onStart && (this.cachedTime != 0 || this.cachedDuration == 0) && !suppressEvents) {
				this.vars.onStart.apply(this.vars.onStartScope, this.vars.onStartParams);
			}
			
			var pt:PropTween = this.cachedPT1;
			while (pt) {
				pt.target[pt.property] = pt.start + (this.ratio * pt.change);
				pt = pt.nextNode;
			}
			if (_hasUpdate && !suppressEvents) {
				this.vars.onUpdate.apply(this.vars.onUpdateScope, this.vars.onUpdateParams);
			}
			if (isComplete && !this.gc) { //check gc because there's a chance that kill() could be called in an onUpdate
				if (_hasPlugins && this.cachedPT1) {
					onPluginEvent("onComplete", this);
				}
				complete(true, suppressEvents);
			}
		}
		
		/**
		 * Allows particular properties of the tween to be killed. For example, if a tween is affecting 
		 * the "_x", "_y", and "_alpha" properties and you want to kill just the "_x" and "_y" parts of the 
		 * tween, you'd do <code>myTween.killVars({_x:true, _y:true});</code>
		 * 
		 * @param vars An object containing a corresponding property for each one that should be killed. The values don't really matter. For example, to kill the _x and _y property tweens, do myTween.killVars({_x:true, _y:true});
		 * @param permanent If true, the properties specified in the vars object will be permanently disallowed in the tween. Typically the only time false might be used is while the tween is in the process of initting and a plugin needs to make sure tweens of a particular property (or set of properties) is killed. 
		 * @return Boolean value indicating whether or not properties may have changed on the target when any of the vars were disabled. For example, when a motionBlur (plugin) is disabled, it swaps out a BitmapData for the target and may alter the alpha. We need to know this in order to determine whether or not a new tween that is overwriting this one should be re-initted() with the changed properties. 
		 */
		public function killVars(vars:Object, permanent:Boolean):Boolean {
			if (_overwrittenProps == undefined) {
				_overwrittenProps = {};
			}
			var p:String, pt:PropTween, changed:Boolean;
			for (p in vars) {
				if (propTweenLookup[p]) {
					pt = propTweenLookup[p];
					if (pt.isPlugin && pt.name == "_MULTIPLE_") {
						pt.target.killProps(vars);
						if (pt.target.overwriteProps.length == 0) {
							pt.name = "";
						}
						if (p != pt.target.propName || pt.name == "") {
							delete propTweenLookup[p];
						}
					}
					if (pt.name != "_MULTIPLE_") {
						//remove PropTween (do it inline to improve speed and keep file size low)
						if (pt.nextNode) {
							pt.nextNode.prevNode = pt.prevNode;
						}
						if (pt.prevNode) {
							pt.prevNode.nextNode = pt.nextNode;
						} else if (this.cachedPT1 == pt) {
							this.cachedPT1 = pt.nextNode;
						}
						if (pt.isPlugin && pt.target.onDisable) {
							pt.target.onDisable(); //some plugins need to be notified so they can perform cleanup tasks first
							if (pt.target.activeDisable) {
								changed = true;
							}
						}
						delete propTweenLookup[p];
					}
				}
				if (permanent != false && vars != _overwrittenProps) {
					_overwrittenProps[p] = 1;
				}
			}
			return changed;
		}
		
		/** @inheritDoc **/
		public function invalidate():Void {
			if (_notifyPluginsOfEnabled) {
				onPluginEvent("onDisable", this);
			}
			this.cachedPT1 = undefined;
			_overwrittenProps = undefined;
			_hasUpdate = this.initted = this.active = _notifyPluginsOfEnabled = false;
			this.propTweenLookup = {};
		}
		
		/** @private **/
		public function setEnabled(enabled:Boolean, ignoreTimeline:Boolean):Boolean {
			if (enabled) {
				var a:Array = masterList[_targetID].tweens;
				if (a) {
					a[a.length] = this;
				} else {
					masterList[_targetID] = {target:this.target, tweens:[this]};
				}
			}
			super.setEnabled(enabled, ignoreTimeline);
			if (_notifyPluginsOfEnabled && this.cachedPT1) {
				return onPluginEvent(((enabled) ? "onEnable" : "onDisable"), this);
			}
			return false;
		}
			
		/**
		 * @private
		 * Only used for easing equations that accept extra parameters (like Elastic.easeOut and Back.easeOut).
		 * Basically, it acts as a proxy. To utilize it, pass an Array of extra parameters via the vars object's
		 * "easeParams" special property
		 *  
		 * @param t time
		 * @param b start
		 * @param c change
		 * @param d duration
		 * @return Eased value
		 */
		private function easeProxy(t:Number, b:Number, c:Number, d:Number):Number { 
			return this.vars.proxiedEase.apply(null, arguments.concat(this.vars.easeParams));
		}
		
		
//---- STATIC FUNCTIONS -----------------------------------------------------------------------------------
		
		/**
		 * Static method for creating a TweenLite instance. This can be more intuitive for some developers 
		 * and shields them from potential garbage collection issues that could arise when assigning a
		 * tween instance to a variable that persists. The following lines of code produce exactly 
		 * the same result: <br /><br /><code>
		 * 
		 * var myTween:TweenLite = new TweenLite(mc, 1, {_x:100}); <br />
		 * TweenLite.to(mc, 1, {_x:100}); <br />
		 * var myTween:TweenLite = TweenLite.to(mc, 1, {_x:100});</code>
		 * 
		 * @param target Target object whose properties this tween affects. This can be ANY object, not just a MovieClip. 
		 * @param duration Duration in seconds (or in frames if the tween's timing mode is frames-based)
		 * @param vars An object containing the end values of the properties you're tweening. For example, to tween to _x=100, _y=100, you could pass {_x:100, _y:100}. It can also contain special properties like "onComplete", "ease", "delay", etc.
		 * @return TweenLite instance
		 */
		public static function to(target:Object, duration:Number, vars:Object):TweenLite {
			return new TweenLite(target, duration, vars);
		}
		
		/**
		 * Static method for creating a TweenLite instance that tweens in the opposite direction
		 * compared to a TweenLite.to() tween. In other words, you define the START values in the 
		 * vars object instead of the end values, and the tween will use the current values as 
		 * the end values. This can be very useful for animating things into place on the stage
		 * because you can build them in their end positions and do some simple TweenLite.from()
		 * calls to animate them into place. <b>NOTE:</b> By default, <code>immediateRender</code>
		 * is <code>true</code> in from() tweens, meaning that they immediately render their starting state 
		 * regardless of any delay that is specified. You can override this behavior by passing 
		 * <code>immediateRender:false</code> in the <code>vars</code> object so that it will wait to 
		 * render until the tween actually begins (often the desired behavior when inserting into timelines). 
		 * To illustrate the default behavior, the following code will immediately set the <code>_alpha</code> of <code>mc</code> 
		 * to 0 and then wait 2 seconds before tweening the <code>_alpha</code> back to 100 over the course 
		 * of 1.5 seconds:<br /><br /><code>
		 * 
		 * TweenLite.from(mc, 1.5, {_alpha:0, delay:2});</code>
		 * 
		 * @param target Target object whose properties this tween affects. This can be ANY object, not just a MovieClip. 
		 * @param duration Duration in seconds (or in frames if the tween's timing mode is frames-based)
		 * @param vars An object containing the start values of the properties you're tweening. For example, to tween from _x=100, _y=100, you could pass {_x:100, _y:100}. It can also contain special properties like "onComplete", "ease", "delay", etc.
		 * @return TweenLite instance
		 */
		public static function from(target:Object, duration:Number, vars:Object):TweenLite {
			vars.runBackwards = true;
			if (vars.immediateRender != false) {
				vars.immediateRender = true;
			}
			return new TweenLite(target, duration, vars);
		}
		
		/**
		 * Provides a simple way to call a function after a set amount of time (or frames). You can
		 * optionally pass any number of parameters to the function too. For example:<br /><br /><code>
		 * 
		 * TweenLite.delayedCall(1, myFunction, ["param1", 2]); <br />
		 * function myFunction(param1:String, param2:Number):Void { <br />
		 *     trace("called myFunction and passed params: " + param1 + ", " + param2); <br />
		 * } </code>
		 * 
		 * @param delay Delay in seconds (or frames if useFrames is true) before the function should be called
		 * @param onComplete Function to call
		 * @param onCompleteParams An Array of parameters to pass the function.
		 * @return TweenLite instance
		 */
		public static function delayedCall(delay:Number, onComplete:Function, onCompleteParams:Array, onCompleteScope:Object, useFrames:Boolean):TweenLite {
			return new TweenLite(onComplete, 0, {delay:delay, onComplete:onComplete, onCompleteParams:onCompleteParams, onCompleteScope:onCompleteScope, immediateRender:false, useFrames:useFrames, overwrite:0});
		}
		
		/**
		 * @private
		 * Updates the rootTimeline and rootFramesTimeline and collects garbage every 60 frames.
		 */
		private static function updateAll():Void {
			rootTimeline.renderTime(((getTimer() * 0.001) - rootTimeline.cachedStartTime) * rootTimeline.cachedTimeScale, false, false);
			rootFrame++;
			rootFramesTimeline.renderTime((rootFrame - rootFramesTimeline.cachedStartTime) * rootFramesTimeline.cachedTimeScale, false, false);
			
			if (!(rootFrame % 60)) { //garbage collect every 60 frames...
				var ml:Object = masterList, i:Number, a:Array;
				for (var p:String in ml) {
					a = ml[p].tweens;
					i = a.length;
					while (--i > -1) {
						if (a[i].gc) {
							a.splice(i, 1);
						}
					}
					if (a.length == 0) {
						delete ml[p];
					}
				}
			}
		}
		
		/**
		 * Kills all the tweens (or certain tweening properties) of a particular object, optionally completing them first.
		 * If, for example, you want to kill all tweens of the "mc" object, you'd do:<br /><br /><code>
		 * 
		 * TweenLite.killTweensOf(mc);<br /><br /></code>
		 * 
		 * But if you only want to kill all the "_alpha" and "_x" portions of mc's tweens, you'd do:<br /><br /><code>
		 * 
		 * TweenLite.killTweensOf(mc, false, {_alpha:true, _x:true});<br /><br /></code>
		 * 
		 * <code>killTweensOf()</code> affects tweens that haven't begun yet too. If, for example, 
		 * a tween of object "mc" has a delay of 5 seconds and <code>TweenLite.killTweensOf(mc)</code> is called
		 * 2 seconds after the tween was created, it will still be killed even though it hasn't started yet. <br /><br />
		 * 
		 * @param target Object whose tweens should be immediately killed
		 * @param complete Indicates whether or not the tweens should be forced to completion before being killed (false by default)
		 * @param vars An object defining which tweening properties should be killed (<code>undefined</code>, the default, causes all properties to be killed). For example, if you only want to kill "_alpha" and "_x" tweens of object "mc", you'd do <code>myTimeline.killTweensOf(mc, true, {_alpha:true, _x:true})</code>. If there are no tweening properties remaining in a tween after the indicated properties are killed, the entire tween is killed, meaning any onComplete, onUpdate, onStart, etc. won't fire.
		 */
		public static function killTweensOf(target:Object, complete:Boolean, vars:Object):Void {
			var id:String = getID(target, true);
			var a:Array = masterList[id].tweens, i:Number, tween:TweenLite;
			if (a != undefined) {
				i = a.length;
				while (--i > -1) {
					tween = a[i];
					if (!tween.gc) {
						if (complete == true) {
							tween.complete(false, false);
						} 
						if (vars != undefined) {
							tween.killVars(vars);
						}
						if (vars == undefined || (tween.cachedPT1 == undefined && tween.initted)) {
							tween.setEnabled(false, false);
						}
					}
				}
				if (vars == undefined) {
					delete masterList[id];
				}
			}
		}
		
		/** @private **/
		public static function getID(target:Object, lookup:Boolean):String {
			var id:String;
			if (lookup) {
				var ml:Object = masterList;
				if (typeof(target) == "movieclip") {
					if (ml[String(target)] != undefined) {
						return String(target);
					} else {
						id = String(target);
						masterList[id] = {target:target, tweens:[]};
						return id;
					}
				} else {
					for (var p:String in ml) {
						if (ml[p].target == target) {
							return p;
						}
					}
				}
			}
			_cnt++;
			id = "t" + _cnt;
			masterList[id] = {target:target, tweens:[]};
			return id;
		}
		
		/**
		 * @private
		 * Default easing equation
		 * 
		 * @param t time
		 * @param b start (must be 0)
		 * @param c change (must be 1)
		 * @param d duration
		 * @return Eased value
		 */
		private static function easeOut(t:Number, b:Number, c:Number, d:Number):Number {
			return -1 * (t /= d) * (t - 2);
		}
		
		
		/** 
		 * @private
		 * Subloaded SWFs in Flash Lite may not have access to _root.createEmptyMovieClip(), so we needed a way 
		 * to step through all the MovieClips on the Stage (including nested ones) until one is found that 
		 * can be used with createEmptyMovieClip(). Note: when getBytesLoaded() returns undefined, we know that
		 * the MovieClip has been deemed off-limits by the Flash Player and it won't allow createEmptyMovieClip()
		 * on that MovieClip.
		 **/
		private static function findSubloadedSWF(mc:MovieClip):MovieClip {
			for (var p:String in mc) {
				if (typeof(mc[p]) == "movieclip") {
					if (mc[p]._url != _root._url && mc[p].getBytesLoaded() != undefined) {
						return mc[p];
					} else if (findSubloadedSWF(mc[p]) != undefined) {
						return findSubloadedSWF(mc[p]);
					}
				}
			}
			return undefined;
		}
		
		/** 
		 * @private 
		 * This method was made public because in some very rare situations (like when an AS2/AS1-based swf 
		 * is subloaded into an AS3-based one, then unloaded, and another one is loaded subsequently), a bug in the Flash Player 
		 * prevented the onEnterFrame from working properly and the _root reference became invalid. If you run into a 
		 * situation where tweens appear to stop working in subsequent subloads, just make a call to TweenLite.jumpStart(_root) 
		 * on the first frame of those subloaded swfs to jump-start the rendering. 
		 **/
		public static function jumpStart(root:MovieClip):Void {
			if (_timingClip != undefined) {
				_timingClip.removeMovieClip();
			}
			var mc:MovieClip = (root.getBytesLoaded() == undefined) ? findSubloadedSWF(root) : root; //subloaded swfs won't return getBytesLoaded() in Flash Lite, and it locks us out from being able to createEmptyMovieClip(), so we must find the subloaded clip to do it there instead.
			var l:Number = 999; //Don't just do getNextHighestDepth() because often developers will hard-code stuff that uses low levels which would overwrite the TweenLite clip. Start at level 999 and make sure nothing's there. If there is, move up until we find an empty level.
			while (mc.getInstanceAtDepth(l) != undefined) {
				l++;
			}
			_timingClip = mc.createEmptyMovieClip("__tweenLite" + String(version).split(".").join("_"), l);
			_timingClip.onEnterFrame = updateAll;
			TweenLite.to({}, 0, {}); //just to properly instantiate the class and get all the necessary variables/properties set up before updateAll() starts getting called.
			rootTimeline.cachedTime = rootTimeline.cachedTotalTime = ((getTimer() * 0.001) - rootTimeline.cachedStartTime) * rootTimeline.cachedTimeScale; //so that the start time of subsequent tweens that get created are correct. Otherwise, in cases where an AS2/AS1 swf is unloaded from an AS3 swf and time elapses and then another AS2/AS1 swf is loaded, the tweens will have their cachedStartTime set to the timeline's cachedTotalTime which won't have been updated because the onEnterFrame may have been stopped because of the bug in Flash.
		}
	
}