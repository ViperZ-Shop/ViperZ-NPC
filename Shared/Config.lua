Config = {}


Config.MostrarBlip = true  


--NPC'S TIENDA
Config.TiendaPrimerNPC = {
    items = {
        { label = 'Porro - <span style="color:green;">5$</span>', value = 'joint', price = 5 }, 
        { label = 'Mechero - <span style="color:green;">3$</span>', value = 'lighter', price = 3 },
        { label = 'Hablar con el Jefe', value = 'hablar_jefe' }
    },
}

Config.TiendaBossNPC = {
    weapons = {
        { label = 'Cuchillo - <span style="color:green;">350$</span>', value = 'WEAPON_KNIFE', price = 350 },
        { label = 'Bate - <span style="color:green;">500$</span>', value = 'WEAPON_BAT', price = 500 },
        { label = 'Pistola SNS - <span style="color:green;">4500$</span>', value = 'WEAPON_SNSPISTOL', price = 4500 }
    },
}

-- CONFIGURACION DE LOS NPC'S
Config.PRIMERNPC = {
    coords = {x = -1557.1393, y = -416.2604, z = 37.0950},
    heading = 140.7039,
    model = "g_m_m_chigoon_01",
    animation = "WORLD_HUMAN_SMOKING",
    distance = 1.5, 
    CooldownMinutes = 10
}

Config.JEFENPC = {
    coords = {x = -2016.9220, y = 559.3937, z = 107.2909},
    heading = 73.2524,
    model = "g_m_m_armboss_01",
    animation = "WORLD_HUMAN_GUARD_STAND",
    distance = 1.5
}
