class HDToolbarMenu_Gadgets : HDToolbarMenu
{
	enum ToolbarGadgets
	{
		TOOLBARGADGETS_PREV,
		TOOLBARGADGETS_DERP,
		TOOLBARGADGETS_HERP,
		TOOLBARGADGETS_IED,
		TOOLBARGADGETS_DOOR,
	};

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
			case TOOLBARGADGETS_PREV:
				toolbar.SwitchMenu("HDToolbarMenu_Main");
				break;

			case TOOLBARGADGETS_DERP:
				toolbar.SwitchMenu("HDToolbarMenu_GadgetsDERP");
				break;

			case TOOLBARGADGETS_HERP:
				toolbar.SwitchMenu("HDToolbarMenu_GadgetsHERP");
				break;

			case TOOLBARGADGETS_IED:
				toolbar.SwitchMenu("HDToolbarMenu_GadgetsIED");
				break;

			case TOOLBARGADGETS_DOOR:
				toolbar.SwitchMenu("HDToolbarMenu_GadgetsDB");
				break;
		}
	}
}

class HDToolbarMenu_GadgetsDERP : HDToolbarMenu
{
	enum ToolbarGadgets_DERP
	{
		TOOLBARGADGETS_DERP_PREV,
		TOOLBARGADGETS_DERP_EQUIPDERP,
		TOOLBARGADGETS_DERP_EQUIPCONT,
		TOOLBARGADGETS_DERP_HACK,
		TOOLBARGADGETS_DERP_WAIT,
		TOOLBARGADGETS_DERP_LINE,
		TOOLBARGADGETS_DERP_TURRET,
		TOOLBARGADGETS_DERP_PATROL,
		TOOLBARGADGETS_DERP_COME,
		TOOLBARGADGETS_DERP_GO,
		TOOLBARGADGETS_DERP_WALL,
		TOOLBARGADGETS_DERP_WALLACTIVATE,
	}

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
			case TOOLBARGADGETS_DERP_PREV:
				toolbar.SwitchMenu("HDToolbarMenu_Gadgets");
				break;

			case TOOLBARGADGETS_DERP_EQUIPDERP:
				if (!UseItem(hdp, "DERPUsable"))
					hdp.A_Log("You don't have any D.E.R.Ps.", true);

				toolbar.ToggleToolbar();
				break;

			case TOOLBARGADGETS_DERP_EQUIPCONT:
				cmd = 1024;
				break;

			case TOOLBARGADGETS_DERP_HACK:
				EventHandler.SendNetworkEvent("derphack");
				break;

			case TOOLBARGADGETS_DERP_WAIT:
				cmd = DERP_IDLE;
				break;

			case TOOLBARGADGETS_DERP_LINE:
				cmd = DERP_WATCH;
				break;

			case TOOLBARGADGETS_DERP_TURRET:
				cmd = DERP_TURRET;
				break;

			case TOOLBARGADGETS_DERP_PATROL:
				cmd = DERP_PATROL;
				break;

			case TOOLBARGADGETS_DERP_COME:
				cmd = DERP_HEEL;
				break;

			case TOOLBARGADGETS_DERP_GO:
				cmd = DERP_GO;
				break;

			case TOOLBARGADGETS_DERP_WALL:
				cmd = 555;
				break;

			case TOOLBARGADGETS_DERP_WALLACTIVATE:
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
	enum ToolbarGadgets_HERP
	{
		TOOLBARGADGETS_HERP_PREV,
		TOOLBARGADGETS_HERP_EQUIPHERP,
		TOOLBARGADGETS_HERP_EQUIPCONT,
		TOOLBARGADGETS_HERP_HACK,
		TOOLBARGADGETS_HERP_ON,
		TOOLBARGADGETS_HERP_OFF,
		TOOLBARGADGETS_HERP_QUERY,
	};

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
			case TOOLBARGADGETS_HERP_PREV:
				toolbar.SwitchMenu("HDToolbarMenu_Gadgets");
				break;

			case TOOLBARGADGETS_HERP_EQUIPHERP:
				if (!UseItem(hdp, "HERPUsable"))
					hdp.A_Log("You don't have any H.E.R.P.s.");

				toolbar.ToggleToolbar();
				break;

			case TOOLBARGADGETS_HERP_EQUIPCONT:
				if (!UseItem(hdp, "HERPController"))
					hdp.A_Log("H.E.R.P. Controller unavailable.");

				toolbar.ToggleToolbar();
				break;

			case TOOLBARGADGETS_HERP_HACK:
				EventHandler.SendNetworkEvent("herphack");
				break;

			case TOOLBARGADGETS_HERP_ON:
				cmd = HERPC_ON;
				break;

			case TOOLBARGADGETS_HERP_OFF:
				cmd = HERPC_OFF;
				break;

			case TOOLBARGADGETS_HERP_QUERY:
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
	enum ToolbarGadgets_IED
	{
		TOOLBARGADGETS_IED_PREV,
		TOOLBARGADGETS_IED_DEPLOY,
		TOOLBARGADGETS_IED_KABOOM,
		TOOLBARGADGETS_IED_PASSIVE,
		TOOLBARGADGETS_IED_ACTIVE,
		TOOLBARGADGETS_IED_QUERY,
	};

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
			case TOOLBARGADGETS_IED_PREV:
				toolbar.SwitchMenu("HDToolbarMenu_Gadgets");
				break;

			case TOOLBARGADGETS_IED_DEPLOY:
				if (!UseItem(hdp, "HDIEDKit"))
					hdp.A_Log("You don't have any IED kits.", true);

				break;

			case TOOLBARGADGETS_IED_KABOOM:
				cmd = 999;
				break;

			case TOOLBARGADGETS_IED_PASSIVE:
				cmd = 2;
				break;

			case TOOLBARGADGETS_IED_ACTIVE:
				cmd = 1;
				break;

			case TOOLBARGADGETS_IED_QUERY:
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
	enum ToolbarGadgets_Door
	{
		TOOLBARGADGETS_DOOR_PREV,
		TOOLBARGADGETS_DOOR_DEPLOY,
		TOOLBARGADGETS_DOOR_KABOOM,
		TOOLBARGADGETS_DOOR_QUERY,
	};

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
			case TOOLBARGADGETS_DOOR_PREV:
				toolbar.SwitchMenu("HDToolbarMenu_Gadgets");
				break;

			case TOOLBARGADGETS_DOOR_DEPLOY:
				if (!UseItem(hdp, "DoorBuster"))
					hdp.A_Log("You don't have any Door Busters.", true);

				toolbar.ToggleToolbar();
				break;

			case TOOLBARGADGETS_DOOR_KABOOM:
				EventHandler.SendNetworkEvent("doorbuster", 999);
				toolbar.ToggleToolbar();
				break;

			case TOOLBARGADGETS_DOOR_QUERY:
				EventHandler.SendNetworkEvent("doorbuster", 123);
				toolbar.ToggleToolbar();
				break;
		}
	}
}
