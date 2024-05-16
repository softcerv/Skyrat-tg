/mob/living/proc/vore_mob()
	set name = "Ingest Mob"
	set category = "Vore"
	set desc = "Attempt to ingest the mob that you are currently holding onto."

	var/datum/component/carrier/vore/vore_carrier = get_vore_component()
	if(!istype(vore_carrier))
		return FALSE // How are you going to eat them????

	var/mob/living/carbon/human/prey = pulling
	if(grab_state < GRAB_AGGRESSIVE)
		to_chat(span_warning("You need to have a better grip on [prey] to eat them."), src)
		return FALSE

	if(!istype(prey) || !prey.check_if_prey())
		return FALSE

	log_message("[src] attempted to ingest [prey].", LOG_GAME)
	if(!check_prefs_list_in_view(list(/datum/preference/toggle/erp/vore_pred, /datum/preference/toggle/erp/vore_prey)))
		to_chat(span_warning("Someone is looking at you that doesn't want to see vore."), src) // Isn't there somebody you forgot to ask?
		return FALSE

	to_chat(span_warning("You start to devour [prey]."), src)
	to_chat(span_warning("[src] begins to devour you."), prey)

	if(!do_after(src, 30 SECONDS, prey, hidden = TRUE)) // We don't want to quickly eat, that would be rude.
		balloon_alert(src, "interrupted!")

	if(!vore_carrier.add_mob(prey)) // The carrier handles the actual ingesting of the mob.
		return FALSE

	log_message("[src] successfully ingested [prey].", LOG_GAME)
	return TRUE

/// Checks if the parent mob is able to be eaten by a predator.
/mob/living/carbon/human/proc/check_if_prey(debug = TRUE)
	if(debug)
		return TRUE

	if((stat < CONSCIOUS) || !mind)
		return FALSE

	// Add stuff here :3
	return TRUE

/// Opens up the vore menu.
/mob/living/proc/open_vore_menu()
	set name = "Open Vore Menu"
	set category = "Vore"
	set desc = "Open the menu for vore."

	var/datum/component/carrier/vore/vore_component = get_vore_component()
	if(!istype(vore_component))
		return FALSE

	vore_component.ui_interact(src)
	return TRUE

