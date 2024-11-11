obj
	InjurySystem
		Injury
			var 
				injuredBy = null
				time = null
				healthReduction = null
				staminaReduction = null
				description
			New(name, time, setDescription,  healthAmount, staminaAmount, Injurer)
				..()
				src.name = name
				src.time = time
				src.injuredBy = Injurer
				src.staminaReduction = staminaAmount
				src.healthReduction = healthAmount
				src.description = setDescription



mob
	var
		riskLevel
		tmp/pendingInjuries[0]

	proc    
		applyInjury(mob/Injuree)
			if(!Injuree.client) return
			var
				mob/Injurer = Injuree.killer
				permaChance = roll(1, 20)
				woundChance = roll(1, 8)
				risk = 0

				time
				wound

			switch(Injurer.riskLevel)
				if(0)
					return .
				if(1)
					risk = 4
				if(2)
					risk = 10
				if(3)
					risk = 18
			if(!Injurer.pendingInjuries.Find(Injuree))
				Injurer.pendingInjuries.Add(Injuree)
			for(var/obj/HUD/FieldHUD/SetInjure/A in Injurer.client.screen)
				A.icon_state = "injureFlagAlert"

			wound = (woundChance + risk - Injuree.deathcount)*5
			
			if((permaChance + risk - 7) >= 15) //check if permanent (1d20 + risk - 7)
				time = "Permanent"

			if(wound<15)
				wound=15
			else
				time = world.realtime + (((10 + woundChance + risk - Injuree.deathcount)*8)*60*60*10)
			var/tempName = pick("Head Injury", "Torso Injury", "Leg Injury")

			new/obj/InjurySystem/Injury("[tempName]", time, wound, wound*10, "[src.SecondName], [src.FirstName]")


			oview(10, Injuree) << "[Injuree] has suffered an injury from [Injurer]."
			oview(10, Injuree) << " - Wound Roll Info -<br>Risk: [risk];"
			oview(10, Injuree) << "Dice Roll(1d6): [woundChance]; Permanent Roll(1d20):[permaChance];"
			oview(10, Injuree) << "Vitality Lost: [wound]; Stamina Lost: [wound*10];"
			oview(10, Injuree) << "Injured by: [Injurer]; Healed on: [time2text(time)]<br> Ask [Injurer] OOCly to set a name and description for your wound."			

		checkInjury()


		setInjure()//Used for those who defeated someone to set a desc and a name for the injure.
			if(src.pendingInjuries.len)
				for(var/j=pendingInjuries.len;j>0;j--)
					var/mob/M = pendingInjuries[j]
					var/InjurererName = "[src.SecondName], [src.FirstName]"
					for(var/obj/InjurySystem/Injury/Search in M.contents)
						if(istype(Search, /obj/InjurySystem/Injury))
							if(Search.injuredBy == InjurererName)
								Search.desc = input(usr,"Describe the wound you inflicted on [M].") as text
								Search.name = input(usr,"Give a name for that wound.") as text
					pendingInjuries.len--
				for(var/obj/HUD/FieldHUD/SetInjure/A in src.client.screen)
					A.icon_state = "injureFlag"

		healInjury(mob/Target)
			var/list/Injuries = list()
			for(var/obj/InjurySystem/Injury/Search in Target.contents)
				if(istype(Search, /obj/InjurySystem/Injury))
					Injuries.Add(Search)
			
			var/choice = input(src, "Which of these Injuries would you wish to heal?", "Injury Heal", null) in list ("Cancel" + Injuries)
			if(choice == "Cancel")
				src << "You decide to not heal [Target]"
				return
			else
				for(var/obj/InjurySystem/Injury/Search in Target.contents)
					if(Search.name == choice)
						del Search
						usr << "You have healed [Target]'s [choice] injury!"
						return
						
		healAllInjury(mob/Target)
			for(var/obj/InjurySystem/Injury/Delete)
				del Delete

		checkInjuries(mob/Target)
			for(var/obj/InjurySystem/Injury/Helper in Target.contents)
				var/healTime = time2text(Helper.time,"DDD MMM DD hh:mm:ss YYYY")
				usr << "[Helper.name] --"
				usr << "[Helper.description]"
				usr << "[Helper.healthReduction] --"
				usr << "[Helper.staminaReduction] --"
				usr << "[healTime] --"
