class HDToolbar : Inventory
{
	bool Enabled;
	int Selected;
	Vector2 PointerPos;
	HDToolbarMenu Menu;

	override void BeginPlay()
	{
		PointerPos = (0, 0);
	}

	override void Tick()
	{
		if (!Owner || !Enabled || !Menu)
			return;

		if (Owner.Health <= 0)
		{
			ToggleToolbar();
			return;
		}

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

	void ToggleToolbar()
	{
		Enabled = !Enabled;
		if (!Enabled)
			return;

		PointerPos = (Screen.GetWidth() / 2, Screen.GetHeight() / 2);
		SwitchMenu("HDToolbarMenu_Main"); // if you want to override this, just use SwitchMenu again after the toggle
	}

	void SwitchMenu(string menuName)
	{
		Menu = HDToolbarMenu(new(menuName));
		Menu.Init(self);
	}
}
