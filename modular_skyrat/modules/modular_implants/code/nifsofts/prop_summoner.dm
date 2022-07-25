/obj/item/disk/nifsoft_uploader/summoner
	loaded_nifsoft = /datum/nifsoft/summoner


/datum/nifsoft/summoner
	name = "Grimoire Caeruleam"
	program_desc = "The Grimoire Caeruleam is an open-source, virtual decentralized directory of summonable objects originally developed by the Altspace Coven, a post-pagan group of witches first digitized into engrams in the year 2544. These summonable constructs, or 'Icons,' are comprised of delicate patterns of nanomachines serving as a framework and projector for hardlight; the name 'Caeruleam' referencing the blue light an Icon casts in the summoner's hand. While the Grimoire has served thousands thus far, Corporate interests have blocked all access to Icons capable of harming their assets."
	cost = 200
	activation_cost = 100 // Around 1/10th the energy of a standard NIF
	/// Does the resulting object have a holographic like filter appiled to it?
	var/holographic_filter = TRUE
	/// Is there any special tag added at the begining of the resulting object name?
	var/name_tag = "cerulean "
	cooldown = TRUE

	///The list of items that can be summoned from the NIFSoft.
	var/list/summonable_items = list(
		/obj/item/toy/katana/nanite,
		/obj/item/cane/nanite,
		/obj/item/storage/dice/nanite,
		/obj/item/toy/cards/deck/nanite,
		/obj/item/toy/cards/deck/tarot/nanite, //The arcana is the means by which all is revealed
		/obj/item/toy/cards/deck/kotahi/nanite,
		/obj/item/toy/foamblade/nanite,
		/obj/item/cane/white/nanite,
		/obj/item/lighter/nanite,
		/obj/item/clothing/mask/holocigarette/nanite,
	)

/datum/nifsoft/summoner/activate()
	var/obj/item/organ/internal/cyberimp/brain/nif/installed_nif = parent_nif

	if(!activation_check(installed_nif))
		return FALSE

	var/list/summon_choices = list()
	for(var/obj/item/summon_item as anything in summonable_items)
		var/image/obj_icon = image(icon = initial(summon_item.icon), icon_state = initial(summon_item.icon_state))

		summon_choices[summon_item] = obj_icon

	var/obj/item/choice = show_radial_menu(linked_mob, linked_mob, summon_choices, radius = 42, custom_check = CALLBACK(src, .proc/check_menu, linked_mob))
	if(!choice)
		return FALSE

	var/obj/item/new_item = new choice

	new_item.nif_generated_item = TRUE
	if(name_tag)
		new_item.name = name_tag + new_item.name //This is here so that people know the item is created from a NIF.

	if(holographic_filter)
		new_item.alpha = 180
		new_item.set_light(2)
		new_item.add_atom_colour("#acccff", FIXED_COLOUR_PRIORITY)

	if(!linked_mob.put_in_hands(new_item))
		to_chat(linked_mob, span_warning("The [new_item] fails to materialize in your hands!"))
		qdel(new_item)
		return FALSE

	return ..()

/datum/nifsoft/summoner/proc/check_menu(mob/living/carbon/human/user)
	if(!istype(user) || !user.installed_nif)
		return FALSE

	return TRUE

/obj/item
	/// Is the item generated by a NIF?
	var/nif_generated_item = FALSE

/obj/item/examine(mob/user)
	. = ..()

	if(nif_generated_item)
		. += span_blue("<b>Ctrl + Shift + Click</b> to destroy this item.")

/obj/item/CtrlShiftClick(mob/user)
	. = ..()

	if(nif_generated_item)
		user.visible_message(span_blue("[usr] firmly grasps the [src], causing it to disintegrate into a fine blue ash"),
		span_blue("You firmly grasp the [src], causing it to disintegrate into a fine blue ash"))
		qdel(src)

/obj/item/toy/cards/deck/Initialize(mapload)
	. = ..()
	if(nif_generated_item)
		for(var/obj/item/card/card as anything in cards)
			card.nif_generated_item = TRUE
			card.alpha = 180
			card.set_light(2)
			card.add_atom_colour("#acccff", FIXED_COLOUR_PRIORITY)

/obj/item/storage/dice/Initialize(mapload)
	. = ..()
	if(nif_generated_item)
		for(var/obj/item/item as anything in contents)
			item.nif_generated_item = TRUE
			item.alpha = 180
			item.set_light(2)
			item.add_atom_colour("#4e5664", FIXED_COLOUR_PRIORITY)

//Summonable Items
///A somehow wekaer version of the toy katana
/obj/item/toy/katana/nanite
	name = "hexblade"
	desc = "One of the first groups to contribute to the Caeruleam Grimoire's repository were the Malatestan Duelists, a group of mercenary-philosophers seeking to become undisputed masters of the principal art of Cutting. Originally intended as a means of generating perfectly sharp, perfectly unbreakable, and perfectly capable of the Sanctioned Action: to cut. However, these 'blunted' prop Icons are only a mere shadow of what the Duelists originally developed, the only version of the Icon permitted by interstellar law to civilians; normally seen on convention floors or in the hands of those wishing to spar without risk."
	force = 0
	throwforce = 0

