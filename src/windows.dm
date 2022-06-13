/obj
	var/working_map = ""
	screen_loc = "CENTER"

/obj/proc/position()
	if(working_map)
		screen_loc = "[working_map]:[screen_loc]"

// Laid behind the window to force the window to scale correctly
/obj/background

/obj/background/proc/fill_rect(x1, y1, x2, y2)
	screen_loc = "[x1],[y1] to [x2],[y2]"
	position()

// We use this to hold any misc objects we want to render to submaps
// We'll vis_contents them onto this to properly relay em
/obj/screen_holder

/obj/screen_holder/position()
	screen_loc = "[1],[1]"
	return ..()

/client
	var/obj/screen_holder/popup_holder
	var/obj/list/on_screen = list()

#define PARENT_PLANE 10
#define CHILD_PLANE 11

/turf/wall
	plane = PARENT_PLANE

/obj/plane_master
	appearance_flags = PLANE_MASTER

// Parent goes to the base plane, and goes blue
/obj/plane_master/parent
	color = "#0000ff"
	plane = PARENT_PLANE
	render_target = "*parent"

/obj/relay_parent
	render_source = "*parent"
	plane = 0

// base plane is sent to the "child" plane master
/obj/plane_master/base
	plane = 0
	render_target = "*base"

/obj/relay_base
	render_source = "*base"
	plane = CHILD_PLANE

// Child plane master tints its contents purple
/obj/plane_master/child
	color = "#FF00FF"
	plane = CHILD_PLANE

// walls will experience a total of two relays

// Creates and fills a popup with our desired screen objects
/client/proc/setup_popup(make_relay = TRUE)
	var/width = 10
	var/height = 10
	var/x_value = world.icon_size * width
	var/y_value = world.icon_size * height
	var/map_name = create_popup("plane test", x_value, y_value)

	popup_holder = create_screen_obj(/obj/screen_holder, map_name)
	var/obj/background/background = create_screen_obj(/obj/background, map_name)
	background.fill_rect(1, 1, width, height)

	var/obj/plane_master/base/plate = create_screen_obj(/obj/plane_master/base, map_name)
	if(make_relay)
		create_screen_obj(/obj/relay_base, map_name)
		create_screen_obj(/obj/plane_master/parent, map_name)
		create_screen_obj(/obj/relay_parent, map_name)
		create_screen_obj(/obj/plane_master/child, map_name)
	else
		plate.render_target = null

// Actually creates our popup. Done by cloning a hidden window sitting in our dmf
// And then setting its size as desired
/client/proc/create_popup(name, ratiox = 100, ratioy = 100)
	winclone(src, "popupwindow", name)
	var/list/winparams = list()
	winparams["size"] = "[ratiox]x[ratioy]"
	winset(src, "[name]", list2params(winparams))
	winshow(src, "[name]", 1)

	var/list/params = list()
	params["parent"] = "[name]"
	params["type"] = "map"
	params["size"] = "[ratiox]x[ratioy]"
	params["anchor1"] = "0,0"
	params["anchor2"] = "[ratiox],[ratioy]"
	winset(src, "[name]_map", list2params(params))

	return "[name]_map"

// Creates a screen object, positions it, and if a submap is passed in places it on that
/client/proc/create_screen_obj(obj_type, map = "")
	var/obj/screen_obj = new obj_type()
	screen_obj.working_map = map
	screen_obj.position()
	register_map_obj(screen_obj)
	return screen_obj

/client/proc/register_map_obj(obj/screen_obj)
	screen |= screen_obj
	if(screen_obj.working_map)
		on_screen |= screen_obj
		
/client/proc/clear_popups()
	for(var/obj/thing in on_screen)
		del(thing)

/client/New()
	. = ..()
	// Lets do our base setup of planes and relays
	create_screen_obj(/obj/plane_master/parent)
	create_screen_obj(/obj/relay_parent)
	create_screen_obj(/obj/plane_master/base)
	create_screen_obj(/obj/relay_base)
	create_screen_obj(/obj/plane_master/child)

/client/verb/popup_relay_view()
	pop_window("RELAY VIEW", use_relays = TRUE)

/client/verb/popup_view()
	pop_window("VIEW")
	
/client/proc/pop_window(name, use_relays = FALSE)
	clear_popups()
	setup_popup(use_relays)
	for(var/atom/thing in view(mob, view + 1))
		popup_holder.vis_contents += thing
	world.log << "[name] ---"
	print_screen()

/client/proc/print_screen()
	for(var/obj/thing in screen)
		world << "[thing.type]: \n\tloc={[thing.screen_loc]} \n\trender_target={[thing.render_target]} \n\trender_source={[thing.render_source]} \n\tplane={[thing.plane]}"
