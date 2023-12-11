class HDToolbarMenu_Gadgets : HDToolbarMenu
{
	override void Init(HDToolbar toolbar)
	{
		Buttons.Clear();
		Buttons.Push("<< Prev. Menu");
		Buttons.Push("* D.E.R.P >>");
		Buttons.Push("* H.E.R.P >>");
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

			case 2:
				toolbar.SwitchMenu("HDToolbarMenu_GadgetsHERP");
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
		Buttons.Push("* Hack D.E.R.P");
		Buttons.Push("* Set all D.E.R.Ps to WAIT");
		Buttons.Push("* Set all D.E.R.Ps to LINE");
		Buttons.Push("* Set all D.E.R.Ps to TURRET");
		Buttons.Push("* Set all D.E.R.Ps to PATROL");
		Buttons.Push("* Set all D.E.R.Ps to COME");
		Buttons.Push("* Set all D.E.R.Ps to GO");
		Buttons.Push("* Stick D.E.R.P to wall");
		Buttons.Push("* Activate all wall D.E.R.Ps");
	}

	override void PressButton(HDToolbar toolbar)
	{
		let hdp = HDPlayerPawn(toolbar.Owner);
		int cmd = 0;
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
				cmd = 1024;
				break;

			case 3:
				EventHandler.SendNetworkEvent("derphack");
				break;

			case 4:
				cmd = DERP_IDLE;
				break;

			case 5:
				cmd = DERP_WATCH;
				break;

			case 6:
				cmd = DERP_TURRET;
				break;

			case 7:
				cmd = DERP_PATROL;
				break;

			case 8:
				cmd = DERP_HEEL;
				break;

			case 9:
				cmd = DERP_GO;
				break;

			case 10:
				cmd = 555;
				break;

			case 11:
				cmd = 556;
				break;
		}

		if (cmd == 0)
			return;

		EventHandler.SendNetworkEvent("derp", cmd);
		toolbar.ToggleToolbar();
	}
}

class HDToolbarMenu_GadgetsHERP : HDToolbarMenu
{
	override void Init(HDToolbar toolbar)
	{
		Buttons.Clear();
		Buttons.Push("<< Prev. Menu");
		Buttons.Push("* Equip H.E.R.P.");
		Buttons.Push("* Equip Controller");
		Buttons.Push("* Hack H.E.R.P.");
		Buttons.Push("* Turn on all H.E.R.P.s");
		Buttons.Push("* Turn off all H.E.R.P.s");
		Buttons.Push("* Query H.E.R.P.s");
	}

	override void PressButton(HDToolbar toolbar)
	{
		let hdp = HDPlayerPawn(toolbar.Owner);
		int cmd = 0;
		switch (toolbar.Selected)
		{
			case 0:
				toolbar.SwitchMenu("HDToolbarMenu_Gadgets");
				break;

			case 1:
				if (!UseItem(hdp, "HERPUsable"))
					hdp.A_Log("You don't have any H.E.R.P.s.");

				toolbar.ToggleToolbar();
				break;

			case 2:
				if (!UseItem(hdp, "HERPController"))
					hdp.A_Log("H.E.R.P. Controller unavailable.");

				toolbar.ToggleToolbar();
				break;

			case 3:
				EventHandler.SendNetworkEvent("herphack");
				break;

			case 4:
				cmd = HERPC_ON;
				break;

			case 5:
				cmd = HERPC_OFF;
				break;

			case 6:
				cmd = 123;
				break;
		}

		if (cmd == 0)
			return;

		toolbar.ToggleToolbar();
		EventHandler.SendNetworkEvent("herp", cmd);
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
		Buttons.Push("* Set IEDs to Passive(id ".._IEDID..")");
		Buttons.Push("* Set IEDs to Active(id ".._IEDID..")");
		Buttons.Push("* Query IEDs");
	}

	override void PressButton(HDToolbar toolbar)
	{
		let hdp = HDPlayerPawn(toolbar.Owner);
		int cmd = 0;
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
				cmd = 999;
				break;

			case 3:
				cmd = 2;
				break;

			case 4:
				cmd = 1;
				break;

			case 5:
				cmd = 123;
				break;
		}

		if (cmd == 0)
			return;

		EventHandler.SendNetworkEvent("ied", cmd, _IEDID);
		toolbar.ToggleToolbar();
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
