--[[
< CATHERINE > - A free role-playing framework for Garry's Mod.
Development and design by L7D.

Catherine is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Catherine.  If not, see <http://www.gnu.org/licenses/>.
]]--

Schema.vo = Schema.vo or { }
Schema.vo.normalVoice = { }
Schema.vo.dispatchVoice = { }
Schema.vo.breenCast = { }

local COMBINE, CITIZEN = Schema.IsCombineFacton, { FACTION_CITIZEN, FACTION_CWU }

function Schema.vo.RegisterNormal( faction, command, output, sound, allowFemale )
	Schema.vo.normalVoice[ #Schema.vo.normalVoice + 1 ] = {
		faction = faction,
		command = command,
		output = output,
		sound = sound,
		allowFemale = allowFemale
	}
end

function Schema.vo.RegisterDispatch( command, output, sound )
	Schema.vo.dispatchVoice[ #Schema.vo.dispatchVoice + 1 ] = {
		command = command,
		output = output,
		sound = sound
	}
end

function Schema.vo.RegisterBreenCast( command, output, sound )
	Schema.vo.breenCast[ #Schema.vo.breenCast + 1 ] = {
		command = command,
		output = output,
		sound = sound
	}
end

Schema.vo.RegisterBreenCast( "Welcome1", "Welcome, Welcome to City 17.", "breencast/br_welcome01.wav" )

Schema.vo.RegisterDispatch( "Anti-Citizen", "Attention ground units. Anti-citizen reported in this community. Code: LOCK, CAUTERIZE, STABILIZE.", "npc/overwatch/cityvoice/f_anticitizenreport_spkr.wav" )
Schema.vo.RegisterDispatch( "Anti-Civil", "Protection team alert. Evidence of anti-civil activity in this community. Code: ASSEMBLE, PLAN, CONTAIN.", "npc/overwatch/cityvoice/f_anticivilevidence_3_spkr.wav" )
Schema.vo.RegisterDispatch( "Person Interest", "Attention please. Unidentified person of interest confirm your civil status with local protection team immediately.", "npc/overwatch/cityvoice/f_confirmcivilstatus_1_spkr.wav" )
Schema.vo.RegisterDispatch( "Citizen Inaction", "Citizen reminder. Inaction is conspiracy. Report counter behaviour to a Civil Protection team immediately.", "npc/overwatch/cityvoice/f_innactionisconspiracy_spkr.wav" )
Schema.vo.RegisterDispatch( "Unrest Structure", "Alert community ground protection units, local unrest structure detected. ASSEMBLE, ADMINISTER, PACIFY.", "npc/overwatch/cityvoice/f_localunrest_spkr.wav" )
Schema.vo.RegisterDispatch( "Status Evasion", "Attention protection team. Status evasion in progress in this community. RESPOND, ISOLATE, ENQUIRE.", "npc/overwatch/cityvoice/f_protectionresponse_1_spkr.wav" )
Schema.vo.RegisterDispatch( "Lockdown", "Attention all ground protection teams. Judgment waiver now in effect. Capital prosecution is discretionary.", "npc/overwatch/cityvoice/f_protectionresponse_5_spkr.wav" )
Schema.vo.RegisterDispatch( "Rations Deducted", "Attention occupants. Your block is now charged with permissive inactive cohesion. Five ration units deducted.", "npc/overwatch/cityvoice/f_rationunitsdeduct_3_spkr.wav" )
Schema.vo.RegisterDispatch( "Inspection", "Citizen notice. Priority identification check in progress. Please assemble in your designated inspection positions.", "npc/overwatch/cityvoice/f_trainstation_assemble_spkr.wav" )
Schema.vo.RegisterDispatch( "Inspection 2", "Attention please. All citizens in local residential block, assume your inspection positions.", "npc/overwatch/cityvoice/f_trainstation_assumepositions_spkr.wav" )
Schema.vo.RegisterDispatch( "Miscount Detected", "Attention resident. Miscount detected in your block. Co-operation with your Civil Protection team permit full ration reward.", "npc/overwatch/cityvoice/f_trainstation_cooperation_spkr.wav" )
Schema.vo.RegisterDispatch( "Infection", "Attention resident. This block contains potential civil infection. INFORM, CO-OPERATE, ASSEMBLE.", "npc/overwatch/cityvoice/f_trainstation_inform_spkr.wav" )
Schema.vo.RegisterDispatch( "Relocation", "Citizen notice. Failure to co-operate will result in permanent off-world relocation.", "npc/overwatch/cityvoice/f_trainstation_offworldrelocation_spkr.wav" )
Schema.vo.RegisterDispatch( "Unrest Code", "Attention community. Unrest procedure code is now in effect. INOCULATE, SHIELD, PACIFY. Code: PRESSURE, SWORD, STERILIZE.", "npc/overwatch/cityvoice/f_unrestprocedure1_spkr.wav" )
Schema.vo.RegisterDispatch( "Evasion", "Attention please. Evasion behaviour consistent with mal-compliant defendant. Ground protection team, alert. Code: ISOLATE, EXPOSE, ADMINISTER.", "npc/overwatch/cityvoice/f_evasionbehavior_2_spkr.wav" )
Schema.vo.RegisterDispatch( "Individual", "Individual. You are charged with social endangerment, level one. Protection unit, prosecution code: DUTY, SWORD, MIDNIGHT.", "npc/overwatch/cityvoice/f_sociolevel1_4_spkr.wav" )
Schema.vo.RegisterDispatch( "Autonomous", "Attention all ground protection teams. Autonomous judgement is now in effect, sentencing is now discretionary. Code: AMPUTATE, ZERO, CONFIRM.", "npc/overwatch/cityvoice/f_protectionresponse_4_spkr.wav" )
Schema.vo.RegisterDispatch( "Citizenship", "Individual. You are convicted of multi anti-civil violations. Implicit citizenship revoked. Status: MALIGNANT.", "npc/overwatch/cityvoice/f_citizenshiprevoked_6_spkr.wav" )
Schema.vo.RegisterDispatch( "Malcompliance", "Individual. You are charged with capital malcompliance, anti-citizen status approved.", "npc/overwatch/cityvoice/f_capitalmalcompliance_spkr.wav" )
Schema.vo.RegisterDispatch( "Exogen", "Overwatch acknowledges critical exogen breach, AirWatch augmentation force dispatched and inbound. Hold for reinforcements.", "npc/overwatch/cityvoice/fprison_airwatchdispatched.wav" )
Schema.vo.RegisterDispatch( "Failure", "Attention ground units. Mission failure will result in permanent off-world assignment. Code reminder: SACRIFICE, COAGULATE, PLAN.", "npc/overwatch/cityvoice/fprison_missionfailurereminder.wav" )

