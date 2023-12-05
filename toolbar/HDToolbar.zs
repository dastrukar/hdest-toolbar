class HDToolbarMenu play abstract
{
	Array<string> Buttons;

	virtual void Init() {}
	virtual void PressButton(HDToolbar toolbar) {}
}

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
				toolbar.SwitchMenu("HDToolbarMenu_Medical", "toolbar/open1");
				break;

			case 4:
				toolbar.SwitchMenu("HDToolbarMenu_Gadgets", "toolbar/open1");
				break;
		}
	}
}

class HDToolbarMenu_Medical : HDToolbarMenu
{
	override void Init()
	{
		Buttons.Clear();
		Buttons.Push("<< Prev. Menu");
		Buttons.Push("* Medikit");
		Buttons.Push("* Stimpack");
		Buttons.Push("* Bandage");
	}

	override void PressButton(HDToolbar toolbar)
	{
		switch (toolbar.Selected)
		{
			case 0:
				toolbar.SwitchMenu("HDToolbarMenu_Main", "toolbar/reject");
				break;

			case 1:
				let portableMedikit = toolbar.Owner.FindInventory("PortableMedikit");
				let secondFlesh = toolbar.Owner.FindInventory("HDMedikitter");
				if (!portableMedikit && !secondFlesh)
					toolbar.Owner.A_Log("You don't have a medikit.", true);

				else if (portableMedikit)
					toolbar.Owner.UseInventory(portableMedikit);

				else if (secondFlesh)
					toolbar.Owner.UseInventory(secondFlesh);

				toolbar.ToggleToolbar();
				break;

			case 2:
				let stim = toolbar.Owner.FindInventory("PortableStimpack");
				if (!stim)
					toolbar.Owner.A_Log("You don't have a stimpack.", true);

				else
					toolbar.Owner.UseInventory(stim);

				toolbar.ToggleToolbar();
				break;
		}
	}
}

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

class HDToolbar : Inventory
{
	private int _Timeout;
	private float _PlayerPitch;
	private float _PlayerAngle;

	bool Enabled;
	int Selected;
	Vector2 PointerPos;
	Array<string> Buttons;
	HDToolbarMenu Menu;

	override void BeginPlay()
	{
		PointerPos = (0, 0);
		_Timeout = 0;
	}

	override void DoEffect()
	{
		if (!Owner || !Enabled || !Menu)
			return;

		GetPlayerInput();

		// check which button is selected
		float buttonSize = 30;
		float buttonHeight = Screen.GetHeight() / 2 + buttonSize - 7;
		int prevSel = Selected;
		for (int i = 0; i < Menu.Buttons.Size(); i++)
		{
			if (PointerPos.y < buttonHeight)
			{
				Selected = i;
				break;
			}

			// if no other button was selected, then the last button is probably selected
			// this is done because the mouse might've moved faster than expected
			if (i + 1 >= Menu.Buttons.Size())
				Selected = i;

			buttonHeight += buttonSize;
		}

		if (prevSel != Selected)
			Owner.A_StartSound("toolbar/select", CHAN_BODY, CHANF_UI | CHANF_LOCAL);
	}

	// mouse input code somewhat based on Gearbox's
	// also ripped from my Ugly as Sin wheel input code lol
	private void GetPlayerInput()
	{
		Vector2 motion = (
			Round(Owner.Player.cmd.Yaw * -0.08),
			Round(Owner.Player.cmd.Pitch * -0.08)
		);

		Owner.Player.mo.Pitch = _PlayerPitch;
		Owner.Player.mo.Angle = _PlayerAngle;
		Owner.Player.cmd.Pitch = 0;
		Owner.Player.cmd.Yaw = 0;

		// apparently, NaN == NaN returns false.... why???
		// but if motion.x is NaN, motion.x != motion.x returns true???? wtf
		if (!(motion.x != motion.x)) { PointerPos.x += motion.x; }
		if (!(motion.y != motion.y)) { PointerPos.y += motion.y; }

		PointerPos.x = Clamp(PointerPos.x, 0, Screen.GetWidth());
		PointerPos.y = Clamp(PointerPos.y, 0, Screen.GetHeight());
	}

	void ToggleToolbar()
	{
		Enabled = !Enabled;
		if (!Enabled)
		{
			Owner.A_StartSound("toolbar/accept", CHAN_BODY, CHANF_UI | CHANF_LOCAL);
			return;
		}

		PointerPos = (Screen.GetWidth() / 2, Screen.GetHeight() / 2);
		_PlayerPitch = Owner.Player.mo.Pitch;
		_PlayerAngle = Owner.Player.mo.Angle;
		SwitchMenu("HDToolbarMenu_Main", "toolbar/open0"); // if you want to override this, just use SwitchMenu again after the toggle
	}

	void SwitchMenu(string menuName, string playSound)
	{
		Owner.A_StartSound(playSound, CHAN_BODY, CHANF_UI | CHANF_LOCAL);
		Menu = HDToolbarMenu(new(menuName));
		Menu.Init();
	}
}
