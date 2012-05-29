/**
 * SWFAddress 2.4: Deep linking for Flash and Ajax <http://www.asual.com/swfaddress/>
 *
 * SWFAddress is (c) 2006-2009 Rostislav Hristov and contributors
 * This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>
 *
 */

import flash.external.ExternalInterface;
import mx.events.EventDispatcher;
import com.asual.swfaddress.SWFAddressEvent;

/**
 * @author Rostislav Hristov <http://www.asual.com>
 * @author Ma Bingyao <andot@ujn.edu.cn>
 */
class com.asual.swfaddress.SWFAddress {

    private static var _init:Boolean = false;
    private static var _initChange:Boolean = false;
    private static var _initChanged:Boolean = false;
    private static var _strict:Boolean = true;
    private static var _value:String = '';
    private static var _queue:Array = new Array();
    private static var _queueInterval:Number;
    private static var _initInterval:Number;
    private static var _availability:Boolean = ExternalInterface.available;
    private static var _dispatcher:EventDispatcher = new EventDispatcher();
    private static var _initializer:Boolean = _initialize();

    public static var onInit:Function;
    public static var onChange:Function;
    public static var onInternalChange:Function;
    public static var onExternalChange:Function;

    private function SWFAddress() {}

    private static function _initialize():Boolean {
        if (_availability) {
            try {
                _availability = 
                    Boolean(ExternalInterface.call('function() { return (typeof SWFAddress != "undefined"); }')); 
                ExternalInterface.addCallback('getSWFAddressValue', SWFAddress, 
                    function():String {return this._value});
                ExternalInterface.addCallback('setSWFAddressValue', SWFAddress, 
                    SWFAddress._setValue);
            } catch (e:Error) {
                _availability = false;
            }
        }
        if (typeof _level0.$swfaddress != 'undefined') {
            SWFAddress._value = _level0.$swfaddress;
            _availability = true;
        }
        _initInterval = setInterval(SWFAddress._check, 10);
        return true;
    }
    