Schema.vo.RegisterNormal( COMBINE, "Sweeping", "Sweeping for suspect.", "npc/metropolice/hiding02.wav" )
Schema.vo.RegisterNormal( COMBINE, "Isolate", "Isolate!", "npc/metropolice/hiding05.wav" )
Schema.vo.RegisterNormal( COMBINE, "You Can Go", "Alright, you can go.", "npc/metropolice/vo/allrightyoucango.wav" )
Schema.vo.RegisterNormal( COMBINE, "Need Assistance", "Eleven-ninety-nine, officer needs assistance!", "npc/metropolice/vo/11-99officerneedsassistance.wav" )
Schema.vo.RegisterNormal( COMBINE, "Administer", "Administer.", "npc/metropolice/vo/administer.wav" )
Schema.vo.RegisterNormal( COMBINE, "Affirmative", "Affirmative.", "npc/metropolice/vo/affirmative.wav" )
Schema.vo.RegisterNormal( COMBINE, "All Units Move In", "All units move in!", "npc/metropolice/vo/allunitsmovein.wav" )
Schema.vo.RegisterNormal( COMBINE, "Amputate", "Amputate.", "npc/metropolice/vo/amputate.wav" )
Schema.vo.RegisterNormal( COMBINE, "Anti-Citizen", "Anti-citizen.", "npc/metropolice/vo/anticitizen.wav" )
Schema.vo.RegisterNormal( COMBINE, "Citizen", "Citizen.", "npc/metropolice/vo/citizen.wav" )
Schema.vo.RegisterNormal( COMBINE, "Copy", "Copy.", "npc/metropolice/vo/copy.wav" )
Schema.vo.RegisterNormal( COMBINE, "Cover Me", "Cover me, I'm going in!", "npc/metropolice/vo/covermegoingin.wav" )
Schema.vo.RegisterNormal( COMBINE, "Assist Trespass", "Assist for a criminal trespass!", "npc/metropolice/vo/criminaltrespass63.wav" )
Schema.vo.RegisterNormal( COMBINE, "Destroy Cover", "Destroy that cover!", "npc/metropolice/vo/destroythatcover.wav" )
Schema.vo.RegisterNormal( COMBINE, "Don't Move", "Don't move!", "npc/metropolice/vo/dontmove.wav" )
Schema.vo.RegisterNormal( COMBINE, "Final Verdict", "Final verdict administered.", "npc/metropolice/vo/finalverdictadministered.wav" )
Schema.vo.RegisterNormal( COMBINE, "Final Warning", "Final warning!", "npc/metropolice/vo/finalwarning.wav" )
Schema.vo.RegisterNormal( COMBINE, "First Warning", "First warning, move away!", "npc/metropolice/vo/firstwarningmove.wav" )
Schema.vo.RegisterNormal( COMBINE, "Get Down", "Get down!", "npc/metropolice/vo/getdown.wav" )
Schema.vo.RegisterNormal( COMBINE, "Get Out", "Get out of here!", "npc/metropolice/vo/getoutofhere.wav" )
Schema.vo.RegisterNormal( COMBINE, "Suspect One", "I got suspect one here.", "npc/metropolice/vo/gotsuspect1here.wav" )
Schema.vo.RegisterNormal( COMBINE, "Help", "Help!", "npc/metropolice/vo/help.wav" )
Schema.vo.RegisterNormal( COMBINE, "Running", "He's running!", "npc/metropolice/vo/hesrunning.wav" )
Schema.vo.RegisterNormal( COMBINE, "Hold It", "Hold it right there!", "npc/metropolice/vo/holditrightthere.wav" )
Schema.vo.RegisterNormal( COMBINE, "Move Along Repeat", "I said move along.", "npc/metropolice/vo/isaidmovealong.wav" )
Schema.vo.RegisterNormal( COMBINE, "Malcompliance", "Issuing malcompliance citation.", "npc/metropolice/vo/issuingmalcompliantcitation.wav" )
Schema.vo.RegisterNormal( COMBINE, "Keep Moving", "Keep moving!", "npc/metropolice/vo/keepmoving.wav" )
Schema.vo.RegisterNormal( COMBINE, "Lock Position", "All units, lock your position!", "npc/metropolice/vo/lockyourposition.wav" )
Schema.vo.RegisterNormal( COMBINE, "Trouble", "Lookin' for trouble?", "npc/metropolice/vo/lookingfortrouble.wav" )
Schema.vo.RegisterNormal( COMBINE, "Look Out", "Look out!", "npc/metropolice/vo/lookout.wav" )
Schema.vo.RegisterNormal( COMBINE, "Minor Hits", "Minor hits, continuing prosecution.", "npc/metropolice/vo/minorhitscontinuing.wav" )
Schema.vo.RegisterNormal( COMBINE, "Move", "Move!", "npc/metropolice/vo/move.wav" )
Schema.vo.RegisterNormal( COMBINE, "Move Along", "Move along!", "npc/metropolice/vo/movealong3.wav" )
Schema.vo.RegisterNormal( COMBINE, "Move Back", "Move back, right now!", "npc/metropolice/vo/movebackrightnow.wav" )
Schema.vo.RegisterNormal( COMBINE, "Move It", "Move it!", "npc/metropolice/vo/moveit2.wav" )
Schema.vo.RegisterNormal( COMBINE, "Hardpoint", "Moving to hardpoint.", "npc/metropolice/vo/movingtohardpoint.wav" )
Schema.vo.RegisterNormal( COMBINE, "Officer Help", "Officer needs help!", "npc/metropolice/vo/officerneedshelp.wav" )
Schema.vo.RegisterNormal( COMBINE, "Privacy", "Possible level three civil privacy violator here!", "npc/metropolice/vo/possiblelevel3civilprivacyviolator.wav" )
Schema.vo.RegisterNormal( COMBINE, "Judgement", "Suspect prepare to receive civil judgement!", "npc/metropolice/vo/prepareforjudgement.wav" )
Schema.vo.RegisterNormal( COMBINE, "Priority Two", "I have a priority two anti-citizen here!", "npc/metropolice/vo/priority2anticitizenhere.wav" )
Schema.vo.RegisterNormal( COMBINE, "Prosecute", "Prosecute!", "npc/metropolice/vo/prosecute.wav" )
Schema.vo.RegisterNormal( COMBINE, "Amputate Ready", "Ready to amputate!", "npc/metropolice/vo/readytoamputate.wav" )
Schema.vo.RegisterNormal( COMBINE, "Rodger That", "Rodger that!", "npc/metropolice/vo/rodgerthat.wav" )
Schema.vo.RegisterNormal( COMBINE, "Search", "Search!", "npc/metropolice/vo/search.wav" )
Schema.vo.RegisterNormal( COMBINE, "Shit", "Shit!", "npc/metropolice/vo/shit.wav" )
Schema.vo.RegisterNormal( COMBINE, "Sentence Delivered", "Sentence delivered.", "npc/metropolice/vo/sentencedelivered.wav" )
Schema.vo.RegisterNormal( COMBINE, "Sterilize", "Sterilize!", "npc/metropolice/vo/sterilize.wav" )
Schema.vo.RegisterNormal( COMBINE, "Take Cover", "Take cover!", "npc/metropolice/vo/takecover.wav" )
Schema.vo.RegisterNormal( COMBINE, "Restrict", "Restrict!", "npc/metropolice/vo/restrict.wav" )
Schema.vo.RegisterNormal( COMBINE, "Restricted", "Restricted block.", "npc/metropolice/vo/restrictedblock.wav" )
Schema.vo.RegisterNormal( COMBINE, "Second Warning", "This is your second warning!", "npc/metropolice/vo/thisisyoursecondwarning.wav" )
Schema.vo.RegisterNormal( COMBINE, "Verdict", "You want a non-compliance verdict?", "npc/metropolice/vo/youwantamalcomplianceverdict.wav" )
Schema.vo.RegisterNormal( COMBINE, "Backup", "Backup!", "npc/metropolice/vo/backup.wav" )
Schema.vo.RegisterNormal( COMBINE, "Apply", "Apply.", "npc/metropolice/vo/apply.wav" )
Schema.vo.RegisterNormal( COMBINE, "Restriction", "Terminal restriction zone.", "npc/metropolice/vo/terminalrestrictionzone.wav" )
Schema.vo.RegisterNormal( COMBINE, "Complete", "Protection complete.", "npc/metropolice/vo/protectioncomplete.wav" )
Schema.vo.RegisterNormal( COMBINE, "Location Unknown", "Suspect location unknown.", "npc/metropolice/vo/suspectlocationunknown.wav" )
Schema.vo.RegisterNormal( COMBINE, "Can 1", "Pick up that can.", "npc/metropolice/vo/pickupthecan1.wav" )
Schema.vo.RegisterNormal( COMBINE, "Can 2", "Pick... up... the can.", "npc/metropolice/vo/pickupthecan2.wav" )
Schema.vo.RegisterNormal( COMBINE, "Wrap It", "That's it, wrap it up.", "npc/combine_soldier/vo/thatsitwrapitup.wav" )
Schema.vo.RegisterNormal( COMBINE, "Can 3", "I said pickup the can!", "npc/metropolice/vo/pickupthecan3.wav" )
Schema.vo.RegisterNormal( COMBINE, "Can 4", "Now, put it in the trash can.", "npc/metropolice/vo/putitinthetrash1.wav" )
Schema.vo.RegisterNormal( COMBINE, "Can 5", "I said put it in the trash can!", "npc/metropolice/vo/putitinthetrash2.wav" )
Schema.vo.RegisterNormal( COMBINE, "Now Get Out", "Now get out of here!", "npc/metropolice/vo/nowgetoutofhere.wav" )
Schema.vo.RegisterNormal( COMBINE, "Haha", "Haha.", "npc/metropolice/vo/chuckle.wav" )
Schema.vo.RegisterNormal( COMBINE, "X-Ray", "X-Ray!", "npc/metropolice/vo/xray.wav" )
Schema.vo.RegisterNormal( COMBINE, "Patrol", "Patrol!", "npc/metropolice/vo/patrol.wav" )
Schema.vo.RegisterNormal( COMBINE, "Serve", "Serve.", "npc/metropolice/vo/serve.wav" )
Schema.vo.RegisterNormal( COMBINE, "Knocked Over", "You knocked it over, pick it up!", "npc/metropolice/vo/youknockeditover.wav" )
Schema.vo.RegisterNormal( COMBINE, "Watch It", "Watch it!", "npc/metropolice/vo/watchit.wav" )
Schema.vo.RegisterNormal( COMBINE, "Restricted Canals", "Suspect is using restricted canals at...", "npc/metropolice/vo/suspectusingrestrictedcanals.wav" )
Schema.vo.RegisterNormal( COMBINE, "505", "Subject is five-oh-five!", "npc/metropolice/vo/subjectis505.wav" )
Schema.vo.RegisterNormal( COMBINE, "404", "Possible four-zero-oh here!", "npc/metropolice/vo/possible404here.wav" )
Schema.vo.RegisterNormal( COMBINE, "Vacate", "Vacate citizen!", "npc/metropolice/vo/vacatecitizen.wav" )
Schema.vo.RegisterNormal( COMBINE, "Escapee", "Priority two escapee.", "npc/combine_soldier/vo/prioritytwoescapee.wav" )
Schema.vo.RegisterNormal( COMBINE, "Objective", "Priority one objective.", "npc/combine_soldier/vo/priority1objective.wav" )
Schema.vo.RegisterNormal( COMBINE, "Payback", "Payback.", "npc/combine_soldier/vo/payback.wav" )
Schema.vo.RegisterNormal( COMBINE, "Got Him Now", "Affirmative, we got him now.", "npc/combine_soldier/vo/affirmativewegothimnow.wav" )
Schema.vo.RegisterNormal( COMBINE, "Antiseptic", "Antiseptic.", "npc/combine_soldier/vo/antiseptic.wav" )
Schema.vo.RegisterNormal( COMBINE, "Cleaned", "Cleaned.", "npc/combine_soldier/vo/cleaned.wav" )
Schema.vo.RegisterNormal( COMBINE, "Engaged Cleanup", "Engaged in cleanup.", "npc/combine_soldier/vo/engagedincleanup.wav" )
Schema.vo.RegisterNormal( COMBINE, "Engaging", "Engaging.", "npc/combine_soldier/vo/engaging.wav" )
Schema.vo.RegisterNormal( COMBINE, "Full Response", "Executing full response.", "npc/combine_soldier/vo/executingfullresponse.wav" )
Schema.vo.RegisterNormal( COMBINE, "Heavy Resistance", "Overwatch advise, we have heavy resistance.", "npc/combine_soldier/vo/heavyresistance.wav" )
Schema.vo.RegisterNormal( COMBINE, "Inbound", "Inbound.", "npc/combine_soldier/vo/inbound.wav" )
Schema.vo.RegisterNormal( COMBINE, "Lost Contact", "Lost contact!", "npc/combine_soldier/vo/lostcontact.wav" )
Schema.vo.RegisterNormal( COMBINE, "Move In", "Move in!", "npc/combine_soldier/vo/movein.wav" )
Schema.vo.RegisterNormal( COMBINE, "Harden Position", "Harden that position!", "npc/combine_soldier/vo/hardenthatposition.wav" )
Schema.vo.RegisterNormal( COMBINE, "Go Sharp", "Go sharp, go sharp!", "npc/combine_soldier/vo/gosharpgosharp.wav" )
Schema.vo.RegisterNormal( COMBINE, "Delivered", "Delivered.", "npc/combine_soldier/vo/delivered.wav" )
Schema.vo.RegisterNormal( COMBINE, "Necrotics Inbound", "Necrotics, inbound!", "npc/combine_soldier/vo/necroticsinbound.wav" )
Schema.vo.RegisterNormal( COMBINE, "Necrotics", "Necrotics.", "npc/combine_soldier/vo/necrotics.wav" )
Schema.vo.RegisterNormal( COMBINE, "Outbreak", "Outbreak!", "npc/combine_soldier/vo/outbreak.wav" )
Schema.vo.RegisterNormal( COMBINE, "Copy That", "Copy that.", "npc/combine_soldier/vo/copythat.wav" )
Schema.vo.RegisterNormal( COMBINE, "Outbreak Status", "Outbreak status is code.", "npc/combine_soldier/vo/outbreakstatusiscode.wav" )
Schema.vo.RegisterNormal( COMBINE, "Overwatch", "Overwatch!", "npc/combine_soldier/vo/overwatch.wav" )
Schema.vo.RegisterNormal( COMBINE, "Preserve", "Preserve!", "npc/metropolice/vo/preserve.wav" )
Schema.vo.RegisterNormal( COMBINE, "Pressure", "Pressure!", "npc/metropolice/vo/pressure.wav" )
Schema.vo.RegisterNormal( COMBINE, "Phantom", "Phantom!", "npc/combine_soldier/vo/phantom.wav" )
Schema.vo.RegisterNormal( COMBINE, "Stinger", "Stinger!", "npc/combine_soldier/vo/stinger.wav" )
Schema.vo.RegisterNormal( COMBINE, "Shadow", "Shadow!", "npc/combine_soldier/vo/shadow.wav" )
Schema.vo.RegisterNormal( COMBINE, "Savage", "Savage!", "npc/combine_soldier/vo/savage.wav" )
Schema.vo.RegisterNormal( COMBINE, "Reaper", "Reaper!", "npc/combine_soldier/vo/reaper.wav" )
Schema.vo.RegisterNormal( COMBINE, "Victor", "Victor!", "npc/metropolice/vo/victor.wav" )
Schema.vo.RegisterNormal( COMBINE, "Sector", "Sector!", "npc/metropolice/vo/sector.wav" )
Schema.vo.RegisterNormal( COMBINE, "Inject", "Inject!", "npc/metropolice/vo/inject.wav" )
Schema.vo.RegisterNormal( COMBINE, "Dagger", "Dagger!", "npc/combine_soldier/vo/dagger.wav" )
Schema.vo.RegisterNormal( COMBINE, "Blade", "Blade!", "npc/combine_soldier/vo/blade.wav" )
Schema.vo.RegisterNormal( COMBINE, "Razor", "Razor!", "npc/combine_soldier/vo/razor.wav" )
Schema.vo.RegisterNormal( COMBINE, "Nomad", "Nomad!", "npc/combine_soldier/vo/nomad.wav" )
Schema.vo.RegisterNormal( COMBINE, "Judge", "Judge!", "npc/combine_soldier/vo/judge.wav" )
Schema.vo.RegisterNormal( COMBINE, "Ghost", "Ghost!", "npc/combine_soldier/vo/ghost.wav" )
Schema.vo.RegisterNormal( COMBINE, "Sword", "Sword!", "npc/combine_soldier/vo/sword.wav" )
Schema.vo.RegisterNormal( COMBINE, "Union", "Union!", "npc/metropolice/vo/union.wav" )
Schema.vo.RegisterNormal( COMBINE, "Helix", "Helix!", "npc/combine_soldier/vo/helix.wav" )
Schema.vo.RegisterNormal( COMBINE, "Storm", "Storm!", "npc/combine_soldier/vo/storm.wav" )
Schema.vo.RegisterNormal( COMBINE, "Spear", "Spear!", "npc/combine_soldier/vo/spear.wav" )
Schema.vo.RegisterNormal( COMBINE, "Vamp", "Vamp!", "npc/combine_soldier/vo/vamp.wav" )
Schema.vo.RegisterNormal( COMBINE, "Nova", "Nova!", "npc/combine_soldier/vo/nova.wav" )
Schema.vo.RegisterNormal( COMBINE, "Mace", "Mace!", "npc/combine_soldier/vo/mace.wav" )
Schema.vo.RegisterNormal( COMBINE, "Grid", "Grid!", "npc/combine_soldier/vo/grid.wav" )
Schema.vo.RegisterNormal( COMBINE, "Kilo", "Kilo!", "npc/combine_soldier/vo/kilo.wav" )
Schema.vo.RegisterNormal( COMBINE, "Echo", "Echo!", "npc/combine_soldier/vo/echo.wav" )
Schema.vo.RegisterNormal( COMBINE, "Dash", "Dash!", "npc/combine_soldier/vo/dash.wav" )
Schema.vo.RegisterNormal( COMBINE, "Apex", "Apex!", "npc/combine_soldier/vo/apex.wav" )
Schema.vo.RegisterNormal( COMBINE, "Jury", "Jury!", "npc/metropolice/vo/jury.wav" )
Schema.vo.RegisterNormal( COMBINE, "King", "King!", "npc/metropolice/vo/king.wav" )
Schema.vo.RegisterNormal( COMBINE, "Lock", "Lock!", "npc/metropolice/vo/lock.wav" )
Schema.vo.RegisterNormal( COMBINE, "Vice", "Vice!", "npc/metropolice/vo/vice.wav" )
Schema.vo.RegisterNormal( COMBINE, "Zero", "Zero!", "npc/metropolice/vo/zero.wav" )
Schema.vo.RegisterNormal( COMBINE, "Zone", "Zone!", "npc/metropolice/vo/zone.wav" )

