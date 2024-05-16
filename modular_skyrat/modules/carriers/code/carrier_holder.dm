/// This is the object we use if we give a mob soulcatcher. Having the souls directly parented could cause issues.
/obj/item/carrier_holder
	name = "Carrier Holder"
	desc = "You probably shouldn't be seeing this..."
	/// What carrier component should we create?
	var/carrier_component_to_create = /datum/component/carrier

/obj/item/carrier_holder/New(loc, ...)
	. = ..()
	AddComponent(carrier_component_to_create)

/obj/item/carrier_holder/Destroy(force)
	var/datum/component/carrier/carrier_component = GetComponent(/datum/component/carrier)
	if(istype(carrier_component))
		qdel(carrier_component)

	return ..()

