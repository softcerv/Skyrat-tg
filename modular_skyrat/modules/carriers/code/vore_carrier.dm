/datum/component/carrier/vore
	single_owner = TRUE
	vore_functions = TRUE
	no_dolling = TRUE
	room_limit = 10
	max_mobs = 3
	type_of_room_to_create = /datum/carrier_room/vore

/datum/component/carrier/vore/New()
	. = ..()
	var/mob/living/parent_mob = get_current_holder()
	if(!istype(parent_mob))
		return COMPONENT_INCOMPATIBLE

	add_verb(parent_mob, list(/mob/living/proc/open_vore_menu, /mob/living/proc/vore_mob))

/datum/component/carrier/vore/Destroy(force, ...)
	var/mob/living/parent_mob = get_current_holder()
	if(istype(parent_mob))
		remove_verb(parent_mob, list(/mob/living/proc/open_vore_menu, /mob/living/proc/vore_mob))

	return ..()

/datum/carrier_room/vore
	name = "Belly"
	/// What message is shown to the prey/predator upon a prey being digested?
	var/digest_message
	/// What message is shown to the prey/predator upon a prey being absorbed?
	var/absorb_message

/datum/carrier_room/vore/remove_mob(mob/living/mob_to_remove)
	. = ..()

/// Controls what happens with the prey inside once they are in hardcrit.
/datum/carrier_room/vore/proc/handle_hardcrit_prey(var/mob/living/prey_to_handle)
	var/mob/living/predator = get_owner()
	if(!(prey_to_handle in current_mobs) || !istype(predator))
		return FALSE

	if(prey_to_handle.health > prey_to_handle.hardcrit_threshold)
		return FALSE

	var/choice = tgui_alert(usr, "You have been digested. Would you like to reform now?", name, list("Yes", "No"), autofocus=TRUE) // Change this later or something.
	if(!choice)
		return FALSE // Try again later.

	if(choice == "Yes")
		var/reform_choice = tgui_input_list(usr, "How would you like to reform?", name, list("In pred", "Next to pred", "In Interlink Dorms"))
		if(!reform_choice)
			return FALSE

		// We want to heal them from digestion damage, but we don't want to aheal them.
		prey_to_handle.adjustBruteLoss(-200)
		prey_to_handle.adjustFireLoss(-200)
		prey_to_handle.adjustOxyLoss(-200)

		if(reform_choice == "In pred") // No extra work needed.
			return TRUE

		remove_mob(prey_to_handle)
		if(reform_choice == "Next to pred")
			return TRUE

		if(reform_choice == "In Interlink dorms")
			// Teleport them to the dorms on interlink
			return TRUE

	qdel(prey_to_handle)

/datum/modular_persistence
	///A param string containing vore bellies
	var/vore_carrier_rooms = ""

/// Find and return the vore carrier component that the parent mob has, if there is one present.
/mob/living/proc/get_vore_component()
	var/obj/item/carrier_holder/vore/vore_holder = locate(/obj/item/carrier_holder/vore) in contents
	if(!istype(vore_holder))
		return FALSE

	var/datum/component/carrier/vore/vore_component = vore_holder.GetComponent(/datum/component/carrier/vore)
	if(!istype(vore_component))
		return FALSE

	return vore_component

/obj/item/carrier_holder/vore
	name = "Vore Holder"
	carrier_component_to_create = /datum/component/carrier/vore
