/**
 * VERSION: 1.66
 * DATE: 2011-01-25
 * AS2 (AS3 version is also available)
 * UPDATES AND DOCS AT: http://www.greensock.com/timelinemax/
 **/
import com.greensock.*;
import com.greensock.core.*;
/**
 * 	TimelineMax extends TimelineLite, offering exactly the same functionality plus useful 
 *  (but non-essential) features like repeat, repeatDelay, yoyo, 
 *  currentLabel, addCallback(), removeCallback(), tweenTo(), getLabelAfter(), getLabelBefore(),
 * 	and getActive() (and probably more in the future). It is the ultimate sequencing tool. 
 *  Think of a TimelineMax instance like a virtual MovieClip timeline or a container where 
 *  you place tweens (or other timelines) over the course of time. You can:
 * 	
 * <ul>
 * 		<li> build sequences easily by adding tweens with the append(), prepend(), insert(), and insertMultiple() methods.</li>
 * 
 * 		<li> add labels, play(), stop(), gotoAndPlay(), gotoAndStop(), restart(), and even reverse()! </li>
 * 		
 * 		<li> nest timelines within timelines as deeply as you want. When you pause or change the 
 * 		  timeScale of a parent timeline, it affects all of its descendents.</li>
 * 		
 * 		<li> set the progress of the timeline using its <code>currentProgress</code> property. For example, to skip to
 * 		  the halfway point, set <code>myTimeline.currentProgress = 0.5</code>.</li>
 * 		  
 * 		<li> tween the <code>currentTime</code>, or <code>currentProgress</code> property to fastforward/rewind the timeline. You could 
 * 		  even attach a slider to one of these properties to give the user the ability to drag 
 * 		  forwards/backwards through the whole timeline.</li>
 * 		  
 * 		<li> add onStart, onUpdate, onComplete, onReverseComplete, and/or onRepeat callbacks using the 
 * 		  constructor's <code>vars</code> object.</li>
 * 		
 * 		<li> speed up or slow down the entire timeline with its timeScale property. You can even tween
 * 		  this property to gradually speed up or slow down the timeline.</li>
 * 		  
 * 		<li> use the insertMultiple() method to create complex sequences including various alignment
 * 		  modes and staggering capabilities.</li>
 * 		  
 * 		<li> base the timing on frames instead of seconds if you prefer. Please note, however, that
 * 		  the timeline's timing mode dictates its childrens' timing mode as well. </li>
 * 		
 * 		<li> kill the tweens of a particular object with killTweensOf() or get the tweens of an object
 * 		  with getTweensOf() or get all the tweens/timelines in the timeline with getChildren()</li>
 * 		  
 * 		<li> set the timeline to repeat any number of times or indefinitely. You can even set a delay
 * 		  between each repeat cycle and/or cause the repeat cycles to yoyo, appearing to reverse
 * 		  every other cycle. </li>
 * 		
 * 		<li> get the active tweens in the timeline with getActive().</li>
 * 
 * 		<li> add callbacks anywhere in the timeline that call a function of your choosing when 
 * 			the "virtual playhead" passes a particular spot.</li>
 * 	</ul>
 * 	
 * <b>EXAMPLE:</b><br /><br /><code>
 * 		
 * 		import com.greensock.TweenLite;<br />
 * 		import com.greensock.TimelineMax;<br /><br />
 * 		
 * 		//create the timeline<br />
 * 		var myTimeline:TimelineMax = new TimelineMax();<br /><br />
 * 		
 * 		//add a tween<br />
 * 		myTimeline.append(new TweenLite(mc, 1, {_x:200, _y:100}));<br /><br />
 * 		
 * 		//add another tween at the end of the timeline (makes sequencing easy)<br />
 * 		myTimeline.append(new TweenLite(mc, 0.5, {_alpha:0}));<br /><br />
 * 		
 * 		//repeat the whole timeline twice.<br />
 * 		myTimeline.repeat = 2;<br /><br />
 * 		
 * 		//delay the repeat by 0.5 seconds each time.<br />
 * 		myTimeline.repeatDelay = 0.5;<br /><br />
 * 		
 * 		//stop/pause the timeline.<br />
 * 		myTimeline.stop();<br /><br />
 * 		
 * 		//reverse it anytime...<br />
 * 		myTimeline.reverse();<br /><br />
 * 		
 * 		//Add a "spin" label 3-seconds into the timeline.<br />
 * 		myTimeline.addLabel("spin", 3);<br /><br />
 * 		
 * 		//insert a rotation tween at the "spin" label (you could also define the insert point as the time instead of a label)<br />
 * 		myTimeline.insert(new TweenLite(mc, 2, {_rotation:"360"}), "spin"); <br /><br />
 * 		
 * 		//go to the "spin" label and play the timeline from there...<br />
 * 		myTimeline.gotoAndPlay("spin");<br /><br />
 * 	
 * 		//call myFunction when the "virtual playhead" travels past the 1.5-second point.
 * 		myTimeline.addCallback(myFunction, 1.5);
 * 	
 * 		//add a tween to the beginning of the timeline, pushing all the other existing tweens back in time<br />
 * 		myTimeline.prepend(new TweenLite(mc, 1, {tint:0xFF0000}));<br /><br />
 * 		
 * 		//nest another TimelineMax inside your timeline...<br />
 * 		var nestedTimeline:TimelineMax = new TimelineMax();<br />
 * 		nestedTimeline.append(new TweenLite(mc2, 1, {_x:200}));<br />
 * 		myTimeline.append(nestedTimeline);<br /><br /></code>
 * 		
 * 		
 * 	insertMultiple() provides some very powerful sequencing tools as well, allowing you to add an Array of 
 * 	tweens/timelines and optionally align them with SEQUENCE or START modes, and even stagger them if you want. For example, to insert
 * 	3 tweens into the timeline, aligning their start times but staggering them by 0.2 seconds, <br /><br /><code>
 * 	
 * 		myTimeline.insertMultiple([new TweenLite(mc, 1, {_y:"100"}),
 * 								   new TweenLite(mc2, 1, {_y:"120"}),
 * 								   new TweenLite(mc3, 1, {_y:"140"})], 
 * 								   0, 
 * 								   TweenAlign.START, 
 * 								   0.2);</code><br /><br />
 * 								   
 * 	You can use the constructor's "vars" object to do all the setup too, like:<br /><br /><code>
 * 	
 * 		var myTimeline:TimelineMax = new TimelineMax({tweens:[new TweenLite(mc1, 1, {_y:"100"}), TweenMax.to(mc2, 1, {tint:0xFF0000})], align:TweenAlign.SEQUENCE, onComplete:myFunction, repeat:2, repeatDelay:1});</code><br /><br />
 * 	
 * 	If that confuses you, don't worry. Just use the append(), insert(), and prepend() methods to build your
 * 	sequence. But power users will likely appreciate the quick, compact way they can set up sequences now. <br /><br />
 * 
 *
 * <b>NOTES:</b>
 * <ul>
 * 	<li> TimelineMax automatically inits the OverwriteManager class to prevent unexpected overwriting behavior in sequences.
 * 	  The default mode is AUTO, but you can set it to whatever you want with OverwriteManager.init() (see http://www.greensock.com/overwritemanager/)</li>
 * 	<li> TimelineMax adds about 4.2k to your SWF including OverwriteManager.</li>
 * </ul>
 * 
 * <b>Copyright 2011, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 **/
