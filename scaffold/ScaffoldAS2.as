import com.gaiaframework.utils.DocumentClass;
import gs.TweenLite;
	
class ScaffoldAS2 extends MovieClip
{	
	public var txt:TextField;
	public var bg:ScaffoldBG2;
	
	function ScaffoldAS2()
	{
		super();
	}
	public function transitionIn():Void
	{
		var branch:Array = _parent.page.branch.split("/");
		txt._y = 3 + (txt._height * (branch.length - 1));
		txt.autoSize = "left";
		if (branch.length == 1) 
		{
			txt.text = "  "  + branch.pop();
			bg._alpha = 100;
			bg.init();
		}
		else 
		{
			bg._visible = false;
			var str:String = "";
			var i:Number = branch.length;
			while (i--)
			{
				str += " ";
			}
			txt.text = str + " " + String(branch.pop());
		}
		if (_parent.assets != undefined) 
		{ 
			txt.text += "  (assets: ";
			var arr:Array = [];
			for (var a:String in _parent.assets) 
			{
				arr.push(a);
			}
			txt.text += arr + ")";
		}
		TweenLite.to(this, .3, {_alpha:100});
	}
	public function transitionOut():Void
	{
		bg.transitionOut();
		TweenLite.to(this, .3, {_alpha:0});
	}
	///////////////////////////////////////////////////////////
	// AS2 DOCUMENT CLASS EQUIVALENT - DO NOT REMOVE!!!
	public static function initDocumentClass(document:MovieClip):Void
	{
		DocumentClass.init(document, ScaffoldAS2);
		document._alpha = 0;
	}
	// AS2 DOCUMENT CLASS EQUIVALENT - DO NOT REMOVE!!!
	///////////////////////////////////////////////////////////
}