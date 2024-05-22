//// TRADE PACK MISSION THING..
var/MissionReward = 100;
mob/var/whereTo = null
mob/proc/
	TradePackMissionStart()
		var/dice = "1d4"
		var/Destination = list("Snow Country","Sand Country","Rock Country","Grass Country","Small City","Water Country")
		var/H = pick(Destination)

		if (usr.rank == "Missing-Nin")
			goto StolenThing

		if(usr.CarryingTradePack)
			usr <<"You are already carrying a pack!"
			return;


		var/h=roll(dice)
		// Where the packs will spawn, will be randomized using the H variable, what is just the roller..
		// also here we make the worldwide broadcast.
		usr.OnMission = 1
		switch(h)
			if(1)
				usr<< "You're tasked with taking this crate full of <font color=Red>medical supplies</font> towards to [H]"
				usr.whereTo = "[H]"
				var/obj/TradePack/MedicalSupplies/A=new();A.loc=usr
				usr.HeavyTraveling=1
				usr.CarryingTradePack=1
				usr.overlays += image('Icons/Misc/Tradepacks.dmi', pixel_x=-16, pixel_y=-18)
				for(var/mob/M in OnlinePlayers)
					if (M.z!= usr.z && M!=src && M.rank == "Missing-Nin")
						sleep(50)
						M << "<font color=red>A rumor has it [src.name] is carrying a valuable package around the world towards to [src.whereTo] </font>"
			if(2)
				usr<< "You're tasked with taking this crate full of <font color=green>food supplies</font> towards to [H]"
				var/obj/TradePack/FoodSupplies/B=new();B.loc=usr
				usr.HeavyTraveling=1
				usr.CarryingTradePack=1
				usr.overlays += image('Icons/Misc/Tradepacks.dmi', pixel_x=-16, pixel_y=-18)
				usr.whereTo = "[H]"
				for(var/mob/M in OnlinePlayers)
					if (M.z!= usr.z && M!=src && M.rank == "Missing-Nin")
						sleep(50)
						M << "<font color=red>A rumor has it [src.name] is carrying a valuable package around the world towards to [src.whereTo] </font>"
			if(3)
				usr<< "You're tasked with taking this crate full of <font color=gray>war supplies</font> towards to [H]"
				var/obj/TradePack/WeaponSupplies/C=new();C.loc=usr
				usr.HeavyTraveling=1
				usr.CarryingTradePack=1
				usr.overlays += image('Icons/Misc/Tradepacks.dmi', pixel_x=-16, pixel_y=-18)
				usr.whereTo = "[H]"
				for(var/mob/M in OnlinePlayers)
					if (M.z!= usr.z && M!=src && M.rank == "Missing-Nin")
						sleep(50)
						M << "<font color=red>A rumor has it [src.name] is carrying a valuable package around the world towards to [src.whereTo] </font>"
			if(4)
				usr<< "You're tasked with taking this crate full of <font color=pink>trade supplies</font> towards to [H]"
				var/obj/TradePack/RandomSupplies/D=new();D.loc=usr
				usr.HeavyTraveling=1
				usr.CarryingTradePack=1
				usr.overlays += image('Icons/Misc/Tradepacks.dmi', pixel_x=-16, pixel_y=-18)
				usr.whereTo = "[H]"
				for(var/mob/M in OnlinePlayers)
					if (M.z!= usr.z && M!=src && M.rank == "Missing-Nin")
						sleep(50)
						M << "<font color=red>A rumor has it [src.name] is carrying a valuable package around the world towards to [src.whereTo] </font>"
		StolenThing
		while(usr.CarryingTradePack && usr.rank == "Missing-Nin")
			sleep(50)
			usr.TradePackMissionCheck()

		if(usr.OnMission)
			usr.TradePackMissionTimeLimit(1800)

	TradePackMissionTimeLimit(time)
		while(time>0&&usr.CarryingTradePack)
			if(usr.AttackCounter)
				sleep(100)
			usr.TradePackMissionCheck()
			sleep(50)
			time--
			

		if (locate(/obj/TradePack) in usr.contents)
			usr <<"<font color=red>You have failed to completed the tradepack journey in time; It is worthless now.</font>"
			usr.FailedMissions+=1
			usr.OnMission = 0
			usr.HeavyTraveling=0
			usr.CarryingTradePack = 0
			usr.whereTo = null
		else
			usr << "You have lost your trade pack...!!"
			usr.FailedMissions+=1
			usr.OnMission = 0
			usr.HeavyTraveling=0
			usr.CarryingTradePack = 0
			usr.whereTo = null

		usr.overlays -= image('Icons/Misc/Tradepacks.dmi', pixel_x=-16, pixel_y=-18)
		for(var/obj/TradePack/A in usr.contents)
			del(A)

	TradePackMissionCompletion()
		usr.Yen+=MissionReward
		usr <<"<font color=green>You have succesfully completed the tradepack journey.</font>"
		usr <<"<font color=Chartreuse>You have been awarded ¥[MissionReward] </font>"
		usr.overlays -= image('Icons/Misc/Tradepacks.dmi', pixel_x=-16, pixel_y=-18)
		usr.OnMission = 0
		usr.HeavyTraveling=0
		usr.CarryingTradePack = 0		
		for(var/obj/TradePack/A in usr.contents)
			del(A)

	TradePackMissionCompletionStolen()
		usr.Yen+=MissionReward*2.5
		usr <<"<font color=red>You have succesfully stashed away and stolen the journey.</font>"
		usr <<"<font color=DarkOrange>You have been awarded ¥[MissionReward*2.5] </font>"
		usr.overlays -= image('Icons/Misc/Tradepacks.dmi', pixel_x=-16, pixel_y=-18)
		usr.OnMission = 0
		usr.HeavyTraveling=0
		usr.CarryingTradePack = 0
		for(var/obj/TradePack/A in usr.contents)
			del(A)

	TradePackMissionCheck()
		switch(usr.whereTo)
			if("Snow Country")
				if (usr.z == 20)
					usr <<"You're in the right place, now hold on here for a while we unload the package!"
					sleep(500)
					usr.TradePackMissionCompletion()
					usr.OnMission = 0
					usr.HeavyTraveling=0
					usr.CarryingTradePack = 0
					usr.whereTo = null
			if("Sand Country")
				if (usr.z == 21)
					usr <<"You're in the right place, now hold on here for a while we unload the package!"
					sleep(500)
					usr.TradePackMissionCompletion()
					usr.OnMission = 0
					usr.HeavyTraveling=0
					usr.CarryingTradePack = 0
					usr.whereTo = null

			if("Rock Country")
				if (usr.z == 22)
					usr <<"You're in the right place, now hold on here for a while we unload the package!"
					sleep(500)
					usr.TradePackMissionCompletion()
					usr.OnMission = 0
					usr.HeavyTraveling=0
					usr.CarryingTradePack = 0
					usr.whereTo = null

			if("Grass Country")
				if (usr.z == 23)
					usr <<"You're in the right place, now hold on here for a while we unload the package!"
					sleep(500)
					usr.TradePackMissionCompletion()
					usr.OnMission = 0
					usr.HeavyTraveling=0
					usr.CarryingTradePack = 0
					usr.whereTo = null

			if("Small City")
				if (usr.z == 24)
					usr <<"You're in the right place, now hold on here for a while we unload the package!"
					sleep(500)
					usr.TradePackMissionCompletion()
					usr.OnMission = 0
					usr.HeavyTraveling=0
					usr.CarryingTradePack = 0
					usr.whereTo = null
			if("Water Country")
				if (usr.z == 25)
					usr <<"You're in the right place, now hold on here for a while we unload the package!"
					sleep(500)
					usr.TradePackMissionCompletion()
					usr.OnMission = 0
					usr.HeavyTraveling=0
					usr.CarryingTradePack = 0
					usr.whereTo = null
			if("Thieves Guild")
				if (usr.z == 26)
					usr <<"You're in the right place, now hold on here for a while we unload the package before the authorities find us!"
					sleep(500)
					usr.TradePackMissionCompletionStolen()
					usr.OnMission = 0
					usr.HeavyTraveling=0
					usr.CarryingTradePack = 0
					usr.whereTo = null

	TradePackMissionSteal()
		if(usr.rank == "Missing-Nin")
			usr.whereTo = "Thieves Guild"
			usr << "<h4> You have taken a hold of </b>TRADE PACK</b> deliver it to [usr.whereTo] for a massive pay off!</h4> "
			usr.TradePackMissionStart()


