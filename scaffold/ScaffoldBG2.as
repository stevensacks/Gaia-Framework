import mx.utils.Delegate;

class ScaffoldBG2 extends MovieClip
{	
	public var tileClip:MovieClip;
	public var tileMask:MovieClip;
	public var logo:MovieClip;
	public var bg:MovieClip;
	
	private var resizeDelegate:Function;
	
	function ScaffoldBG2()
	{
		super();
		Stage.addListener(this);
	}
	public function transitionOut():Void
	{
		Stage.removeListener(this);
	}
	public function onResize():Void
	{
		var sW:Number = _root.GAIA.__WIDTH;
		var sH:Number = _root.GAIA.__HEIGHT;
		if (_root.GAIA.alignCount == 0)
		{
			logo._x = Math.round((Stage.width - logo._width) / 2);
			logo._y = Math.round((Stage.height - logo._height) / 2);
			bg._width = tileMask._width = Stage.width;
			bg._height = tileMask._height = Stage.height;
		}
		else
		{
			logo._x = Math.round((sW - logo._width) / 2);
			logo._y = Math.round((sH - logo._height) / 2);
			bg._width = tileMask._width = sW;
			bg._height = tileMask._height = sH;
		}
	}
	function init():Void
	{
		onResize();
	}
}