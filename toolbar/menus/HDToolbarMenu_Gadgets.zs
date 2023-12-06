class HDToolbarMenu_Gadgets : HDToolbarMenu
{
	override void Init()
	{
		Buttons.Clear();
		Buttons.Push("<< Prev. Menu");
		Buttons.Push("* D.E.R.P");
		Buttons.Push("* H.E.R.P");
		Buttons.Push("* IED >>");
	}

	override void PressButton(HDToolbar toolbar)
	{
		switch (toolbar.Selected)
		{
			case 0:
				toolbar.SwitchMenu("HDToolbarMenu_Main", "toolbar/reject");
				break;

			case 3:
				toolbar.SwitchMenu("HDToolbarMenu_GadgetsIED", "toolbar/open1");
				break;
		}
	}
}

class HDToolbarMenu_GadgetsIED : HDToolbarMenu
{
	override void Init()
	{
		Buttons.Clear();
		Buttons.Push("<< Prev. Menu");
		Buttons.Push("* Deploy IED (id 1)");
		Buttons.Push("* Detonate IEDs (id 1)");
		Buttons.Push("* Deactivate seeking (id 1)");
		Buttons.Push("* Activate seeking (id 1)");
		Buttons.Push("* Query IEDs");
	}

	override void PressButton(HDToolbar toolbar)
	{
		switch (toolbar.Selected)
		{
			case 0:
				toolbar.SwitchMenu("HDToolbarMenu_Main", "toolbar/reject");
				break;

			case 1:
				let ied = toolbar.Owner.FindInventory("HDIEDKit");
				if (!ied)
					toolbar.Owner.A_Log("You don't have any IED kits.", true);

				else
					toolbar.Owner.UseInventory(ied);

				break;

			case 2:
				EventHandler.SendNetworkEvent("ied", 999, 1);
				toolbar.ToggleToolbar();
				break;

			case 3:
				EventHandler.SendNetworkEvent("ied", 2, 1);
				toolbar.ToggleToolbar();
				break;

			case 4:
				EventHandler.SendNetworkEvent("ied", 1, 1);
				toolbar.ToggleToolbar();
				break;

			case 5:
				EventHandler.SendNetworkEvent("ied", 123, 0);
				toolbar.ToggleToolbar();
				break;
		}
	}
}

