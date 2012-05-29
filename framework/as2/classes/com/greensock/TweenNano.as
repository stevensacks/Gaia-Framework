/**
 * VERSION: 1.06
 * DATE: 2011-01-12
 * AS2 (AS3 is also available)
 * UPDATES AND DOCS AT: http://www.greensock.com
 **/

/**
 * 	TweenNano is a super-lightweight (1.6k in AS3 and 2k in AS2) version of <a href="http://www.TweenLite.com">TweenLite</a> 
 *  and is only recommended for situations where you absolutely cannot afford the extra 3.3k (5.3k total) that the normal 
 *  TweenLite engine would cost and your project doesn't require any plugins. Otherwise, I'd strongly advocate using 
 *  TweenLite because of the additional flexibility it provides via plugins and compatibility with TimelineLite and TimelineMax. 
 *  TweenNano can do everything TweenLite can do with the following exceptions:
 * 	<ul>
 * 		<li><b> No Plugins </b>- One of the great things about TweenLite is that you can activate
 * 			plugins in order to add features (like autoAlpha, tint, blurFilter, etc.). TweenNano, however, 
 * 			doesn't work with plugins. </li>
 * 		  
 * 		<li><b> Incompatible with TimelineLite and TimelineMax </b>- Complex sequencing and management of groups of 
 * 			tweens can be much easier with TimelineLite and TimelineMax, but TweenNano instances cannot be inserted into
 * 			TimelineLite or TimelineMax instances.</li>
 * 		  
 * 		<li><b> Fewer overwrite modes </b>- You can either overwrite all or none of the existing tweens of the same 
 * 			object (overwrite:true or overwrite:false) in TweenNano. TweenLite, however, can use OverwriteManager to expand 
 * 			its capabilities and use modes like AUTO, CONCURRENT, PREEXISTING, and ALL_ONSTART
 * 			(see <a href="http://www.greensock.com/overwritemanager/">http://www.greensock.com/overwritemanager/</a>
 * 			for details).</li>
 * 
 * 		<li><b>Compared to TweenLite, TweenNano is missing the following methods/properties:</b>
 * 			<ul>
 * 				<li>pause()</li>
 * 				<li>play()</li>
 * 				<li>resume()</li>
 * 				<li>restart()</li>
 * 				<li>reverse()</li>
 * 				<li>invalidate()</li>
 * 				<li>onStart</li>
 * 				<li>defaultEase</li>
 * 				<li>easeParams</li>
 * 				<li>currentTime</li>
 * 				<li>startTime</li>
 * 				<li>totalTime</li>
 * 				<li>paused</li>
 * 				<li>reversed</li>
 * 				<li>totalDuration</li>
 * 			</ul>
 * 		</li>
 * 	</ul>
 * 
 * <hr>	
 * <b>SPECIAL PROPERTIES:</b>
 * <br /><br />
 * 
 * Any of the following special properties can optionally be passed in through the vars object (the third parameter):
 * 
 * <ul>
 * 	<li><b> delay : Number</b>			Amount of delay in seconds (or frames for frames-based tweens) before the tween should begin.</li>
 * 	
 * 	<li><b> useFrames : Boolean</b>		If useFrames is set to true, the tweens's timing mode will be based on frames. 
 * 										Otherwise, it will be based on seconds/time.</li>
 * 	
 * 	<li><b> ease : Function</b>			Use any standard easing equation to control the rate of change. For example, 
 * 										<code>Elastic.easeOut</code>. The Default is Regular.easeOut.</li>
 * 	
 * 	<li><b> onUpdate : Function</b>		A function that should be called every time the tween's time/position is updated 
 * 										(on every frame while the timeline is active)</li>
 * 	
 * 	<li><b> onUpdateParams : Array</b>	An Array of parameters to pass the onUpdate function</li>
 * 	
 * 	<li><b> onComplete : Function</b>	A function that should be called when the tween has finished </li>
 * 	
 * 	<li><b> onCompleteParams : Array</b> An Array of parameters to pass the onComplete function.</li>
 * 	
 * 	<li><b> immediateRender : Boolean</b> Normally when you create a from() tween, it renders the starting state immediately even
 * 										  if you define a delay which in typical "animate in" scenarios is very desirable, but
 * 										  if you prefer to override this behavior and have the from() tween render only after any 
 * 										  delay has elapsed, set <code>immediateRender</code> to false. </li>
 * 	
 * 	<li><b> overwrite : int</b>			Controls how other tweens of the same object are handled when this tween is created. Here are the options:
 * 										<ul>
 * 			  							<li><b> false (NONE):</b> No tweens are overwritten. This is the fastest mode, but you need to be careful not 
 * 													to create any tweens with overlapping properties of the same object that run at the same time, 
 * 													otherwise they'll conflict with each other. <br /><code>
 * 												   		TweenNano.to(mc, 1, {x:100, y:200});<br />
 * 														TweenNano.to(mc, 1, {x:300, delay:2, overwrite:false}); //does NOT overwrite the previous tween.</code></li>
 * 											
 * 										<li><b> true (ALL_IMMEDIATE):</b> This is the default mode in TweenNano. All tweens of the same target
 * 													are completely overwritten immediately when the tween is created, regardless of whether or 
 * 													not any of the properties overlap. <br /><code>
 * 												   		TweenNano.to(mc, 1, {x:100, y:200});<br />
 * 														TweenNano.to(mc, 1, {x:300, delay:2, overwrite:true}); //immediately overwrites the previous tween</code></li>
 * 										</ul></li>
 * 	</ul>
 * 
 * <b>EXAMPLES:</b> <br /><br />
 * 
 * 	Tween the the MovieClip "mc" to an _alpha value of 50 and an x-coordinate of 120 
 * 	over the course of 1.5 seconds like so:<br /><br />
 * 	
 * <code>
 * 		import com.greensock.TweenNano;<br /><br />
 * 		TweenNano.to(mc, 1.5, {_alpha:50, _x:120});
 * 	</code><br /><br />
 *  
 * 	To tween the "mc" MovieClip's _alpha property to 50, its _x property to 120 using the <code>Back.easeOut</code> easing 
 *  function, delay starting the whole tween by 2 seconds, and then call a function named "onFinishTween" when it 
 *  has completed (it will have a duration of 5 seconds) and pass a few parameters to that function (a value of 
 *  5 and a reference to the mc), you'd do so like:<br /><br />
 * 		
 * 	<code>
 * 		import com.greensock.TweenNano;<br />
 * 		import com.greensock.easing.Back;<br /><br />
 * 
 * 		TweenNano.to(mc, 5, {_alpha:50, _x:120, ease:Back.easeOut, delay:2, onComplete:onFinishTween, onCompleteParams:[5, mc]});<br />
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
 * 		import com.greensock.TweenNano;<br />
 * 		import com.greensock.easing.Elastic;<br /><br />
 * 
 * 		TweenNano.from(mc, 5, {_y:"-100", ease:Elastic.easeOut});		
 *  </code><br /><br />
 * 
 * <b>NOTES / TIPS:</b><br /><br />
 * <ul>
 * 	<li> The base TweenNano class adds about 2k to your Flash file.</li>
 * 	  
 * 	<li> Passing values as Strings will make the tween relative to the current value. For example, if you do
 * 	  <code>TweenNano.to(mc, 2, {_x:"-20"});</code> it'll move the mc._x to the left 20 pixels which is the same as doing
 * 	  <code>TweenNano.to(mc, 2, {_x:mc._x - 20});</code> You could also cast it like: <code>TweenNano.to(mc, 2, {_x:String(myVariable)});</code></li>
 * 	
 * 	<li> Kill all tweens for a particular object anytime with the <code>TweenNano.killTweensOf(mc); </code></li>
 * 	  
 * 	<li> You can kill all delayedCalls to a particular function using <code>TweenNano.killTweensOf(myFunction);</code>
 * 	  This can be helpful if you want to preempt a call.</li>
 * 
 *  <li> If some of your tweens don't appear to be working, read about the <code>overwrite</code> special property
 * 		above - it is most likely an overwriting issue that could be solved by adding <code>overwrite:false</code> to your vars object.</li>
 * 	  
 * 	<li> Use the <code>TweenNano.from()</code> method to animate things into place. For example, if you have things set up on 
 * 	  the stage in the spot where they should end up, and you just want to animate them into place, you can 
 * 	  pass in the beginning _x and/or _y and/or _alpha (or whatever properties you want).</li>
 * 	  
 * 	<li> If you find this class useful, please consider joining Club GreenSock which not only helps to sustain
 * 	  ongoing development, but also gets you bonus plugins, classes and other benefits that are ONLY available 
 * 	  to members. Learn more at <a href="http://blog.greensock.com/club/">http://blog.greensock.com/club/</a></li>
 * </ul>
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */
class com.greensock.TweenNano {
		/** @private **/
		private static var version:Number = 1.06;
		/** @private **/
		private static var _time:Number;
		/** @private **/
		private static var _frame:Number;
		/** @private Holds references to all our tweens based on their targets (an Array for each target) **/
		private static var _masterList:Object = {}; 
		/** @private A reference to the Shape that we use to drive all our ENTER_FRAME events. **/
		private static var _timingClip:MovieClip; 
		/** @private Indicates whether or not the TweenNano class has been initted. **/
		private static var _tnInitted:Boolean; 
		/** @private **/
		private static var _reservedProps:Object = {ease:1, delay:1, useFrames:1, overwrite:1, onComplete:1, onCompleteParams:1, runBackwards:1, immediateRender:1, onUpdate:1, onUpdateParams:1};
		/** @private **/
		private static var _cnt:Number = -16000;
		
