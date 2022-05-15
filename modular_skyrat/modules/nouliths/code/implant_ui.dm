/obj/item/organ/cyberimp/brain/noulith_bridge/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NoulithPanel", name)
		ui.open()

/obj/item/organ/cyberimp/brain/noulith_bridge/ui_data(mob/user)
	var/data = list()
	data["linked_mob"] = linked_mob
	data["linked_weapon"] = linked_weapon
	data["linked_weapon_description"] = linked_weapon.desc
	return data

/obj/item/organ/cyberimp/brain/noulith_bridge/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	if(action == "attune")
		attune_to_weapon()
		SStgui.update_uis(src)

	if(action == "summon")
		summon_weapon()
		SStgui.update_uis(src)
