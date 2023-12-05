// and also handles the UI
class HDToolbarHandler : EventHandler
{
	override void WorldTick()
	{
		for (int i = 0; i < MAXPLAYERS; i++)
		{
			let hdp = HDPlayerPawn(Players[i].mo);
			if (!hdp)
				continue;

			if (!hdp.CountInv("HDToolbar"))
				hdp.GiveInventory("HDToolbar", 1);
		}
	}

	override void NetworkProcess(ConsoleEvent e)
	{
		let hdp = HDPlayerPawn(Players[e.Player].mo);
		if (!hdp)
			return;

		let toolbar = HDToolbar(hdp.FindInventory("HDToolbar"));
		if (!toolbar)
			return;

		if (e.Name == "hd_toolbar")
			toolbar.ToggleToolbar();

		else if (e.Name == "hd_toolbar_accept" && toolbar.Enabled)
			toolbar.Menu.PressButton(toolbar);

		else if (e.Name == "hd_toolbar_reject" && toolbar.Enabled)
		{
			toolbar.Selected = 0;
			toolbar.Menu.PressButton(toolbar);
		}
	}

	override bool InputProcess(InputEvent e)
	{
		let hdp = HDPlayerPawn(Players[ConsolePlayer].mo);
		if (!hdp)
			return false;

		let toolbar = HDToolbar(hdp.FindInventory("HDToolbar"));
		if (!toolbar || !toolbar.Enabled)
			return false;

		if (e.Type == InputEvent.Type_KeyDown && e.KeyScan == InputEvent.Key_Mouse1)
		{
			EventHandler.SendNetworkEvent("hd_toolbar_accept");
			return true;
		}
		else if (e.Type == InputEvent.Type_KeyDown && e.KeyScan == InputEvent.Key_Mouse2)
		{
			EventHandler.SendNetworkEvent("hd_toolbar_reject");
			return true;
		}

		return false;
	}

	override void RenderOverlay(RenderEvent e)
	{
		let hdp = HDPlayerPawn(Statusbar.CPlayer.mo);
		if (!hdp)
			return;

		let toolbar = HDToolbar(hdp.FindInventory("HDToolbar"));
		if (!toolbar || !toolbar.Enabled || !toolbar.Menu)
			return;

		Vector2 drawPos = (Screen.GetWidth() / 2, Screen.GetHeight() / 2);
		for (int i = 0; i < toolbar.Menu.Buttons.Size(); i++)
		{
			/*
			// collision lines for testing
			Screen.DrawLine(
				drawPos.x, drawPos.y - 7,
				drawPos.x + 300, drawPos.y - 7,
				"white"
			);
			*/
			Screen.DrawThickLine(
				drawPos.x - 10, drawPos.y + 8,
				drawPos.x + 300, drawPos.y + 8,
				25,
				(toolbar.Selected == i)? Color(255, 255, 215, 0) : Color(255, 20, 20, 20),
				190
			);
			Screen.DrawText(
				NewSmallFont,
				OptionMenuSettings.mFontColorValue,
				drawPos.x, drawPos.y,
				toolbar.Menu.Buttons[i]
			);

			drawPos.y += 30;
		}

		// Pointer
		Screen.DrawLine(
			toolbar.PointerPos.x - 20, toolbar.PointerPos.y,
			toolbar.PointerPos.x + 20, toolbar.PointerPos.y,
			"white"
		);
		Screen.DrawLine(
			toolbar.PointerPos.x, toolbar.PointerPos.y - 20,
			toolbar.PointerPos.x, toolbar.PointerPos.y + 20,
			"white"
		);
		Screen.DrawText(
			NewSmallFont,
			OptionMenuSettings.mFontColorValue,
			toolbar.PointerPos.x + 20, toolbar.PointerPos.y + 20,
			"x: "..toolbar.PointerPos.x.."\ny: "..toolbar.PointerPos.y
		);
	}
}
