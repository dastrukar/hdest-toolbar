class HDToolbarMenu_Main : HDToolbarMenu
{
	override void Init()
	{
		Buttons.Clear();
		Buttons.Push("<< Close Menu");
		Buttons.Push("* Strip/Wear Armour");
		Buttons.Push("* Purge Useless Ammo");
		Buttons.Push("* Medical >>");
		Buttons.Push("* Gadgets >>");
	}

	override void PressButton(HDToolbar toolbar)
	{
		switch (toolbar.Selected)
		{
			case 0:
				toolbar.ToggleToolbar();
				break;

			case 1:
				EventHandler.SendNetworkEvent("hd_strip");
				break;

			case 2:
				EventHandler.SendNetworkEvent("hd_purge");
				toolbar.ToggleToolbar();
				break;

			case 3:
				toolbar.SwitchMenu("HDToolbarMenu_Medical");
				break;

			case 4:
				toolbar.SwitchMenu("HDToolbarMenu_Gadgets");
				break;
		}
	}
}
