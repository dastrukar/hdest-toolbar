// and also handles the UI
const TRANSITION_FRAMES = 10;

class HDToolbarHandler : EventHandler
{
	ui private int _Frames;

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

		HDToolbarMenu currentMenu = toolbar.Menu;

		if (e.Name == "hd_toolbar")
			toolbar.ToggleToolbar();

		else if (toolbar.Enabled)
		{
			bool justPressed = false;
			if (e.Name == "hd_toolbar_accept" && toolbar.Enabled)
			{
				justPressed = true;
				currentMenu.PressButton(toolbar);
			}
			else if (e.Name == "hd_toolbar_reject" && toolbar.Enabled)
			{
				justPressed = true;
				toolbar.Selected = 0;
				currentMenu.PressButton(toolbar);
			}

			if (justPressed && toolbar.Enabled)
				EventHandler.SendInterfaceEvent(ConsolePlayer, "hd_toolbar_setframe", 0);
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

	override void InterfaceProcess(ConsoleEvent e)
	{
		if (e.IsManual)
			return;

		if (e.Name == "hd_toolbar_setframe")
		{
			_Frames = e.Args[0];
		}
	}

	override void RenderOverlay(RenderEvent e)
	{
		let hdp = HDPlayerPawn(Statusbar.CPlayer.mo);
		if (!hdp)
			return;

		let toolbar = HDToolbar(hdp.FindInventory("HDToolbar"));
		if (!toolbar || !toolbar.Menu)
			return;

		if (_Frames > TRANSITION_FRAMES || _Frames < 0)
			_Frames = 0;

		if (toolbar.Enabled && _Frames < TRANSITION_FRAMES)
			++_Frames;

		else if (!toolbar.Enabled && _Frames > 0)
			--_Frames;

		if (_Frames <= 0)
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
			float scale = _Frames / float(TRANSITION_FRAMES);
			Screen.DrawThickLine(
				drawPos.x - 10, drawPos.y + 8 * scale,
				drawPos.x + 300 * scale, drawPos.y + 8 * scale,
				25 * scale,
				(toolbar.Enabled && toolbar.Selected == i)? Statusbar.CPlayer.GetDisplayColor() : Color(255, 20, 20, 20),
				190
			);
			Screen.DrawText(
				NewSmallFont,
				OptionMenuSettings.mFontColorValue,
				drawPos.x, drawPos.y,
				toolbar.Menu.Buttons[i],
				DTA_SCALEX, scale,
				DTA_SCALEY, scale
			);

			drawPos.y += 30 * scale;
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
