// and also handles the UI
const TRANSITION_FRAMES = 10;

class HDToolbarHandler : EventHandler
{
	ui private int _Frames;
	ui private int _Selected;
	ui private Vector2 _PointerPos;

	override void OnRegister()
	{
		RequireMouse = true;
	}

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
		if (!hdp || hdp.Health <= 0)
			return;

		let toolbar = HDToolbar(hdp.FindInventory("HDToolbar"));
		if (!toolbar)
			return;

		HDToolbarMenu oldMenu = toolbar.Menu;

		if (e.Name == "hd_toolbar")
		{
			toolbar.ToggleToolbar();
			string playSound = (toolbar.Enabled)? "toolbar/open0" : "toolbar/accept";
			toolbar.Owner.A_StartSound(playSound, CHAN_BODY, CHANF_UI | CHANF_LOCAL);
			EventHandler.SendInterfaceEvent(e.Player, "hd_toolbar_setselected", 0);
			EventHandler.SendInterfaceEvent(e.Player, "hd_toolbar_setmpos", Screen.GetWidth() / 2, Screen.GetHeight() / 2);
		}
		else if (toolbar.Enabled)
		{
			bool justPressed = false;
			if (e.Name == "hd_toolbar_accept" && toolbar.Enabled)
			{
				justPressed = true;
				toolbar.Selected = e.Args[0];
				toolbar.Menu.PressButton(toolbar);
			}
			else if (e.Name == "hd_toolbar_reject" && toolbar.Enabled)
			{
				justPressed = true;
				toolbar.Selected = 0;
				toolbar.Menu.PressButton(toolbar);
			}

			if (!justPressed)
				return;

			if (toolbar.Enabled)
				EventHandler.SendInterfaceEvent(e.Player, "hd_toolbar_setframe", 0);

			string playSound;
			if (toolbar.Menu == oldMenu)
				playSound = "toolbar/accept";

			else if (toolbar.Menu != oldMenu)
			{
				playSound = (toolbar.Selected == 0)? "toolbar/reject" : "toolbar/open1";

				if (hd_toolbar_resetselection)
				{
					EventHandler.SendInterfaceEvent(e.Player, "hd_toolbar_setselected", 0);
					EventHandler.SendInterfaceEvent(e.Player, "hd_toolbar_setmpos", Screen.GetWidth() / 2, Screen.GetHeight() / 2);
				}
			}

			toolbar.Owner.A_StartSound(playSound, CHAN_BODY, CHANF_UI | CHANF_LOCAL);
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

		if (hd_toolbar_nomouse)
		{
			if (e.Type != InputEvent.Type_KeyDown)
				return false;

			if (hd_toolbar_nomouse_usemovement)
			{
				if (CheckKey(e.KeyScan, "+forward"))
				{
					EventHandler.SendInterfaceEvent(ConsolePlayer, "hd_toolbar_moveselection", -1);
					return true;
				}
				else if (CheckKey(e.KeyScan, "+back"))
				{
					EventHandler.SendInterfaceEvent(ConsolePlayer, "hd_toolbar_moveselection", 1);
					return true;
				}
			}
			else if (hd_toolbar_nomouse_useweaponswap)
			{
				if (e.Type == InputEvent.Type_KeyDown && CheckKey(e.KeyScan, "weapprev"))
				{
					if (hd_toolbar_nomouse_useweaponswap_invert)
						EventHandler.SendInterfaceEvent(ConsolePlayer, "hd_toolbar_moveselection", 1);

					else
						EventHandler.SendInterfaceEvent(ConsolePlayer, "hd_toolbar_moveselection", -1);

					return true;
				}
				else if (e.Type == InputEvent.Type_KeyDown && CheckKey(e.KeyScan, "weapnext"))
				{
					if (hd_toolbar_nomouse_useweaponswap_invert)
						EventHandler.SendInterfaceEvent(ConsolePlayer, "hd_toolbar_moveselection", -1);

					else
						EventHandler.SendInterfaceEvent(ConsolePlayer, "hd_toolbar_moveselection", 1);

					return true;
				}
			}

			if (hd_toolbar_nomouse_useleftright)
			{
				if (CheckKey(e.KeyScan, "+moveleft"))
				{
					EventHandler.SendNetworkEvent("hd_toolbar_reject");
					return true;
				}
				else if (CheckKey(e.KeyScan, "+moveright"))
				{
					EventHandler.SendNetworkEvent("hd_toolbar_accept", _Selected);
					return true;
				}
			}
		}
		else if (e.Type == InputEvent.Type_Mouse)
		{
			EventHandler.SendInterfaceEvent(ConsolePlayer, "hd_toolbar_updatempos", e.MouseX, e.MouseY);
			return true;
		}

		if (hd_toolbar_usefire)
		{
			if (e.Type == InputEvent.Type_KeyDown && CheckKey(e.KeyScan, "+attack"))
			{
				EventHandler.SendNetworkEvent("hd_toolbar_accept", _Selected);
				return true;
			}
			else if (e.Type == InputEvent.Type_KeyDown && CheckKey(e.KeyScan, "+altattack"))
			{
				EventHandler.SendNetworkEvent("hd_toolbar_reject");
				return true;
			}
		}

		return false;
	}

