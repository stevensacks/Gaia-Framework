/**
 * SWFAddress 2.4: Deep linking for Flash and Ajax <http://www.asual.com/swfaddress/>
 *
 * SWFAddress is (c) 2006-2009 Rostislav Hristov and contributors
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
 *
 */
 
/**
 * @author Rostislav Hristov <http://www.asual.com>
 * @author Matthew J Tretter <http://www.exanimo.com>
 * @author Piotr Zema <http://felixz.marknaegeli.com>
 */
package com.asual.swfaddress {

    import flash.events.Event;
    import com.asual.swfaddress.SWFAddress;
    
    /**
     * Event class for SWFAddress.
     */
    public class SWFAddressEvent extends Event {
        
        /**
         * Defines the <code>value</code> of the type property of a <code>init</code> event object.
         */
        public static const INIT:String = 'init';

        /**
         * Defines the <code>value</code> of the type property of a <code>change</code> event object.
         */
        public static const CHANGE:String = 'change';

        /**
         * Defines the <code>value</code> of the type property of a <code>internalChange</code> event object.
         */
        public static const INTERNAL_CHANGE:String = 'internalChange';

        /**
         * Defines the <code>value</code> of the type property of a <code>externalChange</code> event object.
         */
        public static const EXTERNAL_CHANGE:String = 'externalChange';
        
        private var _value:String;
        private var _path:String;
        private var _pathNames:Array;
        private var _parameterNames:Array;
        private var _parameters:Object;
        
        /**
         * Creates a new SWFAddress event.
         * @param type Type of the event.
         */
        public function SWFAddressEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
            super(type, bubbles, cancelable);
        }

        /**
         * The current target of this event.
         */
        public override function get currentTarget():Object {
            return SWFAddress;
        }

        /**
         * The type of this event.
         */
        public override function get type():String {
            return super.type;
        }

        /**
         * The target of this event.
         */
        public override function get target():Object {
            return SWFAddress;
        }

        /**
         * The value of this event.
         */
        public function get value():String {
            if (_value == null) {
                _value = SWFAddress.getValue();
            }
            return _value;
        }

        /**
         * The path of this event.
         */
        public function get path():String {
            if (_path == null) {
                _path = SWFAddress.getPath();
            }
            return _path;
        }
        
        /**
         * The folders in the deep linking path of this event.
         */         
        public function get pathNames():Array {
            if (_pathNames == null) {
                _pathNames = SWFAddress.getPathNames();
            }
            return _pathNames;
        }
        
        /**
         * The parameters of this event.
         */
        public function get parameters():Object {
            if (_parameters == null) {
                _parameters = new Object();
                for (var i:int = 0; i < parameterNames.length; i++) {
                    _parameters[parameterNames[i]] = SWFAddress.getParameter(parameterNames[i]);
                }
            }
            return _parameters;
        }
        
        /**
         * The parameters names of this event.
         */    
        public function get parameterNames():Array {
            if (_parameterNames == null) {
                _parameterNames = SWFAddress.getParameterNames();            
            }
            return _parameterNames;
        }
    
        /**
         * Creates a copy of the <code>SWFAddressEvent</code> object and sets the value of each parameter to match the original.
         */
        public override function clone():Event {
            return new SWFAddressEvent(type, bubbles, cancelable);
        }
    
        /**
         * Returns a string that contains all the properties of the SWFAddressEvent object.
         * The string has the following format:
         * 
         * <p>[<code>SWFAddressEvent type=<em>value</em> bubbles=<em>value</em>
         * cancelable=<em>value</em> eventPhase= value=<em>value</em> path=<em>value</em>
         * paths=<em>value</em> parameters=<em>value</em></code>]</p>
         * 
         * @return A string representation of the <code>SWFAddressEvent</code> object.
         */
        public override function toString():String {
            return formatToString('SWFAddressEvent', 'type', 'bubbles', 'cancelable', 
                'eventPhase', 'value', 'path', 'pathNames', 'parameterNames', 'parameters');
        }
    }
}