		/** Duration of the tween in seconds (or in frames if "useFrames" is true). **/
		public var duration:Number; 
		/** Stores variables (things like "alpha", "y" or whatever we're tweening, as well as special properties like "onComplete"). **/
		public var vars:Object; 
		/** @private Start time in seconds (or frames for frames-based tweens) **/
		public var startTime:Number;
		/** Target object whose properties this tween affects. This can be ANY object, not just a MovieClip. **/
		public var target:Object;
		/** @private Indicates whether or not the tween is currently active **/
		public var active:Boolean; 
		/** @private Flagged for garbage collection **/
		public var gc:Boolean;
		/** Indicates that frames should be used instead of seconds for timing purposes. So if useFrames is true and the tween's duration is 10, it would mean that the tween should take 10 frames to complete, not 10 seconds. **/
		public var useFrames:Boolean;
		/** @private Target ID (a way to identify each end target, i.e. "t1", "t2", "t3") **/
		public var endTargetID:String;
		/** @private result of _ease(this.time, 0, 1, this.duration). Usually between 0 and 1, but not always (like with Elastic.easeOut). **/
		public var ratio:Number;
	
		/** @private Easing method to use which determines how the values animate over time. Examples are Elastic.easeOut and Strong.easeIn. Many are found in the fl.motion.easing package or com.greensock.easing. **/
		private var _ease:Function;
		/** @private Indicates whether or not init() has been called (where all the tween property start/end value information is recorded) **/
		private var _initted:Boolean;
		/** @private Contains parsed data for each property that's being tweened (property name, start, and change) **/
		private var _propTweens:Array; 
		
