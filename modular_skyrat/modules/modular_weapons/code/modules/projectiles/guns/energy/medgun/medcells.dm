//Medigun Cells/
/obj/item/stock_parts/cell/medigun/ //This is the cell that mediguns from cargo will come with//
	name = "Basic Medigun Cell"
	maxcharge = 1200
	chargerate = 40

/obj/item/stock_parts/cell/medigun/upgraded
	name = "Upgraded Medigun Cell"
	maxcharge = 1500
	chargerate = 80

/obj/item/stock_parts/cell/medigun/experimental //This cell type is meant to be used in self charging mediguns like CMO and ERT one.//
	name = "Experiemental Medigun Cell"
	maxcharge = 1800
	chargerate = 100

/obj/item/stock_parts/cell/medigun/paramed //Not sure if I want to keep this self-charge or not. I'm leaning towards self-charge right now since it's piss poor anyways.
	name = "Paramedic Medigun Cell"
	maxcharge = 600
	chargerate = 40 //I'll probably want to tweak the values on this.....
//End of cells

/obj/item/ammo_casing/energy/medical
	projectile_type = /obj/projectile/energy/medical/default
	select_name = "oxygen"
	fire_sound = 'sound/effects/stealthoff.ogg'
	e_cost = 120
	delay = 8
	harmful = FALSE

/obj/projectile/energy/medical
	name = "medical heal shot"
	icon_state = "blue_laser"
	damage = 0

/obj/projectile/energy/medical/upgraded
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE

/obj/item/ammo_casing/energy/medical/default
	name = "oxygen heal shot"

/obj/projectile/energy/medical/default/on_hit(mob/living/target)
	. = ..()
	if(!istype(target, /mob/living/carbon/human))
		return
	if(target.stat == DEAD)
		return
	target.adjustOxyLoss(-10)

//T1 Healing Projectiles//
//The Basic Brute Heal Projectile//
/obj/item/ammo_casing/energy/medical/brute1
	projectile_type = /obj/projectile/energy/medical/brute1
	select_name = "brute"

/obj/projectile/energy/medical/brute1
	name = "brute heal shot"
	icon_state = "red_laser"

/obj/projectile/energy/medical/brute1/on_hit(mob/living/target)
	. = ..()
	if(!istype(target, /mob/living/carbon/human))
		return
	if(target.stat == DEAD)
		return
	if(target.getBruteLoss() > 49 && target.getBruteLoss() < 100 )
		target.adjustCloneLoss(2.45)
	if(target.getBruteLoss() > 99)
		target.adjustCloneLoss(4.9)
	target.adjustBruteLoss(-7.5)
//The Basic Burn Heal//
/obj/item/ammo_casing/energy/medical/burn1
	projectile_type = /obj/projectile/energy/medical/burn1
	select_name = "burn"

/obj/projectile/energy/medical/burn1
	name = "burn heal shot"
	icon_state = "yellow_laser"

/obj/projectile/energy/medical/burn1/on_hit(mob/living/target)
	. = ..()
	if(!istype(target, /mob/living/carbon/human))
		return
	if(target.stat == DEAD)
		return
	if(target.getFireLoss() > 49 && target.getFireLoss() < 100 )
		target.adjustCloneLoss(2.45)
	if(target.getFireLoss() > 99)
		target.adjustCloneLoss(4.9)
	target.adjustFireLoss(-7.5)

//Basic Toxin Heal//
/obj/item/ammo_casing/energy/medical/toxin1
	projectile_type = /obj/projectile/energy/medical/toxin1
	select_name = "toxin"

/obj/projectile/energy/medical/toxin1
	name = "toxin heal shot"
	icon_state = "green_laser"

/obj/projectile/energy/medical/toxin1/on_hit(mob/living/target)
	. = ..()
	if(!istype(target, /mob/living/carbon/human))
		return
	if(target.stat == DEAD)
		return
	target.adjustToxLoss(-5)
	target.radiation = max(target.radiation - 40, 0)//Toxin is treatable, but inefficent//
//T2 Healing Projectiles//
//Tier II Brute Projectile//
/obj/item/ammo_casing/energy/medical/brute2
	projectile_type = /obj/projectile/energy/medical/upgraded/brute2
	select_name = "brute II"

/obj/projectile/energy/medical/upgraded/brute2
	name = "strong brute heal shot"
	icon_state = "red_laser"


/obj/projectile/energy/medical/upgraded/brute2/on_hit(mob/living/target)
	. = ..()
	if(!istype(target, /mob/living/carbon/human))
		return
	if(target.stat == DEAD)
		return
	if(target.getBruteLoss() > 49 && target.getBruteLoss() < 100 )
		target.adjustCloneLoss(1.9)
	if(target.getBruteLoss() > 99)
		target.adjustCloneLoss(3.8)
	target.adjustBruteLoss(-11.25)
//Tier II Burn Projectile//
/obj/item/ammo_casing/energy/medical/burn2
	projectile_type = /obj/projectile/energy/medical/upgraded/burn2
	select_name = "burn II"

/obj/projectile/energy/medical/upgraded/burn2
	name = "strong burn heal shot"
	icon_state = "yellow_laser"