class com.greensock.TimelineMax extends TimelineLite {
		/** @private **/
		public static var version:Number = 1.66;
		
		/** @private **/
		private var _repeat:Number;
		/** @private **/
		private var _repeatDelay:Number;
		/** @private **/
		private var _cyclesComplete:Number;
		
		/** 
		 * Works in conjunction with the repeat property, determining the behavior of each cycle; when yoyo is true, 
		 * the timeline will go back and forth, appearing to reverse every other cycle (this has no affect on the "reversed" property though). 
		 * So if repeat is 2 and yoyo is false, it will look like: start - 1 - 2 - 3 - 1 - 2 - 3 - 1 - 2 - 3 - end. 
		 * But if repeat is 2 and yoyo is true, it will look like: start - 1 - 2 - 3 - 3 - 2 - 1 - 1 - 2 - 3 - end.  
		 **/
		public var yoyo:Boolean;
		
		/**
		 * Constructor <br /><br />
		 * 
		 * <b>SPECIAL PROPERTIES</b><br />
		 * The following special properties may be passed in via the constructor's vars parameter, like
		 * <code>new TimelineMax({paused:true, onComplete:myFunction, repeat:2, yoyo:true})</code> 
		 * 
		 * <ul>
		 * 	<li><b> delay : Number</b>				Amount of delay before the timeline should begin (in seconds unless "useFrames" is set 
		 * 											to true in which case the value is measured in frames).</li>
		 * 								
		 * 	<li><b> useFrames : Boolean</b>			If useFrames is set to true, the timeline's timing mode will be based on frames. 
		 * 											Otherwise, it will be based on seconds/time. NOTE: a TimelineLite's timing mode is 
		 * 											always determined by its parent timeline. </li>
		 * 
		 *  <li><b> paused : Boolean</b> 			Sets the initial paused state of the timeline (by default, timelines automatically begin playing immediately)</li>
		 * 
		 * 	<li><b> reversed : Boolean</b>			If true, the timeline will be reversed initially. This does NOT force it to the very end and start 
		 * 											playing backwards. It simply affects the orientation of the timeline, so if reversed is set to 
		 * 											true initially, it will appear not to play because it is already at the beginning. To cause it to
		 * 											play backwards from the end, set reversed to true and then set the <code>currentProgress</code> property to 1 immediately
		 * 											after creating the timeline.</li>
		 * 									
		 * 	<li><b> tweens : Array</b>				To immediately insert several tweens into the timeline, use the "tweens" special property
		 * 											to pass in an Array of TweenLite/TweenMax/TimelineLite/TimelineMax instances. You can use this in conjunction
		 * 											with the align and stagger special properties to set up complex sequences with minimal code.
		 * 											These values simply get passed to the insertMultiple() method.</li>
		 * 	
		 * 	<li><b> align : String</b>				Only used in conjunction with the "tweens" special property when multiple tweens are
		 * 											to be inserted immediately. The value simply gets passed to the 
		 * 											insertMultiple() method. Default is NORMAL. Options are:
		 * 											<ul>
		 * 												<li><b> TweenAlign.SEQUENCE:</b> aligns the tweens one-after-the-other in a sequence</li>
		 * 												<li><b> TweenAlign.START:</b> aligns the start times of all of the tweens (ignores delays)</li>
		 * 												<li><b> TweenAlign.NORMAL:</b> aligns the start times of all the tweens (honors delays)</li>
		 * 											</ul></li>
		 * 										
		 * 	<li><b> stagger : Number</b>			Only used in conjunction with the "tweens" special property when multiple tweens are
		 * 											to be inserted immediately. It staggers the tweens by a set amount of time (in seconds) (or
		 * 											in frames if "useFrames" is true). For example, if the stagger value is 0.5 and the "align" 
		 * 											property is set to TweenAlign.START, the second tween will start 0.5 seconds after the first one 
		 * 											starts, then 0.5 seconds later the third one will start, etc. If the align property is 
		 * 											TweenAlign.SEQUENCE, there would be 0.5 seconds added between each tween. This value simply gets 
		 * 											passed to the insertMultiple() method. Default is 0.</li>
		 * 	
		 * 	<li><b> onStart : Function</b>			A function that should be called when the timeline begins (the <code>currentProgress</code> won't necessarily
		 * 											be zero when onStart is called. For example, if the timeline is created and then its <code>currentProgress</code>
		 * 											property is immediately set to 0.5 or if its <code>currentTime</code> property is set to something other than zero,
		 * 											onStart will still get fired because it is the first time the timeline is getting rendered.)</li>
		 * 	
		 * 	<li><b> onStartParams : Array</b>		An Array of parameters to pass the onStart function.</li>
		 * 	
		 * 	<li><b> onStartScope: Object</b>		Defines the scope of the onStart function (what "this" refers to inside that function).</li>
		 * 	
		 * 	<li><b> onUpdate : Function</b>			A function that should be called every time the timeline's time/position is updated 
		 * 											(on every frame while the timeline is active)</li>
		 * 	
		 * 	<li><b> onUpdateParams : Array</b>		An Array of parameters to pass the onUpdate function</li>
		 * 	
		 * 	<li><b> onUpdateScope: Object</b>		Defines the scope of the onUpdate function (what "this" refers to inside that function).</li>
		 * 	
		 * 	<li><b> onComplete : Function</b>		A function that should be called when the timeline has finished </li>
		 * 	
		 * 	<li><b> onCompleteParams : Array</b>	An Array of parameters to pass the onComplete function</li>
		 * 	
		 * 	<li><b> onCompleteScope: Object</b>		Defines the scope of the onComplete function (what "this" refers to inside that function).</li>
		 * 	
		 * 	<li><b> onReverseComplete : Function</b> A function that should be called when the timeline has reached its starting point again after having been reversed </li>
		 * 	
		 * 	<li><b> onReverseCompleteParams : Array</b> An Array of parameters to pass the onReverseComplete functions</li>
		 * 	
		 * 	<li><b> onReverseCompleteScope: Object</b>	Defines the scope of the onReverseComplete function (what "this" refers to inside that function).</li>
		 *  
		 * 	<li><b> onRepeat : Function</b>			A function that should be called every time the timeline repeats </li>
		 * 	
		 * 	<li><b> onRepeatParams : Array</b>		An Array of parameters to pass the onRepeat function</li>
		 * 	
		 * 	<li><b> onRepeatScope: Object</b>		Defines the scope of the onRepeat function (what "this" refers to inside that function).</li>
		 * 	
		 * 	<li><b> autoRemoveChildren : Boolean</b> If autoRemoveChildren is set to true, as soon as child tweens/timelines complete,
		 * 											they will automatically get killed/removed. This is normally undesireable because
		 * 											it prevents going backwards in time (like if you want to reverse() or set the 
		 * 											<code>currentProgress</code> value to a lower value, etc.). It can, however, improve speed and memory
		 * 											management. TweenLite's root timelines use <code>autoRemoveChildren:true.</code></li>
		 * 
		 * 	<li><b> repeat : Number</b>				Number of times that the timeline should repeat. To repeat infinitely, use -1.</li>
		 * 	
		 * 	<li><b> repeatDelay : Number</b>		Amount of time in seconds (or frames for frames-based timelines) between repeats.</li>
		 * 	
		 * 	<li><b> yoyo : Boolean</b> 				Works in conjunction with the repeat property, determining the behavior of each 
		 * 											cycle. When yoyo is true, the timeline will go back and forth, appearing to reverse 
		 * 											every other cycle (this has no affect on the <code>reversed</code> property though). So if repeat is
		 * 											2 and yoyo is false, it will look like: start - 1 - 2 - 3 - 1 - 2 - 3 - 1 - 2 - 3 - end. But 
		 * 											if repeat is 2 and yoyo is true, it will look like: start - 1 - 2 - 3 - 3 - 2 - 1 - 1 - 2 - 3 - end. </li>
		 * 	</ul>
		 * 
		 * @param vars optionally pass in special properties like useFrames, onComplete, onCompleteParams, onUpdate, onUpdateParams, onStart, onStartParams, tweens, align, stagger, delay, autoRemoveChildren, onCompleteListener, onStartListener, onUpdateListener, repeat, repeatDelay, and/or yoyo.
		 */
		public function TimelineMax(vars:Object) {
			super(vars);
			_repeat = this.vars.repeat || 0;
			_repeatDelay = this.vars.repeatDelay || 0;
			_cyclesComplete = 0;
			this.yoyo = this.vars.yoyo || false;
			this.cacheIsDirty = true;
		}
		
