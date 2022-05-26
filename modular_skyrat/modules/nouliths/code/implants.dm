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

	/// Is the implant only allowed to attune to select weapons. This should only be enabled on debug items.
	var/unrestricted_attunement = TRUE
	/// Is the cooldown currently active on pull?
	var/pull_on_cooldown =  FALSE
	/// What is the current cooldown on the pull ability?
	var/pull_cooldown = 15 SECONDS
	/// Will summon be preformed after pulling?
	var/summon_after_pull = TRUE
	/// Stores whether or not a weapon can be stowed.
	var/weapon_stowable
	/// Is a weapon currently stowed?
	var/weapon_stowed = FALSE

	// Variables related to cosmetics
	/// Stores a weapon's custom exmaine.
	var/weapon_custom_examine

/obj/item/organ/cyberimp/brain/noulith_bridge/Insert(mob/living/carbon/insertee)
	. = ..()
	linked_mob = insertee
	loc = insertee

/obj/item/organ/cyberimp/brain/noulith_bridge/Remove(mob/living/carbon/removee)
	. = ..()
	linked_mob = null

//LINK CODE
/// Links the user with a compatible item. if unrestricted_attunement is enabled, the user can attune with any item in the game.
/obj/item/organ/cyberimp/brain/noulith_bridge/proc/attune_to_weapon()
	if(!linked_mob)
		return FALSE

	if(linked_weapon)
		to_chat(linked_mob, span_notice("You unattune from the [linked_weapon]."))
		linked_weapon.noulith_custom_examine = null
		linked_weapon = null
		weapon_stowable = null
		return TRUE

	var/obj/item/held_item = linked_mob.get_active_held_item()
	if(!held_item)
		to_chat(linked_mob, span_notice("You don't have anything your active hand."))
		return FALSE

	if(HAS_TRAIT(held_item, TRAIT_NODROP)) // No using this to cheese no_drop items
		to_chat(linked_mob, span_notice("You can't attune to something stuck to you."))
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

	weapon_stowable = linked_weapon.noulith_stowable
	to_chat(linked_mob, span_notice("You attune to the [held_item]."))

//WEAPON ABILITIES
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

	if(weapon_stowed)
		linked_mob.visible_message(span_notice("[linked_mob] draws the [linked_weapon] from their back."), span_notice("You draw [linked_weapon] from your back."))
	else
		linked_mob.visible_message(span_notice("[linked_weapon] flies into [linked_mob]'s hand!"), span_notice("[linked_weapon] flies into your hand."))

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

/obj/item/organ/cyberimp/brain/noulith_bridge/proc/stow()
	if(!linked_weapon)
		return FALSE

	if(!weapon_stowable)
		return FALSE
		to_chat(linked_mob, span_warning("You are unable to stow [linked_weapon]"))

	if(weapon_stowed)
		summon_weapon()
		weapon_stowed = FALSE
		return

	if(linked_mob.get_active_held_item() != linked_weapon)
		to_chat(linked_mob, span_warning("You need to hold [linked_weapon], to be able to stow it."))
		return FALSE

	if(!linked_mob.transferItemToLoc(linked_weapon, src))
		return FALSE

	weapon_stowed = TRUE

// COSMETIC ABILITIES
/// Gives the linked weapon a custom examine text.
/obj/item/organ/cyberimp/brain/noulith_bridge/proc/custom_examine(new_text)
	if(!linked_weapon)
		return FALSE

	if(!new_text)
		linked_weapon.noulith_custom_examine = null
		return
	linked_weapon.noulith_custom_examine = new_text
	weapon_custom_examine = new_text

/obj/item/organ/cyberimp/brain/noulith_bridge/proc/reset_pulltimer()
	pull_on_cooldown = FALSE

/datum/action/item_action/noulith_bridge
	button_icon = 'modular_skyrat/modules/nouliths/icons/mob/backgrounds.dmi'
	background_icon_state = "android"
	icon_icon = 'modular_skyrat/modules/nouliths/icons/mob/actions.dmi'
	check_flags = AB_CHECK_CONSCIOUS

/datum/action/item_action/noulith_bridge/open_menu
	name = "Open Noulith Menu"
	button_icon_state = "link"

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
	/// Linked user from a Noulith Bridge
	var/noulith_linked_mob
	/// Custom description examine text.
	var/noulith_custom_examine
	/// Is the item stowable?
	var/noulith_stowable = TRUE

/obj/item/examine(mob/user)
	. = ..()
	if(noulith_custom_examine)
		. += "<br>Looking at the [src], it is inscribed by blue light.<br>"
		. += "<b>[span_cyan(noulith_custom_examine)]</b><br>"

/obj/item/autosurgeon/organ/noulith_bridge
	starting_organ = /obj/item/organ/cyberimp/brain/noulith_bridge
