/obj/item/organ/cyberimp/brain/noulith_bridge/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NoulithPanel", name)
		ui.open()

/obj/item/organ/cyberimp/brain/noulith_bridge/ui_data(mob/user)
	var/data = list()
	data["linked_mob"] = linked_mob
	return data
