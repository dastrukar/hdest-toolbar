class HDToolbarMenu play abstract
{
	Array<string> Buttons;

	virtual void Init() {}
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
}