		/**
		 * If you want a function to be called at a particular time or label, use addCallback.
		 * 
		 * @param function the function to be called
		 * @param timeOrLabel the time in seconds (or frames for frames-based timelines) or label at which the callback should be inserted. For example, myTimeline.addCallback(myFunction, 3) would call myFunction() 3-seconds into the timeline, and myTimeline.addCallback(myFunction, "myLabel") would call it at the "myLabel" label.
		 * @param params an Array of parameters to pass the callback
		 * @param scope the scope to use for the callback (what "this" will refer to inside the callback function)
		 * @return TweenLite instance
		 */
		public function addCallback(callback:Function, timeOrLabel:Object, params:Array, scope:Object):TweenLite {
			var cb:TweenLite = new TweenLite(callback, 0, {onComplete:callback, onCompleteParams:params, onCompleteScope:scope, overwrite:0, immediateRender:false});
			insert(cb, timeOrLabel);
			return cb;
		}
		
		/**
		 * Removes a callback from a particular time or label. If timeOrLabel is undefined, all callbacks of that
		 * particular function are removed from the timeline.
		 * 
		 * @param function callback function to be removed
		 * @param timeOrLabel the time in seconds (or frames for frames-based timelines) or label from which the callback should be removed. For example, myTimeline.removeCallback(myFunction, 3) would remove the callback from 3-seconds into the timeline, and myTimeline.removeCallback(myFunction, "myLabel") would remove it from the "myLabel" label, and myTimeline.removeCallback(myFunction, undefined) would remove ALL callbacks of that function regardless of where they are on the timeline.
		 * @return true if any callbacks were successfully found and removed. false otherwise.
		 */
		public function removeCallback(callback:Function, timeOrLabel:Object):Boolean {
			if (timeOrLabel == undefined) {
				return killTweensOf(callback, false);
			} else {
				if (typeof(timeOrLabel) == "string") {
					if (_labels[timeOrLabel] == undefined) {
						return false;
					}
					timeOrLabel = _labels[timeOrLabel];
				}
				var a:Array = getTweensOf(callback, false), success:Boolean;
				var i:Number = a.length;
				while (--i > -1) {
					if (a[i].cachedStartTime == timeOrLabel) {
						remove(a[i]);
						success = true;
					}
				}
				return success;
			}
		}
		
