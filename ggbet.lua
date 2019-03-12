local Nyx = {}

Nyx.Enabled = Menu.AddOptionBool({"Hero Specific", "Nyx Assassin"}, "Enabled", false)
Nyx.Key = Menu.AddKeyOption({"Hero Specific", "Nyx Assassin"}, "Кнопка комбо", Enum.ButtonCode.KEY_V)
Nyx.Items = {"Hero Specific", "Nyx Assassin", "Артефакты в комбо"}
Nyx.Skill = {"Hero Specific", "Nyx Assassin", "Скилы в комбо"}

Nyx.Dagon = Menu.AddOptionBool(Nyx.Items, "Dagon", false)
-- картинка
Nyx.Urn = Menu.AddOptionBool(Nyx.Items, "Urn or Spirit Vessel", false)
--картинка
Nyx.EtherealBlade = Menu.AddOptionBool(Nyx.Items, "Ethereal Blade", false)
--картинка
Nyx.ShivaGuard = Menu.AddOptionBool(Nyx.Items, "Shivas Guard", false)
--картинка

Nyx.Impale = Menu.AddOptionBool(Nyx.Skill, "Impale")
--картинка
Nyx.ManaBurn = Menu.AddOptionBool(Nyx.Skill, "Mana Burn")
--картинка
Nyx.SpikedCarapace = Menu.AddOptionBool(Nyx.Skill, "Spiked Carapace")
--картинка
Nyx.Vendetta = Menu.AddOptionBool(Nyx.Skill, "Vendetta")
--картинка

local font = Renderer.LoadFont("Tahoma", 20, Enum.FontWeight.EXTRABOLD)

local enemy = nil
local myHero = nil

local dagon
local urn
local etherealblade
local shivaguard

Nyx.lastTick = 0

local impale
local manaburn
local spikedcarapace
local vendetta

local sleep_after_cast = 0
local sleep_after_attack = 0 



function Nyx.OnUpdate()
    if not Menu.IsEnabled(Nyx.Enabled) or not Engine.IsInGame() or not Heroes.GetLocal() then return end
	    myHero = Heroes.GetLocal()
		if NPC.GetUnitName(myHero) ~= "npc_dota_hero_nyx_assassin" then return end
	    if not Entity.IsAlive(myHero) or NPC.ISstunned(myHero) or NPC.IsSilenced(myHero) then return end
		if Menu.IsKeyDown(Nyx.Key) then
		         enemy = Input.GetNearestHeroToCursor(Entity.GetTeamNum(myHero), Enum.TeamType.TEAM_ENEMY)
	             if enemy and enemy~= 0 then
				         Nyx.Combo(myHero, enemy)
						 return
			     end
		end
end

function Nyx.Combo(myHero, enemy)

     impale = NPC.GetAbility(myHero, "nyx_assassin_impale")
     burn = NPC.GetAbility(myHero, "nyx_assassin_mana_burn")
     spiked = NPC.GetAbility(myHero, "nyx_assassin_spiked_carapace")
	 
	 dagon = NPC.GetItem(myHero,"item_dagon") 
	 urn = NPC.GetItem(myHero,"item_urn_of_shadows")
    if not urn then
        urn = NPC.GetItem(myHero, "item_spirit_vessel")
    end
	 blade = NPC.GetItem(myHero, "item_ethereal_blade")
	 shiva = NPC.GetItem(myHero, "item_shivas_guard")
	 
	 local myMana = NPC.GetMana(myHero)
	 
	 
	 if Menu.IsKeyDown(Nyx.Key) and Entity.GetHealth(enemy) > 0 then  
	     if not NPC.IsEntityInRange(myHero, enemy, 1500) then return end
		 local enemy_origun = Entity.GetAbsOrigin(enemy)
		 local curdor_pos = Input.GetWorldCursorPos()
	     if (cursor_pos - enemy_origin):Length2D() > Menu.GetValue(Nyx.NearestTarget) then enemy = nil return end
	     
		 if impale and Ability.IsCastable(impale, myMana) and Menu.IsEnabled(Nyx.Impale) then
		     Ability.CastPosition(impale, enemy_origin)
			 Nyx.lastTick = os.clock()
	     end
			 
		 if urn and Ability.IsReady(urn) and Menu.IsEnabled(Nyx.Urn) then
            Ability.CastTarget(urn, enemy)
         end
		 
		 if blade and Ability.IsReady(blade, myMana) and Menu.IsEnabled(Nyx.Blade) then
            Ability.CastTarget(blade, enemy)
         end
		 
		 if dagon and Ability.IsReady(dagon, myMana) and Menu.IsEnabled(Nyx.Dagon) then
		     Ability.CastTarget(dagon, enemy)
		 end
		 
		  if shiva and Ability.IsReady(shiva, myMana) and Menu.IsEnabled(Nyx.Shiva) then
            Ability.CastNoTarget(shiva)
        end
         if Nyx.SleepReady(0.3, sleep_after_attack) then
            Player.AttackTarget(Players.GetLocal(), myHero, enemy, false)
            sleep_after_attack = os.clock()
            Nyx.lastTick = os.clock()
            sleep_after_cast = os.clock()
            return
        end
    end
end
end



function Nyx.SleepReady(sleep, lastTick)
    if (os.clock() - Nyx.lastTick) >= sleep then
		return true
    end
    
	return false
end


return Nyx



