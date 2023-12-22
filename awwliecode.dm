mob/var/WillingToRampage = 0 // 1 == Yes || 0 == no.
mob/var/Izanagi = 0 // 1 == has Izanagi || 0 == 0
mob/var/Izanami = 0
mob/var/KilledBy
mob/var/howMuchMoneySpentOnStrippers = 0
mob/var/BetAmount = 0
mob/var/HowMuchLost = 0
var/Doorvaluething


var/dead=0
mob/GainedAfterLogIn/verb
	WillingRampage()
		set name="Willing Rampage"
		set category="Commands"
		if(usr.BijuuMastery > 30)
			usr<<"You're too experienced to let your bijuu rampage!"
			return
		if(usr.BijuuMastery >= 1)
			if(usr.WillingToRampage == 1 && usr.BijuuMastery >= 1)
				usr<<"<font color = red><b>Ask an admin to reset your Willingness to Rampage (After awhile)"
				return
			usr<<"<font color = red><b>You let go and allow the beast to consume your will!!"
			usr.WillingToRampage = 1
			ReleaseBijuu()
			 //# for refrence, admins / wipe host should allow this once unsupervised.. otherwise talk to an dmin or some.
			// src.DelayIt(500000,M,"None")
		if(usr.BijuuMastery < 1 )
			usr<<"<font color = red><b>You don't have a Bijuu or enough mastery!"
mob/proc/Voiding()
	// Basically, the idea is to put this on the death proc.
	var/VoidChance = 75
	 // 20 is the base value, can be adjusted as we go through. However, if you roll below the VoidCHance, you'll lose your character.
	//	var/RebirthChance = 5
	var
		VoidRoll = roll(1,100)
//		RbChance = roll(1,20)
//		lttraitroll = roll(1,100)
//		deveyeroll = roll(1,50)
	if (src.SecondName=="Sarutobi")
		VoidChance-=5
	if (src.Izanagi==1)
		VoidChance = 0
	if (VoidRoll > VoidChance)
        //If void roll is equal to or higher than basevalue, it'll let you live, otherwise, you'll go through death.
		src <<"Against all odds, you have eluded the clutches of death for now. <br>Utilize this second chance wisely, for you may not be so fortunate the next. <br>With a total roll of <font color=#1489b4>[VoidRoll]</font> you prevailed over death's door at value <font color=#b02014>[VoidChance]</font>."
		src.loc = locate(156,64,61)
		src.SaveK2()
		client.HttpPost(
						/* Replace this with the webhook URL that you can Copy in Discord's Edit Webhook panel.
							It's best to use a global const for this and keep it secret so others can't use it.
						*/
						"https://discord.com/api/webhooks/",

						/*
						[content] is required and can't be blank.
							It's the message posted by the webhook.

						[avatar_url] and [username] are optional.
							They're taken from your key.
							They override the webhook's name and avatar for the post.
						*/
						list(
							content = "This dude voided.",
							username = "[src.name] [key]"
						)
					)

	else
		src <<"The world around you grows dark, and the final flicker of life within you fades into nothingness. <br>With a total roll of <font color=#1489b4>[VoidRoll]</font> you failed to overcome the embrace of death at value <font color=#b02014>[VoidChance]</font>.<br>"
		src <<"<b>You have... Died.</b>"
		src.loc = locate(155,87,58)
		src.SaveK2()
		client.HttpPost(
						/* Replace this with the webhook URL that you can Copy in Discord's Edit Webhook panel.
							It's best to use a global const for this and keep it secret so others can't use it.
						*/
						"https://discord.com/api/webhooks/",

						/*
						[content] is required and can't be blank.
							It's the message posted by the webhook.

						[avatar_url] and [username] are optional.
							They're taken from your key.
							They override the webhook's name and avatar for the post.
						*/
						list(
							content = "This dude didn't void",
							username = "[src.name] [key]"
						)
					)