		/**
		 * Creates a linear tween that essentially scrubs the playhead to a particular time or label and then stops. For 
		 * example, to make the TimelineMax play to the "myLabel2" label, simply do: <br /><br /><code>
		 * 
		 * myTimeline.tweenTo("myLabel2"); <br /><br /></code>
		 * 
		 * If you want advanced control over the tween, like adding an onComplete or changing the ease or adding a delay, 
		 * just pass in a vars object with the appropriate properties. For example, to tween to the 5-second point on the 
		 * timeline and then call a function named <code>myFunction</code> and pass in a parameter that's references this 
		 * TimelineMax and use a Strong.easeOut ease, you'd do: <br /><br /><code>
		 * 
		 * myTimeline.tweenTo(5, {onComplete:myFunction, onCompleteParams:[myTimeline], ease:Strong.easeOut});<br /><br /></code>
		 * 
		 * Remember, this method simply creates a TweenLite instance that tweens the <code>currentTime</code> property of your timeline. 
		 * So you can store a reference to that tween if you want, and you can kill() it anytime. Also note that <code>tweenTo()</code>
		 * does <b>NOT</b> affect the timeline's <code>reversed</code> property. So if your timeline is oriented normally
		 * (not reversed) and you tween to a time/label that precedes the current time, it will appear to go backwards
		 * but the <code>reversed</code> property will <b>not</b> change to <code>true</code>. Also note that <code>tweenTo()</code>
		 * pauses the timeline immediately before tweening its <code>currentTime</code> property, and it stays paused after the tween completes.
		 * If you need to resume playback, you could always use an onComplete to call the <code>resume()</code> method.<br /><br />
		 * 
		 * If you plan to sequence multiple playhead tweens one-after-the-other, it is typically better to use 
		 * <code>tweenFromTo()</code> so that you can define the starting point and ending point, allowing the 
		 * duration to be accurately determined immediately. 
		 * 
		 * @see #tweenFromTo()
		 * @param timeOrLabel The destination time in seconds (or frame if the timeline is frames-based) or label to which the timeline should play. For example, myTimeline.tweenTo(5) would play from wherever the timeline is currently to the 5-second point whereas myTimeline.tweenTo("myLabel") would play to wherever "myLabel" is on the timeline.
		 * @param vars An optional vars object that will be passed to the TweenLite instance. This allows you to define an onComplete, ease, delay, or any other TweenLite special property. onInit is the only special property that is not available (tweenTo() sets it internally)
		 * @return TweenLite instance that handles tweening the timeline to the desired time/label.
		 */
		public function tweenTo(timeOrLabel:Object, vars:Object):TweenLite {
			var varsCopy:Object = {ease:easeNone, overwrite:2, useFrames:this.useFrames, immediateRender:false};
			for (var p:String in vars) {
				varsCopy[p] = vars[p];
			}
			varsCopy.onInit = onInitTweenTo;
			varsCopy.onInitParams = [null, this, NaN];
			varsCopy.currentTime = parseTimeOrLabel(timeOrLabel);
			var tl:TweenLite = new TweenLite(this, (Math.abs(Number(varsCopy.currentTime) - this.cachedTime) / this.cachedTimeScale) || 0.001, varsCopy);
			tl.vars.onInitParams[0] = tl;
			return tl;
		}
		
