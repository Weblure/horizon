/obj/structure/dresser
	name = "dresser"
	desc = "A nicely-crafted wooden dresser. It's filled with lots of undies."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "dresser"
	density = TRUE
	anchored = TRUE

/obj/structure/dresser/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WRENCH)
		to_chat(user, SPAN_NOTICE("You begin to [anchored ? "unwrench" : "wrench"] [src]."))
		if(I.use_tool(src, user, 20, volume=50))
			to_chat(user, SPAN_NOTICE("You successfully [anchored ? "unwrench" : "wrench"] [src]."))
			set_anchored(!anchored)
	else
		return ..()

/obj/structure/dresser/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/stack/sheet/mineral/wood(drop_location(), 10)
	qdel(src)

/obj/structure/dresser/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!Adjacent(user))//no tele-grooming
		return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user

		if(H.dna && H.dna.species && (NO_UNDERWEAR in H.dna.species.species_traits))
			to_chat(user, SPAN_WARNING("You are not capable of wearing underwear."))
			return

		var/choice = tgui_input_list(user, "Underwear, Undershirt, or Socks?", "Changing", list("Underwear","Underwear Color","Undershirt","Socks"))

		if(!Adjacent(user))
			return
		switch(choice)
			if("Underwear")
				var/new_undies = tgui_input_list(user, "Select your underwear", "Changing", GLOB.underwear_list)
				if(new_undies)
					H.underwear = new_undies
			if("Underwear Color")
				var/new_underwear_color = input(H, "Choose your underwear color", "Underwear Color","#"+H.underwear_color) as color|null
				if(new_underwear_color)
					H.underwear_color = sanitize_hexcolor(new_underwear_color)
			if("Undershirt")
				var/new_undershirt = tgui_input_list(user, "Select your undershirt", "Changing", GLOB.undershirt_list)
				if(new_undershirt)
					H.undershirt = new_undershirt
			if("Socks")
				var/new_socks = tgui_input_list(user, "Select your socks", "Changing", GLOB.socks_list)
				if(new_socks)
					H.socks= new_socks

		add_fingerprint(H)
		H.update_body()
