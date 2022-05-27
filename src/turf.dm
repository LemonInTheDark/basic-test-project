/turf/floor
    icon = 'icons/turfs.dmi'
    icon_state = "floor"

/turf/wall
    icon = 'icons/turfs.dmi'
    icon_state = "wall"
    density = 1

/turf/floor/a_spawn

/turf/floor/a_spawn/New()
    tag = "a_spawn"
    return ..()

/turf/floor/a_source

/turf/floor/a_source/New()
    tag = "a_source"
    return ..()