// Citizen voice stuff.
//Schema.vo.RegisterNormal( CITIZEN, "Command", "Answer", "vo/npc/male01/answer01.wav", true )

if ( CLIENT ) then
	local voiceHTMLBase = [[
	<!DOCTYPE html>
	<html lang="ko">
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title></title>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
		<style>
			@import url(http://fonts.googleapis.com/css?family=Open+Sans);
			body {
				font-family: "Open Sans", "나눔고딕", "NanumGothic", "맑은 고딕", "Malgun Gothic", "serif", "sans-serif"; 
				-webkit-font-smoothing: antialiased;
			}
		</style>
	</head>
	<body>
		<div class="container" style="margin-top:15px;">
		<div class="page-header">
			<h1>%s&nbsp&nbsp<small>%s</small></h1>
		</div>

		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
	]]
	
	function Schema.vo.RegisterHelp( )
		local title_voice = LANG( "Help_Category_CombineVoice" )
		local html = Format( voiceHTMLBase, title_voice, LANG( "Help_Desc_CombineVoice" ) )
		local haveCombineVoice = false
		
		for k, v in pairs( Schema.vo.normalVoice ) do
			if ( table.HasValue( v.faction, FACTION_CP ) or table.HasValue( v.faction, FACTION_OW ) ) then
				haveCombineVoice = true
				
				html = html .. [[
					<ul class="list-group">
						<li class="list-group-item">]] .. v.command .. [[<br> : ]] .. v.output .. [[</li>
					</ul>
				]]
			end
		end
		
		html = html .. [[</body></html>]]
		
		if ( haveCombineVoice ) then
			catherine.help.Register( CAT_HELP_HTML, title_voice, html, true )
		end
		
		local title_voice = LANG( "Help_Category_CitizenVoice" )
		local html = Format( voiceHTMLBase, title_voice, LANG( "Help_Desc_CitizenVoice" ) )
		local haveCitizenVoice = false
		
		for k, v in pairs( Schema.vo.normalVoice ) do
			if ( table.HasValue( v.faction, FACTION_CITIZEN ) or table.HasValue( v.faction, FACTION_CWU ) ) then
				haveCitizenVoice = true
				
				html = html .. [[
					<ul class="list-group">
						<li class="list-group-item">]] .. v.command .. [[<br> : ]] .. v.output .. [[</li>
					</ul>
				]]
			end
		end
		
		html = html .. [[</body></html>]]
		
		if ( haveCitizenVoice ) then
			catherine.help.Register( CAT_HELP_HTML, title_voice, html, true )
		end
	end
	
	Schema.vo.RegisterHelp( )
end