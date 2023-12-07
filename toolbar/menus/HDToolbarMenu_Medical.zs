class HDToolbarMenu_Medical : HDToolbarMenu
{
	override void Init(HDToolbar toolbar)
	{
		Buttons.Clear();
		Buttons.Push("<< Prev. Menu");
		Buttons.Push("* Medikit");
		Buttons.Push("* Stimpack");
		Buttons.Push("* Bandage");
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
					hdp.A_Log("You don't have a medikit.", true);

				toolbar.ToggleToolbar();
				break;

			case 2:
				if (!UseItem(hdp, "PortableStimpack"))
					hdp.A_Log("You don't have a stimpack.", true);

				toolbar.ToggleToolbar();
				break;

			case 3:
				if (!UseItem(hdp, "SelfBandage") && !UseItem(hdp, "UaS_SelfBandage"))
					hdp.A_Log("Error: Couldn't find SelfBandage or UaS_Bandage.", true);

				toolbar.ToggleToolbar();
				break;
		}
	}
}
