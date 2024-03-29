
	/* MENUS.JS */
	
	var eOpenMenu = null;

	function OpenMenu(eSrc,eMenu)
	{
		
		eMenu.style.left = eSrc.offsetLeft + divMenuBar.offsetLeft;
		eMenu.style.top = divMenuBar.offsetHeight + divMenuBar.offsetTop;
		eMenu.style.visibility = "visible";
		eOpenMenu = eMenu;
	}

	function CloseMenu(eMenu)
	{
		eMenu.style.visibility = "hidden";
		eOpenMenu = null;
	}

	function document.onmouseover()
	{
		var eSrc = window.event.srcElement;
		if ("clsMenuBarItem" == eSrc.className)
		{
			if (eSrc.id=="active-link")
			{
				var eMenu = document.all[eSrc.title.replace("tdMenuBarItem","divMenu")];
			}
			else
			{
				var eMenu = document.all[eSrc.id.replace("tdMenuBarItem","divMenu")];
			}
			if (eOpenMenu && eOpenMenu != eMenu) 
			{
				CloseMenu(eOpenMenu);
			}
			if (eMenu) 
			{
				OpenMenu(eSrc,eMenu);
			}
		}
		else if (eOpenMenu && !eOpenMenu.contains(eSrc) && !divMenuBar.contains(eSrc)) 
		{
			CloseMenu(eOpenMenu);
		}
	}
	
	function document.onmouseout()
	{
		var eSrc = window.event.srcElement;
		if ("clsMenuBarItem" == eSrc.className)
		{
			eSrc.style.color = ""; 
		}
	}	
