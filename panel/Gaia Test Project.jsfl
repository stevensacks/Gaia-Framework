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

function testProject()
{
	var version = fl.version.split(" ")[1].split(",")[0];
	if (version == "10")
	{
		var len = fl.swfPanels.length
		for (var i = 0; i < len; i++)
		{
			if (fl.swfPanels[i].name == "Gaia Framework")
			{
				fl.swfPanels[i].call("publishProject");
				break;
			}
		}
	}
	else
	{
		alert("Gaia Test Project command is not supported in Flash CS3");
	}
}
testProject();