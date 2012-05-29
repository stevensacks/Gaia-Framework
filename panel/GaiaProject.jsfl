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

function log(m)
{
	fl.trace(unescape(m));
}
function doConfirm(m)
{
	return confirm(unescape(m));
}
function loadGaiaProjectFile(projectPath)
{
	if (fl.fileExists(projectPath + "/project.gaia")) return FLfile.read(projectPath + "/project.gaia");
	return;
}
function saveStringFile(filePath, str)
{
	fl.outputPanel.clear();
	saveTextViaOutput(filePath, unescape(str));
}
function getFileSize(filePath)
{
	if (fl.fileExists(filePath)) return FLfile.getSize(filePath);
}
function getMainProperties(mainPath)
{
	fl.closeAll(false);
	if (fl.fileExists(mainPath)) 
	{
		fl.openDocument(mainPath);
		var properties = fl.getDocumentDOM().width + "," + fl.getDocumentDOM().height + "," + fl.getDocumentDOM().backgroundColor + "," + fl.getDocumentDOM().frameRate;
		fl.getDocumentDOM().close(false);
		return properties;
	}
}
function getDocumentOpen(src)
{
	var docs = fl.documents;
	var i = docs.length;
	while (i--)
	{
		if (docs[i].name == src) return true;
	}
	return false;
}
function openAndPublish(projectPath, filePath)
{
	if (fl.fileExists(filePath))
	{
		fl.openDocument(filePath);
		var success = true;
		fl.getDocumentDOM().publish();
		fl.compilerErrors.save(projectPath + "/errors.log");
		var errors = FLfile.read(projectPath + "/errors.log");
		if (errors.length > 0)
		{
			var errorIndex = errors.indexOf("Error(s)");
			if (errorIndex > -1) success = errors.indexOf("0 Error(s)") > - 1;
			else success = false;
		}
		FLfile.remove(projectPath + "/errors.log");
		return success;
	}
}
function publishSilently(projectPath, filePath)
{
	if (fl.fileExists(filePath))
	{
		var success = true;
		fl.publishDocument(filePath);
		fl.compilerErrors.save(projectPath + "/errors.log");
		var errors = FLfile.read(projectPath + "/errors.log");
		if (errors.length > 0)
		{
			var errorIndex = errors.indexOf("Error(s)");
			if (errorIndex > -1) success = errors.indexOf("0 Error(s)") > - 1;
			else success = false;
		}
		FLfile.remove(projectPath + "/errors.log");
		return success;
	}
}
function openProjectFolder(projectPath)
{
	var isWindows = FLfile.getPlatform().indexOf("win") > -1;
	var cmd = ' "' + uriToPath(projectPath) + '"';
	if (isWindows) cmd = 'explorer' + cmd;
	else cmd = 'open' + cmd;
	FLfile.runCommandLine(cmd);
}
function closeCurrentDocument()
{
	fl.closeDocument(fl.getDocumentDOM(), false);
}
function testMain(mainPath)
{
	fl.openDocument(mainPath);
	fl.getDocumentDOM().testMovie();
}
function testMainSWF(mainPath)
{
	fl.openScript(mainPath);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PROJECT CREATION
function createProject(frameworkPath, projectPath, source, deploy, classes, siteXML, width, height, w100, h100, centerX, centerY, bgColor, fps, player)
{
	fl.outputPanel.clear();
	copyFramework(frameworkPath, projectPath, source, deploy, classes, siteXML, player);
	initBaseFiles(projectPath, source, deploy, classes, width, height, w100, h100, centerX, centerY, bgColor, fps, player);
}
function copyFramework(frameworkPath, projectPath, source, deploy, classes, siteXML, player)
{
	var folderList = FLfile.listFolder(frameworkPath, "directories");
	copyFolders(frameworkPath, projectPath, folderList);
	var version = fl.version.split(" ")[1].split(",")[0];
	//
	var fromFolder = projectPath + "/__GaiaSrc" + version;
	if ((version == "10" || version == "11") && player == "10") fromFolder += "_10";
	renameFolder(fromFolder, projectPath + "/" + source);
	FLfile.remove(projectPath + "/__GaiaSrc9");
	FLfile.remove(projectPath + "/__GaiaSrc10");
	FLfile.remove(projectPath + "/__GaiaSrc10_10");
	FLfile.remove(projectPath + "/__GaiaSrc11");
	FLfile.remove(projectPath + "/__GaiaSrc11_10");
	//
	fromFolder = projectPath + "/templates" + version;
	if (player == "10") fromFolder += "_10";
	copyFiles(fromFolder, projectPath + "/templates", FLfile.listFolder(projectPath + "/templates" + version, "files"));
	FLfile.remove(projectPath + "/templates9");
	FLfile.remove(projectPath + "/templates10");
	FLfile.remove(projectPath + "/templates10_10");
	FLfile.remove(projectPath + "/templates11");
	FLfile.remove(projectPath + "/templates11_10");
	//
	// copy deploy and classes
	renameFolder(projectPath + "/__GaiaDeploy", projectPath + "/" + deploy);
	renameFolder(projectPath + "/__GaiaClasses", projectPath + "/" + classes);
	//
	// greensock swc
	FLfile.copy(frameworkPath + "/greensock.swc", projectPath + "/" + source + "/greensock.swc");
	//
	// move siteXML if necessary
	if (siteXML.length > 0)
	{
		// add to index.html
		FLfile.createFolder(projectPath + "/" + deploy + "/" + siteXML);
		FLfile.copy(projectPath + "/" + deploy + "/site.xml", projectPath + "/" + deploy + "/" + siteXML + "/site.xml");
		FLfile.remove(projectPath + "/" + deploy + "/site.xml");
		var html = FLfile.read(projectPath + "/" + deploy + "/index.html");
		var startIndex = html.indexOf("var flashvars = {") + 17;
		var endIndex = html.indexOf("}", startIndex);
		var before = html.substring(0, startIndex);
		var after = html.substring(endIndex);
		var siteXmlVar = '\n\t\tsiteXML: "' + siteXML + '/site.xml"\n\t';
		html = before + siteXmlVar + after;
		
		saveTextViaOutput(projectPath + "/" + deploy + "/index.html", html);
		// add to Main.as
		var code = FLfile.read(projectPath + "/" + classes + "/Main.as");
		if (frameworkPath.indexOf("/as3") > -1)
		{
			startIndex = code.indexOf("super();") + 8;
			before = code.substring(0, startIndex);
			after = code.substring(startIndex);
			code = before + '\n\t\t\tsiteXML = "' + siteXML + '/site.xml";' + after;
		}
		else
		{
			startIndex = code.indexOf("super(target);") + 14;
			before = code.substring(0, startIndex);
			after = code.substring(startIndex);
			code = before + '\n\t\tsiteXML = "' + siteXML + '/site.xml";' + after;
		}
		saveTextViaOutput(projectPath + "/" + classes + "/Main.as", code);
	}
}
function renameFolder(sourcePath, targetPath)
{
	FLfile.createFolder(targetPath);
	var folderList = FLfile.listFolder(sourcePath, "directories");
	copyFolders(sourcePath, targetPath, folderList);
	copyFiles(sourcePath, targetPath, FLfile.listFolder(sourcePath, "files"));
	FLfile.remove(sourcePath);
}
function copyFolders(sourcePath, targetPath, folderList)
{
	var i = folderList.length;
	while (i--)
	{
		FLfile.createFolder(targetPath + "/" + folderList[i]);
		copyFiles(sourcePath + "/" + folderList[i], targetPath + "/" + folderList[i], FLfile.listFolder(sourcePath + "/" + folderList[i], "files"));
		copyFolders(sourcePath + "/" + folderList[i], targetPath + "/" + folderList[i], FLfile.listFolder(sourcePath + "/" + folderList[i], "directories"));
	}
}
function copyFiles(sourcePath, targetPath, fileList)
{
	var i = fileList.length;
	while (i--)
	{
		FLfile.copy(sourcePath + "/" + fileList[i], targetPath + "/" + fileList[i]);
	}
}
function initBaseFiles(projectPath, source, deploy, classes, width, height, w100, h100, centerX, centerY, bgColor, fps, player)
{
	resizeFlashFile(projectPath + "/" + source + "/main.fla", width, height, bgColor, fps, false);
	resizeFlashFile(projectPath + "/templates/ASpage.fla", width, height, bgColor, fps, false);
	resizeFlashFile(projectPath + "/templates/TLpage.fla", width, height, bgColor, fps, false);
	resizeHTML(projectPath + "/" + deploy + "/index.html", width, height, w100, h100, bgColor, player);
	if (fl.fileExists(projectPath + "/" + classes + "/com/gaiaframework/core/gaia_internal.as"))
	{
		positionMainAS3(projectPath + "/" + classes, width, height, centerX, centerY);
	}
	else
	{
		positionMainAS2(projectPath + "/" + classes, width, height, centerX, centerY);
	}
}
function positionMainAS3(classesPath, width, height, centerX, centerY)
{
	var main = FLfile.read(classesPath + "/Main.as");
	if (centerX == "false" && centerY == "false")
	{
		main = main.split("%ALIGNSITE%").join("").split("%OVERRIDE%").join("");
	}
	else 
	{
		main = main.split("%ALIGNSITE%").join("\n" + "\t\t\talignSite(" + width + ", " + height + ");");
		if (centerX == "true" && centerY == "true")
		{
			main = main.split("%OVERRIDE%").join("override protected function onResize(event:Event):void\n\t\t{\n\t\t\tview.x = Math.round((stage.stageWidth - __WIDTH) / 2);\n\t\t\tview.y = Math.round((stage.stageHeight - __HEIGHT) / 2);\n\t\t}");
		}
		else if (centerX == "true")
		{
			main = main.split("%OVERRIDE%").join("override protected function onResize(event:Event):void\n\t\t{\n\t\t\tview.x = Math.round((stage.stageWidth - __WIDTH) / 2);\n\t\t}");
		}
		else if (centerY == "true")
		{
			main = main.split("%OVERRIDE%").join("override protected function onResize(event:Event):void\n\t\t{\n\t\t\tview.y = Math.round((stage.stageHeight - __HEIGHT) / 2);\n\t\t}");
		}
	}
	saveTextViaOutput(classesPath + "/Main.as", main);
}
function positionMainAS2(classesPath, width, height, centerX, centerY)
{
	var main = FLfile.read(classesPath + "/Main.as");
	if (centerX == "false" && centerY == "false")
	{
		main = main.split("%ALIGNSITE%").join("").split("%OVERRIDE%").join("");
	}
	else
	{
		main = main.split("%ALIGNSITE%").join("\n\t\talignSite(" + width + ", " + height + ");");
		if (centerX == "true" && centerY == "true")
		{
			main = main.split("%OVERRIDE%").join("private function onResize():Void\n\t{\n\t\tclip._x = Math.round((Stage.width - __WIDTH) / 2);\n\t\tclip._y = Math.round((Stage.height - __HEIGHT) / 2);\n\t}");
		}
		else if (centerX == "true")
		{
			main = main.split("%OVERRIDE%").join("private function onResize():Void\n\t{\n\t\tclip._x = Math.round((Stage.width - __WIDTH) / 2);\n\t}");
		}
		else if (centerY == "true")
		{
			main = main.split("%OVERRIDE%").join("private function onResize():Void\n\t{\n\t\tclip._y = Math.round((Stage.height - __HEIGHT) / 2);\n\t}");
		}
	}
	saveTextViaOutput(classesPath + "/Main.as", main);
}
function flashDevelop(frameworkPath, projectPath, language, projectName)
{
	if (language == "AS3") 
	{
		FLfile.copy(frameworkPath + "/FlashDevelop.as3proj", projectPath + "/" + projectName + ".as3proj");
	}
	else
	{
		FLfile.copy(frameworkPath + "/FlashDevelop.as2proj", projectPath + "/" + projectName + ".as2proj");
	}
}
function flexBuilder(flexPath, projectPath, projectName, lib, bin, src)
{
	FLfile.createFolder(projectPath + "/.settings");
	FLfile.copy(flexPath + "/org.eclipse.core.resources.prefs", projectPath + "/.settings/org.eclipse.core.resources.prefs");
	//
	var props = FLfile.read(flexPath + "/.actionScriptProperties");
	props = props.split("%LIB%").join(lib).split("%BIN%").join(bin).split("%SRC%").join(src);
	saveTextViaOutput(projectPath + "/.actionScriptProperties", props);
	//
	var proj = FLfile.read(flexPath + "/.project");
	proj = proj.split("%PROJECTNAME%").join(projectName);
	saveTextViaOutput(projectPath + "/.project", proj);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PROJECT RESIZE
function resizeProject(projectPath, source, classes, width, height, centerX, centerY, bgColor, fps)
{
	fl.outputPanel.clear();
	fl.closeAll(false);
	resizeFlashFile(projectPath + "/" + source + "/main.fla", width, height, bgColor, fps, false);
	resizeFlashFile(projectPath + "/templates/ASpage.fla", width, height, bgColor, fps, false);
	resizeFlashFile(projectPath + "/templates/TLpage.fla", width, height, bgColor, fps, false);
	resizeMainClass(projectPath + "/" + classes, width, height, centerX, centerY);
	updateGaiaLog();
}
function resizeMainClass(classesPath, width, height, centerX, centerY)
{
	var main = FLfile.read(classesPath + "/Main.as");
	var packageBrace;
	var classBrace;
	var lastFuncBrace;
	var subMain;
	var superIndex = main.indexOf("super();");
	var alignIndex = main.indexOf("alignSite");
	var resizeIndex = main.indexOf("onResize(");
	if (centerX == "true" || centerY == "true")
	{
		// recalibrate alignSite function
		if (alignIndex == -1)
		{
			if (superIndex > -1)
			{
				main = main.split("super();").join("super();\n\t\t\talignSite(" + width + ", " + height + ");");
			}
			else
			{
				main = main.split("super(target);").join("super(target);\n\t\talignSite(" + width + ", " + height + ");");
			}
		}
		else
		{
			var beforeAlign = main.substring(0, alignIndex);
			var afterAlignIndex = main.indexOf(");", alignIndex);
			main = beforeAlign + "alignSite(" + width + ", " + height + main.substring(afterAlignIndex);
		}
		// recalibrate onResize index
		superIndex = main.indexOf("super();");
		resizeIndex = main.indexOf("onResize(");
		if (resizeIndex == -1)
		{
			if (superIndex > -1)
			{
				packageBrace = main.lastIndexOf("}");
				subMain = main.substring(0, packageBrace - 1);
				classBrace = subMain.lastIndexOf("}");
				subMain = main.substring(0, classBrace - 1);
				lastFuncBrace = subMain.lastIndexOf("}");
				subMain = main.substring(0, lastFuncBrace + 1);
				if (centerX == "true" && centerY == "true")
				{
					main = subMain + "\n\t\toverride protected function onResize(event:Event):void\n\t\t{\n\t\t\tview.x = Math.round((stage.stageWidth - __WIDTH) / 2);\n\t\t\tview.y = Math.round((stage.stageHeight - __HEIGHT) / 2);\n\t\t}\n\t}\n}";
				}
				else if (centerX == "true")
				{
					main = subMain + "\n\t\toverride protected function onResize(event:Event):void\n\t\t{\n\t\t\tview.x = Math.round((stage.stageWidth - __WIDTH) / 2);\n\t\t}\n\t}\n}";
				}
				else if (centerY == "true")
				{
					main = subMain + "\n\t\toverride protected function onResize(event:Event):void\n\t\t{\n\t\t\tview.y = Math.round((stage.stageHeight - __HEIGHT) / 2);\n\t\t}\n\t}\n}";
				}
			}
			else
			{
				classBrace = main.lastIndexOf("}");
				subMain = main.substring(0, classBrace - 1);
				lastFuncBrace = subMain.lastIndexOf("}");
				subMain = main.substring(0, lastFuncBrace + 1);
				if (centerX == "true" && centerY == "true")
				{
					main = subMain + "\n\tprivate function onResize():Void\n\t{\n\t\tclip._x = Math.round((Stage.width - __WIDTH) / 2);\n\t\tclip._y = Math.round((Stage.height - __HEIGHT) / 2);\n\t}\n}";
				}
				else if (centerX == "true")
				{
					subMain + "\n\tprivate function onResize():Void\n\t{\n\t\tclip._x = Math.round((Stage.width - __WIDTH) / 2);\n\t}\n}";
				}
				else if (centerY == "true")
				{
					subMain + "\n\tprivate function onResize():Void\n\t{\n\t\tclip._y = Math.round((Stage.height - __HEIGHT) / 2);\n\t}\n}";
				}
			}
		}
		else
		{
			main = replaceOnResizeWithToken(main);
			var resizeFunction;
			if (superIndex > -1)
			{
				if (centerX == "true" && centerY == "true")
				{
					resizeFunction = "override protected function onResize(event:Event):void\n\t\t{\n\t\t\tview.x = Math.round((stage.stageWidth - __WIDTH) / 2);\n\t\t\tview.y = Math.round((stage.stageHeight - __HEIGHT) / 2);\n\t\t}";
				}
				else if (centerX == "true")
				{
					resizeFunction = "override protected function onResize(event:Event):void\n\t\t{\n\t\t\tview.x = Math.round((stage.stageWidth - __WIDTH) / 2);\n\t\t}";
				}
				else if (centerY == "true")
				{
					resizeFunction = "override protected function onResize(event:Event):void\n\t\t{\n\t\t\tview.y = Math.round((stage.stageHeight - __HEIGHT) / 2);\n\t\t}";
				}
			}
			else
			{
				if (centerX == "true" && centerY == "true")
				{
					resizeFunction = "private function onResize():Void\n\t{\n\t\tclip._x = Math.round((Stage.width - __WIDTH) / 2);\n\t\tclip._y = Math.round((Stage.height - __HEIGHT) / 2);\n\t}";
				}
				else if (centerX == "true")
				{
					resizeFunction = "private function onResize():Void\n\t{\n\t\tclip._x = Math.round((Stage.width - __WIDTH) / 2);\n\t}";
				}
				else if (centerY == "true")
				{
					resizeFunction = "private function onResize():Void\n\t{\n\t\tclip._y = Math.round((Stage.height - __HEIGHT) / 2);\n\t}";
				}
			}
			main = main.split("%RESIZE%").join(resizeFunction);
		}
	}
	else
	{
		// remove align
		if (alignIndex > -1)
		{
			var endOfAlignIndex = main.indexOf(");", alignIndex);
			subMain = main.substring(0, alignIndex);
			main = subMain + main.substring(endOfAlignIndex + 2);
		}
		if (resizeIndex > -1)
		{
			var trueResizeIndex;
			if (superIndex > -1)
			{
				trueResizeIndex = main.indexOf("override protected function onResize(");				
			}
			else
			{
				trueResizeIndex = main.indexOf("private function onResize(");
			}
			var resizeEndIndex = main.indexOf("}", trueResizeIndex);
			subMain = main.substring(0, trueResizeIndex);
			main = subMain + main.substring(resizeEndIndex + 1);
		}
	}
	saveTextViaOutput(classesPath + "/Main.as", main);
}
function replaceOnResizeWithToken(main)
{
	var superIndex = main.indexOf("super();");
	var resizeIndex;
	if (superIndex > -1) resizeIndex = main.indexOf("override protected function onResize(");
	else resizeIndex = main.indexOf("private function onResize(");
	var afterResizeIndex = main.indexOf("}", resizeIndex);
	var before = main.substring(0, resizeIndex);
	var after = main.substring(afterResizeIndex + 1);
	main = before + "%RESIZE%" + after;
	return main;
}
function resizeFlashFile(filePath, width, height, bgColor, fps, publish)
{
	if (fl.fileExists(filePath)) 
	{
		fl.closeAll(false);
		fl.openDocument(filePath);
		fl.getDocumentDOM().width = Number(width);
		fl.getDocumentDOM().height = Number(height);
		fl.getDocumentDOM().backgroundColor = Number("0x" + bgColor);
		fl.getDocumentDOM().frameRate = Number(fps);
		fl.getDocumentDOM().save();
		if (publish && filePath.indexOf("preload.fla") == -1) fl.getDocumentDOM().publish();
		fl.getDocumentDOM().close(false);
	}
}
function resizeHTML(filePath, width, height, w100, h100, bgColor, player)
{
	if (fl.fileExists(filePath)) 
	{
		var html = FLfile.read(filePath);
		var cssBgColor = "#" + bgColor;
		html = resizeCss(html, width, height, w100, h100, cssBgColor);
		html = resizeSWFObject(html, width, height, w100, h100, cssBgColor, player);
		saveTextViaOutput(filePath, html);
	}
}
function resizeCss(html, width, height, w100, h100, bgColor)
{
	var cssStartIndex = html.indexOf('<style type="text/css">');
	if (cssStartIndex > -1)
	{
		var cssEndIndex = html.indexOf('</style>', cssStartIndex);
		var newCss = '<style type="text/css">\n\t/' + '*' + 'hide from ie on mac\\' + '*' + '/\n'; 
		if (w100 == "true" || h100 == "true")
		{
			if (h100 == "true")
			{
				newCss += '\thtml {\n\t\theight: 100%;\n\t\toverflow: hidden\n\t}\n';
			}
			newCss += '\t#flashcontent {\n';
			if (w100 == "true") 
			{
				newCss += '\t\twidth: 100%;\n';
			}
			else
			{
				newCss += '\t\twidth: ' + width + 'px;\n';
			}
			if (h100 == "true")
			{
				newCss += '\t\theight: 100%;\n';
				newCss += '\t}\n';
				newCss += '\t/' + '*' + ' end hide ' + '*' + '/\n';
				newCss += '\tbody {\n\t\theight: 100%;\n\t\tmargin: 0;\n\t\tpadding: 0;\n\t\tbackground-color: ' + bgColor + ';\n\t}\n';
			}
			else
			{
				newCss += '\t\theight: ' + height + 'px;\n';
				newCss += '\t}\n';
				newCss += '\t/' + '*' + ' end hide ' + '*' + '/\n';
				newCss += '\tbody {\n\t\tmargin: 0;\n\t\tpadding: 0;\n\t\tbackground-color: ' + bgColor + ';\n\t}\n';
			}
		}
		else
		{
			newCss += '\t#flashcontent {\n';
			newCss += '\t\twidth: ' + width + 'px;\n';
			newCss += '\t\theight: ' + height + 'px;\n';
			newCss += '\t}\n';
			newCss += '\t/' + '*' + ' end hide ' + '*' + '/\n';
			newCss += '\tbody {\n\t\tmargin: 0;\n\t\tpadding: 0;\n\t\tbackground-color: ' + bgColor + ';\n\t}\n';
		}
		var beforeCss = html.substring(0, cssStartIndex);
		var afterCss = html.substring(cssEndIndex);
		return beforeCss + newCss + afterCss;
	}
	return html;
}
function resizeSWFObject(html, width, height, w100, h100, bgColor, player)
{
	var swfObjectLookup = 'swfobject.embedSWF("main.swf", "flashcontent", "';
	var widthStartIndex = html.indexOf(swfObjectLookup);
	if (widthStartIndex > -1)
	{
		var widthString = width;
		var heightString = height;
		if (w100 == "true") widthString = "100%";
		if (h100 == "true") heightString = "100%";
		//
		// replace width
		var widthEndIndex = html.indexOf('", ', widthStartIndex + swfObjectLookup.length);
		if (widthEndIndex - (widthStartIndex + swfObjectLookup.length) > 5) return html;
		var beforeWidth = html.substring(0, widthStartIndex + swfObjectLookup.length);
		var afterWidth = html.substring(widthEndIndex);
		html = beforeWidth + widthString + afterWidth;
		//
		// recalibrate
		var widthStartIndex = html.indexOf(swfObjectLookup);
		var widthEndIndex = html.indexOf('", ', widthStartIndex + swfObjectLookup.length);
		//
		// replace height
		var heightStartIndex = html.indexOf(', "', widthEndIndex);
		if (heightStartIndex == -1) return html;
		var heightEndIndex = html.indexOf('", ', heightStartIndex + 3);
		if (heightEndIndex - (heightStartIndex + 3) > 5) return html;
		var beforeHeight = html.substring(0, heightStartIndex + 3);
		var afterHeight = html.substring(heightEndIndex);
		html = beforeHeight + heightString + afterHeight;
	}
	var paramsIndex = html.indexOf('var params = {');
	if (paramsIndex > -1)
	{
		var bgColorStartIndex = html.indexOf('bgcolor: "#', paramsIndex) + 11;
		if (bgColorStartIndex > -1)
		{
			var bgColorEndIndex = html.indexOf('"', bgColorStartIndex);
			var beforeBgColor = html.substring(0, bgColorStartIndex - 1);
			var afterBgColor = html.substring(bgColorEndIndex);
			html = beforeBgColor + bgColor + afterBgColor;
		}
	}
	if (player == "10") html = html.split("9.0.124").join("10.0.0");
	return html;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// FRAMEWORK UPDATE
function updateFramework(frameworkPath, projectPath, deploy, classes, player, source)
{
	fl.outputPanel.clear();
	var projectClassPath = projectPath + "/" + classes;
	//
	var totalFiles = 0;
	var frameworkClassPath = frameworkPath + "/__GaiaClasses";
	totalFiles += updateGaiaFolders(frameworkClassPath, projectClassPath, source);
	//
	if (frameworkClassPath.indexOf("/as3") > -1)
	{
		totalFiles += updateGreensockSWC(frameworkPath, projectPath, source);
	}
	//
	var frameworkDeployPath = frameworkPath + "/__GaiaDeploy";
	var projectDeployPath = projectPath + "/" + deploy;
	totalFiles += updateDeployFolders(frameworkDeployPath, projectDeployPath, deploy);
	totalFiles += updateSWFObject(projectDeployPath, deploy);
	totalFiles += updateTemplates(frameworkPath + "/templates", projectPath + "/templates", player);
	totalFiles += updateMain(projectClassPath);
	//
	if (totalFiles > 0)
	{
		var traceString = ("-------------------\n");
		traceString += "Total Updates: " + totalFiles;
		appendToUpdateLog(traceString);
	}
	var updateLog = FLfile.read(fl.configURI + "GaiaFramework/update.log");
	FLfile.remove(fl.configURI + "GaiaFramework/update.log");
	return totalFiles + "," + escape(updateLog);
}
function updateGaiaFolders(frameworkPath, projectPath, source)
{
	var totalFiles = 0;
	// GAIA
	totalFiles += updateGaiaClassFiles(frameworkPath, projectPath, "/com/gaiaframework/api");
	totalFiles += updateGaiaClassFiles(frameworkPath, projectPath, "/com/gaiaframework/assets");
	totalFiles += updateGaiaClassFiles(frameworkPath, projectPath, "/com/gaiaframework/core");
	totalFiles += updateGaiaClassFiles(frameworkPath, projectPath, "/com/gaiaframework/debug");
	totalFiles += updateGaiaClassFiles(frameworkPath, projectPath, "/com/gaiaframework/events");
	totalFiles += updateGaiaClassFiles(frameworkPath, projectPath, "/com/gaiaframework/flow");
	totalFiles += updateGaiaClassFiles(frameworkPath, projectPath, "/com/gaiaframework/templates");
	totalFiles += updateGaiaClassFiles(frameworkPath, projectPath, "/com/gaiaframework/utils");
	// SWFAddress
	totalFiles += updateGaiaClassFiles(frameworkPath, projectPath, "/com/asual/swfaddress");
	//
	if (frameworkPath.indexOf("/as3") > -1)
	{
		// JSON
		totalFiles += updateGaiaClassFiles(frameworkPath, projectPath, "/com/serialization");
		// SWFWHEEL
		totalFiles += updateGaiaClassFiles(frameworkPath, projectPath, "/org/libspark/ui");
	}
	else
	{
		// GREENSOCK
		totalFiles += updateGaiaClassFiles(frameworkPath, projectPath, "/com/greensock");
		totalFiles += updateGaiaClassFiles(frameworkPath, projectPath, "/com/greensock/core");
		totalFiles += updateGaiaClassFiles(frameworkPath, projectPath, "/com/greensock/easing");
		totalFiles += updateGaiaClassFiles(frameworkPath, projectPath, "/com/greensock/plugins");
	}
	return totalFiles;
}
function updateGreensockSWC(frameworkPath, projectPath, source)
{
	FLfile.copy(frameworkPath + "/greensock.swc", projectPath + "/" + source + "/greensock.swc");
	var traceString = ("*** Greensock ***\n");
	traceString += ("∆ Update: greensock.swc\n");
	traceString += "► Files: 1\n";
	appendToUpdateLog(traceString);
	return 1;
}
function updateDeployFolders(frameworkPath, projectPath, deploy)
{
	// JavaScript files
	return updateGaiaClassFiles(frameworkPath, projectPath, "/js", deploy);
}
function updateGaiaClassFiles(frameworkPath, projectPath, classPath, deploy)
{
	var fileList = FLfile.listFolder(frameworkPath + classPath, "files");
	var count = 0;
	var traceString = "";
	if (frameworkPath.indexOf("__GaiaDeploy") == -1) traceString += ("*** " + classPath.substring(1).split("/").join(".") + " ***\n");
	else traceString += ("*** " + deploy + "/js ***\n");
	for (var i = 0; i < fileList.length; i++)
	{
		var frameworkFile = frameworkPath + classPath + "/" + fileList[i];
		var projectFile = projectPath + classPath + "/" + fileList[i];
		if (!fl.fileExists(projectFile) || FLfile.getSize(frameworkFile) != FLfile.getSize(projectFile) || FLfile.read(frameworkFile) != FLfile.read(projectFile))
		{
			if (!fl.fileExists(projectFile))
			{
				traceString += ("+  Added:  " + fileList[i] + "\n");
				FLfile.createFolder(projectPath + classPath);
			}
			else
			{
				traceString += ("∆ Update:  " + fileList[i] + "\n");
				FLfile.remove(projectFile);
			}
			FLfile.copy(frameworkFile, projectFile);
			count++;
		}
	}
	if (count > 0)
	{
		traceString += "► Files: " + count + "\n";
		appendToUpdateLog(traceString);
	}
	return count;
}
function updateTemplates(frameworkTemplatesPath, projectTemplatesPath, player)
{
	var count = 0;
	var traceString = "*** templates ***\n";
	var template = "ASpage.fla";
	var version = fl.version.split(" ")[1].split(",")[0];
	var frameworkTemplatesFLAPath = frameworkTemplatesPath + version
	frameworkTemplatesFLAPath += version;
	if (version == "10" && player == "10") frameworkTemplatesFLAPath += "_10";
	if (!fl.fileExists(projectTemplatesPath + "/" + template)) 
	{
		FLfile.copy(frameworkTemplatesFLAPath + "/" + template, projectTemplatesPath + "/" + template);
		traceString += ("+  Added:  " + template + "\n");
		count++;
	}
	template = "TLpage.fla";
	if (!fl.fileExists(projectTemplatesPath + "/" + template)) 
	{
		FLfile.copy(frameworkTemplatesFLAPath + "/" + template, projectTemplatesPath + "/" + template);
		traceString += ("+  Added:  " + template + "\n");
		count++;
	}
	template = "Page.as";
	if (!fl.fileExists(projectTemplatesPath + "/" + template) || FLfile.getSize(frameworkTemplatesPath + "/" + template) != FLfile.getSize(projectTemplatesPath + "/" + template))
	{
		if (!fl.fileExists(projectTemplatesPath + "/" + template))
		{
			traceString += ("+  Added:  " + template + "\n");
		}
		else
		{
			traceString += ("∆ Update:  " + template + "\n");
			FLfile.remove(projectTemplatesPath + "/" + template);
			
		}
		FLfile.copy(frameworkTemplatesPath + "/" + template, projectTemplatesPath + "/" + template);
		count++;
	}
	if (count > 0)
	{
		traceString += "► Files: " + count + "\n";
		appendToUpdateLog(traceString);
	}
	return count;
}
function updateMain(projectClassPath)
{
	if (fl.fileExists(projectClassPath + "/Main.as"))
	{
		var main = FLfile.read(projectClassPath + "/Main.as");
		if (main.indexOf("centerSite(") > -1)
		{
			main = main.split("centerSite(").join("alignSite(");
			main = main.split("_$WIDTH").join("__WIDTH");
			main = main.split("_$HEIGHT").join("__HEIGHT");
			saveTextViaOutput(projectClassPath + "/Main.as", main);
			var traceString = "*** Main.as ***\n";
			traceString += "∆ Update: Main.as\n";
			traceString += "► Files: 1\n";
			appendToUpdateLog(traceString);
			return 1;
		}
	}
	return 0;
}
function updateSWFObject(deployPath, deploy)
{
	var fileList = FLfile.listFolder(deployPath, "files");
	var count = 0;
	var traceString = "";
	traceString += "*** " + deploy + " ***\n";
	for (var i = 0; i < fileList.length; i++)
	{
		if (fileList[i].split(".").pop() == "html")
		{
			var html = FLfile.read(deployPath + "/" + fileList[i]);
			var flashcontentIndex = html.indexOf('<div id="flashcontent">');
			if (flashcontentIndex > -1)
			{
				var widthStartIndex = html.indexOf('var so = new SWFObject("main.swf", "main", "');
				if (widthStartIndex > -1)
				{
					var width, height, version, bgColor, branch;
					// width
					var widthEndIndex = html.indexOf('", ', widthStartIndex + 44);
					width = html.substring(widthStartIndex + 44, widthEndIndex);
					// height
					var heightStartIndex = html.indexOf(', "', widthEndIndex);
					var heightEndIndex = html.indexOf('", ', heightStartIndex + 3);
					height = html.substring(heightStartIndex + 3, heightEndIndex);
					// version
					var versionStartIndex = html.indexOf(', "', heightEndIndex);
					var versionEndIndex = html.indexOf('", ', versionStartIndex + 3);
					version = html.substring(versionStartIndex + 3, versionEndIndex);
					if (version == "9") version = "9.0.124";
					else if (version == "10") version = "10.0.0";
					// bg color
					var colorStartIndex = html.indexOf(', "', versionEndIndex);
					var colorEndIndex = html.indexOf('"', colorStartIndex + 3);
					bgColor = html.substring(colorStartIndex + 3, colorEndIndex);
					//
					// params
					var params = 'var params = {';
					var paramString = getOptions("", 'so.addParam("', html, 0);
					params += paramString + '\n\t\tbgcolor: "#' + bgColor + '"\n\t};\n';
					// flash vars
					var flashVars = 'var flashvars = {';
					var flashVarString = getOptions("", 'so.addVariable("', html, 0);
					if (flashVarString.length > 0) flashVarString = flashVarString.substring(0, flashVarString.length - 1) + '\n\t';
					flashVars += flashVarString + '};\n';
					//
					// strip old SWFObject
					var oldStartIndex = html.indexOf('<script type="text/javascript">', flashcontentIndex);
					if (oldStartIndex > -1)
					{
						var oldEndIndex = html.indexOf('</script>', oldStartIndex);
						var beforeOld = html.substring(0, oldStartIndex);
						var afterOld = html.substring(oldEndIndex + 9);
						html = beforeOld + afterOld;
					}
					// add new SWFObject
					var newSO = '<script type="text/javascript">\n';
					newSO += '\t' + params;
					newSO += '\t' + flashVars;
					newSO += '\tvar attributes = {\n\t\tid: "flashcontent",\n\t\tname: "flashcontent"\n\t};\n';
					newSO += 'tswfobject.embedSWF("main.swf", "flashcontent", "';
					newSO += width + '", "' + height + '", "' + version + '", "expressInstall.swf", flashvars, params, attributes);\n';
					newSO += '</script>';
					html = html.split('"js/swfaddress.js"></script>').join('"js/swfaddress.js"></script>\n' + newSO);
					//
					saveTextViaOutput(deployPath + "/" + fileList[i], html);
					//
					traceString += "∆ Update:  " + fileList[i] + "\n";
					count++;
				}
			}
		}
	}
	if (count > 0)
	{
		traceString += "► Files: " + count + "\n";
		appendToUpdateLog(traceString);
	}
	return count;
}
function getOptions(optionString, optionType, html, lastIndex)
{
	var optionStartIndex = html.indexOf(optionType, lastIndex);
	if (optionStartIndex > -1)
	{
		var optionEndIndex = html.indexOf('", ', optionStartIndex);
		var optionName = html.substring(optionStartIndex + optionType.length, optionEndIndex);
		var valueStartIndex = html.indexOf('"', optionEndIndex + 3);
		var valueEndIndex = html.indexOf('")', valueStartIndex);
		var optionValue = html.substring(valueStartIndex + 1, valueEndIndex);
		optionString += '\n\t\t' + optionName + ': "' + optionValue + '",';
		return getOptions(optionString, optionType, html, valueEndIndex - 1);
	}
	return optionString;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// UTF-8 WORKAROUND
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
function appendToUpdateLog(text)
{
	var logPath = fl.configURI + "GaiaFramework/update.log";
	FLfile.write(logPath, text, true);
}
function debug(text)
{
	text = unescape(text);
	text = text.split("\r\n").join("\n");
	while (text.charAt(text.length - 1) == "\n")
	{
		text = text.substring(0, text.length - 1);
	}
	var logPath = fl.configURI + "GaiaFramework/errors.txt";
	fl.outputPanel.clear();
	fl.outputPanel.trace(text);
	fl.outputPanel.trace(new Date());
	fl.outputPanel.trace("---------------------------------------------------------\n");
	fl.outputPanel.save(logPath, true, false);
	fl.outputPanel.clear();
}
function openPanelLog()
{
	var logPath = fl.configURI + "GaiaFramework/errors.txt";
	fl.openScript(logPath);
}
function clearPanelLog()
{
	var logPath = fl.configURI + "GaiaFramework/errors.txt";
	fl.outputPanel.clear();
	fl.outputPanel.save(logPath, false, false);
}
////////////////////////////////////////////////////////////////////////////////////
// COMMAND LINE UTILS
function uriToPath(filePath)
{
	var isWindows = FLfile.getPlatform().indexOf("win") > -1;
	if (filePath.indexOf("file://") == 0)
	{
		if (isWindows) filePath = filePath.split("file://").join("/");
		else filePath = filePath.split("file://").join("");
	}
	if (isWindows)
	{
		filePath = filePath.split("|/").join(":/");
		filePath = filePath.split("/").join("\\");
	}
	if (!isWindows)
	{
		var fileSplit;
		fileSplit = filePath.split("/");
		if (filePath.indexOf(getMacHD()) == -1)
		{
			filePath = "/Volumes/" + fileSplit.slice(2, fileSplit.length).join("/");
		}
		else
		{
			filePath = "/" + fileSplit.slice(2, fileSplit.length).join("/");
		}
	}
	else
	{
		filePath = filePath.substr(2);
	}
	return unescape(filePath);
}
function getMacHD()
{
	var result = unescape(fl.configURI.split("file:///").join("").split("/").shift());
	return result;
}
