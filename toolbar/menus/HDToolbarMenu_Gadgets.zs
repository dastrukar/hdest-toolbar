class HDToolbarMenu_Gadgets : HDToolbarMenu
{
	override void Init(HDToolbar toolbar)
	{
		Buttons.Clear();
		Buttons.Push("<< Prev. Menu");
		Buttons.Push("* D.E.R.P >>");
		Buttons.Push("* H.E.R.P");
		Buttons.Push("* IED >>");
		Buttons.Push("* Door Buster >>");
	}

	override void PressButton(HDToolbar toolbar)
	{
		switch (toolbar.Selected)
		{
			case 0:
				toolbar.SwitchMenu("HDToolbarMenu_Main");
				break;

			case 1:
				toolbar.SwitchMenu("HDToolbarMenu_GadgetsDERP");
				break;

			case 3:
				toolbar.SwitchMenu("HDToolbarMenu_GadgetsIED");
				break;

			case 4:
				toolbar.SwitchMenu("HDToolbarMenu_GadgetsDB");
				break;
		}
	}
}

class HDToolbarMenu_GadgetsDERP : HDToolbarMenu
{
	override void Init(HDToolbar toolbar)
	{
		Buttons.Clear();
		Buttons.Push("<< Prev. Menu");
		Buttons.Push("* Equip D.E.R.P");
		Buttons.Push("* Equip Controller");
		Buttons.Push("* Set all D.E.R.Ps to WAIT");
		Buttons.Push("* Set all D.E.R.Ps to LINE");
		Buttons.Push("* Set all D.E.R.Ps to TURRET");
		Buttons.Push("* Set all D.E.R.Ps to PATROL");
		Buttons.Push("* Stick D.E.R.P to wall");
		Buttons.Push("* Activate all wall D.E.R.Ps");
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
				if (!UseItem(hdp, "DERPUsable"))
					hdp.A_Log("You don't have any D.E.R.Ps.", true);

				toolbar.ToggleToolbar();
				break;

			case 2:
				EventHandler.SendNetworkEvent("derp", 1024);
				toolbar.ToggleToolbar();
				break;

			case 3:
				EventHandler.SendNetworkEvent("derp", DERP_IDLE);
				toolbar.ToggleToolbar();
				break;

			case 4:
				EventHandler.SendNetworkEvent("derp", DERP_WATCH);
				toolbar.ToggleToolbar();
				break;

			case 5:
				EventHandler.SendNetworkEvent("derp", DERP_TURRET);
				toolbar.ToggleToolbar();
				break;

			case 6:
				EventHandler.SendNetworkEvent("derp", DERP_PATROL);
				toolbar.ToggleToolbar();
				break;

			case 7:
				EventHandler.SendNetworkEvent("derp", 555);
				toolbar.ToggleToolbar();
				break;

			case 8:
				EventHandler.SendNetworkEvent("derp", 556);
				toolbar.ToggleToolbar();
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

class HDToolbarMenu_GadgetsDB : HDToolbarMenu
{
	override void Init(HDToolbar toolbar)
	{
		Buttons.Clear();
		Buttons.Push("<< Prev. Menu");
		Buttons.Push("* Deploy Door Buster");
		Buttons.Push("* Activate all Door Busters");
		Buttons.Push("* Query Door Busters");
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
				if (!UseItem(hdp, "DoorBuster"))
					hdp.A_Log("You don't have any Door Busters.", true);

				toolbar.ToggleToolbar();
				break;

			case 2:
				EventHandler.SendNetworkEvent("doorbuster", 999);
				toolbar.ToggleToolbar();
				break;

			case 3:
				EventHandler.SendNetworkEvent("doorbuster", 123);
				toolbar.ToggleToolbar();
				break;
		}
	}
}
