class HDToolbarMenu_Medical : HDToolbarMenu
{
	override void Init(HDToolbar toolbar)
	{
		Buttons.Clear();
		Buttons.Push("<< Prev. Menu");
		Buttons.Push("* Medikit");
		Buttons.Push("* Stimpack");
		Buttons.Push("* Bandage");
		Buttons.Push("* Potion");
		Buttons.Push("* Berserk Pack");
		Buttons.Push("* Shield Core");
	}

	override void PressButton(HDToolbar toolbar)
	{
		let hdp = HDPlayerPawn(toolbar.Owner);
		switch (toolbar.Selected)
		{
			case 0:
				toolbar.SwitchMenu("HDToolbarMenu_Main");
				break;

			case 1:
				if (!UseItem(hdp, "PortableMedikit") && !UseItem(hdp, "HDMedikitter"))
					hdp.A_Log("You don't have any medikits.", true);

				toolbar.ToggleToolbar();
				break;

			case 2:
				if (!UseItem(hdp, "PortableStimpack"))
					hdp.A_Log("You don't have any stimpacks.", true);

				toolbar.ToggleToolbar();
				break;

			case 3:
				if (!UseItem(hdp, "SelfBandage") && !UseItem(hdp, "UaS_SelfBandage"))
					hdp.A_Log("Error: Couldn't find SelfBandage or UaS_Bandage.", true);

				toolbar.ToggleToolbar();
				break;

			case 4:
				if (!UseItem(hdp, "HDHealingPotion"))
					hdp.A_Log("You don't have any potions.", true);

				toolbar.ToggleToolbar();
				break;

			case 5:
				if (!UseItem(hdp, "PortableBerserkPack"))
					hdp.A_Log("You don't have any berserk packs.", true);

				toolbar.ToggleToolbar();
				break;

			case 6:
				if (!UseItem(hdp, "ShieldCore"))
					hdp.A_Log("You don't have any shield cores.", true);

				toolbar.ToggleToolbar();
				break;
		}
	}
}