mob/NPC/TradePackDude//Merchant System in developement//Just so you know where they are on the map.
	verb/Command()
		set src in oview(1)
		set name="Command"
		set hidden=1
		src.TradePackMissionStart()

obj/TradePack
	icon = 'Icons/Misc/Tradepacks.dmi'
	density=1
	pixel_x=-16
	pixel_y=-16
	var/OriginalOwner = null

	verb
		Get()
			set src in oview(1)
			if(!usr.knockedout||usr.Dead)
				var/AlreadyCarrying=0
				for(var/obj/TradePack/A in usr.contents)
					AlreadyCarrying = 1

				if(AlreadyCarrying)
					usr<<"You're already carrying a pack"
					return
				else
					if (OriginalOwner == null)
						src.OriginalOwner = usr
					src.loc = usr
					usr <<"You picked up [src.name]"
					usr.overlays+= image('Icons/Misc/Tradepacks.dmi', pixel_x=-16, pixel_y=-18)
					usr.CarryingTradePack = 1
					usr.HeavyTraveling=1
					if(src.OriginalOwner != usr || usr.rank == "Missing-Nin")
						usr.TradePackMissionSteal()




		Drop()
			src.loc=locate(usr.x, usr.y, usr.z)
			usr.overlays -= image('Icons/Misc/Tradepacks.dmi', pixel_x=-16, pixel_y=-18)
			usr.HeavyTraveling=0
			usr.CarryingTradePack = 0


	MedicalSupplies
		name = "Medical Supplies"
	FoodSupplies
		name = "Food Supplies"
	WeaponSupplies
		name = "Ninja Tool Supplies"
	RandomSupplies
		name = "Generic Supplies"


