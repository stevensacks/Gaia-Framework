package
{
	import com.gaiaframework.api.IPage
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.display.MovieClip;
	import gs.TweenLite;
	
	public class ScaffoldAS3 extends MovieClip
	{	
		public var txt:TextField;
		public var bg:ScaffoldBG3;
		
		public function ScaffoldAS3()
		{
			super();
			alpha = 0;
			mouseChildren = false;
			mouseEnabled = false;
		}
		public function transitionIn():void
		{
			var branch:Array = IPage(parent.parent).page.branch.split("/");
			txt.y = 3 + (txt.height * (branch.length - 1));
			txt.autoSize = TextFieldAutoSize.LEFT;
			if (branch.length == 1) 
			{
				txt.text = "  "  + branch.pop();
				bg.alpha = 1;
				bg.init();
			}
			else 
			{
				bg.visible = false;
				var str:String = "";
				var i:int = branch.length;
				while (i--)
				{
					str += " ";
				}
				txt.text = str + " " + String(branch.pop());
			}
			if (IPage(parent.parent).assets != null) 
			{ 
				txt.appendText("  (assets: ");
				var arr:Array = [];
				for (var a:String in IPage(parent.parent).assets) arr.push(a);
				arr.sortOn("order", Array.NUMERIC);
				txt.appendText(arr.toString() + ")");
			}
			TweenLite.to(this, .3, {alpha:1});
		}
		public function transitionOut():void
		{
			bg.transitionOut();
			TweenLite.to(this, .3, {alpha:0});
		}
	}
}