	ui bool CheckKey(int key, string command)
	{
		Array<int> keys;
		Bindings.GetAllKeysForCommand(keys, command);
		for (int i = 0; i < keys.Size(); i++)
		{
			if (keys[i] == key)
				return true;
		}

		return false;
	}

	ui void UpdateSelected(int index, HDToolbar toolbar, bool playSound = true)
	{
		if (playSound)
			StatusBar.CPlayer.mo.A_StartSound("toolbar/select", CHAN_BODY, CHANF_UI | CHANF_LOCAL);

		_Selected = index;

		if (_Selected < 0)
			_Selected = toolbar.Menu.Buttons.Size() - 1;

		else if (_Selected >= toolbar.Menu.Buttons.Size())
			_Selected = 0;
	}

	override void InterfaceProcess(ConsoleEvent e)
	{
		if (e.Name == "hd_toolbar_moveselection")
		{
			let toolbar = HDToolbar(Statusbar.CPlayer.mo.FindInventory("HDToolbar"));
			if (toolbar && toolbar.Enabled)
				UpdateSelected(_Selected + e.Args[0], toolbar);

			return;
		}
		else if (e.Name == "hd_toolbar_accept") // a wrapper for users to use
		{
			EventHandler.SendNetworkEvent("hd_toolbar_accept", _Selected);
			return;
		}

		if (e.IsManual)
			return;

		if (e.Name == "hd_toolbar_setframe")
			_Frames = e.Args[0];

		else if (e.Name == "hd_toolbar_setmpos")
		{
			_PointerPos.x = Clamp(e.Args[0], 0, Screen.GetWidth());
			_PointerPos.y = Clamp(e.Args[1], 0, Screen.GetHeight());
		}
		else if (e.Name == "hd_toolbar_updatempos")
		{
			_PointerPos.x = Clamp(_PointerPos.x + e.Args[0], 0, Screen.GetWidth());
			_PointerPos.y = Clamp(_PointerPos.y - e.Args[1], 0, Screen.GetHeight());
		}
		else if (e.Name == "hd_toolbar_setselected")
			_Selected = e.Args[0];

		else
		{
			Array<string> tokens;
			e.Name.Split(tokens, ":");
			if (tokens.Size() != 2 || tokens[0] != "hd_toolbar_cmd")
				return;

			EventHandler.SendNetworkEvent(tokens[1], e.Args[0], e.Args[1], e.Args[2]);
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

		// Animation frames
		if (_Frames > TRANSITION_FRAMES || _Frames < 0)
			_Frames = 0;

		if (toolbar.Enabled && _Frames < TRANSITION_FRAMES)
			++_Frames;

		else if (!toolbar.Enabled && _Frames > 0)
			--_Frames;

		if (_Frames <= 0)
			return;

		// Buttons
		Vector2 drawPos = (Screen.GetWidth() / 2, Screen.GetHeight() / 2);
		float buttonSize = 30 * hd_toolbar_scale;
		float buttonDrawSize = 25 * hd_toolbar_scale;
		float buttonHeight = Screen.GetHeight() / 2 + buttonSize - 7;
		int tmpSelected = (hd_toolbar_nomouse)? _Selected : -1;
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
			// check which button is selected
			// if no other button was selected, then the last button is probably selected
			// this is done because the mouse might've moved faster than expected
			if (tmpSelected < 0 && (_PointerPos.y < buttonHeight || i + 1 >= toolbar.Menu.Buttons.Size()))
				tmpSelected = i;

			// Draw buttons
			float scale = _Frames / float(TRANSITION_FRAMES);
			Screen.DrawThickLine(
				drawPos.x - 10 * hd_toolbar_scale, drawPos.y + 8 * hd_toolbar_scale * scale,
				drawPos.x + 300 * hd_toolbar_scale * scale, drawPos.y + 8 * hd_toolbar_scale * scale,
				buttonDrawSize * scale,
				(toolbar.Enabled && tmpSelected == i)? Statusbar.CPlayer.GetDisplayColor() : Color(255, 20, 20, 20),
				255 * hd_toolbar_bgalpha
			);
			Screen.DrawText(
				NewSmallFont,
				OptionMenuSettings.mFontColorValue,
				drawPos.x, drawPos.y,
				toolbar.Menu.Buttons[i],
				DTA_SCALEX, hd_toolbar_scale * scale,
				DTA_SCALEY, hd_toolbar_scale * scale,
				DTA_ALPHA, hd_toolbar_fgalpha
			);

			drawPos.y += buttonSize * scale;
			buttonHeight += buttonSize;
		}

		// Update selection
		UpdateSelected(tmpSelected, toolbar, (tmpSelected != _Selected));

		// Pointer
		if (hd_toolbar_nomouse || !toolbar.Enabled)
			return;

		float pointerLength = 10 * hd_toolbar_scale;
		float squareLength = 5 * hd_toolbar_scale;
		Screen.DrawLine(
			_PointerPos.x - pointerLength, _PointerPos.y,
			_PointerPos.x + pointerLength, _PointerPos.y,
			"white"
		);
		Screen.DrawLine(
			_PointerPos.x, _PointerPos.y - pointerLength,
			_PointerPos.x, _PointerPos.y + pointerLength,
			"white"
		);
		Screen.DrawLine(
			_PointerPos.x + squareLength, _PointerPos.y + squareLength,
			_PointerPos.x - squareLength, _PointerPos.y + squareLength,
			"white"
		);
		Screen.DrawLine(
			_PointerPos.x + squareLength, _PointerPos.y - squareLength,
			_PointerPos.x - squareLength, _PointerPos.y - squareLength,
			"white"
		);
		Screen.DrawLine(
			_PointerPos.x + squareLength, _PointerPos.y - squareLength,
			_PointerPos.x + squareLength, _PointerPos.y + squareLength,
			"white"
		);
		Screen.DrawLine(
			_PointerPos.x - squareLength, _PointerPos.y - squareLength,
			_PointerPos.x - squareLength, _PointerPos.y + squareLength,
			"white"
		);
		/*
		// debug pos
		Screen.DrawText(
			NewSmallFont,
			OptionMenuSettings.mFontColorValue,
			_PointerPos.x + 20, _PointerPos.y + 20,
			"x: ".._PointerPos.x.."\ny: ".._PointerPos.y
		);
		*/
	}
}