		/**
		 * Constructor
		 *  
		 * @param target Target object whose properties this tween affects. This can be ANY object, not just a MovieClip. 
		 * @param duration Duration in seconds (or in frames if "useFrames" is true)
		 * @param vars An object containing the end values of the properties you're tweening, like {_x:100, _y:50}. It can also contain special properties like "onComplete", "ease", "delay", etc.
		 */
		public function TweenNano(target:Object, duration:Number, vars:Object) {
			if (!_tnInitted) {
				_time = getTimer() * 0.001;
				_frame = 0;
				_tnInitted = true;
			}
			if (_timingClip.onEnterFrame != updateAll) { //subloaded swfs in Flash Lite restrict access to _root.createEmptyMovieClip(), so we find the subloaded swf MovieClip to createEmptyMovieClip(), but if it gets unloaded, the onEnterFrame will stop running so we need to check each time a tween is created.
				var mc:MovieClip = (_root.getBytesLoaded() == undefined) ? findSubloadedSWF(_root) : _root; //subloaded swfs won't return getBytesLoaded() in Flash Lite, and it locks us out from being able to createEmptyMovieClip(), so we must find the subloaded clip to do it there instead.
				var l:Number = 999; //Don't just do getNextHighestDepth() because often developers will hard-code stuff that uses low levels which would overwrite the TweenLite clip. Start at level 999 and make sure nothing's there. If there is, move up until we find an empty level.
				while (mc.getInstanceAtDepth(l) != undefined) {
					l++;
				}
				_timingClip = mc.createEmptyMovieClip("__tweenNano" + String(version).split(".").join("_"), l);
				_timingClip.onEnterFrame = updateAll;
			}
			this.vars = vars;
			this.duration = duration;
			this.ratio = 0;
			this.active = Boolean(duration == 0 && this.vars.delay == 0 && this.vars.immediateRender != false);
			this.target = target;
			if (typeof(this.vars.ease) != "function") {
				_ease = TweenNano.easeOut;
			} else {
				_ease = this.vars.ease;
			}
			_propTweens = [];
			this.useFrames = Boolean(vars.useFrames == true);
			
			var delay:Number = this.vars.delay || 0;
			this.startTime = (this.useFrames) ? _frame + delay : _time + delay;
			this.endTargetID = getID(target, true);
			
			var a:Array = _masterList[this.endTargetID].tweens;
			if (a == undefined || Number(this.vars.overwrite) == 1 || this.vars.overwrite == undefined) { 
				_masterList[this.endTargetID] = {target:target, tweens:[this]};
			} else {
				a[a.length] = this;
			}
			
			if (this.active || this.vars.immediateRender) {
				renderTime(0);
			}
		}
		
