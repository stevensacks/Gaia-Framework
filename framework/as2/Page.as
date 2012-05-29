import com.gaiaframework.templates.AbstractPage;
import com.gaiaframework.utils.DocumentClass;
import com.gaiaframework.events.*;
import com.gaiaframework.assets.*;
import com.gaiaframework.debug.*;
import com.gaiaframework.api.*;
import mx.utils.Delegate;%IMPORTS%

class PACKAGENAME.CLASSNAME extends AbstractPage
{	
	public function CLASSNAME()
	{
		super();%ALPHA%
	}
	
	public function scaffold():Void
	{
		new Scaffold(this);
	}
	
	public function transitionIn():Void 
	{
		super.transitionIn();%TRANSITIONIN%
	}
	public function transitionOut():Void 
	{
		super.transitionOut();%TRANSITIONOUT%
	}
	
	///////////////////////////////////////////////////////////
	// AS2 DOCUMENT CLASS EQUIVALENT - DO NOT REMOVE!!!
	public static function initDocumentClass(document:MovieClip):Void
	{
		DocumentClass.init(document, CLASSNAME);
	}
	// AS2 DOCUMENT CLASS EQUIVALENT - DO NOT REMOVE!!!
	///////////////////////////////////////////////////////////
}