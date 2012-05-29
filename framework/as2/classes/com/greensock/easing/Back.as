class com.greensock.easing.Back {
	public static function easeIn (t:Number, b:Number, c:Number, d:Number, s:Number):Number {
		if (s == undefined) s = 1.70158;
		return c*(t/=d)*t*((s+1)*t - s) + b;
	}
	public static function easeOut (t:Number, b:Number, c:Number, d:Number, s:Number):Number {
		if (s == undefined) s = 1.70158;
		return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
	}
	public static function easeInOut (t:Number, b:Number, c:Number, d:Number, s:Number):Number {
		if (s == undefined) s = 1.70158; 
		if ((t/=d*0.5) < 1) return c*0.5*(t*t*(((s*=(1.525))+1)*t - s)) + b;
		return c*0.5*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
	}
}
