package com.reversefold.glitch.server.player {
	import com.reversefold.glitch.server.data.ConfigProd;
	import com.reversefold.glitch.server.player.Buffs;
	import com.reversefold.glitch.server.player.Imagination;
	import com.reversefold.glitch.server.player.Metabolics;
	import com.reversefold.glitch.server.player.Skills;
	import com.reversefold.glitch.server.player.Stats;
	
	import org.osmf.logging.Log;
	import org.osmf.logging.Logger;

	public class Player {
		private static var log : Logger = Log.getLogger("server.Player");

		private var config : ConfigProd;

		public var tsid;

		public var is_dead : int;

		public function Player(config : ConfigProd) : void {
			//init();
			this.config = config;

			skills = new Skills(config, this);
			stats = new Stats(config, this);
			metabolics = new Metabolics(config, this);
			quests = new Quests(config, this);
			buffs = new Buffs(config, this);
			daily_history = new DailyHistory(config, this);
			imagination = new Imagination(config, this);
		}

//#include inc_admin.js,
//inc_groups.js,
//inc_organizations.js,
//inc_making.js
//#include inc_stores.js,
//inc_skills.js,
		public var skills : Skills;
//inc_stats.js
		public var stats : Stats;
//#include inc_metabolics.js,
		public var metabolics : Metabolics;
//inc_items.js
//#include inc_buddies.js,
//inc_quests.js,
		public var quests : Quests;
//inc_buffs.js
		public var buffs : Buffs;
//#include inc_tests.js,
//inc_houses.js,
		//inc_acl_keys.js,
		//inc_achievements.js
//#include inc_familiar.js,
		//inc_demo.js,
		//inc_party.js,
		//inc_instances.js
//#include inc_auctions.js,
		//inc_announcements.js,
		//inc_skill_packages.js
//#include inc_activity.js,
		//inc_prompts.js,
		//inc_trophies.js
//#include inc_trading.js,
		//inc_teleportation.js,
		//inc_jobs.js
//#include inc_daily_history.js,
		public var daily_history : DailyHistory;
		//inc_profile.js,
		//inc_rewards.js
//#include inc_avatar.js,
		//inc_mail.js,
		//inc_conversations.js
//#include ../items/include/events.js
		//../items/include/rook.js
//#include inc_special_locations.js,
		//inc_games.js,
		//inc_eleven_secrets.js
//#include inc_requests.js,
		//inc_counters.js,
//inc_imagination.js,
		public var imagination : Imagination;
//inc_furniture.js
//#include inc_world_events.js,
		//inc_mountaineering.js,
		//inc_physics.js
//#include inc_butler.js,
		//inc_newxp.js,
		//inc_towers.js,
		//inc_feats.js
//#include inc_visiting.js,
		//inc_emotes.js

		//
		// this is called any time after a player does "something"
		//

		var meditation_ok_types = ['itemstack_mouse_over'];
		var meditation_ok_verbs = ['meditate', 'focus_energy', 'focus_mood', 'radiate'];
		var please_wait_ok_types = ['party_chat', 'groups_chat', 'local_chat', 'buff_tick', 'conversation_choice', 'buff_start', 'prompt_choice'];
		public function performPostProcessing(msg){
			// handle any delayed teleport
			if (msg.type != 'login_start' && msg.type != 'relogin_start' && msg.type != 'login_start' && msg.type != 'relogin_start') this.handleDelayedTeleport();


			// If this is a move_xy, but they didn't actually move, then quit here
			// move_xy without an actual move is likely a state change
			if (msg.type == 'move_xy' && !this['!actually_moved']) return;


			// Butler hints:
			//log.info("msg is "+msg.type);
			//if (msg.type == "global_chat" || (msg.type == "groups_chat_join" && in_array_real(msg.tsid, config.global_chat_groups))) { this.global_chatter = true; }

			// Interrupt meditation
			if (this['!meditating']){
				// meditation also stops if the user sends any chat message (global, party or IM), receives an IM from another player (but party/local/global chat are ok)
				// or performs a verb on a different item

				// Upgrades: meditative_arts_less_distraction = not distracted by incoming messages
				//           meditative_arts_less_distraction_2 = not distracted by outgoing messages
				var meditation_ok_copy = meditation_ok_types.slice();
				if (this.imagination.imagination_has_upgrade("meditative_arts_less_distraction")) {
					meditation_ok_copy.push("im_recv"); // only one incoming type that distracts
				}

				if (this.imagination.imagination_has_upgrade("meditative_arts_less_distraction_2")) {
					meditation_ok_copy.push("local_chat", "local_chat_start", "party_chat", "groups_chat", "groups_chat_leave", "groups_chat_join", "global_chat", "im_send");
				}

				//log.info(this+" meditation_ok types "+meditation_ok_copy);

				var interrupt = true;
				// Ignore buff ticks while in wintry place
				if (this.location.tsid == 'LM413ATO8PR54' || this.location.tsid == 'LLI11ITO8SBS6' || this.location.tsid == 'LM11E7ODKHO1QJE'){
					if (msg.type == 'buff_tick') interrupt = false;
				}

				// this is accomplished by explicitly ignoring allowed actions -- anything else interrupts
				if (interrupt && !in_array(msg.type, meditation_ok_copy) && !in_array(msg.verb, this.meditation_ok_verbs)){
					// Find their orb and cancel meditation
					var orbs = this.get_stacks_by_class('focusing_orb');
					for (var i in orbs){
						if (orbs[i].meditating){
							log.info(this+' meditation was interrupted by: '+msg);
							orbs[i].cancelAnyMeditation();
						}
					}
				}
			}

			// Interrupt the "Please Wait" buff
			if (this.buffs.buffs_has('please_wait')){
				if (!in_array(msg.type, this.please_wait_ok_types)){
					log.info(this+' please_wait was interrupted by: '+msg);
					this.buffs.buffs_remove('please_wait');
					if (config.is_dev || (this.location.instance_id && this.location.instance_id.substr(0, 17) == 'bureaucratic_hall')){
						this.prompts_add({
							txt		: 'You can\'t do anything while waiting. Just wait!',
							icon_buttons	: false,
							timeout		: 3,
							timeout_value	: 'ok',
							choices		: [
								{ value : 'ok', label : 'OK' }
							],
							callback	: 'prompts_buff_callback',
							buff_class_tsid	: 'please_wait'
						});
					}
				}
			}

			// Things we do when you move
			if (msg.type == 'move_xy' && this['!moved_lat'] >= 150){
				if (this['!dismiss_overlay']){
					this.events_add({overlay: this['!dismiss_overlay'], callback: 'dismiss_overlay_event'}, 1);
					delete this['!dismiss_overlay'];
				}
				else if (this.run_overlay_onmove){
					this.events_add({overlay: this.run_overlay_onmove, callback: 'run_overlay_event'}, 1);
					delete this.run_overlay_onmove;
				}
				else if (this.apply_buff){
					this.buffs.buffs_apply(this.apply_buff);
					delete this.apply_buff;
				}
			}
		}


		public function handleDelayedTeleport(){

			if (this['!teleport_delayed'] && this['!teleport_delayed'].tsid){

				var t = this['!teleport_delayed'];
				var ret = this.teleportToLocation(t.tsid, t.x, t.y, t.args);
				if (ret['ok']){
					delete this['!teleport_delayed'];
				}
				else{
					if (!this['!teleport_delayed'].attempts) this['!teleport_delayed'].attempts = 0;
					this['!teleport_delayed'].attempts++;

					if (this['!teleport_delayed'].attempts < 10){
						this.apiSetTimer('handleDelayedTeleport', 500);
					}
					else{
						delete this['!teleport_delayed'];
					}
				}
			}
		}

		public function get_meditation_bonus(){
			// We are now adjusting the meditation limit based on upgrades instead of skill level.

			if (this.imagination.imagination_has_upgrade("meditative_arts_daily_limit_2")) {
				return 1.5;
			}
			else if (this.imagination.imagination_has_upgrade("meditative_arts_daily_limit_1")) {
				return 1.25;
			}
			else {
				return 1;
			}
		}

		public function isOnline(){
			return true;//apiIsPlayerOnline(this.tsid);
		}

	}
}