/obj/item/storage/dice/nanite
	name = "dice set"
	desc = "A gorgeous replication of a gorgeous set of dice. These were modeled after a set of dice originally in the possession of the Selenian Wargaming Society, carved from rare lunar crystals over two hundred years ago. While no one but the Prime Game Master may ever roll even a single piece from the original set, the Society has graciously donated virtual replicas to the Altspace Coven's repo, as a token of their appreciation for aid in more live-action forms of roleplay."

/obj/item/toy/cards/deck/nanite
	name = "main deck"
	desc = "Another piece of gaming equipment graciously donated from the Selenian Wargaming Society, these cards employ a localized field of near-invisible nanites equipped with advanced eye tracking software; to ensure the display on the cards does not allow for peeking. Additionally, over five hundred thousand variations of the standard fifty two card deck are supported, in all known forms of writing. Lastly, a collaboration with the Altspace Coven has yielded a deck of tarot cards; the witches designing it claiming that the incorporeal nature of the cards allow them a higher connectivity with fate itself. "

/obj/item/toy/cards/deck/tarot/nanite
	name = "tarot deck"
	desc = "Another piece of gaming equipment graciously donated from the Selenian Wargaming Society, these cards employ a localized field of near-invisible nanites equipped with advanced eye tracking software; to ensure the display on the cards does not allow for peeking. Additionally, over five hundred thousand variations of the standard fifty two card deck are supported, in all known forms of writing. Lastly, a collaboration with the Altspace Coven has yielded a deck of tarot cards; the witches designing it claiming that the incorporeal nature of the cards allow them a higher connectivity with fate itself. "

/obj/item/toy/cards/deck/kotahi/nanite
	name = "kotahi deck"
	desc = "Another piece of gaming equipment graciously donated from the Selenian Wargaming Society, these cards employ a localized field of near-invisible nanites equipped with advanced eye tracking software; to ensure the display on the cards does not allow for peeking. Additionally, over five hundred thousand variations of the standard fifty two card deck are supported, in all known forms of writing. Lastly, a collaboration with the Altspace Coven has yielded a deck of tarot cards; the witches designing it claiming that the incorporeal nature of the cards allow them a higher connectivity with fate itself. "

/obj/item/cane/nanite
	name = "staff"
	desc = "This program was contributed by a mutual aid group, the Sapient Rights Recovery Association located in many regions across the eastern continents of Earth. Cerulean staffs employ more nanomachines than holograms, giving them a solid core and steady tip for use by the disabled. Through ample usage of sound cues to help summoners navigate the menu, a pattern was also developed for sightless individuals both by incident, birth, and biology."

	force = 0
	throwforce = 0

/obj/item/cane/white/nanite
	name = "white staff"
	desc = "This program was contributed by a mutual aid group, the Sapient Rights Recovery Association located in many regions across the eastern continents of Earth. Cerulean staffs employ more nanomachines than holograms, giving them a solid core and steady tip for use by the disabled. Through ample usage of sound cues to help summoners navigate the menu, a pattern was also developed for sightless individuals both by incident, birth, and biology."

	force = 0
	throwforce = 0

/obj/item/toy/foamblade/nanite
	name = "armblade"
	desc = "This Icon was leaked onto the Grimoire somewhat illegally. It was originally uploaded by a departing member of the Tiger Cooperative, the download text informing the summoner that this Icon was first used by the cultists for use as 'training for their biological Ascension' into shape-shifting entities. Within hours, several variants for all sorts of sapient limb configurations were forked and uploaded, this one an entirely nonlethal one."

/obj/item/lighter/nanite
	name = "catchflame"
	desc = "A work of art by the standards of normal Icons, this one was worked on for five continuous years by a single summoner; now known as Neophyte Inverse after adoption of the Icon by the few physically-bodied members of the Altspace Coven. The engram's work involves the use of nanites to ignite atmospheric hydrogen molecules, the blue glow from the Icon arising from perfect and complete combustion. This allows the lighter to function exactly as a normal zippo would, the description reading '...useful for lighting hearth fires, candles, and incense; try white sage if you can order some off the net, just pray it doesn't dispel engrams lol.'"

/obj/item/clothing/mask/holocigarette/nanite
	name = "cloudstick"
	desc = "One of mankind's many attempts at ending the legacy of Big Tobacco. Contributed by a fully anonymous engram and then forked countless times into countless replications of brands and flavors, the 'Cloudstick' is more of a genre than a single Icon. Most downloadable ones even allow the summoner to change the pixilation of the smoke, to grant them a more 'detached' experience from the real thing. Several summoners report these to help them in quitting smoking, others simply commenting 'it's why i first downloaded the Catchflame"