/obj/projectile/energy/medical/upgraded/burn2/on_hit(mob/living/target)
	. = ..()
	if(!istype(target, /mob/living/carbon/human))
		return
	if(target.stat == DEAD)
		return
	if(target.getFireLoss() > 49 && target.getFireLoss() < 100 )
		target.adjustCloneLoss(1.9)
	if(target.getFireLoss() > 99)
		target.adjustCloneLoss(3.8)
	target.adjustFireLoss(-11.25)
//Tier II Oxy Projectile//
/obj/item/ammo_casing/energy/medical/oxy2
	projectile_type = /obj/projectile/energy/medical/upgraded/oxy2
	select_name = "oxygen II"

/obj/projectile/energy/medical/upgraded/oxy2
	name = "strong oxygen heal shot"

/obj/projectile/energy/medical/upgraded/oxy2/on_hit(mob/living/target)
	. = ..()
	if(!istype(target, /mob/living/carbon/human))
		return
	if(target.stat == DEAD)
		return
	target.adjustOxyLoss(-20)
//Tier II Toxin Projectile//
/obj/item/ammo_casing/energy/medical/toxin2
	projectile_type = /obj/projectile/energy/medical/upgraded/toxin2
	select_name = "toxin II"

/obj/projectile/energy/medical/upgraded/toxin2
	name = "strong toxin heal shot"
	icon_state = "green_laser"

/obj/projectile/energy/medical/upgraded/toxin2/on_hit(mob/living/target)
	. = ..()
	if(!istype(target, /mob/living/carbon/human))
		return
	if(target.stat == DEAD)
		return
	target.adjustToxLoss(-7.5)
	target.radiation = max(target.radiation - 60, 0)
//T3 Healing Projectiles//
//Tier III Brute Projectile//
/obj/item/ammo_casing/energy/medical/brute3
	projectile_type = /obj/projectile/energy/medical/upgraded/brute3
	select_name = "brute III"

/obj/projectile/energy/medical/upgraded/brute3
	name = "powerful brute heal shot"
	icon_state = "red_laser"

/obj/projectile/energy/medical/upgraded/brute3/on_hit(mob/living/target)
	. = ..()
	if(!istype(target, /mob/living/carbon/human))
		return
	if(target.stat == DEAD)
		return
	target.adjustBruteLoss(-15)
//Tier III Burn Projectile//
/obj/item/ammo_casing/energy/medical/burn3
	projectile_type = /obj/projectile/energy/medical/upgraded/burn3
	select_name = "burn III"

/obj/projectile/energy/medical/upgraded/burn3
	name = "powerful burn heal shot"
	icon_state = "yellow_laser"

/obj/projectile/energy/medical/upgraded/burn3/on_hit(mob/living/target)
	. = ..()
	if(!istype(target, /mob/living/carbon/human))
		return
	if(target.stat == DEAD)
		return
	target.adjustFireLoss(-15)
//Tier III Oxy Projectile//
/obj/item/ammo_casing/energy/medical/oxy3
	projectile_type = /obj/projectile/energy/medical/upgraded/oxy3
	select_name = "oxygen III"

/obj/projectile/energy/medical/upgraded/oxy3
	name = "powerful oxygen heal shot"

/obj/projectile/energy/medical/upgraded/oxy3/on_hit(mob/living/target)
	. = ..()
	if(!istype(target, /mob/living/carbon/human))
		return
	if(target.stat == DEAD)
		return
	target.adjustOxyLoss(-30)
//Tier III Toxin Projectile//
/obj/item/ammo_casing/energy/medical/toxin3
	projectile_type = /obj/projectile/energy/medical/upgraded/toxin3
	select_name = "toxin III"

/obj/projectile/energy/medical/upgraded/toxin3
	name = "powerful toxin heal shot"
	icon_state = "green_laser"

/obj/projectile/energy/medical/upgraded/toxin3/on_hit(mob/living/target)
	. = ..()
	if(!istype(target, /mob/living/carbon/human))
		return
	if(target.stat == DEAD)
		return
	target.adjustToxLoss(-5)
	target.radiation = max(target.radiation - 80, 0)

//End of Basic Tiers of cells.//
//Special Cells//

//Roller Bed//
/obj/item/ammo_casing/energy/medical/bed
	projectile_type = /obj/projectile/energy/medical/bed
	select_name = "hard light bed"
	fire_sound = 'sound/effects/stealthoff.ogg'
	e_cost = 240
	harmful = FALSE

/obj/projectile/energy/medical/bed
	name = "Bed field"
	icon_state = "blue_laser"
	damage = 0

/obj/projectile/energy/medical/bed/on_hit(mob/living/target)
	. = ..()
	if(!istype(target, /mob/living/carbon/human))
		return
	if(HAS_TRAIT(target, TRAIT_FLOORED) || target.resting)
		new /obj/structure/bed/roller/medigun(target.loc)
	else
		return

/obj/structure/bed/roller/medigun
	name = "Hardlight Roller Bed"
	desc = "A Roller Bed made out of Hardlight"
	max_integrity = 1
	buildstacktype = 0

