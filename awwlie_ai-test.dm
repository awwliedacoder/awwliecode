/mob/ai
    enemy
        icon = 'Icons/New Base/Base.dmi'   
        health = 2500
        stamina = 25000         
        var
            patrol_range = 5
            aggro_range = 15
            mob/current_target = null
            looks = "Human"
            can_move = 1
            movement_speed


/mob/ai/enemy
    proc
        create_apperance(mob/ai/target)
            switch(looks)
                if("Human")
                    var/base = 'Icons/New Base/Base.dmi'
                    var/skintone = pick(rgb(255, 207, 158), rgb(63, 33, 19), 
                                        rgb(136, 92, 48), rgb(255, 201, 148), 
                                        rgb(252, 191, 131), rgb(81, 86, 134), 
                                        rgb(252, 222, 211), rgb(226, 189, 88))
                    base += skintone
                    target.icon = base
                    
                    if(prob(25))
                        src.overlays += 'Icons/New Base/Eyes.dmi'
                        var/hair = 'Icons/New Base/Hair/EmoH.dmi'
                        hair += rgb(202, 77, 71, 255)
                        src.overlays += hair
                        if(prob(25))
                            src.overlays += 'Icons/New Base/Clothing/GogglesBlue.dmi'
                        if(prob(20))
                            src.overlays += 'Icons/New Base/Clothing/facewrap.dmi'
                        src.overlays += 'Icons/New Base/Clothing/Official Clothing/AKAS2.dmi'
                        return
                    if(prob(15))
                        src.overlays += 'Icons/New Base/KisameEyes.dmi'
                        var/hair = 'Icons/New Base/Hair/leeH.dmi'
                        hair += rgb(239, 252, 55, 255)
                        src.overlays += hair
                        src.overlays += 'Icons/New Base/Clothing/SasukeShirt.dmi'                        
                        return

                    if(prob(5))
                        src.overlays = 'Icons/New Base/MaleEyes.dmi'
                        var/hair = 'Icons/New Base/Hair/itachiH.dmi'
                        hair += rgb(71, 65, 102, 255)
                        src.overlays += hair
                        src.overlays += 'Icons/New Base/Clothing/Official Clothing/KageSuitC.dmi'                        
                        return

                    if(prob(45))
                        src.overlays = 'Icons/New Base/FemaleEyes.dmi'
                        var/hair = 'Icons/New Base/Hair/HinaH.dmi'
                        hair += rgb(34, 22, 21, 255)
                        src.overlays += hair
                        src.overlays += 'Icons/New Base/Clothing/Shirt.dmi'
                        src.overlays += 'Icons/New Base/Clothing/Shorts.dmi'
                        return

                    if(prob(100))
                        src.overlays = 'Icons/New Base/EyesClosed.dmi'                    
                        var/hair = 'Icons/New Base/Hair/AfroH.dmi'
                        hair += rgb(63, 41, 23, 255)
                        src.overlays += hair
                        src.overlays += 'Icons/New Base/Clothing/Official Clothing/cvest_open.dmi'
                        src.overlays += 'Icons/New Base/Clothing/Official Clothing/PoliceSkirtRed.dmi'
                        return


        patrol()
            if(!can_move)
                return .
            if(!current_target)
                if(icon_state != "")
                    icon_state = ""            
                var/atom/T = locate(x + rand(-patrol_range, patrol_range), 
                                    y + rand(-patrol_range, patrol_range),
                                    z)
                if(T && !(T.density))
                    walk_to(src, T, 0, 5)

        check_aggro()
            for(var/mob/player/P in view(aggro_range, src))
                if(P)
                    current_target = P
                    break

        chase_target()
            if(!can_move)
                return
            if(current_target)
                if(get_dist(src, current_target) > aggro_range)
                    current_target = null
                    return .
                if(icon_state != "running")
                    icon_state = "running"
                if(prob(25))
                    walk_to(src, pick(src.x+5, src.y+1, src.x-2, src.y+3), 0, 5)
                    sleep(5)
                walk_to(src, current_target, 0, 2, movement_speed)

        attempt_close_range_attack()
            if(current_target && get_dist(src, current_target) < 2)
                if(prob(25))
                    src.Reppu()
                    sleep(25)
                    return
                if(prob(25))
                    src.Senpuu()
                    sleep(25)
                    return
                if(prob(25))
                    src.SpiralingKicks()
                    sleep(25)
                    return
                if(prob(25))
                    src.RapidPunchProc()
                    sleep(25)
                    return

        attempt_ranged_attack()
            if (current_target && get_dist(src, current_target) < 15 && get_dist(src, current_target) > 2)
                switch(Element)
                    if("Fire")
                        if(prob(20))
                            src.HousenkaShoot()
                            sleep(5)
                            src.HousenkaShoot()
                            sleep(5)
                            src.HousenkaShoot()
                            sleep(25)
                            return .
                        if(prob(20))
                            src.FireSpit()
                            sleep(25)
                            return .
                        if(prob(20))
                            src.FireSpitBarrage()
                            sleep(25)
                            return . 
                        if(prob(20))
                            src.KatonRyuusenka()
                            sleep(25)
                            return .  
                        if(prob(20))
                            src.KKE()
                            sleep(25)
                            return . 

                    if("Water")
                        if(locate(/obj/Jutsu) in view(5, src))
                            src.Rising_Water_Wall()
                            sleep(25)
                            return . 

                        if(prob(10))
                            src.CreateWater()
                            sleep(10)
                            return .

                        if(prob(20))
                            src.Bubble()
                            sleep(25)
                            return .    

                        if(prob(20))
                            src.Senjikizame()
                            sleep(25)
                            return . 

                        if(prob(20))
                            src.DaibakufuZ()
                            sleep(25)
                            return .     

                    if("Earth")
                        if(locate(/obj/Jutsu) in view(5, src))
                            src.DotonWall()
                            sleep(25)
                            return . 
                        if(prob(20))
                            src.Kouka()
                            sleep(25)
                            return . 

                        if(prob(20))
                            src.MoveStopper()
                            sleep(25)
                            return . 
                        if(prob(20))
                            src.SwampBrambles()
                            sleep(25)
                            return . 
                        if(prob(20))
                            src.RisingEarthSpikes()
                            sleep(25)
                            return .       
                        if(prob(20))
                            src.DotonDoseikiryuu()
                            sleep(25)
                            return . 

                    if("Lighting")
                        if(prob(10) && locate(/mob/player) in view(3, src))
                            src.RaigekiYoroiz()
                            sleep(25)
                            return .  
                        if(prob(20))
                            src.IkazuchiKiba()
                            sleep(25)
                            return .  
                        if(prob(20))
                            src.Hinoko()
                            sleep(25)
                            return .  
                        if(prob(20))
                            src.DevineThunderRing()
                            sleep(25)
                            return .  
                        if(prob(20))
                            src.Gian()
                            sleep(25)
                            return .  
                        if(prob(20))
                            src.ChidoriSenbon()
                            sleep(25)
                            return .  
                    if("Wind") 
                        if(prob(20))
                            src.Daitoppa()
                            sleep(25)
                            return .  

                        if(prob(20))
                            src.FuutonReppushou()
                            sleep(25)
                            return .  

                        if(prob(20))
                            src.FuutonKazeDanganzz()
                            sleep(25)
                            return .  

                        if(prob(20))
                            src.SpinningWind()
                            sleep(25)
                            return .   

                        if(prob(20))
                            src.FuutonSenbonDice()
                            sleep(25)
                            return .                              

        see_block()
            var/count = 0
            for(var/obj/Jutsu/D in view(5, src))
                count += 1
                break
            if(count)
                src.Guarding = TRUE
                src.icon_state = "block"
                src.can_move = 0
                spawn(15)
                    src.Guarding = 0
                    src.can_move = 1
                    src.icon_state = ""

mob/ai/enemy/proc/ai_process()
    set waitfor = 0
    while(src)
        sleep(5)
        check_aggro()
        see_block()
        if(current_target)
            chase_target()
            attempt_close_range_attack()
            attempt_ranged_attack()
        else
            patrol()


/mob/ai/enemy/New(loc)
    ..()
    create_apperance(src)
    src.loc = loc
    movement_speed = rand(32, 64)
    Element = pick("Fire", "Water", "Wind", "Earth", "Lighting")
    spawn(0)
        ai_process()

