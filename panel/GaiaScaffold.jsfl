/*****************************************************************************************************
* Gaia Framework for Adobe Flash ©2007-2009
* Author: Steven Sacks
*
* blog: http://www.stevensacks.net/
* forum: http://www.gaiaflashframework.com/forum/
* support: http://gaiaflashframework.tenderapp.com/
* 
* By using the Gaia Framework, you agree to keep the above contact information in the source code.
* 
* Gaia Framework for Adobe Flash is released under the MIT License:
* http://www.opensource.org/licenses/mit-license.php 
*****************************************************************************************************/

function scaffoldInit(projectPath, language, source, deploy, classes, classPackage, template)
{
	firstTimeScaffold(projectPath, language, source, deploy, classes, classPackage, template);
	openPageTemplate(projectPath, source, template);
}
function firstTimeScaffold(projectPath, language, source, deploy, classes, classPackage, template)
{
	var templatesPath = projectPath + "/templates";
	if (fl.fileExists(templatesPath + "/Preloader.as"))
	{
		fl.outputPanel.clear();
		var classFolderPath = projectPath + "/" + classes + "/" + (classPackage.split(".").join("/"));
		FLfile.createFolder(classFolderPath);
		//
		var classFile = "Preloader.as";
		injectPackageAndRemoveTemplate(templatesPath + "/" + classFile, classFolderPath + "/" + classFile, classPackage);
		classFile = "PreloaderScaffold.as";
		injectPackageAndRemoveTemplate(templatesPath + "/" + classFile, classFolderPath + "/" + classFile, classPackage);
		classFile = "Scaffold.as";
		injectPackageAndRemoveTemplate(templatesPath + "/" + classFile, classFolderPath + "/" + classFile, classPackage);
		classFile = "Pages.as";
		injectPackageAndRemoveTemplate(templatesPath + "/Pages.as", classFolderPath + "/Pages.as", classPackage);
		//
		fl.openDocument(projectPath + "/" + source + "/preload.fla");
		if (language == "AS3") 
		{
			fl.getDocumentDOM().docClass = classPackage + ".Preloader";
			fl.getDocumentDOM().getTimeline().layers[0].frames[0].actionScript = "";
		}
		else
		{
			var as = "import " + classPackage + ".Preloader;\nPreloader.initDocumentClass(this);\n";
			fl.getDocumentDOM().getTimeline().layers[0].frames[0].actionScript = as;
		}
		var itemArray = fl.getDocumentDOM().library.items;
		for (var i = 0; i < itemArray.length; i++)
		{
			if (itemArray[i].name == "PreloaderScaffold")
			{
				itemArray[i].linkageClassName = classPackage + ".PreloaderScaffold";
				break;
			}
		}
		setScaffoldFilePublishSettings(projectPath, language, source, deploy, classes, "preload");
		saveCloseRemove(projectPath, source);
		//
		fl.openDocument(projectPath + "/" + source + "/main.fla");
		setScaffoldFilePublishSettings(projectPath, language, source, deploy, classes, "main");
		saveCloseRemove(projectPath, source);
		updateGaiaLog();
	}
}
function injectPackageAndRemoveTemplate(templateFilePath, classFilePath, classPackage)
{
	FLfile.copy(templateFilePath, classFilePath);
	var classText = FLfile.read(classFilePath);
	classText = classText.split("PACKAGENAME").join(classPackage);
	saveTextViaOutput(classFilePath, classText);
	FLfile.remove(templateFilePath);
}
function saveCloseRemove(projectPath, source)
{
	fl.saveDocument(fl.getDocumentDOM());
	fl.closeDocument(fl.getDocumentDOM(), false);
	removeScaffoldFileProfileXML(projectPath, source);
}
function openPageTemplate(projectPath, source, template)
{
	fl.closeAll(false);
	var pageTemplate = "ASpage.fla";
	if (template != "Actionscript") pageTemplate = "TLpage.fla";
	FLfile.copy(projectPath + "/templates/" + pageTemplate, projectPath + "/" + source + "/_SCAFFOLD_.fla");
	fl.openDocument(projectPath + "/" + source + "/_SCAFFOLD_.fla");
	fl.getDocumentDOM().exportPublishProfile(projectPath + "/templates/OriginalPublishProfile.xml");
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SCAFFOLDING
function createScaffoldFile(projectPath, language, source, deploy, classes, classPackage, pagePackage, template, src, pageID)
{
	fl.outputPanel.clear();
	fl.getDocumentDOM().importPublishProfile(projectPath + "/templates/OriginalPublishProfile.xml");
	
	var fileName = src.substr(0, src.length - 4);
	var filePath = projectPath + "/" + source + "/" + fileName + ".fla";
	if (fl.fileExists(filePath)) return false;
	if (fileName.indexOf("/") > -1)
	{
		var splitPath = fileName.split("/");
		splitPath.length--;
		var folderPath = splitPath.join("/");
		FLfile.createFolder(projectPath + "/" + source + "/" + folderPath);
		FLfile.createFolder(projectPath + "/" + deploy + "/" + folderPath);
	}
	setScaffoldFilePublishSettings(projectPath, language, source, deploy, classes, fileName);
	if (language == "AS3")
	{
		scaffoldClass(projectPath, language, classes, classPackage, pagePackage, template, pageID);
		fl.getDocumentDOM().docClass = classPackage + pagePackage + "." + pageID + "Page";
	}
	else
	{
		scaffoldClass(projectPath, language, classes, classPackage, pagePackage, template, pageID);
		var as = "import " + classPackage + pagePackage + "." + pageID + "Page;\n" + pageID + "Page.initDocumentClass(this);\nstop();\nscaffold();\n";
		fl.getDocumentDOM().getTimeline().layers[0].frames[0].actionScript = as;
		scaffoldExcludeXML(projectPath, source, fileName);
	}
	fl.saveDocument(fl.getDocumentDOM(), filePath);
	removeScaffoldFileProfileXML(projectPath, source);
	updateGaiaLog();
	return true;
}
function deleteScaffoldFile(projectPath, source) 
{
	fl.closeDocument(fl.getDocumentDOM(), false);
	FLfile.remove(projectPath + "/templates/OriginalPublishProfile.xml");
	FLfile.remove(projectPath + "/" + source + "/_SCAFFOLD_.fla");
}
function removeScaffoldFileProfileXML(projectPath, source) 
{
	FLfile.remove(projectPath + "/" + source + "/ScaffoldProfile.xml");
}
function setScaffoldFilePublishSettings(projectPath, language, source, deploy, classes, fileName) 
{
	var xml, from, to, delta;
	var profileXmlPath = projectPath + "/" + source + "/ScaffoldProfile.xml";
	
	// export the profile and read it in
	fl.getDocumentDOM().exportPublishProfile(profileXmlPath);
	
	xml = FLfile.read(profileXmlPath);
	
	// override default names to 0
	from = xml.indexOf("<defaultNames>");
	to = xml.indexOf("</defaultNames>");
	delta = xml.substring(from, to);
	xml = xml.split(delta).join("<defaultNames>0");
	
	// override flash default name to 0
	from = xml.indexOf("<flashDefaultName>");
	to = xml.indexOf("</flashDefaultName>");
	delta = xml.substring(from, to);
	xml = xml.split(delta).join("<flashDefaultName>0");
	
	// replace the publish path for swf	
	from = xml.indexOf("<flashFileName>");
	to = xml.indexOf("</flashFileName>");
	delta = xml.substring(from, to);
	
	// set file path
	var flashPath = source + "/" + fileName;
	var flashPathSplit = flashPath.split("/");
	
	var relativeBasePath = "";
	
	var i = flashPathSplit.length - 1;
	while (i--)
	{
		relativeBasePath += "../";
	}
	
	xml = xml.split(delta).join("<flashFileName>" + relativeBasePath + deploy + "/" + fileName + ".swf");
	
	// and the rest
	var types = {};
	types.generatorFileName = "swt";
	types.projectorWinFileName = "exe";
	types.projectorMacFileName = "hqx";
	types.htmlFileName = "html";
	types.gifFileName = "gif";
	types.jpegFileName = "jpg";
	types.pngFileName = "png";
	types.qtFileName = "mov";
	types.rnwkFileName = "smil";
	
	for (var n in types) 
	{
		from = xml.indexOf("<" + n + ">");
		to = xml.indexOf("</" + n + ">");
		if (from > -1 && to > -1)
		{
			delta = xml.substring(from, to);
			xml = xml.split(delta).join("<" + n + ">" + fileName + "." + types[n]);
		}
	}
	
	// make sure package paths look in ../src, actionscript is set to version 2 and classes export in frame 1
	from = xml.indexOf("<ActionScriptVersion>");
	to = xml.indexOf("</ActionScriptVersion>");
	delta = xml.substring(from, to);
	xml = xml.split(delta).join("<ActionScriptVersion>" + language.charAt(2));
	
	from = xml.indexOf("<PackageExportFrame>");
	to = xml.indexOf("</PackageExportFrame>");
	delta = xml.substring(from, to);
	xml = xml.split(delta).join("<PackageExportFrame>1");
	
	// set relative class path
	var classPathSplit = classes.split("/");	
	var relativeClassPath = relativeBasePath;
	var mismatch = false;
	for (i = 0; i < classPathSplit.length; i++)
	{
		if (mismatch || i >= flashPathSplit.length || flashPathSplit[i] != classPathSplit[i]) 
		{
			mismatch = true;
			relativeClassPath += classPathSplit[i] + "/";
		}
		else 
		{
			relativeClassPath = relativeClassPath.substr(3);
		}
	}
	var classPath = relativeClassPath.substr(0, relativeClassPath.length - 1);
	if (classPath.charAt(0) != ".") classPath = "./" + classPath;
	
	var existingClassPackages;
	if (language == "AS3")
	{
		from = xml.indexOf("<AS3PackagePaths>");
		to = xml.indexOf("</AS3PackagePaths>");
		delta = xml.substring(from, to);
		existingClassPackages = delta.substr(17);
		if (existingClassPackages.length > 0) 
		{
			if (existingClassPackages.indexOf(classPath) == -1) classPath += ";" + existingClassPackages;
			else classPath = existingClassPackages;
		}
		classPath = classPath.split(".;").join("");
		xml = xml.split(delta).join("<AS3PackagePaths>" + classPath);
	}
	else
	{
		from = xml.indexOf("<PackagePaths>");
		to = xml.indexOf("</PackagePaths>");
		delta = xml.substring(from, to);
		existingClassPackages = delta.substr(14);
		if (existingClassPackages.length > 0) 
		{
			if (existingClassPackages.indexOf(classPath) == -1) classPath += ";" + existingClassPackages;
			else classPath = existingClassPackages;
		}
		classPath = classPath.split(".;").join("");
		xml = xml.split(delta).join("<PackagePaths>" + classPath);
	}
	// write the modified profile and import it
	saveTextViaOutput(profileXmlPath, xml);
	fl.getDocumentDOM().importPublishProfile(profileXmlPath);
}
function scaffoldClass(projectPath, language, classes, classPackage, pagePackage, template, pageID)
{
	var classFolderPath = projectPath + "/" + classes + "/" + (classPackage.split(".").join("/"));
	FLfile.createFolder(classFolderPath);
	var classFilePath = classFolderPath;
	if (pagePackage.length > 0)
	{
		FLfile.createFolder(classFolderPath + pagePackage.split(".").join("/"));
		classFilePath += pagePackage.split(".").join("/");
	}
	classFilePath += "/" + pageID + "Page.as";
	FLfile.copy(projectPath + "/templates/Page.as", classFilePath);
	//
	var concreteClass = FLfile.read(classFilePath);
	concreteClass = concreteClass.split("PACKAGENAME").join((classPackage + pagePackage)).split("CLASSNAME").join(pageID + "Page");
	
	var alphaScript, importScript, inScript, outScript, scaffoldScript;
	indent = "\t\t";
	if (language == "AS3") indent = "\t\t\t";
	scaffoldScript = "import " + classPackage + ".*;";
	if (template == "Timeline")
	{
		alphaScript = "";
		importScript = "\n\n";
		inScript = "\n" + indent + "gotoAndPlay(\"in\");";
		outScript = "\n" + indent + "gotoAndPlay(\"out\");";
		if (pagePackage.length > 0 || language == "AS2")
		{
			if (language == "AS3") importScript += "\t";
			importScript += scaffoldScript;
		}
	}
	else
	{
		alphaScript = "alpha = 0;";
		importScript = "import com.greensock.TweenMax;";
		if (language == "AS3")
		{
			importScript = "\t" + importScript;
			inScript = "TweenMax.to(this, 0.3, {alpha:1, onComplete:transitionInComplete});";
			outScript = "TweenMax.to(this, 0.3, {alpha:0, onComplete:transitionOutComplete});";
		}
		else
		{
			alphaScript = "_" + alphaScript;			
			inScript = "TweenMax.to(this, 0.3, {_alpha:100, onComplete:Delegate.create(this, transitionInComplete)});";
			outScript = "TweenMax.to(this, 0.3, {_alpha:0, onComplete:Delegate.create(this, transitionOutComplete)});";
		}
		if (pagePackage.length > 0 || language == "AS2") 
		{
			importScript += "\n\n";
			if (language == "AS3") importScript += "\t";
			importScript += scaffoldScript;
		}
		alphaScript = "\n" + indent + alphaScript;
		importScript = "\n" + importScript;
		inScript = "\n" + indent + inScript;
		outScript = "\n" + indent + outScript;
	}
	concreteClass = concreteClass.split("%ALPHA%").join(alphaScript);
	if (concreteClass.indexOf("%IMPORTS%") > -1) concreteClass = concreteClass.split("%IMPORTS%").join(importScript);
	else concreteClass = concreteClass.split("%TWEENLITE%").join(importScript);
	concreteClass = concreteClass.split("%TRANSITIONIN%").join(inScript);
	concreteClass = concreteClass.split("%TRANSITIONOUT%").join(outScript);
	saveTextViaOutput(classFilePath, concreteClass);
}
function initPagesClass(frameworkPagesPath, projectPath, classes, classPackage)
{
	var classFolderPath = projectPath + "/" + classes + "/" + (classPackage.split(".").join("/"));
	var classFilePath = classFolderPath + "/Pages.as";
	FLfile.copy(frameworkPagesPath, classFilePath);
	var classText = FLfile.read(classFilePath);
	classText = classText.split("PACKAGENAME").join(classPackage);
	saveTextViaOutput(classFilePath, classText);
}
function updatePagesClass(pagesPath, language, constants)
{
	if (fl.fileExists(pagesPath))
	{
		var code = FLfile.read(pagesPath);
		var from = code.indexOf("{", code.indexOf("Pages"));
		var to;
		if (language == "AS3") to = code.indexOf("\t}");
		else to = code.indexOf("}");
		if (from > -1 && to > -1)
		{
			var before = code.substr(0, from + 1);
			var after = code.substr(to, code.length);
			code = before + unescape(constants) + after;
			saveTextViaOutput(pagesPath, code);
			return true;
		}
	}
	return false;
}
function scaffoldExcludeXML(projectPath, source, fileName)
{
	FLfile.copy(projectPath + "/templates/exclude.xml", projectPath + "/" + source + "/" + fileName + "_exclude.xml");
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