mob/GainedAfterLogIn/verb
	Kill(mob/M in get_step(src,src.dir))
		set name="Kill"
		set category="Commands"
		if(!M.client) return
		var
			deathornot
		switch (input(usr, "Are you sure you want to kill [M]","Death") in list("No","Yes"))
			if("Yes")
				deathornot = input(M, "[src] is trying to kill you!") in list ("Accept","Deny")
				switch(deathornot)
					if("Accept")
						M << "<b>This is how you died..</b>"
						M.KilledBy = "[src]"
						M.Dead=1
						M.Bloody()
						M.Voiding()
						M.SaveK2()
						client.HttpPost(
						/* Replace this with the webhook URL that you can Copy in Discord's Edit Webhook panel.
							It's best to use a global const for this and keep it secret so others can't use it.
						*/
						"https://discord.com/api/webhooks/",

						/*
						[content] is required and can't be blank.
							It's the message posted by the webhook.

						[avatar_url] and [username] are optional.
							They're taken from your key.
							They override the webhook's name and avatar for the post.
						*/
						list(
							content = "[src] has killed [M]",
							username = "[src.name] [key]"
						)
					)
					if("Deny")
						return
			if("No")
				return
/*
mob/proc/StripperStatBoost()
	if(usr.Age<18)
		view()<<"<b>[usr] was kicked away from the club for being too young!!"
		usr.stamina-=200
		usr.HitBack(2,SOUTH)
		return;
	if(usr.Yen<10000)
		view()<<"<b>[usr] was slapped by a stripper for being too broke!"
		usr.stamina-=100
		usr.HitBack(2,SOUTH)
		return;
	usr.Yen-=10000
	view()<<"[usr]'s eyes are set on the Stripper!!"
	usr.howMuchMoneySpentOnStrippers+=10000
	usr.addTaiAddOn("StripperBoost",usr.TaiSkill*1.1)
	usr.addNinAddOn("StripperBoost",usr.NinSkill*1.1)
	usr.addGenAddOn("StripperBoost",usr.GenSkill*1.1)

	spawn(5000)
		view()<<"[usr]'s interest is falling away from the Stripper!"
		usr.removeGenAddOn("StripperBoost")
		usr.removeNinAddOn("StripperBoost")
		usr.removeTaiAddOn("StripperBoost") 

mob/proc/Pachinko()
	var
		SmallRoll
		BigRoll
		MegaRoll
		LossRoll

	var/html = "<html> <title>Pachinko Machine</title> <body bgcolor=black text=#CCCCCC link=white vlink=white alink=white></html>"
	html += "<h1 align=center>[usr]'s Pachinko Machine!</h1>"


	if(usr.Age<18)
		view()<<"[usr] is too young to play the Pachinko machine!"
		usr.Yen-=100
		return;
	if(usr.Yen<100)
		view()<<"[usr] puts [usr.Yen] ryo in machine, but it does not start!"
		usr.Yen-=usr.Yen
		return;

	usr.BetAmount = input("Bet amount", "How much") as num
	if(usr.Yen<usr.BetAmount)
		usr <<"You cannot go in to debt!"
		return;


	if(usr.BetAmount < 100)
		usr.BetAmount = 100
		usr <<"The minimum bet is 100; Your bet has been set at 100 RYO!"

		switch(usr.Village)
		if("Leaf")
			LeafVillagePool+=100
		if("Rain")
			RainVillagePool+=100
		if("Rock")
			RockVillagePool+=100
		if("Sound")
			SoundVillagePool+=100
		if("Sand")
			SandVillagePool+=100
		if("Cloud")
			CloudVillagePool+=100

	html += "<p align=center>The Machine takes 100 ryo as donation!</p>" 
	if(usr.BetAmount >= 10000)
		usr <<"The maximum bet is 10000 ryo at a time!"
		return
	usr.HowMuchLost -= usr.BetAmount
	usr.Yen -= usr.BetAmount


	usr <<"The machine begins to roll balls!!"
	for(var/i=1, i<=(usr.BetAmount/100), i++)
		SmallRoll = roll(1,25)
		BigRoll = roll(1,110)
		MegaRoll = roll(1,1250)
		LossRoll = roll(1,155)

		html += "<p align=center>[usr]'s [i]'s ball has landed on [SmallRoll]!</p>"
		html += "<p align=center>[usr]'s [i]'s ball has landed on [BigRoll]</p>"
		html += "<p align=center>[usr]'s [i]'s ball has landed on [MegaRoll]</p>"
		spawn(100)
		if(LossRoll == 1 )
			html += "<p align=center>[usr]'s ball has gone in to the loss lost zone! A a part of your money must be paid in due to this amount [usr.BetAmount/3] Ryo</p>"
			usr.HowMuchLost-= usr.BetAmount/3
			usr.Yen-= usr.BetAmount/3
		if(usr.Clan=="Uchiha" && MegaRoll == 13)
			view()<<"[usr] GOT THE MEGA JACKPOT [BetAmount*100] ryo...  but the machine sputters and spits as it jams, resulting in no payout!"
			return;

		if(SmallRoll==1)
			html += "<p align=center>[usr] has won a small jackpot of [BetAmount*0.1] Ryo</p>"
			usr.Yen+=BetAmount*0.1
			usr.HowMuchLost+=BetAmount*0.1
		if(BigRoll==1)
			html += "<p align=center>[usr] has won a jackpot of [BetAmount*1.5]</p>"
			usr.Yen+=BetAmount*1.5
			usr.HowMuchLost+=BetAmount*1.5

		if(MegaRoll==1)
			html += "<p align=center>[usr] has won a mega jackpot of [BetAmount*15]</p>"
			usr.Yen+=BetAmount*15
			usr.HowMuchLost+=BetAmount*15


	if(usr.HowMuchLost<0)
		html += "<h3 align=center>[usr] has lost [usr.HowMuchLost] ryo so far!!</h3>"
	else
		html += "<h3 align=center>[usr] has won [usr.HowMuchLost] ryo so far!!</h3>"
	usr << browse("[html]","window=Event;size=750x600")
mob/GameMachines/
	PachinkoMachine
		name = "Pachinko Machine"
		icon = 'Icons/pachinko.dmi'

		layer=MOB_LAYER+100

		verb/Command()
			set src in oview(1)
			set name="Command"
			set hidden=1
			if(!src in get_step(usr,usr.dir))
				usr<<"You need to be facing machine!";return
			sleep(3)
			usr.Pachinko()
*/