		/**
		 * @private
		 * Initializes the property tweens, determining their start values and amount of change. 
		 * Also triggers overwriting if necessary and sets the _hasUpdate variable.
		 */
		public function init():Void {
			for (var p:String in this.vars) {
				if (!_reservedProps[p]) {
					_propTweens[_propTweens.length] = [p, this.target[p], (typeof(this.vars[p]) == "number") ? this.vars[p] - this.target[p] : Number(this.vars[p])]; //[property, start, change]
				}
			}
			if (this.vars.runBackwards) {
				var pt:Array;
				var i:Number = _propTweens.length;
				while (--i > -1) {
					pt = _propTweens[i];
					pt[1] += pt[2];
					pt[2] = -pt[2];
				}
			}
			_initted = true;
		}
		
		/**
		 * Renders the tween at a particular time (or frame number for frames-based tweens)
		 * WITHOUT changing its startTime, meaning if the tween is in progress when you call
		 * renderTime(), it will not adjust the tween's timing to continue from the new time. 
		 * The time is based simply on the overall duration. For example, if a tween's duration
		 * is 3, renderTime(1.5) would render it at the halfway finished point.
		 * 
		 * @param time time (or frame number for frames-based tweens) to render.
		 */
		public function renderTime(time:Number):Void {
			if (!_initted) {
				init();
			}
			var pt:Array, i:Number = _propTweens.length;
			if (time >= this.duration) {
				time = this.duration;
				this.ratio = 1;
			} else if (time <= 0) {
				this.ratio = 0;
			} else {
				this.ratio = _ease(time, 0, 1, this.duration);			
			}
			while (--i > -1) {
				pt = _propTweens[i];
				this.target[pt[0]] = pt[1] + (this.ratio * pt[2]); 
			}
			if (this.vars.onUpdate) {
				this.vars.onUpdate.apply(this.vars.onUpdateScope, this.vars.onUpdateParams);
			}
			if (time == this.duration) {
				complete(true);
			}
		}
		
		/**
		 * Forces the tween to completion.
		 * 
		 * @param skipRender To skip rendering the final state of the tween, set skipRender to true. 
		 */
		public function complete(skipRender:Boolean):Void {
			if (skipRender != true) {
				renderTime(this.duration);
				return;
			}
			kill();
			if (this.vars.onComplete) {
				this.vars.onComplete.apply(this.vars.onCompleteScope, this.vars.onCompleteParams);
			}
		}
		
		/** Kills the tween, stopping it immediately. **/
		public function kill():Void {
			this.gc = true;
			this.active = false;
		}
		
		
//---- STATIC FUNCTIONS -------------------------------------------------------------------------
		
		/**
		 * Static method for creating a TweenNano instance which can be more intuitive for some developers 
		 * and shields them from potential garbage collection issues that could arise when assigning a
		 * tween instance to a variable that persists. The following lines of code all produce exactly 
		 * the same result: <br /><br /><code>
		 * 
		 * var myTween:TweenNano = new TweenNano(mc, 1, {_x:100}); <br />
		 * TweenNano.to(mc, 1, {_x:100}); <br />
		 * var myTween:TweenNano = TweenNano.to(mc, 1, {_x:100});</code>
		 * 
		 * @param target Target object whose properties this tween affects. This can be ANY object, not just a MovieClip. 
		 * @param duration Duration in seconds (or frames if "useFrames" is true)
		 * @param vars An object containing the end values of the properties you're tweening, like {_x:100, _y:50}. It can also contain special properties like "onComplete", "ease", "delay", etc.
		 * @return TweenNano instance
		 */
		public static function to(target:Object, duration:Number, vars:Object):TweenNano {
			return new TweenNano(target, duration, vars);
		}
		
