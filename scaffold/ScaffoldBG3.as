package
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ScaffoldBG3 extends MovieClip
	{	
		public var tileClip:Sprite;
		public var tileMask:Sprite;
		public var logo:MovieClip;
		public var bg:MovieClip;
		
		public function ScaffoldBG3()
		{
			super();
			alpha = 0;
			mouseChildren = false;
			mouseEnabled = false;
			drawTilesAndMask();
			if (stage) stage.addEventListener(Event.RESIZE, onResize, false, 0 , true);
			else addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
		}
		private function onAddedToStage($event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(Event.RESIZE, onResize, false, 0 , true);
		}
		public function transitionOut():void
		{
			stage.removeEventListener(Event.RESIZE, onResize);
		}
		public function onResize(event:Event):void
		{
			var sW:int = stage.getChildAt(0)["__WIDTH"];
			var sH:int = stage.getChildAt(0)["__HEIGHT"];
			if (stage.getChildAt(0)["alignCount"] == 0)
			{
				logo.x = Math.round((stage.stageWidth - logo.width) / 2);
				logo.y = Math.round((stage.stageHeight - logo.height) / 2);
				bg.width = tileMask.width = stage.stageWidth;
				bg.height = tileMask.height = stage.stageHeight;
			}
			else
			{
				logo.x = Math.round((sW - logo.width) / 2);
				logo.y = Math.round((sH - logo.height) / 2);
				bg.width = tileMask.width = sW;
				bg.height = tileMask.height = sH;
			}
		}
		public function init():void
		{
			onResize(new Event(Event.RESIZE));
		}
		private function drawTilesAndMask():void
		{
			tileClip = new Sprite();
			for (var w:int = 0; w < 8; w++)
			{
				for (var h:int = 0; h < 6; h++)
				{
					var tile:CrossTile = new CrossTile();
					tile.x = tile.width * w;
					tile.y = tile.height * h;
					tileClip.addChild(tile);
				}
			}
			tileClip.cacheAsBitmap = true;
			addChild(tileClip);
			addChild(logo);
			tileClip.mask = tileMask;
		}
	}
}