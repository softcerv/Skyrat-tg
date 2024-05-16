/**
 * Checks to see if the parent mob has `pref_to_check` enabled, returns `FALSE` if the pref cannot be found or is set to False, otherwise returns `TRUE`
 *
 * This proc should be used when checking direct one-time interactions where logging would be benefical.
 * If you don't need to use logging, please use the `read_preference` proc
 *
 * Arguments
 * * `pref_to_check` - The toggle preference that we want to check to make sure works.
 * * `mechanic_user` - The person using the erp mechanic on the parent mob?
 * * `used_item` - What item, if any, is being used on the parent mob?
 */
/mob/living/proc/check_erp_prefs(datum/preference/toggle/pref_to_check, mob/living/mechanic_user = null, obj/item/used_item = FALSE)
	if(!ispath(pref_to_check))
		return FALSE

	if(client?.prefs?.read_preference(pref_to_check))
		return TRUE // We are good to go!

	if(!client?.prefs || (mechanic_user == src))
		return FALSE // Clients are a fickle mistress, but also no need for any further checks if someone is doing it on themselves without the prefs to allow it.

	var/message_to_log = "[src] had an ERP mechanic attempted to be used on them while their prefs were disabled"
	if(used_item)
		message_to_log = "[used_item] was attempted to be used on [src] while their prefs were disabled"

	var/turf/parent_turf = get_turf(src)
	if(parent_turf)
		message_to_log += " at [loc_name(parent_turf)]"

	if(mechanic_user)
		message_to_log += ", by [mechanic_user]"

	log_message(message_to_log + ".", LOG_GAME)

	return FALSE


/// Checks the prefs of all mobs in `view()`. If there is a mob with the `pref_to_check` set to false, we return `FALSE` otherwise, we return `TRUE`
/mob/living/proc/check_prefs_in_view(datum/preference/toggle/pref_to_check)
	if(!ispath(pref_to_check))
		return FALSE

	var/false_pref_not_found = TRUE
	for(var/mob/living/viewer in dview())
		if(!viewer?.client) // It doens't really matter if these people see it.
			continue

		if(!viewer.client.prefs) // Better safe than sorry
			false_pref_not_found = FALSE
			continue

		if(viewer.client.prefs.read_preference(pref_to_check))
			continue

		false_pref_not_found = FALSE
		viewer.log_message("[src] used a mechanic that checked for those without [pref_to_check] in view, [viewer] had the pref disabled.", LOG_GAME)
		log_message("[src] used a mechanic that checked for those without [pref_to_check] in view, [viewer] had the pref disabled.", LOG_GAME)

	return false_pref_not_found

/// Functions like check_prefs_in_view but looks to see if the person has a single pref enabled from within a list.
/mob/living/proc/check_prefs_list_in_view(var/list/prefs_to_check)
	for(var/datum/preference/toggle/pref_to_check in prefs_to_check)
		if(!ispath(pref_to_check))
			return FALSE

	var/false_pref_not_found = TRUE
	for(var/mob/living/viewer in dview())
		var/current_user_has_no_false_prefs = TRUE
		if(!viewer?.client) // It doens't really matter if these people see it.
			continue

		for(var/datum/preference/toggle/pref_to_check in prefs_to_check)
			if(viewer?.client?.prefs?.read_preference(pref_to_check))
				current_user_has_no_false_prefs = TRUE //We only need to see that the user has one pref enabled.

		if(!current_user_has_no_false_prefs)
			viewer.log_message("[src] used a mechanic that checked for those without prefs in view, [viewer] had none of the required prefs enabled.", LOG_GAME)
			log_message("[src] used a mechanic that checked for those without prefs in view, [viewer] had none of the required prefs enabled.", LOG_GAME)
			false_pref_not_found = FALSE

	return false_pref_not_found

