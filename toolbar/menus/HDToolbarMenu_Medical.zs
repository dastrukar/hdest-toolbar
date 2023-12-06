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