		/**
		 * Creates a linear tween that essentially scrubs the playhead from a particular time or label to another 
		 * time or label and then stops. If you plan to sequence multiple playhead tweens one-after-the-other, 
		 * <code>tweenFromTo()</code> is better to use than <code>tweenTo()</code> because it allows the duration 
		 * to be determined immediately, ensuring that subsequent tweens that are appended to a sequence are 
		 * positioned appropriately. For example, to make the TimelineMax play from the label "myLabel1" to the "myLabel2" 
		 * label, and then from "myLabel2" back to the beginning (a time of 0), simply do: <br /><br /><code>
		 * 
		 * var playheadTweens:TimelineMax = new TimelineMax(); <br />
		 * playheadTweens.append( myTimeline.tweenFromTo("myLabel1", "myLabel2") );<br />
		 * playheadTweens.append( myTimeline.tweenFromTo("myLabel2", 0); <br /><br /></code>
		 * 
		 * If you want advanced control over the tween, like adding an onComplete or changing the ease or adding a delay, 
		 * just pass in a vars object with the appropriate properties. For example, to tween from the start (0) to the 
		 * 5-second point on the timeline and then call a function named <code>myFunction</code> and pass in a parameter 
		 * that's references this TimelineMax and use a Strong.easeOut ease, you'd do: <br /><br /><code>
		 * 
		 * myTimeline.tweenFromTo(0, 5, {onComplete:myFunction, onCompleteParams:[myTimeline], ease:Strong.easeOut});<br /><br /></code>
		 * 
		 * Remember, this method simply creates a TweenLite instance that tweens the <code>currentTime</code> property of your timeline. 
		 * So you can store a reference to that tween if you want, and you can <code>kill()</code> it anytime. Also note that <code>tweenFromTo()</code>
		 * does <b>NOT</b> affect the timeline's <code>reversed</code> property. So if your timeline is oriented normally
		 * (not reversed) and you tween to a time/label that precedes the current time, it will appear to go backwards
		 * but the <code>reversed</code> property will <b>not</b> change to <code>true</code>. Also note that <code>tweenFromTo()</code>
		 * pauses the timeline immediately before tweening its <code>currentTime</code> property, and it stays paused after the tween completes.
		 * If you need to resume playback, you could always use an onComplete to call the <code>resume()</code> method.
		 * 
		 * @see #tweenTo()
		 * @param fromTimeOrLabel The beginning time in seconds (or frame if the timeline is frames-based) or label from which the timeline should play. For example, <code>myTimeline.tweenTo(0, 5)</code> would play from 0 (the beginning) to the 5-second point whereas <code>myTimeline.tweenFromTo("myLabel1", "myLabel2")</code> would play from "myLabel1" to "myLabel2".
		 * @param toTimeOrLabel The destination time in seconds (or frame if the timeline is frames-based) or label to which the timeline should play. For example, <code>myTimeline.tweenTo(0, 5)</code> would play from 0 (the beginning) to the 5-second point whereas <code>myTimeline.tweenFromTo("myLabel1", "myLabel2")</code> would play from "myLabel1" to "myLabel2".
		 * @param vars An optional vars object that will be passed to the TweenLite instance. This allows you to define an onComplete, ease, delay, or any other TweenLite special property. onInit is the only special property that is not available (<code>tweenFromTo()</code> sets it internally)
		 * @return TweenLite instance that handles tweening the timeline between the desired times/labels.
		 */
		public function tweenFromTo(fromTimeOrLabel:Object, toTimeOrLabel:Object, vars:Object):TweenLite {
			var tl:TweenLite = tweenTo(toTimeOrLabel, vars);
			tl.vars.onInitParams[2] = parseTimeOrLabel(fromTimeOrLabel);
			tl.duration = Math.abs(Number(tl.vars.currentTime) - tl.vars.onInitParams[2]) / this.cachedTimeScale;
			return tl;
		}
		