    private static function _check():Void {
        if ((typeof SWFAddress.onInit == 'function' || typeof _dispatcher['__q_init'] != 'undefined') && !_init) {
            SWFAddress._setValueInit(_getValue());    
            SWFAddress._init = true;        
        }
        if (typeof SWFAddress.onChange == 'function' || typeof _dispatcher['__q_change'] != 'undefined' || 
            typeof SWFAddress.onExternalChange == 'function' || typeof _dispatcher['__q_externalChange'] != 'undefined') {
            clearInterval(_initInterval);
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
        var value:String, ids:String = 'null';
        if (_availability) {
            value = String(ExternalInterface.call('SWFAddress.getValue'));
            ids = String(ExternalInterface.call('SWFAddress.getIds'));
        }
        if (ids == 'undefined' || ids == 'null' || !_availability || _initChanged) {
            value = SWFAddress._value;
        } else if (value == 'undefined' || value == 'null') {
            value = '';
        }
        return _strictCheck(value || '', false);
    }

    private static function _setValueInit(value:String):Void {
        SWFAddress._value = value;
        if (!_init) {
            _dispatchEvent(SWFAddressEvent.INIT);
        } else {
            _dispatchEvent(SWFAddressEvent.CHANGE);
            _dispatchEvent(SWFAddressEvent.EXTERNAL_CHANGE);
        }
        _initChange = true;
    }

    private static function _setValue(value:String):Void {
        if (value == 'undefined' || value == 'null') value = '';
        if (SWFAddress._value == value && SWFAddress._init) return;
        if (!SWFAddress._initChange) return;
        SWFAddress._value = value;
        if (!_init) {
            SWFAddress._init = true;        
            if (typeof SWFAddress.onInit == 'function' || typeof _dispatcher['__q_init'] != 'undefined') {
                _dispatchEvent(SWFAddressEvent.INIT);
            }
        }
        _dispatchEvent(SWFAddressEvent.CHANGE);
        _dispatchEvent(SWFAddressEvent.EXTERNAL_CHANGE);
    }
    
    private static function _dispatchEvent(type:String):Void {    
        if (typeof _dispatcher['__q_' + type] != 'undefined') {
            _dispatcher.dispatchEvent(new SWFAddressEvent(type));
        }
        type = type.substr(0, 1).toUpperCase() + type.substring(1);
        if (typeof SWFAddress['on' + type] == 'function') {
            SWFAddress['on' + type]();
        }
    }
    
    private static function _callQueue():Void {
        if (_queue.length != 0) {
            var script:String = '';
            for (var i:Number = 0, obj:Object; obj = _queue[i]; i++) {
                if (typeof obj.param == 'string') obj.param = '"' + obj.param + '"';
                script += obj.fn + '(' + obj.param + ');';
            }
            _queue = new Array();
            getURL('javascript:' + script + 'void(0);');
        } else {
            clearInterval(_queueInterval);
        }
    }
    
    private static function _call(fn:String, param:Object):Void {
        if (typeof param == 'undefined') param = '';
        if (_availability) {
            if (System.capabilities.os.indexOf('Mac') != -1) {
                if (_queue.length == 0) {
                    _queueInterval = setInterval(SWFAddress._callQueue, 10);                
                }
                _queue.push({fn: fn, param: param});
            } else {
                ExternalInterface.call(fn, param);
            }
        }
    }
    
    public static function toString():String {
        return '[class SWFAddress]';
    }
    
    /**
     * Ported from iecompat.js <http://www.coolcode.cn/?action=show&id=126>
     */
    public static function encodeURI(str:String):String {

        var l:Array = ['%00', '%01', '%02', '%03', '%04', '%05', '%06', '%07', '%08', 
                        '%09', '%0A', '%0B', '%0C', '%0D', '%0E', '%0F', '%10', 
                        '%11', '%12', '%13', '%14', '%15', '%16', '%17', '%18', 
                        '%19', '%1A', '%1B', '%1C', '%1D', '%1E', '%1F', '%20', 
                        '!', '%22', '#', '$', '%25', '&', '\'', '(', ')', '*', 
                        '+', ',', '-', '.', '/', '0', '1', '2', '3', '4', '5', 
                        '6', '7', '8', '9', ':', ';', '%3C', '=', '%3E', '?',
                        '@', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 
                        'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 
                        'V', 'W', 'X', 'Y', 'Z', '%5B', '%5C', '%5D', '%5E', '_', 
                        '%60', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 
                        'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',  'u', 
                        'v', 'w', 'x', 'y', 'z', '%7B', '%7C', '%7D', '~', '%7F'];
                        
        var out:Array = [], i:Number, j:Number, len:Number = str.length, c:Number, c2:Number;
    
        for (i = 0, j = 0; i < len; i++) {
            c = str.charCodeAt(i);
            if (c <= 0x007F) {
                    out[j++] = l[c];
                    continue;
            } else if (c <= 0x7FF) {
                    out[j++] = '%' + (0xC0 | ((c >>  6) & 0x1F)).toString(16).toUpperCase();
                    out[j++] = '%' + (0x80 |         (c & 0x3F)).toString(16).toUpperCase();
                    continue;
            } else if (c < 0xD800 || c > 0xDFFF) {
                    out[j++] = '%' + (0xE0 | ((c >> 12) & 0x0F)).toString(16).toUpperCase();
                    out[j++] = '%' + (0x80 | ((c >>  6) & 0x3F)).toString(16).toUpperCase();
                    out[j++] = '%' + (0x80 |         (c & 0x3F)).toString(16).toUpperCase();
                    continue;
            } else {
                if (++i < len) {
                    c2 = str.charCodeAt(i);
                    if (c <= 0xDBFF && 0xDC00 <= c2 && c2 <= 0xDFFF) {
                        c = ((c & 0x03FF) << 10 | (c2 & 0x03FF)) + 0x010000;
                        if (0x010000 <= c && c <= 0x10FFFF) {
                                out[j++] = '%' + (0xF0 | ((c >>> 18) & 0x3F)).toString(16).toUpperCase();
                                out[j++] = '%' + (0x80 | ((c >>> 12) & 0x3F)).toString(16).toUpperCase();
                                out[j++] = '%' + (0x80 | ((c >>>  6) & 0x3F)).toString(16).toUpperCase();
                                out[j++] = '%' + (0x80 |          (c & 0x3F)).toString(16).toUpperCase();
                                continue;
                        }
                    }
                }
            }
            return null;
        }
        return out.join('');
    }
    
    /**
     * Ported from iecompat.js <http://www.coolcode.cn/?action=show&id=126>
     */
    public static function decodeURI(str:String):String {
    
        var out:Array = [], i:Number = 0, j:Number = 0, len:Number = str.length;
        var c:Number, c2:Number, c3:Number, c4:Number, s:Number;

        var checkcode:Function = function (strcc:String, i2:Number, i1:Number):Number {
            var d1 = strcc.charAt(i1),
                d2 = strcc.charAt(i2);
            if (isNaN(parseInt(d1, 16)) || isNaN(parseInt(d2, 16))) {
                return null;
            }
            return parseInt(d1 + d2, 16);
        }
        
        var checkutf8:Function = function (strcu:String, i3:Number, i2:Number, i1:Number):Number {
            var ccu = strcu.charCodeAt(i1);
            if (ccu == 37) {
                if ((ccu = checkcode(strcu, i3, i2)) == null) return null;
            }
            if ((ccu >> 6) != 2) {
                return null;
            }
            return ccu;
        }
    
        while(i < len) {
            c = str.charCodeAt(i++);
            if (c == 37) {
                if ((c = checkcode(str, i++, i++)) == null) return null;
            } else {
                out[j++] = String.fromCharCode(c);
                continue;
            }
            switch(c) {
                case 35: case 36: case 38: case 43: case 44: case 47:
                case 58: case 59: case 61: case 63: case 64: {
                    if (str.charCodeAt(i - 3) == 37) {
                        out[j++] = str.substr(i - 3, 3);
                    } else {
                        out[j++] = str.substr(i - 1, 1);
                    }
                    break;
                }
                default: {
                    switch (c >> 4) { 
                        case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: {
                            // 0xxxxxxx
                            out[j++] = String.fromCharCode(c);
                            break;
                        }
                        case 12: case 13: {
                            // 110x xxxx    10xx xxxx
                            if ((c2 = checkutf8(str, i++, i++, i++)) == null) return null;
                            out[j++] = String.fromCharCode(((c & 0x1F) << 6) | (c2 & 0x3F));
                            break;
                        }
                        case 14: {
                            // 1110 xxxx  10xx xxxx  10xx xxxx
                            if ((c2 = checkutf8(str, i++, i++, i++)) == null) return null;
                            if ((c3 = checkutf8(str, i++, i++, i++)) == null) return null;
                            out[j++] = String.fromCharCode(((c & 0x0F) << 12) |
                                ((c2 & 0x3F) << 6) | ((c3 & 0x3F) << 0));
                            break;
                        }
                        default: {
                            switch (c & 0xf) {
                                case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7: {
                                    // 1111 0xxx  10xx xxxx  10xx xxxx  10xx xxxx
                                    if ((c2 = checkutf8(str, i++, i++, i++)) == null) return null;
                                    if ((c3 = checkutf8(str, i++, i++, i++)) == null) return null;
                                    if ((c4 = checkutf8(str, i++, i++, i++)) == null) return null;
                                    s = ((c  & 0x07) << 18) |
                                        ((c2 & 0x3f) << 12) |
                                        ((c3 & 0x3f) <<  6) |
                                        (c4 & 0x3f) - 0x10000;
                                    if (0 <= s && s <= 0xfffff) {
                                        out[j++] = String.fromCharCode(((s >>> 10) & 0x03ff) | 0xd800, (s & 0x03ff) | 0xdc00);
                                    } else {
                                        return null;
                                    }
                                    break;
                                }
                                default: {
                                    return null;
                                }
                            }
                        }
                    }
                }
            }
        }
        return out.join('');
    }
    
    public static function back():Void {
        _call('SWFAddress.back');
    }

    public static function forward():Void {
        _call('SWFAddress.forward');
    }

    public static function up():Void {
        var path:String = SWFAddress.getPath();
        SWFAddress.setValue(path.substr(0, path.lastIndexOf('/', path.length - 2) + (path.substr(path.length - 1) == '/' ? 1 : 0)));
    }
        
    public static function go(delta:Number):Void {
        _call('SWFAddress.go', delta);
    }
    
    public static function href(url:String, target:String):Void {
        target = (typeof target != 'undefined') ? target : '_self';
        if (_availability && System.capabilities.playerType == 'ActiveX') {
            ExternalInterface.call('SWFAddress.href', url, target);
            return;
        }
        getURL(url, target);
    }

    public static function popup(url:String, name:String, options:String, handler:String):Void {
        name = (typeof name != 'undefined') ? name : 'popup';
        options = (typeof options != 'undefined') ? options : '""';
        handler = (typeof handler != 'undefined') ? handler : '';
        if (_availability && System.capabilities.playerType == 'ActiveX') {
            ExternalInterface.call('SWFAddress.popup', url, name, options, handler);
            return;
        }
        getURL('javascript:popup=window.open("' + url + '","' + name + '",' + options + ');' + handler + ';void(0);');
    }

    public static function addEventListener(type:String, listener:Function):Void {
        _dispatcher.addEventListener(type, listener);
    }

    public static function removeEventListener(type:String, listener:Function):Void {
        _dispatcher.removeEventListener(type, listener);
    }

    public static function dispatchEvent(event:Object):Void {
        _dispatcher.dispatchEvent(event);
    }
    
    public static function hasEventListener(type:String):Boolean {
        return (typeof _dispatcher['__q_' + type] != 'undefined');
    }

    public static function getBaseURL():String {
        var url:String = 'null';
        if (_availability)
            url = String(ExternalInterface.call('SWFAddress.getBaseURL'));
        return (url == 'undefined' || url == 'null' || !_availability) ? '' : url;
    }

    public static function getStrict():Boolean {
        var strict:String = 'null';
        if (_availability)
            strict = String(ExternalInterface.call('SWFAddress.getStrict'));
        return (strict == 'null' || strict == 'undefined') ? _strict : (strict == 'true');
    }

    public static function setStrict(strict:Boolean):Void {
        _call('SWFAddress.setStrict', strict);
        _strict = strict;
    }

    public static function getHistory():Boolean {
        return Boolean((_availability) ? 
            ExternalInterface.call('SWFAddress.getHistory') : false);
    }

    public static function setHistory(history:Boolean):Void {
        _call('SWFAddress.setHistory', history);
    }

    public static function getTracker():String {
        return (_availability) ? 
            String(ExternalInterface.call('SWFAddress.getTracker')) : '';
    }

    public static function setTracker(tracker:String):Void {
        _call('SWFAddress.setTracker', tracker);
    }

    public static function getTitle():String {
        var title:String = (_availability) ? 
            String(ExternalInterface.call('SWFAddress.getTitle')) : '';
        if (title == 'undefined' || title == 'null') title = '';
        return decodeURI(title);
    }

    public static function setTitle(title:String):Void {
        _call('SWFAddress.setTitle', encodeURI(decodeURI(title)));
    }
    
    public static function getStatus():String {
        var status:String = (_availability) ? 
            String(ExternalInterface.call('SWFAddress.getStatus')) : '';
        if (status == 'undefined' || status == 'null') status = '';
        return decodeURI(status);
    }

    public static function setStatus(status:String):Void {
        _call('SWFAddress.setStatus', encodeURI(decodeURI(status)));
    }
    
    public static function resetStatus():Void {
        _call('SWFAddress.resetStatus');
    }

    public static function getValue():String {
        return decodeURI(_strictCheck(_value || '', false));
    }

    public static function setValue(value:String):Void {
        if (value == 'undefined' || value == 'null') value = '';
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
    
    public static function getPathNames():Array {
        var path:String = SWFAddress.getPath();
        var names:Array = path.split('/');
        if (path.substr(0, 1) == '/' || path.length == 0)
            names.splice(0, 1);
        if (path.substr(path.length - 1, 1) == '/')
            names.splice(names.length - 1, 1);
        return names;
    }
        
    public static function getQueryString():String {
        var value:String = SWFAddress.getValue();
        var index:Number = value.indexOf('?');
        if (index != -1 && index < value.length) {
            return value.substr(index + 1);
        }
    }

    public static function getParameter(param:String):String {
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
    }

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