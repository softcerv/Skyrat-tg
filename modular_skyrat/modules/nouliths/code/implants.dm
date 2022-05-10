/obj/item/organ/cyberimp/brain/noulith_bridge
	name = "Noulith Connection Bridge"
	desc = "Connects the user's brain with a Noulith Weapons"
	/// The person the implant is currently inserted into.
	var/mob/living/carbon/human/linked_mob
	/// The weapon currently linked with the implant.
	var/obj/item/linked_weapon
	/// Is the implant only allowed to attune to select weapons. This should only be disabled on debug items.
	var/unrestricted_attunement = TRUE
	actions_types = list(/datum/action/item_action/organ_action/use/attune)

/obj/item/organ/cyberimp/brain/noulith_bridge/Insert(mob/living/carbon/insertee)
	. = ..()
	linked_mob = insertee

/obj/item/organ/cyberimp/brain/noulith_bridge/Remove(mob/living/carbon/removee)
	. = ..()
	linked_mob = null

/obj/item/organ/cyberimp/brain/noulith_bridge/ui_action_click(mob/user)
	. = ..()
	var/held_item = user.get_active_held_item()
	if(!held_item)
		to_chat(user, span_notice("You don't have anything your active hand."))
		return FALSE
	attune_to_weapon(user, held_item)

/obj/item/organ/cyberimp/brain/noulith_bridge/proc/attune_to_weapon(mob/living/user, obj/item/target_weapon)
	if(!unrestricted_attunement && !target_weapon.attunable)
		to_chat(user, span_notice("You are unable to attune to the current item."))
		return FALSE

	if(linked_weapon == target_weapon)
		linked_weapon = null
		to_chat(user, span_notice("You unattune from the [target_weapon]."))
		return TRUE

	linked_weapon = target_weapon
	to_chat(user, span_notice("You unattune to the [target_weapon]."))

/obj/item
	/// Is an item able to be attuned with a Noulith Connection Bridge.
	var/attunable

/datum/action/item_action/organ_action/use/attune/New(Target)
	name = "Attune"

/obj/item/autosurgeon/organ/noulith_bridge
	starting_organ = /obj/item/organ/cyberimp/brain/noulith_bridge

