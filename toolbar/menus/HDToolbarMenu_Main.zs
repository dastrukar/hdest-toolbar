class HDToolbarMenu_Main : HDToolbarMenu
{
	enum ToolbarMain
	{
		TOOLBARMAIN_CLOSE,
		TOOLBARMAIN_STRIP,
		TOOLBARMAIN_PURGE,
		TOOLBARMAIN_MAG,
		TOOLBARMAIN_MEDICAL,
		TOOLBARMAIN_GADGETS,
	};

	override void Init(HDToolbar toolbar)
	{
		Buttons.Clear();
		Buttons.Push("<< Close Menu");
		Buttons.Push("* Strip/Wear Armour");
		Buttons.Push("* Purge Useless Ammo");
		Buttons.Push("* Mag. Manager");
		Buttons.Push("* Medical >>");
		Buttons.Push("* Gadgets >>");
	}

	override void PressButton(HDToolbar toolbar)
	{
		switch (toolbar.Selected)
		{
			case TOOLBARMAIN_CLOSE:
				toolbar.ToggleToolbar();
				break;

			case TOOLBARMAIN_STRIP:
				EventHandler.SendNetworkEvent("hd_strip");
				break;

			case TOOLBARMAIN_PURGE:
				EventHandler.SendNetworkEvent("hd_purge");
				toolbar.ToggleToolbar();
				break;

			case TOOLBARMAIN_MAG:
				if (toolbar.Owner.Player.WeaponState & WF_USER3OK)
				{
					let psp = toolbar.Owner.Player.GetPSprite(PSP_WEAPON);
					let magState = toolbar.Owner.Player.ReadyWeapon.FindState("user3");
					if (psp && magState)
						psp.SetState(magState);
				}
				else
					toolbar.Owner.A_Log("Unable to switch to Mag. Manager. (weapon not ready)", true);

				toolbar.ToggleToolbar();
				break;

			case TOOLBARMAIN_MEDICAL:
				toolbar.SwitchMenu("HDToolbarMenu_Medical");
				break;

			case TOOLBARMAIN_GADGETS:
				toolbar.SwitchMenu("HDToolbarMenu_Gadgets");
				break;
		}
	}
}
