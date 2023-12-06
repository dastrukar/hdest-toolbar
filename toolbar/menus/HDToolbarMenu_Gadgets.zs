class HDToolbarMenu_Gadgets : HDToolbarMenu
{
	override void Init(HDToolbar toolbar)
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
	private int _IEDID;

	override void Init(HDToolbar toolbar)
	{
		let ied = HDIEDKit(toolbar.Owner.FindInventory("HDIEDKit"));
		_IEDID = (ied)? ied.BotID : 1;

		Buttons.Clear();
		Buttons.Push("<< Prev. Menu");
		Buttons.Push("* Deploy IED (id ".._IEDID..")");
		Buttons.Push("* Detonate IEDs (id ".._IEDID..")");
		Buttons.Push("* Deactivate seeking (id ".._IEDID..")");
		Buttons.Push("* Activate seeking (id ".._IEDID..")");
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
				EventHandler.SendNetworkEvent("ied", 999, _IEDID);
				toolbar.ToggleToolbar();
				break;

			case 3:
				EventHandler.SendNetworkEvent("ied", 2, _IEDID);
				toolbar.ToggleToolbar();
				break;

			case 4:
				EventHandler.SendNetworkEvent("ied", 1, _IEDID);
				toolbar.ToggleToolbar();
				break;

			case 5:
				EventHandler.SendNetworkEvent("ied", 123, _IEDID);
				toolbar.ToggleToolbar();
				break;
		}
	}
}

