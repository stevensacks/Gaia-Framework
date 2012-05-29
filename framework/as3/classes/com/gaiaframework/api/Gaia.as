/*****************************************************************************************************
* Gaia Framework for Adobe Flash ©2007-2009
* Author: Steven Sacks
*
* blog: http://www.stevensacks.net/
* git: https://github.com/stevensacks/Gaia-Framework
* support: http://gaiaflashframework.tenderapp.com/
* 
* By using the Gaia Framework, you agree to keep the above contact information in the source code.
* 
* Gaia Framework for Adobe Flash is released under the MIT License:
* http://www.opensource.org/licenses/mit-license.php 
*****************************************************************************************************/

package com.gaiaframework.api
{
	import com.gaiaframework.core.gaia_internal;

	/**
	 * The Gaia class is a Bridge that contains a reference to the Gaia API.
	 * It also contains constants for depth, flows and ApplicationDomain.
	 * 
	 * @author Steven Sacks
	 */
	public class Gaia
	{
		use namespace gaia_internal;		
		gaia_internal static var impl:IGaia;
		
		/**
		 * Top depth container is above middle and bottom.
		 */
		public static const TOP:String = "top";
		/**
		 * Middle depth container is below top and above bottom.
		 */
		public static const MIDDLE:String = "middle";
		/**
		 * Bottom depth container is below middle.
		 */
		public static const BOTTOM:String = "bottom";
		/**
		 * Preloader depth is above top by default and can be set in the <code>site.xml</code> to appear anywhere.
		 */
		public static const PRELOADER:String = "preloader";
		/**
		 * Nested means the page or asset will load into its parent.
		 * 
		 * @see http://www.gaiaflashframework.com/wiki/index.php?title=Site_XML#depth Depth Documentation
		 */
		public static const NESTED:String = "nested";
		
		/**
		 * Normal Flow
		 * Transition Out -> Preload -> Transition In
		 */
		public static const NORMAL:String = "normal";
		/**
		 * Preload Flow
		 * Preload -> Transition Out -> Transition In
		 */
		public static const PRELOAD:String = "preload";
		/**
		 * Reverse Flow
		 * Preload -> Transition In -> Transition Out
		 */
		public static const REVERSE:String = "reverse";
		/**
		 * Cross Flow
		 * Preload -> Transition Out + Transition In
		 */
		public static const CROSS:String = "cross";
		
		/**
		 * ApplicationDomain documentation is out of the scope of this documentation.  Check out the Roger Gonzales post for more information.
		 * 
		 * @see http://blogs.adobe.com/rgonzalez/2006/06/applicationdomain.html Roger Gonzales: ApplicationDomain 
		 */
		public static const DOMAIN_CURRENT:String = "current";
		/**
		 * Null is the default.
		 */
		public static const DOMAIN_NULL:String = "null";
		/**
		 * New ApplicationDomain.
		 */
		public static const DOMAIN_NEW:String = "new";
		
		/**
		 * Gaia.api is how you access the Gaia API methods.
		 */
		public static function get api():IGaia
		{
			return impl;
		}
	}
}