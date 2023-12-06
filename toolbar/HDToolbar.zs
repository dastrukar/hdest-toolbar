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