		/** @private **/
		private static function onInitTweenTo(tween:TweenLite, timeline:TimelineMax, fromTime:Number):Void {
			timeline.paused = true;
			if (!isNaN(fromTime)) {
				timeline.currentTime = fromTime;
			}
			if (tween.vars.currentTime != timeline.currentTime) { //don't make the duration zero - if it's supposed to be zero, don't worry because it's already initting the tween and will complete immediately, effectively making the duration zero anyway. If we make duration zero, the tween won't run at all.
				tween.duration = Math.abs(Number(tween.vars.currentTime) - timeline.currentTime) / timeline.cachedTimeScale;
			}
		}
		
		/** @private **/
		private static function easeNone(t:Number, b:Number, c:Number, d:Number):Number {
			return t / d;
		}	
		
		
		/** @inheritDoc **/
		public function renderTime(time:Number, suppressEvents:Boolean, force:Boolean):Void {
			if (this.gc) {
				this.setEnabled(true, false);
			} else if (!this.active && !this.cachedPaused) {
				this.active = true; 
			}
			var totalDur:Number = (this.cacheIsDirty) ? this.totalDuration : this.cachedTotalDuration, prevTime:Number = this.cachedTime, prevTotalTime:Number = this.cachedTotalTime, prevStart:Number = this.cachedStartTime, prevTimeScale:Number = this.cachedTimeScale, tween:TweenCore, isComplete:Boolean, rendered:Boolean, repeated:Boolean, next:TweenCore, dur:Number, prevPaused:Boolean = this.cachedPaused;
			if (time >= totalDur) {
				if (_rawPrevTime <= totalDur && _rawPrevTime != time) {
					this.cachedTotalTime = totalDur;
					if (!this.cachedReversed && this.yoyo && _repeat % 2 != 0) {
						this.cachedTime = 0;
						forceChildrenToBeginning(0, suppressEvents);
					} else {
						this.cachedTime = this.cachedDuration;
						forceChildrenToEnd(this.cachedDuration, suppressEvents);
					}
					isComplete = !this.hasPausedChild();
					rendered = true;
					if (this.cachedDuration == 0 && isComplete && (time == 0 || _rawPrevTime < 0)) { //In order to accommodate zero-duration timelines, we must discern the momentum/direction of time in order to render values properly when the "playhead" goes past 0 in the forward direction or lands directly on it, and also when it moves past it in the backward direction (from a postitive time to a negative time).
						force = true;
					}
				}
				
			} else if (time <= 0) {
				if (time < 0) {
					this.active = false;
					if (this.cachedDuration == 0 && _rawPrevTime >= 0) { //In order to accommodate zero-duration timelines, we must discern the momentum/direction of time in order to render values properly when the "playhead" goes past 0 in the forward direction or lands directly on it, and also when it moves past it in the backward direction (from a postitive time to a negative time).
						force = true;
						isComplete = true;
					}
				} else if (time == 0 && !this.initted) {
					force = true;
				}
				if (_rawPrevTime >= 0 && _rawPrevTime != time) {
					this.cachedTotalTime = 0;
					this.cachedTime = 0;
					forceChildrenToBeginning(0, suppressEvents);
					rendered = true;
					if (this.cachedReversed) {
						isComplete = true;
					}
				}
			} else {
				this.cachedTotalTime = this.cachedTime = time;
			}
			_rawPrevTime = time;
			
			if (_repeat != 0) {
				
				var prevCycles:Number = _cyclesComplete;
				var cycleDuration:Number = this.cachedDuration + _repeatDelay;
				_cyclesComplete = (this.cachedTotalTime / cycleDuration) >> 0;
				if (_cyclesComplete == this.cachedTotalTime / cycleDuration) {
					_cyclesComplete--; //otherwise when rendered exactly at the end time, it will act as though it is repeating (at the beginning)
				}
				if (prevCycles != _cyclesComplete) {
					repeated = true;
				}
				
				if (isComplete) {
					if (this.yoyo && _repeat % 2) {
						this.cachedTime = 0;
					}
				} else if (time > 0) {
					this.cachedTime = ((this.cachedTotalTime / cycleDuration) - _cyclesComplete) * cycleDuration; //originally this.cachedTotalTime % cycleDuration but floating point errors caused problems, so I normalized it. (4 % 0.8 should be 0 but Flash reports it as 0.79999999!)
					
					if (this.yoyo && _cyclesComplete % 2) {
						this.cachedTime = this.cachedDuration - this.cachedTime;
					} else if (this.cachedTime >= this.cachedDuration) {
						this.cachedTime = this.cachedDuration;
					}
					if (this.cachedTime < 0) {
						this.cachedTime = 0;
					}
				} else {
					_cyclesComplete = 0;
				}
				
				if (repeated && !isComplete && (this.cachedTime != prevTime || force)) {
					
					/*
					  make sure children at the end/beginning of the timeline are rendered properly. If, for example, 
					  a 3-second long timeline rendered at 2.9 seconds previously, and now renders at 3.2 seconds (which
					  would get transated to 2.8 seconds if the timeline yoyos or 0.2 seconds if it just repeats), there
					  could be a callback or a short tween that's at 2.95 or 3 seconds in which wouldn't render. So 
					  we need to push the timeline to the end (and/or beginning depending on its yoyo value).
					*/
					
					var forward:Boolean = Boolean(!this.yoyo || (_cyclesComplete % 2 == 0));
					var prevForward:Boolean = Boolean(!this.yoyo || (prevCycles % 2 == 0));
					var wrap:Boolean = Boolean(forward == prevForward);
					if (prevCycles > _cyclesComplete) {
						prevForward = !prevForward;
					}
					if (prevForward) {
						prevTime = forceChildrenToEnd(this.cachedDuration, suppressEvents);
						if (wrap) {
							prevTime = forceChildrenToBeginning(0, true);
						}
					} else {
						prevTime = forceChildrenToBeginning(0, suppressEvents);
						if (wrap) {
							prevTime = forceChildrenToEnd(this.cachedDuration, true);
						}
					}
					rendered = false;
				}
				
			}
			
			if (this.cachedTotalTime == prevTotalTime && force != true) {
				return;
			} else if (!this.initted) {
				this.initted = true;
			}
			if (prevTotalTime == 0 && this.vars.onStart && this.cachedTotalTime != 0 && !suppressEvents) {
				this.vars.onStart.apply(this.vars.onStartScope, this.vars.onStartParams);
			}
			
			if (rendered) {
				//already rendered, so ignore
			} else if (this.cachedTime - prevTime > 0) {
				tween = _firstChild;
				while (tween) {
					next = tween.nextNode; //record it here because the value could change after rendering...
					if (this.cachedPaused && !prevPaused) { //in case a tween pauses the timeline when rendering
						break;
					} else if (tween.active || (!tween.cachedPaused && tween.cachedStartTime <= this.cachedTime && !tween.gc)) {
						
						if (!tween.cachedReversed) {
							tween.renderTime((this.cachedTime - tween.cachedStartTime) * tween.cachedTimeScale, suppressEvents, false);
						} else {
							dur = (tween.cacheIsDirty) ? tween.totalDuration : tween.cachedTotalDuration;
							tween.renderTime(dur - ((this.cachedTime - tween.cachedStartTime) * tween.cachedTimeScale), suppressEvents, false);
						}
						
					}
					tween = next;
				}
			} else {
				tween = _lastChild;
				while (tween) {
					next = tween.prevNode; //record it here because the value could change after rendering...
					if (this.cachedPaused && !prevPaused) { //in case a tween pauses the timeline when rendering
						break;
					} else if (tween.active || (!tween.cachedPaused && tween.cachedStartTime <= prevTime && !tween.gc)) {
						
						if (!tween.cachedReversed) {
							tween.renderTime((this.cachedTime - tween.cachedStartTime) * tween.cachedTimeScale, suppressEvents, false);
						} else {
							dur = (tween.cacheIsDirty) ? tween.totalDuration : tween.cachedTotalDuration;
							tween.renderTime(dur - ((this.cachedTime - tween.cachedStartTime) * tween.cachedTimeScale), suppressEvents, false);
						}
						
					}
					tween = next;
				}
			}
			if (_hasUpdate && suppressEvents != true) {
				this.vars.onUpdate.apply(this.vars.onUpdateScope, this.vars.onUpdateParams);
			}
			if (repeated && suppressEvents != true) {
				if (this.vars.onRepeat) {
					this.vars.onRepeat.apply(this.vars.onRepeatScope, this.vars.onRepeatParams);
				}
			}
			if (isComplete && (prevStart == this.cachedStartTime || prevTimeScale != this.cachedTimeScale) && (totalDur >= this.totalDuration || this.cachedTime == 0)) { //if one of the tweens that was rendered altered this timeline's startTime (like if an onComplete reversed the timeline) or if it added more tweens to the timeline, we shouldn't run complete() because it probably isn't complete. If it is, don't worry, because whatever call altered the startTime would have called complete() if it was necessary at the new time. The only exception is the timeScale property.
				complete(true, suppressEvents);
			}
		}
		
