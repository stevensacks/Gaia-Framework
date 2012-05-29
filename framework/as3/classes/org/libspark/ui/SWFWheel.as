/**
 * SWFWheel - remove dependencies of mouse wheel on each browser.
 *
 * Copyright (c) 2008 - 2009 Spark project (www.libspark.org)
 *
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 */
package org.libspark.ui
{
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;

	/**
     *
     */
    public class SWFWheel
    {
        public static const VERSION:String = '1.2 alpha';
        public static const EXECUTE_LIBRARY_FUNCTION:String = "SWFWheel.join";
        public static const CHECK_FORCE_EXTERNAL_FUNCTION:String = "SWFWheel.force";
        public static const DEFINE_LIBRARY_FUNCTION:String = "function(){if(window.SWFWheel)return;var win=window,doc=document,nav=navigator;var SWFWheel=window.SWFWheel=function(id){this.setUp(id);if(SWFWheel.browser.msie)this.bind4msie();else this.bind();};SWFWheel.prototype={setUp:function(id){var el=SWFWheel.retrieveObject(id);if(el.nodeName.toLowerCase()=='embed'||SWFWheel.browser.safari)el=el.parentNode;this.target=el;this.eventType=SWFWheel.browser.mozilla?'DOMMouseScroll':'mousewheel';},bind:function(){this.target.addEventListener(this.eventType,function(evt){var target,name,delta=0;if(/XPCNativeWrapper/.test(evt.toString())){var k=evt.target.getAttribute('id')||evt.target.getAttribute('name');if(!k)return;target=SWFWheel.retrieveObject(k);}else{target=evt.target;}name=target.nodeName.toLowerCase();if(name!='object'&&name!='embed')return;if(!target.checkBrowserScroll()){evt.preventDefault();evt.returnValue=false;}if(!target.triggerMouseEvent)return;switch(true){case SWFWheel.browser.mozilla:delta=-evt.detail;break;case SWFWheel.browser.opera:delta=evt.wheelDelta/40;break;default:delta=evt.wheelDelta/80;break;}target.triggerMouseEvent(delta);},false);},bind4msie:function(){var _wheel,_unload,target=this.target;_wheel=function(){var evt=win.event,delta=0,name=evt.srcElement.nodeName.toLowerCase();if(name!='object'&&name!='embed')return;if(!target.checkBrowserScroll())evt.returnValue=false;if(!target.triggerMouseEvent)return;delta=evt.wheelDelta/40;target.triggerMouseEvent(delta);};_unload=function(){target.detachEvent('onmousewheel',_wheel);win.detachEvent('onunload',_unload);};target.attachEvent('onmousewheel',_wheel);win.attachEvent('onunload',_unload);}};SWFWheel.browser=(function(ua){return{version:(ua.match(/.+(?:rv|it|ra|ie)[\/:\\s]([\\d.]+)/)||[0,'0'])[1],chrome:/chrome/.test(ua),stainless:/stainless/.test(ua),safari:/webkit/.test(ua)&&!/(chrome|stainless)/.test(ua),opera:/opera/.test(ua),msie:/msie/.test(ua)&&!/opera/.test(ua),mozilla:/mozilla/.test(ua)&&!/(compatible|webkit)/.test(ua)}})(nav.userAgent.toLowerCase());SWFWheel.join=function(id){var t=setInterval(function(){if(SWFWheel.retrieveObject(id)){clearInterval(t);new SWFWheel(id);}},0);};SWFWheel.force=function(id){if(SWFWheel.browser.safari||SWFWheel.browser.stainless)return true;var el=SWFWheel.retrieveObject(id),name=el.nodeName.toLowerCase();if(name=='object'){var k,v,param,params=el.getElementsByTagName('param'),len=params.length;for(var i=0;i<len;i++){param=params[i];if(param.parentNode!=el)continue;k=param.getAttribute('name');v=param.getAttribute('value')||'';if(/wmode/i.test(k)&&/(opaque|transparent)/i.test(v))return true;}}else if(name=='embed'){return/(opaque|transparent)/i.test(el.getAttribute('wmode'));}return false;};SWFWheel.retrieveObject=function(id){var el=doc.getElementById(id);if(!el){var nodes=doc.getElementsByTagName('embed'),len=nodes.length;for(var i=0;i<len;i++){if(nodes[i].getAttribute('name')==id){el=nodes[i];break;}}}return el;};}";

        private static var _stage:Stage;
        private static var _item:InteractiveObject;
        private static var _event:MouseEvent;
        private static var _browserScroll:Boolean = false;

        /**
         *  initialize the SWFWheel hack.
         *
         *  @param stage                Stage object.
         */
        public static function initialize(stage:Stage):void
        {
            if (!available || isReady) return;

            _stage = stage;

            // define javascript library.
            ExternalInterface.call(DEFINE_LIBRARY_FUNCTION);
            // start light hack.
            ExternalInterface.call(EXECUTE_LIBRARY_FUNCTION, ExternalInterface.objectID);
            ExternalInterface.addCallback('checkBrowserScroll', checkBrowserScroll);

            // check the environment.
            var mac:Boolean = Boolean(Capabilities.os.toLowerCase().indexOf("mac") !== -1);
            var force:Boolean = Boolean(ExternalInterface.call(CHECK_FORCE_EXTERNAL_FUNCTION, ExternalInterface.objectID));

            // ignore no mac, no safari.
            if(!mac && !force) return;

            //  start deep hack.
            _stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoved);
            ExternalInterface.addCallback('triggerMouseEvent', triggerMouseEvent);
        }

        /**
         *
         *  @return bool        if already initialized, this property is true. otherwize it is false.
         */
        public static function get isReady():Boolean
        {
            return _stage != null;
        }

        /**
         *
         *  @return bool        if SWFWheel is available, this property is true. otherwite it is false.
         */
        public static function get available():Boolean
        {
            var f:Boolean = false;

            if (!ExternalInterface.available) return f;

            try
            {
                f = Boolean(ExternalInterface.call("function(){return true;}"));
            }
            catch (e:Error)
            {
                //  FIXME: should show full stack trace?
                //trace(e.getStackTrace());
                trace("Warning: turn off SWFWheel because can't access external interface.");
            }
            return f;
        }

        /**
         *
         *  @return bool        if be allowed browser scrolling, this property is true, otherwise it is false.
         */
        public static function get browserScroll():Boolean
        {
            return _browserScroll;
        }

        /**
         *
         *  @param value            specified broswer scrolling.
         */
        public static function set browserScroll(value:Boolean):void
        {
            _browserScroll = value;
        }

        /**
         *  will execute when mouse moved.
         *
         *  @param  event           MouseEvent object.
         */
        private static function mouseMoved(event:MouseEvent):void
        {
            _item = InteractiveObject(event.target);
            _event = MouseEvent(event);
        }

        /**
         *  will execute when dispatch `mouse wheel` event on swf content layer.
         *
         *  @param  delta           mouse wheel delta.
         */
        private static function triggerMouseEvent(delta:Number):void
        {
            //  FIXME: should create dummy parameters?
            if (_event == null || _item == null) return;

            var event:MouseEvent = new MouseEvent(
                    MouseEvent.MOUSE_WHEEL,
                    true,
                    false,
                    _event.localX,
                    _event.localY,
                    _event.relatedObject,
                    _event.ctrlKey,
                    _event.altKey,
                    _event.shiftKey,
                    _event.buttonDown,
                    int(delta)
                );
            _item.dispatchEvent(event);
        }

        /**
         *  will execute when dispatch `mouse wheel` event on swf content layer.
         *
         *  @return bool
         */
        private static function checkBrowserScroll():Boolean
        {
            return _browserScroll;
        }
    }
}
