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
				toolbar.SwitchMenu("HDToolbarMenu_Main");
				break;

			case 3:
				toolbar.SwitchMenu("HDToolbarMenu_GadgetsIED");
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
		let hdp = HDPlayerPawn(toolbar.Owner);
		switch (toolbar.Selected)
		{
			case 0:
				toolbar.SwitchMenu("HDToolbarMenu_Gadgets");
				break;

			case 1:
				if (!UseItem(hdp, "HDIEDKit"))
					hdp.A_Log("You don't have any IED kits.", true);

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