		/**
		 * Returns the tweens/timelines that are currently active in the timeline.
		 * 
		 * @param nested determines whether or not tweens and/or timelines that are inside nested timelines should be returned. If you only want the "top level" tweens/timelines, set this to false.
		 * @param tweens determines whether or not tweens (TweenLite and TweenMax instances) should be included in the results
		 * @param timelines determines whether or not timelines (TimelineLite and TimelineMax instances) should be included in the results
		 * @return an Array of active tweens/timelines
		 */
		public function getActive(nested:Boolean, tweens:Boolean, timelines:Boolean):Array {
			if (nested == undefined) {
				nested = true;
			}
			if (tweens == undefined) {
				tweens = true;
			}
			if (timelines == undefined) {
				timelines = false;
			}
			var a:Array = [], all:Array = getChildren(nested, tweens, timelines), i:Number;
			var l:Number = all.length;
			for (i = 0; i < l; i++) {
				if (all[i].active) {
					a[a.length] = all[i];
				}
			}
			return a;
		}
		
		/**
		 * Returns the next label (if any) that occurs AFTER the time parameter. It makes no difference
		 * if the timeline is reversed. A label that is positioned exactly at the same time as the <code>time</code>
		 * parameter will be ignored. 
		 * 
		 * @param time Time after which the label is searched for. If you do not pass a time in, the currentTime will be used. 
		 * @return Name of the label that is after the time passed to getLabelAfter()
		 */
		public function getLabelAfter(time:Number):String {
			if (time == undefined) {
				time = this.cachedTime;
			}
			var labels:Array = getLabelsArray();
			var l:Number = labels.length;
			for (var i:Number = 0; i < l; i++) {
				if (labels[i].time > time) {
					return labels[i].name;
				}
			}
			return null;
		}
		
