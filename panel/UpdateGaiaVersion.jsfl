/*****************************************************************************************************
* Gaia Framework for Adobe Flash ©2007-2012
* Author: Steven Sacks
*
* forum: http://www.gaiaflashframework.com/forum/
* wiki: http://www.gaiaflashframework.com/wiki/
* 
* By using the Gaia Framework, you agree to keep the above contact information in the source code.
* 
* Gaia Framework for Adobe Flash is released under the MIT License:
* http://www.opensource.org/licenses/mit-license.php 
*****************************************************************************************************/

function update()
{
	var oldVersion = "3.2.6";
	var newVersion = "3.3.0";
	//
	var src = fl.browseForFolderURL("Select Gaia Source Folder") + "/";
	// as3
	var path = src + "framework/as3/classes/com/gaiaframework/core/GaiaImpl.as";
	var code = FLfile.read(path);
	code = code.split(oldVersion).join(newVersion);
	saveTextViaOutput(path, code);
	// as2
	path = src + "framework/as2/classes/com/gaiaframework/core/GaiaImpl.as";
	code = FLfile.read(path);
	code = code.split(oldVersion).join(newVersion);
	saveTextViaOutput(path, code);
	// mxi
	path = src + "Gaia Framework.mxi";
	code = FLfile.read(path);
	code = code.split(oldVersion).join(newVersion);
	saveTextViaOutput(path, code);
	// panel
	path = src + "panel/src/com/gaiaframework/panel/services/Panel.as";
	code = FLfile.read(path);
	code = code.split(oldVersion).join(newVersion);
	saveTextViaOutput(path, code);
	// optimize
	path = src + "panel/GaiaOptimize.jsfl";
	code = FLfile.read(path);
	code = code.split(oldVersion).join(newVersion);
	saveTextViaOutput(path, code);
}
function saveTextViaOutput(filePath, text)
{
	text = text.split("\r\n").join("\n");
	while (text.charAt(text.length - 1) == "\n" || text.charAt(text.length - 1) == "\r")
	{
		text = text.substring(0, text.length - 1);
	}
	fl.outputPanel.clear();
	fl.outputPanel.trace(text);
	fl.outputPanel.save(filePath, false, false);
	fl.outputPanel.clear();
}
update();
