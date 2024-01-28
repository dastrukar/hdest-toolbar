class HDToolbarMenu play abstract
{
	Array<string> Buttons;

	virtual void Init(HDToolbar toolbar) {}
	virtual void PressButton(HDToolbar toolbar) {}

	// Helper functions

	// Returns false if item was not found
	protected bool UseItem(HDPlayerPawn hdp, string name)
	{
		let item = hdp.FindInventory(name);
		if (!item)
			return false;

		hdp.UseInventory(item);
		return true;
	}

	protected void SendNetworkEvent(HDPlayerPawn hdp, string eventName, int arg1 = 0, int arg2 = 0, int arg3 = 0)
	{
		eventName = "hd_toolbar_cmd:"..eventName;
		EventHandler.SendInterfaceEvent(hdp.PlayerNumber(), eventName, arg1, arg2, arg3);
	}
}
