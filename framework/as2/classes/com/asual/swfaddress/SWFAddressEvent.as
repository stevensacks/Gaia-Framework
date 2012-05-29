/**
 * SWFAddress 2.4: Deep linking for Flash and Ajax <http://www.asual.com/swfaddress/>
 *
 * SWFAddress is (c) 2006-2009 Rostislav Hristov and contributors
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
 *
 */

import com.asual.swfaddress.SWFAddress;

class com.asual.swfaddress.SWFAddressEvent {

    public static var INIT:String = 'init';
    public static var CHANGE:String = 'change';
    public static var INTERNAL_CHANGE:String = 'internalChange';
    public static var EXTERNAL_CHANGE:String = 'externalChange';
        
    private var _type:String;
    private var _value:String;
    private var _path:String;
    private var _pathNames:Array;
    private var _parameterNames:Array;
    private var _parameters:Object;
    
    public function SWFAddressEvent(type:String) {
        _type = type;
    }

    public function toString():String {
        return '[class SWFAddressEvent]';
    }
    
    public function get type():String {
        return _type;
    }

    public function get target():Object {
        return SWFAddress;
    }

    public function get value():String {
        if (typeof _value == 'undefined') {
            _value = SWFAddress.getValue();
        }
        return _value;
    }

    public function get path():String {
        if (typeof _path == 'undefined') {
            _path = SWFAddress.getPath();
        }
        return _path;
    }

    public function get pathNames():Array {
        if (typeof _pathNames == 'undefined') {
            _pathNames = SWFAddress.getPathNames();
        }
        return _pathNames;
    }

    public function get parameters():Object {
        if (typeof _parameters == 'undefined') {
            _parameters = new Array();
            for (var i:Number = 0; i < parameterNames.length; i++) {
                _parameters[parameterNames[i]] = SWFAddress.getParameter(parameterNames[i]);
            }
        }
        return _parameters;
    }

    public function get parameterNames():Array {
        if (typeof _parameterNames == 'undefined') {
            _parameterNames = SWFAddress.getParameterNames();
        }
        return _parameterNames;
    }    
}