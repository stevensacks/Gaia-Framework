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

function scaffoldSEOFile(indexPath, deployPath, seoName, siteTitle, pageTitle, pageBranch, seoMenu) 
{
	fl.outputPanel.clear();
	var seoPath = deployPath + "/" + seoName;
	var projectIndexPath = deployPath + "/index.html";
	var html;
	var swfObject = getIndexSWFObject(projectIndexPath);
	if (fl.fileExists(seoPath) && pageBranch != "index") 
	{
		html = seoInject(seoPath, siteTitle, pageTitle, pageBranch, seoMenu, swfObject);
	}
	else
	{
		var css = getIndexCSS(projectIndexPath);
		var thePath = (pageBranch == "index") ? projectIndexPath : indexPath;
		html = indexInject(projectIndexPath, siteTitle, pageTitle, pageBranch, seoMenu, swfObject, css, seoName);
	}
	var seoFolder = seoPath.split("/").slice(0, seoPath.split("/").length - 1).join("/");
	if (!FLfile.exists(seoFolder)) FLfile.createFolder(seoFolder);
	saveTextViaOutput(seoPath, html);
}
function getIndexCSS(indexPath)
{
	var html = FLfile.read(indexPath);
	var startIndex = html.indexOf('<style type="text/css">');
	var endIndex = html.indexOf('</style>', startIndex);
	return html.substring(startIndex, endIndex);
}
function getIndexSWFObject(indexPath)
{
	var html = FLfile.read(indexPath);
	var startIndex = html.indexOf('var params = {');
	var endIndex = html.indexOf('attributes);', startIndex);
	return html.substring(startIndex, endIndex);
}
function indexInject(projectIndexPath, siteTitle, pageTitle, pageBranch, seoMenu, swfObject, css, seoName)
{
	var html = FLfile.read(projectIndexPath);
	if (pageBranch == "index" && html.indexOf('<link rel="alternate" type="application/rss+xml" title="Sitemap" href="sitemap.xml"/>') == -1)
	{
		html = html.split('<head>').join('<head>\n<link rel="alternate" type="application/rss+xml" title="Sitemap" href="sitemap.xml"/>');
	}
	//
	if (html.indexOf("<!--SEO-->") > -1)
	{
		var seoText = "";
		seoText += "<div id=\"alternateContent\">\n";
		seoText += "\t\t\t<h1>" + siteTitle + "</h1>\n";
		seoText += "\t\t\t<h2>" + pageTitle + "</h2>\n";
		seoText += unescape(seoMenu) + "\n";
		seoText += '\t\t\t<div id="copy">\n';
		seoText += '\t\t\t\t<p id="sample">Sample</p>\n';
		seoText += "\t\t\t</div>\n";
		seoText += "\t\t</div>";
		html = html.split("<!--SEO-->").join(seoText);
	}
	else
	{
		html = updateExistingSEO(html, siteTitle, pageTitle, seoMenu);
	}
	//
	// css
	var startIndex = html.indexOf('<style type="text/css">');
	var endIndex = html.indexOf('</style>', startIndex);
	var before = html.substring(0, startIndex);
	var after = html.substring(endIndex);
	html = before + css + after;
	//
	// swfobject
	html  = writeSWFObject(html, swfObject);
	//
	if (pageBranch != "index")
	{
		html = writeBranch(html, pageBranch);
		html = html.split('index.html?detectflash=false').join(seoName + '?detectflash=false');
	}
	return html;
}
function seoInject(seoPath, siteTitle, pageTitle, pageBranch, seoMenu, swfObject)
{
	var html = FLfile.read(seoPath);
	html = updateExistingSEO(html, siteTitle, pageTitle, seoMenu);
	html = writeSWFObject(html, swfObject);
	html = writeBranch(html, pageBranch);
	return html;
}
function updateExistingSEO(html, siteTitle, pageTitle, seoMenu)
{
	var baseTag = '<div id="alternateContent">';
	if (html.indexOf(baseTag) > -1)
	{
		// h1
		var htmlUpdate = updateTagValue(html, baseTag, "h1", siteTitle);
		if (htmlUpdate.length > 0) html = htmlUpdate;
		// h2
		htmlUpdate = updateTagValue(html, baseTag, "h2", pageTitle);
		if (htmlUpdate.length > 0) html = htmlUpdate;
		// menu
		htmlUpdate = updateMenu(html, baseTag, seoMenu);
		if (htmlUpdate.length > 0) html = htmlUpdate;
	}
	return html;
}
function updateTagValue(html, baseTag, tag, newValue)
{
	var baseIndex = html.indexOf(baseTag);
	var fromIndex = html.indexOf("<" + tag + ">", baseIndex) + tag.length + 2;
	var toIndex = html.indexOf("</" + tag + ">", fromIndex);
	if (baseIndex == -1 || fromIndex == -1 || toIndex == -1) return "";
	var beforeHtml = html.substring(0, fromIndex);
	var afterHtml = html.substring(toIndex);
	html = beforeHtml + newValue + afterHtml;
	return html;
}
function updateMenu(html, baseTag, menu)
{
	var baseIndex = html.indexOf(baseTag);
	var fromIndex = html.indexOf('            <ul id="sitenav">', baseIndex);
	var toIndex = html.indexOf("</ul>", fromIndex) + 5;
	if (baseIndex == -1 || fromIndex == -1 || toIndex == -1) return "";
	var beforeHtml = html.substring(0, fromIndex);
	var afterHtml = html.substring(toIndex);
	html = beforeHtml + unescape(menu) + afterHtml;
	return html;
}
function writeSWFObject(html, swfObject)
{
	startIndex = html.indexOf('var params = {');
	endIndex = html.indexOf('attributes);', startIndex);
	before = html.substring(0, startIndex);
	after = html.substring(endIndex);
	html = before + swfObject + after;
	return html;
}
function writeBranch(html, pageBranch)
{
	var startIndex = html.indexOf('var flashvars = {') + 17;
	var endIndex = html.indexOf("}", startIndex);
	var currentVars = html.substring(startIndex, endIndex);
	var before, after, branchVar;
	var branchIndex = html.indexOf('branch: "');
	if (branchIndex == -1)
	{
		before = html.substring(0, startIndex);
		after = html.substring(endIndex - currentVars.length);
		branchVar = '\n\t\tbranch: "' + pageBranch + '"';
		if (currentVars.indexOf(":") > -1) branchVar += ",";
		else branchVar += '\n\t';
	}
	else
	{
		startIndex = branchIndex + 9;
		endIndex = html.indexOf('"', startIndex);
		before = html.substring(0, startIndex);
		after = html.substring(endIndex);
		branchVar = pageBranch;
	}
	html = before + branchVar + after;
	return html;
}
function generateSiteMap(deployPath, siteMap)
{
	saveTextViaOutput(deployPath + "/sitemap.xml", unescape(siteMap));
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