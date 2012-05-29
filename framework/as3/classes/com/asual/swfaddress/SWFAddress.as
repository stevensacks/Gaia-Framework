/**
 * SWFAddress 2.4: Deep linking for Flash and Ajax <http://www.asual.com/swfaddress/>
 *
 * SWFAddress is (c) 2006-2009 Rostislav Hristov and contributors
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
 *
 */

/**
 * @author Rostislav Hristov <http://www.asual.com>
 * @author Mark Ross <http://www.therossman.org>
 * @author Piotr Zema <http://felixz.marknaegeli.com>
 */
package com.asual.swfaddress {

    import flash.errors.IllegalOperationError;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.TimerEvent;
    import flash.external.ExternalInterface;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import flash.system.Capabilities;
    import flash.utils.Timer;
    import com.asual.swfaddress.SWFAddressEvent;

    /**
     * Dispatched when <code>SWFAddress</code> initializes.
     */
    [Event(name='init', type='com.asual.swfaddress.SWFAddressEvent')]
    /**
     * Dispatched when any value change.
     */
    [Event(name='change', type='com.asual.swfaddress.SWFAddressEvent')]
    /**
     * Dispatched when value was changed by Flash.
     */
    [Event(name='internalChange', type='com.asual.swfaddress.SWFAddressEvent')]
    /**
     * Dispatched when value was changed by Browser.
     */
    [Event(name='externalChange', type='com.asual.swfaddress.SWFAddressEvent')]

    /**
     * SWFAddress class. 
     */ 
    public class SWFAddress {

        private static var _init:Boolean = false;
        private static var _initChange:Boolean = false;
        private static var _initChanged:Boolean = false;
        private static var _strict:Boolean = true;
        private static var _value:String = '';
        private static var _queue:Array = new Array();
        private static var _queueTimer:Timer = new Timer(10);
        private static var _initTimer:Timer = new Timer(10);
        private static var _availability:Boolean = ExternalInterface.available;
        private static var _dispatcher:EventDispatcher = new EventDispatcher();

        /**
         * Init event.
         */
        public static var onInit:Function;
        
        /**
         * Change event.
         */
        public static var onChange:Function;

        /**
         * @throws IllegalOperationError The class cannot be instantiated.
         */
        public function SWFAddress() {
            throw new IllegalOperationError('SWFAddress cannot be instantiated.');
        }
        
        private static function _initialize():Boolean {
            if (_availability) {
                try {
                    _availability = 
                        ExternalInterface.call('function() { return (typeof SWFAddress != "undefined"); }') 
                            as Boolean;
                    ExternalInterface.addCallback('getSWFAddressValue', 
                        function():String {return _value;});
                    ExternalInterface.addCallback('setSWFAddressValue',
                        _setValue);
                } catch (e:Error) {
                    _availability = false;
                }
            }
            _queueTimer.addEventListener(TimerEvent.TIMER, _callQueue);            
            _initTimer.addEventListener(TimerEvent.TIMER, _check);
            _initTimer.start();
            return true;
        }
        public static var _initializer:Boolean = _initialize();
        
        private static function _check(event:TimerEvent):void {
            if ((typeof SWFAddress['onInit'] == 'function' || _dispatcher.hasEventListener(SWFAddressEvent.INIT)) && !_init) {
                SWFAddress._setValueInit(_getValue());
                SWFAddress._init = true;
            }
            if (typeof SWFAddress['onChange'] == 'function' || _dispatcher.hasEventListener(SWFAddressEvent.CHANGE) || 
                typeof SWFAddress['onExternalChange'] == 'function' || _dispatcher.hasEventListener(SWFAddressEvent.EXTERNAL_CHANGE)) {
                _initTimer.stop();
                SWFAddress._init = true;
                SWFAddress._setValueInit(_getValue());
            }
        }
        
        private static function _strictCheck(value:String, force:Boolean):String {
            if (SWFAddress.getStrict()) {
                if (force) {
                    if (value.substr(0, 1) != '/') value = '/' + value;
                } else {
                    if (value == '') value = '/';
                }
            }
            return value;
        }
        
        private static function _getValue():String {
            var value:String, ids:String = null;
            if (_availability) { 
                value = ExternalInterface.call('SWFAddress.getValue') as String;
                var arr:Array = ExternalInterface.call('SWFAddress.getIds') as Array;
                if (arr != null)
                    ids = arr.toString(); 
            }
            if (ids == null || !_availability || _initChanged) {
                value = SWFAddress._value;
            } else if (value == 'undefined' || value == null) {
                value = '';
            }
            return _strictCheck(value || '', false);
        }

        private static function _setValueInit(value:String):void {
            SWFAddress._value = value;
            if (!_init) {
                _dispatchEvent(SWFAddressEvent.INIT);
            } else {
                _dispatchEvent(SWFAddressEvent.CHANGE);
                _dispatchEvent(SWFAddressEvent.EXTERNAL_CHANGE);
            }
            _initChange = true;
        }        

        private static function _setValue(value:String):void {        
            if (value == 'undefined' || value == null) value = '';
            if (SWFAddress._value == value && SWFAddress._init) return;
            if (!SWFAddress._initChange) return;
            SWFAddress._value = value;
            if (!_init) {
                SWFAddress._init = true;
                if (typeof SWFAddress['onInit'] == 'function' || _dispatcher.hasEventListener(SWFAddressEvent.INIT)) {
                    _dispatchEvent(SWFAddressEvent.INIT);
                }
            }
            _dispatchEvent(SWFAddressEvent.CHANGE);
            _dispatchEvent(SWFAddressEvent.EXTERNAL_CHANGE);
        }
        
        private static function _dispatchEvent(type:String):void {
            if (_dispatcher.hasEventListener(type)) {
                _dispatcher.dispatchEvent(new SWFAddressEvent(type));
            }
            type = type.substr(0, 1).toUpperCase() + type.substring(1);
            if (typeof SWFAddress['on' + type] == 'function') {
                SWFAddress['on' + type]();
            }
        }
        
        private static function _callQueue(event:TimerEvent):void {
            if (_queue.length != 0) {
                var script:String = '';
                for (var i:int = 0, obj:Object; obj = _queue[i]; i++) {
                    if (obj.param is String) obj.param = '"' + obj.param + '"';
                    script += obj.fn + '(' + obj.param + ');';
                }
                _queue = new Array();
                navigateToURL(new URLRequest('javascript:' + script + 'void(0);'), '_self');
            } else {
                _queueTimer.stop();
            }
        }
        
        private static function _call(fn:String, param:Object=''):void {
            if (_availability) {
                if (Capabilities.os.indexOf('Mac') != -1) {
                    if (_queue.length == 0) {
                        _queueTimer.start();
                    }
                    _queue.push({fn: fn, param: param});
                } else {
                    ExternalInterface.call(fn, param);
                }
            }
        }
        
        /**
         * Loads the previous URL in the history list.
         */
        public static function back():void {
            _call('SWFAddress.back');
        }

        /**
         * Loads the next URL in the history list.
         */
        public static function forward():void {
            _call('SWFAddress.forward');
        }

        /**
         * Navigates one level up in the deep linking path.
         */
        public static function up():void {
            var path:String = SWFAddress.getPath();
            SWFAddress.setValue(path.substr(0, path.lastIndexOf('/', path.length - 2) + (path.substr(path.length - 1) == '/' ? 1 : 0)));
        }
        
        /**
         * Loads a URL from the history list.
         * @param delta An integer representing a relative position in the history list.
         */
        public static function go(delta:int):void {
            _call('SWFAddress.go', delta);
        }
        
        /**
         * Opens a new URL in the browser. 
         * @param url The resource to be opened.
         * @param target Target window.
         */
        public static function href(url:String, target:String = '_self'):void {
            if (_availability && Capabilities.playerType == 'ActiveX') {
                ExternalInterface.call('SWFAddress.href', url, target);
                return;
            }
            navigateToURL(new URLRequest(url), target);
        }

        /**
         * Opens a browser popup window. 
         * @param url Resource location.
         * @param name Name of the popup window.
         * @param options Options which get evaluted and passed to the window.open() method.
         * @param handler Optional JavsScript handler code for popup handling.    
         */
        public static function popup(url:String, name:String='popup', options:String='""', handler:String=''):void {
            if (_availability && (Capabilities.playerType == 'ActiveX' || ExternalInterface.call('asual.util.Browser.isSafari'))) {
                ExternalInterface.call('SWFAddress.popup', url, name, options, handler);
                return;
            }
            navigateToURL(new URLRequest('javascript:popup=window.open("' + url + '","' + name + '",' + options + ');' 
                + handler + ';void(0);'), '_self');
        }
        
        /**
         * Registers an event listener object with an EventDispatcher object so that the listener receives notification of an event. 
         * You can register event listeners on all nodes in the display list for a specific type of event, phase, and priority.
         * @param type The type of event.
         * @param listener The listener function that processes the event. This function must accept an Event object as its only parameter and must return nothing.
         * @param useCapture Determines whether the listener works in the capture phase or the target and bubbling phases.
         * @param priority The priority level of the event listener.
         * @param useWeakReference Determines whether the reference to the listener is strong or weak.
         * @throws ArgumentError The listener specified is not a function. 
         */
        public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, 
            useWeakReference:Boolean = false):void {
            _dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }

        /**
         * Removes a listener from the EventDispatcher object. If there is no matching listener registered with the EventDispatcher object, a call to this method has no effect.
         * @param type The type of event. 
         * @param listener The listener object to remove.
         * @param useCapture Specifies whether the listener was registered for the capture phase or the target and bubbling phases. 
         * If the listener was registered for both the capture phase and the target and bubbling phases, two calls to removeEventListener() are required to remove both, 
         * one call with useCapture() set to true, and another call with useCapture() set to false. 
         */
        public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
            _dispatcher.removeEventListener(type, listener, useCapture);
        }

        /**
         * Dispatches an event to all the registered listeners. 
         * @param event Event object.
         * @return A value of <code>true</code> if a listener of the specified type is registered; <code>false</code> otherwise.
         * @throws Error The event dispatch recursion limit has been reached. 
         */
        public static function dispatchEvent(event:Event):Boolean {
            return _dispatcher.dispatchEvent(event);
        }

        /**
         * Checks whether the EventDispatcher object has any listeners registered for a specific type of event. This allows you to determine where an EventDispatcher object has 
         * altered handling of an event type in the event flow hierarchy.
         * @param event The type of event.  
         * @return A value of <code>true</code> if a listener of the specified type is registered; <code>false</code> otherwise. 
         */
        public static function hasEventListener(type:String):Boolean {
            return _dispatcher.hasEventListener(type);
        }

        /**
         * Provides the base address of the document. 
         */
        public static function getBaseURL():String {
            var url:String = null;
            if (_availability)
                url = String(ExternalInterface.call('SWFAddress.getBaseURL'));
            return (url == null || url == 'null' || !_availability) ? '' : url;
        }

        /**
         * Provides the state of the strict mode setting. 
         */
        public static function getStrict():Boolean {
            var strict:String = null;
            if (_availability)
                strict = ExternalInterface.call('SWFAddress.getStrict') as String;
            return (strict == null) ? _strict : (strict == 'true');
        }

        /**
         * Enables or disables the strict mode.
         * @param strict Strict mode state.
         */
        public static function setStrict(strict:Boolean):void {
            _call('SWFAddress.setStrict', strict);
            _strict = strict;
        }

        /**
         * Provides the state of the history setting. 
         */
        public static function getHistory():Boolean {
            return (_availability) ? 
                ExternalInterface.call('SWFAddress.getHistory') as Boolean : false;
        }

        /**
         * Enables or disables the creation of history entries.
         * @param history History state.
         */
        public static function setHistory(history:Boolean):void {
            _call('SWFAddress.setHistory', history);
        }

        /**
         * Provides the tracker function.
         */
        public static function getTracker():String {
            return (_availability) ? 
                ExternalInterface.call('SWFAddress.getTracker') as String : '';
        }

        /**
         * Sets a function for page view tracking. The default value is 'urchinTracker'.
         * @param tracker Tracker function.
         */
        public static function setTracker(tracker:String):void {
            _call('SWFAddress.setTracker', tracker);
        }

        /**
         * Provides the title of the HTML document.
         */
        public static function getTitle():String {
            var title:String = (_availability) ? 
                ExternalInterface.call('SWFAddress.getTitle') as String : '';
            if (title == 'undefined' || title == null) title = '';
            return decodeURI(title);
        }

        /**
         * Sets the title of the HTML document.
         * @param title Title value.
         */
        public static function setTitle(title:String):void {
            _call('SWFAddress.setTitle', encodeURI(decodeURI(title)));
        }

        /**
         * Provides the status of the browser window.
         */
        public static function getStatus():String {
            var status:String = (_availability) ? 
                ExternalInterface.call('SWFAddress.getStatus') as String : '';
            if (status == 'undefined' || status == null) status = '';
            return decodeURI(status);
        }

        /**
         * Sets the status of the browser window.
         * @param status Status value.
         */
        public static function setStatus(status:String):void {
            _call('SWFAddress.setStatus', encodeURI(decodeURI(status)));
        }

        /**
         * Resets the status of the browser window.
         */
        public static function resetStatus():void {
            _call('SWFAddress.resetStatus');
        }

        /**
         * Provides the current deep linking value.
         */
        public static function getValue():String {
            return decodeURI(_strictCheck(_value || '', false));
        }

        /**
         * Sets the current deep linking value.
         * @param value A value which will be appended to the base link of the HTML document.
         */
        public static function setValue(value:String):void {
            if (value == 'undefined' || value == null) value = '';
            value = encodeURI(decodeURI(_strictCheck(value, true)));
            if (SWFAddress._value == value) return;
            SWFAddress._value = value;
            _call('SWFAddress.setValue', value);
            if (SWFAddress._init) {
                _dispatchEvent(SWFAddressEvent.CHANGE);
                _dispatchEvent(SWFAddressEvent.INTERNAL_CHANGE);
            } else {
                _initChanged = true;
            }
        }

        /**
         * Provides the deep linking value without the query string.
         */
        public static function getPath():String {
            var value:String = SWFAddress.getValue();
            if (value.indexOf('?') != -1) {
                return value.split('?')[0];
            } else if (value.indexOf('#') != -1) {
                return value.split('#')[0];
            } else {
                return value;
            }
        }
        
        /**
         * Provides a list of all the folders in the deep linking path.
         */
        public static function getPathNames():Array {
            var path:String = SWFAddress.getPath();
            var names:Array = path.split('/');
            if (path.substr(0, 1) == '/' || path.length == 0)
                names.splice(0, 1);
            if (path.substr(path.length - 1, 1) == '/')
                names.splice(names.length - 1, 1);
            return names;
        }

        /**
         * Provides the query string part of the deep linking value.
         */
        public static function getQueryString():String {
            var value:String = SWFAddress.getValue();
            var index:Number = value.indexOf('?');
            if (index != -1 && index < value.length) {
                return value.substr(index + 1);
            }
            return null;
        }

        /**
         * Provides the value of a specific query parameter as a string or array of strings.
         * @param param Parameter name.
         */
        public static function getParameter(param:String):Object {
            var value:String = SWFAddress.getValue();
            var index:Number = value.indexOf('?');
            if (index != -1) {
                value = value.substr(index + 1);
                var params:Array = value.split('&');
                var p:Array;
                var i:Number = params.length;
                var r:Array = new Array();
                while(i--) {
                    p = params[i].split('=');
                    if (p[0] == param) {
                        r.push(p[1]);
                    }
                }
                if (r.length != 0) {
                    return r.length != 1 ? r : r[0];
                }
            }
            return null;
        }

        /**
         * Provides a list of all the query parameter names.
         */
        public static function getParameterNames():Array {
            var value:String = SWFAddress.getValue();
            var index:Number = value.indexOf('?');
            var names:Array = new Array();
            if (index != -1) {
                value = value.substr(index + 1);
                if (value != '' && value.indexOf('=') != -1) {
                    var params:Array = value.split('&');
                    var i:Number = 0;
                    while(i < params.length) {
                        names.push(params[i].split('=')[0]);
                        i++;
                    }
                }
            }
            return names;
        }
    }
}