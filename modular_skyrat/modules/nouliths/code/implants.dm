/obj/item/organ/cyberimp/brain/noulith_bridge
	name = "Noulith Connection Bridge"
	desc = "Connects the user's brain with a Noulith Weapons"
	actions_types = list(/datum/action/item_action/noulith_bridge/open_menu)

	// Variables related to information about Nouliths.

	/// The person the implant is currently inserted into.
	var/mob/living/carbon/human/linked_mob
	/// The weapon currently linked with the implant.
	var/obj/item/linked_weapon
	/// Stores the weapon description.
	var/linked_weapon_description
	/// Stores the weapon's specfic Noulith lore Description.
	var/stored_weapon_lore = "No records are currently avalible."

	// Variables related to abilities, including cooldowns.

	/// Is the implant only allowed to attune to select weapons. This should only be disabled on debug items.
	var/unrestricted_attunement = TRUE
	/// Is the cooldown currently active on pull?
	var/pull_on_cooldown =  FALSE
	/// What is the current cooldown on the pull ability?
	var/pull_cooldown = 15 SECONDS
	/// Will summon be preformed after pulling?
	var/summon_after_pull = TRUE


/obj/item/organ/cyberimp/brain/noulith_bridge/Insert(mob/living/carbon/insertee)
	. = ..()
	linked_mob = insertee
	loc = insertee

/obj/item/organ/cyberimp/brain/noulith_bridge/Remove(mob/living/carbon/removee)
	. = ..()
	linked_mob = null

/// Links the user with a compatible item. if unrestricted_attunement is enabled, the user can attune with any item in the game.
/obj/item/organ/cyberimp/brain/noulith_bridge/proc/attune_to_weapon()
	if(!linked_mob)
		return FALSE

	if(linked_weapon)
		to_chat(linked_mob, span_notice("You unattune from the [linked_weapon]."))
		linked_weapon = null
		return TRUE

	var/obj/item/held_item = linked_mob.get_active_held_item()
	if(!held_item)
		to_chat(linked_mob, span_notice("You don't have anything your active hand."))
		return FALSE

	if(!unrestricted_attunement && !held_item.attunable)
		to_chat(linked_mob, span_notice("You are unable to attune to the current item."))
		return FALSE

	linked_weapon = held_item

	if(linked_weapon.desc)
		linked_weapon_description = linked_weapon.desc
	else
		linked_weapon_description = "There is no description."

	if(linked_weapon.noulith_weapon_lore)
		stored_weapon_lore = linked_weapon.noulith_weapon_lore
	else
		stored_weapon_lore = "No records are currently avalible."

	to_chat(linked_mob, span_notice("You attune to the [held_item]."))

/// Grabs the weapon, if it is nearby, and places it inside of the linked user's hands.
/obj/item/organ/cyberimp/brain/noulith_bridge/proc/summon_weapon()
	if(!linked_weapon)
		return FALSE

	if(!unlimited_summoning && !linked_mob.Adjacent(linked_weapon))
		to_chat(linked_mob, span_warning("You fail to grab the weapon, it may be too far away."))
		return FALSE

	if(!linked_mob.put_in_hands(linked_weapon))
		to_chat(linked_mob, span_warning("You were unable to hold the [linked_weapon]"))
		return FALSE

	linked_mob.visible_message(span_notice("The [linked_weapon] flies into [linked_mob]'s hand!"), span_notice("The [linked_weapon] flies into your hand."))

/// Pulls the linked weapon to the user. Uses the same kind of restrictions as TK when it comes to range.
/obj/item/organ/cyberimp/brain/noulith_bridge/proc/pull_weapon()
	if(!linked_weapon)
		return FALSE

	if(!ismovable(linked_weapon))
		return FALSE

	if(!tkMaxRangeCheck(linked_mob, linked_weapon)) //This should be a reasonable limit on the range of this.
		return FALSE

	linked_mob.throw_mode = TRUE //This is used to catch the weapon, otherwise it would just hit the user.

	linked_weapon.throw_at(linked_mob, linked_weapon.tk_throw_range, 1,linked_mob)

	pull_on_cooldown = TRUE
	addtimer(CALLBACK(src, .proc/reset_pulltimer), pull_cooldown)

/obj/item/organ/cyberimp/brain/noulith_bridge/proc/reset_pulltimer()
	pull_on_cooldown = FALSE

/datum/action/item_action/noulith_bridge
	button_icon = 'modular_skyrat/modules/nouliths/icons/mob/backgrounds.dmi'
	background_icon_state = "android"
	icon_icon = 'modular_skyrat/modules/nouliths/icons/mob/actions.dmi'
	check_flags = AB_CHECK_CONSCIOUS

/datum/action/item_action/noulith_bridge/open_menu
	name = "Open Noulith Menu"
	button_icon_state = "weapon"

/datum/action/item_action/noulith_bridge/open_menu/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return
	var/datum/action/item_action/noulith_bridge/bridge = target
	bridge.ui_interact(usr)

/obj/item
	/// Is an item able to be attuned with a Noulith Connection Bridge.
	var/attunable
	/// Does the weapon have an unlimited summon range? relates to Nouliths
	var/unlimited_summoning = TRUE
	/// Shows as text under the lore tab when linked to a Noulith Bridge. Use this to put extra lore in that might not otherwise fit in the weapon description.
	var/noulith_weapon_lore

/obj/item/autosurgeon/organ/noulith_bridge
	starting_organ = /obj/item/organ/cyberimp/brain/noulith_bridge
