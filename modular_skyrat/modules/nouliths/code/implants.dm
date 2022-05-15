/obj/item/organ/cyberimp/brain/noulith_bridge
	name = "Noulith Connection Bridge"
	desc = "Connects the user's brain with a Noulith Weapons"
	/// The person the implant is currently inserted into.
	var/mob/living/carbon/human/linked_mob
	/// The weapon currently linked with the implant.
	var/obj/item/linked_weapon
	/// Stores the weapon description.
	var/linked_weapon_description
	/// Is the implant only allowed to attune to select weapons. This should only be disabled on debug items.
	var/unrestricted_attunement = TRUE
	actions_types = list(/datum/action/item_action/noulith_bridge/open_menu)

/obj/item/organ/cyberimp/brain/noulith_bridge/Insert(mob/living/carbon/insertee)
	. = ..()
	linked_mob = insertee
	loc = insertee

/obj/item/organ/cyberimp/brain/noulith_bridge/Remove(mob/living/carbon/removee)
	. = ..()
	linked_mob = null

/*
/obj/item/organ/cyberimp/brain/noulith_bridge/ui_action_click(mob/user)
	. = ..()
	var/held_item = user.get_active_held_item()
	if(!held_item)
		to_chat(user, span_notice("You don't have anything your active hand."))
		return FALSE
	attune_to_weapon(user, held_item)
*/


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
	to_chat(linked_mob, span_notice("You attune to the [held_item]."))

/obj/item/organ/cyberimp/brain/noulith_bridge/proc/summon_weapon()
	if(!linked_weapon)
		return FALSE

	if(!unlimited_summoning || !linked_mob.Adjacent(linked_weapon))
		to_chat(linked_mob, span_warning("You fail to grab the weapon, it may be too far away."))
		return FALSE

	if(!linked_mob.put_in_hands(linked_weapon))
		to_chat(linked_mob, span_warning("You were unable to hold the [linked_weapon]"))
		return FALSE

	linked_mob.visible_message(span_notice("The [linked_weapon] flies into [linked_mob]'s hand!"), span_notice("The [linked_weapon] flies into your hand."))

/datum/action/item_action/noulith_bridge
	background_icon_state = "bg_tech_blue"
	icon_icon = 'icons/mob/actions/actions_mod.dmi'
	check_flags = AB_CHECK_CONSCIOUS

/datum/action/item_action/noulith_bridge/open_menu
	name = "Open Noulith Menu"

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

/obj/item/autosurgeon/organ/noulith_bridge
	starting_organ = /obj/item/organ/cyberimp/brain/noulith_bridge