		/**
		 * Returns the previous label (if any) that occurs BEFORE the time parameter. It makes no difference
		 * if the timeline is reversed. A label that is positioned exactly at the same time as the <code>time</code>
		 * parameter will be ignored. 
		 * 
		 * @param time Time before which the label is searched for. If you do not pass a time in, the currentTime will be used. 
		 * @return Name of the label that is before the time passed to getLabelBefore()
		 */
		public function getLabelBefore(time:Number):String {
			if (time == undefined) {
				time = this.cachedTime;
			}
			var labels:Array = getLabelsArray();
			var i:Number = labels.length;
			while (--i > -1) {
				if (labels[i].time < time) {
					return labels[i].name;
				}
			}
			return null;
		}
		
		/** @private Returns an Array of label objects, each with a "time" and "name" property, in the order that they occur in the timeline. **/
		private function getLabelsArray():Array {
			var a:Array = [];
			for (var p:String in _labels) {
				a[a.length] = {time:_labels[p], name:p};
			}
			a.sortOn("time", Array.NUMERIC);
			return a;
		}
		
		
//---- GETTERS / SETTERS -------------------------------------------------------------------------------------------------------
		
		
		
		/** 
		 * Value between 0 and 1 indicating the progress of the timeline according to its totalDuration 
 		 * where 0 is at the beginning, 0.5 is halfway finished, and 1 is finished. <code>currentProgress</code>, 
 		 * by contrast, describes the progress according to the timeline's duration which does not
 		 * include repeats and repeatDelays. For example, if a TimelineMax instance is set 
 		 * to repeat once, at the end of the first cycle <code>totalProgress</code> would only be 0.5 
		 * whereas <code>currentProgress</code> would be 1. If you tracked both properties over the course of the 
		 * tween, you'd see <code>currentProgress</code> go from 0 to 1 twice (once for each cycle) in the same
		 * time it takes the <code>totalProgress</code> property to go from 0 to 1 once.
		 **/
		public function get totalProgress():Number {
			return this.cachedTotalTime / this.totalDuration;
		}
		
		public function set totalProgress(n:Number):Void {
			setTotalTime(this.totalDuration * n, false);
		}
		
		/**
		 * Duration of the timeline in seconds (or frames for frames-based timelines) including any repeats
		 * or repeatDelays. "duration", by contrast, does NOT include repeats and repeatDelays.
		 **/
		public function get totalDuration():Number {
			if (this.cacheIsDirty) {
				var temp:Number = super.totalDuration; //just forces refresh
				//Instead of Infinity, we use 999999999999 so that we can accommodate reverses.
				this.cachedTotalDuration = (_repeat == -1) ? 999999999999 : this.cachedDuration * (_repeat + 1) + (_repeatDelay * _repeat);
			}
			return this.cachedTotalDuration;
		}
		
		/** @inheritDoc **/
		public function get currentTime():Number {
			return this.cachedTime;
		}
		
		public function set currentTime(n:Number):Void {
			if (_cyclesComplete == 0) {
				setTotalTime(n, false);
			} else if (this.yoyo && (_cyclesComplete % 2 == 1)) {
				setTotalTime((this.duration - n) + (_cyclesComplete * (this.cachedDuration + _repeatDelay)), false);
			} else {
				setTotalTime(n + (_cyclesComplete * (this.duration + _repeatDelay)), false);
			}
		}
		
		/** Number of times that the timeline should repeat; -1 repeats indefinitely. **/
		public function get repeat():Number {
			return _repeat;
		}
		
		public function set repeat(n:Number):Void {
			_repeat = n;
			setDirtyCache(true);
		}
		
		/** Amount of time in seconds (or frames for frames-based timelines) between repeats **/
		public function get repeatDelay():Number {
			return _repeatDelay;
		}
		
		public function set repeatDelay(n:Number):Void {
			_repeatDelay = n;
			setDirtyCache(true);
		}
		
		/** The closest label that is at or before the current time. **/
		public function get currentLabel():String {
			return getLabelBefore(this.cachedTime + 0.00000001);
		}
	
}