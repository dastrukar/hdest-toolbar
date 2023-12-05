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
		Buttons.Push("* Medical >>");
		Buttons.Push("* Purge Useless Ammo");
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
				toolbar.SwitchMenu("HDToolbarMenu_Medical");
				break;

			case 3:
				EventHandler.SendNetworkEvent("hd_purge");
				toolbar.ToggleToolbar();
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
				toolbar.SwitchMenu("HDToolbarMenu_Main");
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
			return;

		PointerPos = (Screen.GetWidth() / 2, Screen.GetHeight() / 2);
		_PlayerPitch = Owner.Player.mo.Pitch;
		_PlayerAngle = Owner.Player.mo.Angle;
		SwitchMenu("HDToolbarMenu_Main"); // if you want to override this, just use SwitchMenu again after the toggle
	}

	void SwitchMenu(string menuName)
	{
		Menu = HDToolbarMenu(new(menuName));
		Menu.Init();
	}
}