mob/Admin/verb/ModifyDoorValue()
	set name = "Modify Value oF Door"
	set category = "Staff"
	switch(input(usr,"Do you want to adjust the Value of Door Chakra?") in list("Yes","No"))
		if("Yes")
			var/Doorvaluething=input(usr,"Set the Value")
		if("No")
			return	

mob/proc/ChakraKunaiStealThing()
	for(var/mob/M in get_step(src,src.dir))
		var/howmuchtosteal
		var/global/howmuchchakratoopendoor
		switch(usr.riskLevel)
			if(0)
				usr<<"You must have a at least Risk Level of 1!"
				return;
			if(1)
				howmuchtosteal = 250
				view() <<"<b>[src] strikes the Kunai of Seperation in to the skin of [M] stealing [howmuchtosteal] chakra!</b>"
				howmuchchakratoopendoor = howmuchchakratoopendoor + howmuchtosteal
			if(2)
				howmuchtosteal = 500
				view() <<"<b>[src] strikes the Kunai of Seperation in to the skin of [M] stealing [howmuchtosteal] chakra!</b>"
				howmuchchakratoopendoor = howmuchchakratoopendoor + howmuchtosteal
			if(3)
				howmuchtosteal = 750
				view() <<"<b>[src] strikes the Kunai of Seperation in to the skin of [M] stealing [howmuchtosteal] chakra!</b>"
				howmuchchakratoopendoor = howmuchchakratoopendoor + howmuchtosteal

		M.chakra-=howmuchtosteal
		client.HttpPost(
		"https://discord.com/api/webhooks/",
		list(
			content = "[src] has drained [M] of [howmuchtosteal] chakra; So far [howmuchchakratoopendoor] / [Doorvaluething] chakra has been collected",
			username = "[src.name] [key]"
		)
	)

obj/WEAPONS/ChakraDrainKunai
	name = "Kunai of Seperation"
	icon = 'Icons/SunaBuilding/kunai1.dmi'
	verb
		SeparateChakra()
			usr.ChakraKunaiStealThing()


