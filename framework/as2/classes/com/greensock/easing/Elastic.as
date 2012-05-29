class com.greensock.easing.Elastic {
	private static var _2PI:Number = Math.PI * 2;
	
	public static function easeIn (t:Number, b:Number, c:Number, d:Number, a:Number, p:Number):Number {
		if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
		var s:Number;
		if (!a || (c > 0 && a < c) || (c < 0 && a < -c)) { a=c; s=p/4; }
		else s = p/_2PI * Math.asin (c/a);
		return -(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*_2PI/p )) + b;
	}
	public static function easeOut (t:Number, b:Number, c:Number, d:Number, a:Number, p:Number):Number {
		if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
		var s:Number;
		if (!a || (c > 0 && a < c) || (c < 0 && a < -c)) { a=c; s=p/4; }
		else s = p/_2PI * Math.asin (c/a);
		return (a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*_2PI/p ) + c + b);
	}
	public static function easeInOut (t:Number, b:Number, c:Number, d:Number, a:Number, p:Number):Number {
		if (t==0) return b;  if ((t/=d/2)==2) return b+c;  if (!p) p=d*(.3*1.5);
		var s:Number;
		if (!a || (c > 0 && a < c) || (c < 0 && a < -c)) { a=c; s=p/4; }
		else s = p/_2PI * Math.asin (c/a);
		if (t < 1) return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*_2PI/p )) + b;
		return a*Math.pow(2,-10*(t-=1)) * Math.sin( (t*d-s)*_2PI/p )*.5 + c + b;
	}
}