		/**
		 * Static method for creating a TweenNano instance that tweens in the opposite direction
		 * compared to a TweenNano.to() tween. In other words, you define the START values in the 
		 * vars object instead of the end values, and the tween will use the current values as 
		 * the end values. This can be very useful for animating things into place on the stage
		 * because you can build them in their end positions and do some simple TweenNano.from()
		 * calls to animate them into place. <b>NOTE:</b> By default, <code>immediateRender</code>
		 * is <code>true</code> in from() tweens, meaning that they immediately render their starting state 
		 * regardless of any delay that is specified. You can override this behavior by passing 
		 * <code>immediateRender:false</code> in the <code>vars</code> object so that it will wait to 
		 * render until the tween actually begins. To illustrate the default behavior, the following code 
		 * will immediately set the <code>alpha</code> of <code>mc</code> to 0 and then wait 2 seconds 
		 * before tweening the <code>alpha</code> back to 1 over the course of 1.5 seconds:<br /><br /><code>
		 * 
		 * TweenNano.from(mc, 1.5, {_alpha:0, delay:2});</code>
		 * 
		 * @param target Target object whose properties this tween affects. This can be ANY object, not just a MovieClip. 
		 * @param duration Duration in seconds (or frames if "useFrames" is true)
		 * @param vars An object containing the start values of the properties you're tweening like {x:100, y:50}. It can also contain special properties like "onComplete", "ease", "delay", etc.
		 * @return TweenNano instance
		 */
		public static function from(target:Object, duration:Number, vars:Object):TweenNano {
			vars.runBackwards = true;
			if (vars.immediateRender == undefined) {
				vars.immediateRender = true;
			}
			return new TweenNano(target, duration, vars);
		}
		
		/**
		 * Provides a simple way to call a function after a set amount of time (or frames). You can
		 * optionally pass any number of parameters to the function too. For example:<br /><br /><code>
		 * 
		 * TweenNano.delayedCall(1, myFunction, ["param1", 2]); <br />
		 * function myFunction(param1:String, param2:Number):Void { <br />
		 *     trace("called myFunction and passed params: " + param1 + ", " + param2); <br />
		 * } </code>
		 * 
		 * @param delay Delay in seconds (or frames if "useFrames" is true) before the function should be called
		 * @param onComplete Function to call
		 * @param onCompleteParams An Array of parameters to pass the function.
		 * @param onCompleteScope the scope that should be used for the delayed function call (scope basically defines what "this" refers to in the function).
		 * @param useFrames If true, the delay will be measured in frames instead of seconds.
		 * @return TweenNano instance
		 */
		public static function delayedCall(delay:Number, onComplete:Function, onCompleteParams:Array, onCompleteScope:Object, useFrames:Boolean):TweenNano {
			return new TweenNano(onComplete, 0, {delay:delay, onComplete:onComplete, onCompleteParams:onCompleteParams, onCompleteScope:onCompleteScope, useFrames:useFrames, overwrite:0});
		}
		
		/**
		 * @private
		 * Updates active tweens and activates those whose startTime is before the _time/_frame.
		 */
		public static function updateAll():Void {
			_frame++;
			_time = getTimer() * 0.001;
			var ml:Object = _masterList, a:Array, tgt:String, i:Number, t:Number, tween:TweenNano;
			for (tgt in ml) {
				a = ml[tgt].tweens;
				i = a.length;
				while (--i > -1) {
					tween = a[i];
					t = (tween.useFrames) ? _frame : _time;
					if (tween.active || (!tween.gc && t >= tween.startTime)) {
						tween.renderTime(t - tween.startTime);
					} else if (tween.gc) {
						a.splice(i, 1);
					}
				}
				if (a.length == 0) {
					delete ml[tgt];
				}
			}
		}
		
		/**
		 * Kills all the tweens of a particular object, optionally forcing them to completion too.
		 * 
		 * @param target Object whose tweens should be immediately killed
		 * @param complete Indicates whether or not the tweens should be forced to completion before being killed.
		 */
		 public static function killTweensOf(target:Object, complete:Boolean):Void {
			var id:String = getID(target, true);
			var a:Array = _masterList[id], i:Number;
			if (a) {
				if (complete) {
					i = a.length;
					while (--i > -1) {
						if (!a[i].gc) {
							a[i].complete(false);
						}
					}
				}
				delete _masterList[id];
			}
		}
		
		/** @private **/
		public static function getID(target:Object, lookup:Boolean):String {
			var id:String, ml:Object = _masterList;
			if (lookup) {
				if (typeof(target) == "movieclip") {
					if (ml[String(target)] != undefined) {
						return String(target);
					} else {
						id = String(target);
						ml[id] = {target:target, tweens:[]};
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
			ml[id] = {target:target, tweens:[]};
			return id;
		}
		
		/** @private **/
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
	
}