/obj/structure/bed/roller/medigun/post_unbuckle_mob(mob/living/M)
	set_density(FALSE)
	M.pixel_y = M.base_pixel_y + M.body_position_pixel_y_offset
	qdel(src)

/obj/structure/bed/roller/medigun/MouseDrop(over_object, src_location, over_location)
	if(over_object == usr && Adjacent(usr))
		if(!ishuman(usr) || !usr.canUseTopic(src, BE_CLOSE))
			return FALSE
		if(has_buckled_mobs())
			return FALSE
		usr.visible_message(span_notice("[usr] deactivates \the [src.name]."), span_notice("You deactivate \the [src.name]."))
		qdel(src)

//STABILIZER POD
/obj/item/ammo_casing/energy/medical/upgraded/stabilizer
	projectile_type = /obj/projectile/energy/medical/upgraded/stabilizer
	select_name = "stabilizer pod"
	fire_sound = 'sound/effects/stealthoff.ogg'
	e_cost = 600
	harmful = FALSE

/obj/projectile/energy/medical/upgraded/stabilizer
	name = "stabilizer field"
	icon_state = "blue_laser"
	damage = 0

/obj/projectile/energy/medical/upgraded/stabilizer/on_hit(mob/living/target)
	. = ..()
	if(istype(target, /mob/living/carbon/))
		var/obj/structure/gel_cocoon/medbay/cocoon = new /obj/structure/gel_cocoon/medbay(get_turf(target))
		cocoon.insert_target(target)
		ADD_TRAIT(target, TRAIT_NOCRITDAMAGE, TRAIT_GENERIC)
		if(HAS_TRAIT(target, TRAIT_CRITICAL_CONDITION))
			cocoon.crit = TRUE
	else
		return

//this is basically just a incredibly toned down version of the grapes' cocoon.
/obj/structure/gel_cocoon/medbay
	name = "stabilizer cocoon"
	desc = "A hardlight stasis pod, the patient inside is dosed with Epinephrine while they recover."
	max_integrity = 10 //can withstand a bit, but still easily breakable
	var/crit = FALSE

/obj/structure/gel_cocoon/medbay/container_resist_act(mob/living/user)
	user.visible_message(span_notice("You see [user] breaking out of [src]!"), \
		span_notice("You start tearing the soft tissue of the gel cocoon"))
	if(!do_after(user, 0.5 SECONDS, target = src))
		return FALSE
	dump_inhabitant()
	REMOVE_TRAIT(user, TRAIT_NOCRITDAMAGE, TRAIT_GENERIC)

/obj/structure/gel_cocoon/medbay/Destroy()
	. = ..()
	REMOVE_TRAIT(inhabitant, TRAIT_NOCRITDAMAGE, TRAIT_GENERIC)

/obj/structure/gel_cocoon/medbay/process()
//Helps stabilize patients, but is worse than atropine
	if(inhabitant.reagents.get_reagent_amount(/datum/reagent/medicine/epinephrine) < 2.5)
		inhabitant.reagents.add_reagent(/datum/reagent/medicine/epinephrine, 0.5)
//Ejects Critical Patients once they are healed
	if(crit == TRUE)
		if(!HAS_TRAIT(inhabitant, TRAIT_CRITICAL_CONDITION))
			dump_inhabitant()
		else
			return

//Blood Clotting Cell
/obj/item/ammo_casing/energy/medical/upgraded/clot
	projectile_type = /obj/projectile/energy/medical/upgraded/clot
	select_name = "clot"
	fire_sound = 'sound/effects/stealthoff.ogg'
	e_cost = 120
	harmful = FALSE

/obj/projectile/energy/medical/upgraded/clot
	name = "coagulant agent"
	icon_state = "blue_laser"
	damage = 0

/obj/projectile/energy/medical/upgraded/clot/on_hit(mob/living/target)
	. = ..()
	if(!istype(target, /mob/living/carbon/human))
		return
//Using Sanguirite because there really isn't a way to make it normally.
	if(target.reagents.get_reagent_amount(/datum/reagent/medicine/coagulant) < 5) //Will have to see how this works in practice.
		target.reagents.add_reagent(/datum/reagent/medicine/coagulant, 1)
	else
		return

//Temperature Adjustment Cell
/obj/item/ammo_casing/energy/medical/temp
	projectile_type = /obj/projectile/energy/medical/temp
	select_name = "temperature"
	fire_sound = 'sound/effects/stealthoff.ogg'
	e_cost = 120
	harmful = FALSE

/obj/projectile/energy/medical/temp
	name = "temperature stabilizer"
	icon_state = "blue_laser"
	damage = 0

/obj/projectile/energy/medical/temp/on_hit(mob/living/target)
	. = ..()
	if(!istype(target, /mob/living/carbon/human))
		return
	var/ideal = target.get_body_temp_normal(apply_change=FALSE)
	var/difference = (ideal - target.bodytemperature)
	if(difference > -20 && difference < 20)
		return
	if(difference > 19) //Increases Body Temperature
		target.adjust_bodytemperature(20)
	if(difference < -19) //Decreases Body Temperature
		target.adjust_bodytemperature(-20)
	else
		return
