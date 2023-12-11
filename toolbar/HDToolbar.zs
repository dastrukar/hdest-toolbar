class HDToolbar : Inventory
{
	bool Enabled;
	int Selected;
	HDToolbarMenu Menu;

	override void Tick()
	{
		if (!Owner || !Enabled || !Menu)
			return;

		if (Owner.Health <= 0)
		{
			ToggleToolbar();
			return;
		}
	}

	void ToggleToolbar()
	{
		Enabled = !Enabled;
		if (!Enabled)
			return;

		SwitchMenu("HDToolbarMenu_Main"); // if you want to override this, just use SwitchMenu again after the toggle
	}

	void SwitchMenu(string menuName)
	{
		Menu = HDToolbarMenu(new(menuName));
		Menu.Init(self);
	}
}
