/*****************************************************************************************************
* Gaia Framework for Adobe Flash ©2007-2012
* Author: Steven Sacks
*
* git: https://github.com/stevensacks/Gaia-Framework
* support: http://gaiaflashframework.tenderapp.com/
* 
* By using the Gaia Framework, you agree to keep the above contact information in the source code.
* 
* Gaia Framework for Adobe Flash is released under the MIT License:
* http://www.opensource.org/licenses/mit-license.php 
*****************************************************************************************************/

// OPTIMIZE PROJECT
function optimizeProject(language, classPath, bitmapAsset, bitmapSpriteAsset, soundAsset, soundClipAsset, netStreamAsset, textAsset, xmlAsset, styleSheetAsset, jsonAsset, byteArrayAsset)
{
	fl.outputPanel.clear();
	var traceString = "";
	if (fl.fileExists(classPath + "/assets/AssetTypes.as"))
	{
		var code = FLfile.read(classPath + "/assets/AssetTypes.as");
		//
		code = optimizeAsset(code, xmlAsset, 'XMLAsset');
		code = optimizeAsset(code, soundAsset, 'SoundAsset');
		code = optimizeAsset(code, netStreamAsset, 'NetStreamAsset');
		code = optimizeAsset(code, styleSheetAsset, 'StyleSheetAsset');
		//
		if (language == "AS3")
		{
			code = optimizeAsset(code, bitmapSpriteAsset, 'BitmapSpriteAsset');
			code = optimizeAsset(code, bitmapAsset, 'BitmapAsset');
			code = optimizeAsset(code, byteArrayAsset, 'ByteArrayAsset');
			code = optimizeAsset(code, jsonAsset, 'JSONAsset');
			code = optimizeAsset(code, textAsset, 'TextAsset');
		}
		else
		{
			code = optimizeAsset(code, soundClipAsset, 'SoundClipAsset');
			optimizeSoundInSiteView(classPath, soundAsset);
		}
		saveTextViaOutput(classPath + "/assets/AssetTypes.as", code);
	}
	else
	{
		alert("You must update your project to Gaia 3.3.0 to use this feature");
	}
}
function optimizeAsset(code, value, type)
{
	var index, before, after;
	index = code.indexOf("add(" + type);
	if (value != "true")
	{
		if (code.charAt(index - 1) != "/")
		{
			before = code.substring(0, index) + "//";
			after = code.substring(index);
			code = before + after;
		}
	}
	else
	{
		if (code.charAt(index - 1) == "/")
		{
			before = code.substring(0, index - 2);
			after = code.substring(index);
			code = before + after;
		}
	}
	return code;
}
function optimizeSoundInSiteView(classPath, value)
{
	var code = FLfile.read(classPath + "/core/SiteView.as");
	var index, before, after;
	index = code.indexOf("SoundAsset(asset)");
	if (value != "true")
	{
		if (code.charAt(index - 1) != "/")
		{
			before = code.substring(0, index) + "//";
			after = code.substring(index);
			code = before + after;
		}
	}
	else
	{
		if (code.charAt(index - 1) == "/")
		{
			before = code.substring(0, index - 2);
			after = code.substring(index);
			code = before + after;
		}
	}
	saveTextViaOutput(classPath + "/core/SiteView.as", code);
}
function saveTextViaOutput(filePath, text)
{
	updateGaiaLog();
	text = text.split("\r\n").join("\n");
	while (text.charAt(text.length - 1) == "\n")
	{
		text = text.substring(0, text.length - 1);
	}
	fl.outputPanel.clear();
	fl.outputPanel.trace(text);
	fl.outputPanel.save(filePath, false, false);
	fl.outputPanel.clear();
}
function updateGaiaLog()
{
	var logPath = fl.configURI + "GaiaFramework/errors.txt";
	var log = FLfile.read(logPath);
	var len = log.length;
	fl.outputPanel.save(logPath, true, false);
	log = FLfile.read(logPath);
	if (log.length > len)
	{
		fl.outputPanel.clear();
		fl.outputPanel.trace(new Date());
		fl.outputPanel.trace("---------------------------------------------------------\n");
		fl.outputPanel.save(logPath, true, false);
		fl.outputPanel.clear();
	}
}
