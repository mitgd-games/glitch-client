package com.reversefold.glitch.server {
	import com.reversefold.glitch.server.data.Config;
	import com.reversefold.glitch.server.player.Player;
	import com.reversefold.glitch.server.player.Quests;
	import com.reversefold.glitch.server.player.Utils;
	import com.tinyspeck.debug.Console;
	import com.tinyspeck.engine.data.client.Announcement;
	import com.tinyspeck.engine.model.TSModelLocator;
	import com.tinyspeck.engine.net.NetDelegateSocket;
	
	import org.osmf.logging.Log;
	import org.osmf.logging.Logger;

	public class Server {
		private static var log : Logger = Log.getLogger("server.Player");

		private static var config : Config = Config.instance;
		
		private static var _instance : Server = null;
		public static function get instance() : Server {
			if (_instance == null) {
				_instance = new Server(new Key());
			}
			return _instance;
		}

		public var pc : Player;
		
		//meant to be set only once
		public var socket : NetDelegateSocket;

		public function Server(lock : Key) : void {
			if (lock == null) {
				throw new Error("singleton");
			}
			pc = new Player(config);
		}
		
		// BEGIN api funcs
		
		public function apiSendAnnouncement(ann : Object) : void {
			//We can either store these and add an announcements var to another outgoing message
			//or directly set them using, say
			
			//TODO: is this going to work ok when there are multiple announcements?
			//TODO: does this potentially avoid some other logic that would be accessing the announcements var in the messages?
			TSModelLocator.instance.activityModel.announcements = Announcement.parseMultiple([ann]); // fires trigger when set
		}
		
		public function apiSendMsg(msg : Object) : void {
			sendMessage(msg);
		}
		
		public function apiLogAction(name : String, ... args : Array) : void {
			//TODO: is this supposed to do something other than log?
			log.info(name + ' ' + args.join(' '));
		}
		
		public function apiAsyncHttpCall(url : String, ... args : Array) : void {
			log.warn("apiAsyncHttpCall " + url);
		}
		
		public function apiFindObject(tsid) {
			throw new Error("apiFindObject " + tsid);
		}
		
		public function apiFindItemPrototype(tsid) {
			throw new Error("apiFindItemPrototype " + tsid);
		}
		
		public function apiCopyHash(obj) {
			//RVRS: TODO: this gets passed the result of apiGetJSFileObject in at least one place
			// does this just make a copy of the object?
			throw new Error("apiCopyHash " + obj);
		}
		
		public function apiGetJSFileObject(path) {
			//RVRS: TODO: this is supposed to get the object defined by the JS file
			// it's the magic file-to-class/object method!
			throw new Error("apiGetJSFileObject " + path);
		}
		
		public function apiNewOwnedQuest(quest_class, quests : Quests) {
			//RVRS: TODO
			//quest_class may be a tsid
			//quests is meant to be a player, but we can access that via quests.player if we need to
			throw new Error("apiNewOwnedQuest " + quest_class);
		}
		
		public function apiFindQuestPrototype(class_tsid) {
			//RVRS: TODO
			throw new Error("apiFindQuestPrototype " + class_tsid);
		}
		
		// END api funcs

		
		public function sendMessage(msg : Object) : void {
			//RVRS: TODO: Anything special should be added to the msg here?
			processMessage(msg);
		}

		function processMessage(msg){
			//log.info("TYPE="+msg.type);

			processMessageInner(msg);

			pc.performPostProcessing(msg);
		}

		function processMessageInner(msg){

			switch (msg.type){
				/*
				case 'move_vec':				return doVecMove(pc, msg);
				case 'move_xy':					return doXYMove(pc, msg);
				*/
				case 'login_start':				return doLoginStart(pc, msg, false);
				/*
				case 'login_end':				return doLoginEnd(pc, msg, false);
				case 'relogin_start':				return doLoginStart(pc, msg, true);
				case 'relogin_end':				return doLoginEnd(pc, msg, true);
				case 'location_passthrough':			return doLocationPassthrough(pc, msg);
				case 'signpost_move_start':			return doStartSignpostMove(pc, msg);
				case 'signpost_move_end':			return doEndSignpostMove(pc, msg);
				case 'follow_move_end':				return doEndMove(pc, msg, 'pc_follow_move');
				case 'door_move_start':				return doStartDoorMove(pc, msg);
				case 'door_move_end':				return doEndDoorMove(pc, msg);
				case 'afk':					return doAFK(pc, msg);
				case 'local_chat':				return doLocalChat(pc, msg);
				case 'local_chat_start':				return doLocalChatStart(pc, msg);

				case 'itemstack_verb':				return doVerb(pc, msg);
				case 'itemstack_verb_menu':			return doItemstackVerbMenu(pc, msg);
				case 'itemstack_menu_up':			return doMenuUp(pc, msg);
				case 'itemstack_mouse_over':			return doMouseOver(pc, msg);
				case 'itemstack_verb_cancel':			return doVerbCancel(pc, msg);
				case 'itemstack_inspect':			return doInspectItem(pc, msg);
				case 'itemstack_modify':			return doModifyItem(pc, msg);
				case 'itemstack_create':			if (pc.is_god) return doCreateItem(pc, msg);
				case 'itemstack_status':			return doStatusItem(pc, msg);
				case 'itemstack_invoke':			return doItemstackInvoke(pc, msg);
				case 'itemstack_sync':				return doSync(pc, msg);

				case 'get_item_defs':				return doGetItemDefs(pc, msg);
				case 'get_item_asset':				return doGetItemAsset(pc, msg);
				case 'get_item_placement':			return doGetItemPlacement(pc, msg);

				case 'edit_location':				if (pc.is_god) return doReplaceGeometry(pc, msg);
				case 'im_send':					return doSendIM(pc, msg);
				case 'location_lock_request':			return doLocationLock(pc, msg);
				case 'location_lock_release':			return doLocationUnlock(pc, msg);
				case 'conversation_choice':			return doConversationChoice(pc, msg);
				case 'conversation_cancel':			return doConversationCancel(pc, msg);
				case 'teleport_move_end':			return doEndTeleportMove(pc, msg);
				case 'note_close':				return doNoteClose(pc, msg);

				case 'buddy_add':				return doBuddyAdd(pc, msg);
				case 'buddy_remove':				return doBuddyRemove(pc, msg);

				case 'ping':					return doPing(pc, msg);
				case 'follow_start':				return doStartFollow(pc, msg);
				case 'follow_end':				return doStopFollow(pc, msg);
				case 'make_known':				return doMakeKnown(pc, msg);
				case 'make_unknown':				return doMakeUnknown(pc, msg);
				case 'recipe_request':				return doRecipeRequest(pc, msg);
				case 'store_buy':				return doStoreBuy(pc, msg);
				case 'store_sell':				return doStoreSell(pc, msg);
				case 'store_sell_check':			return doStoreSellCheck(pc, msg);
				case 'overlay_dismissed':			return doOverlayDismissed(pc, msg);
				case 'overlay_done':				return doOverlayDone(pc, msg);
				case 'overlay_click':				return doOverlayClick(pc, msg);
				case 'screen_view_close':			return doScreenViewClose(pc, msg);
				case 'close_img_menu':				return doScreenViewClose(pc, msg);
				case 'inventory_move':				return doInventoryMove(pc, msg);
				case 'location_move':				return doLocationMove(pc, msg);
				case 'location_drag_targets':			return doLocationDragTargets(pc, msg);
				case 'inventory_drag_targets':			return doInventoryDragTargets(pc, msg);
				case 'echo_annc':				return doEchoAnnc(pc, msg);
				case 'play_music':				return doPlayMusic(pc, msg);

				case 'groups_chat_join':			return doGroupsChatJoin(pc, msg);
				case 'groups_chat_leave':			return doGroupsChatLeave(pc, msg);
				case 'groups_chat':				return doGroupsChat(pc, msg);

				case 'prompt_choice':				return doPromptChoice(pc, msg);

				case 'trade_start':				return doStartTrade(pc, msg);
				case 'trade_cancel':				return doCancelTrade(pc, msg);
				case 'trade_add_item':				return doTradeAddItem(pc, msg);
				case 'trade_remove_item':			return doTradeRemoveItem(pc, msg);
				case 'trade_change_item':			return doTradeChangeItem(pc, msg);
				case 'trade_currants':				return doTradeCurrants(pc, msg);
				case 'trade_accept':				return doTradeAccept(pc, msg);
				case 'trade_unlock':				return doTradeUnlock(pc, msg);

				case 'skills_can_learn':			return doSkillsCanLearn(pc, msg);
				case 'skill_unlearn_cancel':			return doUnlearnCancel(pc, msg);

				case 'action_request_reply':			return doActionRequestReply(pc, msg);
				case 'action_request_cancel':			return doActionRequestCancel(pc, msg);
				case 'action_request_broadcast':		return doActionRequestBroadcast(pc, msg);

				case 'teleportation_set':			return doTeleportationSet(pc, msg);
				case 'teleportation_go':			return doTeleportationGo(pc, msg);
				case 'teleportation_map':			return doTeleportationMap(pc, msg);

				case 'pc_verb_menu':				return doPcVerbMenu(pc, msg);
				case 'pc_menu':					return doPCMenu(pc, msg);
				case 'emote':					return doEmote(pc, msg);

				case 'quest_begin':				return doQuestBegin(pc, msg);
				case 'quest_conversation_choice':		return doQuestConversationChoice(pc, msg);
				case 'quest_dialog_closed':			return doQuestDialogEnd(pc, msg);

				case 'shrine_spend':				return doShrineSpend(pc, msg);
				case 'emblem_spend':				return doEmblemSpend(pc, msg);
				case 'shrine_favor_request':            return doShrineFavorRequest(pc, msg);
				case 'favor_request':            return doFavorRequest(pc, msg);

				case 'job_apply_work':				if (pc.is_god) return doJobApplyWork(pc, msg);
				case 'job_contribute_item':			return doJobContributeItem(pc, msg);
				case 'job_contribute_currants':			return doJobContributeCurrants(pc, msg);
				case 'job_contribute_work':			return doJobContributeWork(pc, msg);
				case 'job_stop_work':				return doJobStopWork(pc, msg);
				case 'job_leaderboard':				return doJobLeaderboard(pc, msg);
				case 'job_status':				return doJobStatus(pc, msg);
				case 'job_claim':				return doJobClaim(pc, msg);

				case 'input_response':				return doInputResponse(pc, msg);
				case 'note_save':				return doInputResponse(pc, msg);
				case 'teleportation_script_create':		return doInputResponse(pc, msg);
				case 'teleportation_script_use':		return doTPScriptUse(pc, msg);
				case 'teleportation_script_imbue':		return doTPScriptImbue(pc, msg);

				case 'map_get':					return doMapGet(pc, msg);
				case 'get_path_to_location':			return doMapGetPath(pc, msg);
				case 'clear_location_path':			return doMapClearPath(pc, msg);

				case 'set_prefs':				return doSetPrefs(pc, msg);
				case 'garden_action':				return doGardenAction(pc, msg);

				// Notice board feature
				case 'notice_board_action':			return doNoticeBoardAction(pc, msg);

				// Mail messages
				case 'mail_send':				return doMailSend(pc, msg);
				case 'mail_receive':				return doMailReceive(pc, msg);
				case 'mail_read':				return doMailRead(pc, msg);
				case 'mail_delete':				return doMailDelete(pc, msg);
				case 'mail_archive':				return doMailArchive(pc, msg);
				case 'mail_cancel':				return doMailCancel(pc, msg);
				case 'mail_cost':				return doMailCost(pc, msg);
				case 'mail_check':				return doMailCheck(pc, msg);

				// camera mode notices form client
				case 'camera_mode_started':			return doCameraModeStarted(pc, msg);
				case 'camera_mode_ended':			return doCameraModeEnded(pc, msg);

				// Parties
				case 'party_invite':				return doPartyInvite(pc, msg);
				case 'party_chat':				return doPartyChat(pc, msg);
				case 'party_leave':				return doPartyLeave(pc, msg);
				case 'party_space_response':			return doPartySpaceInviteResponse(pc, msg);
				case 'party_space_join':			return doPartySpaceJoin(pc, msg);

				//
				// House ACLs
				//
				case 'acl_key_info':				return doAclKeyInfo(pc, msg);
				case 'acl_key_change':				return doAclKeyChange(pc, msg);

				//
				// god-only messages
				//
				case 'admin_loc_request':			if (pc.is_god || pc.is_help) return doAdminLocRequest(pc, msg);
				case 'admin_teleport':				if (pc.is_god || pc.is_help) return doAdminTeleport(pc, msg);
				case 'perf_teleport':				return doPerfTeleport(pc, msg);
				case 'guide_status_change':			return doGuideStatusChange(pc, msg);

				// games
				case 'splash_screen_button_payload':		return doSplashScreenButtonPayload(pc, msg);

				case 'new_item_window_closed':			return doNewItemWindowClosed(pc, msg);

				// houses
				case 'houses_add_neighbor':			return doAddNeighbor(pc, msg);
				case 'houses_remove_neighbor':			return doRemoveNeighbor(pc, msg);

				case 'houses_expand_costs':			return doHousesExpandCosts(pc, msg);
				case 'houses_expand_wall':			return doHousesExpandWall(pc, msg);
				case 'houses_expand_yard':			return doHousesExpandYard(pc, msg);
				case 'houses_expand_tower':			return doHousesExpandTower(pc, msg);
				case 'houses_unexpand_wall':			return doHousesUnexpandWall(pc, msg);

				case 'houses_style_choices':			return doHousesStyleChoices(pc, msg);
				case 'houses_style_switch':			return doHousesStyleSwitch(pc, msg);

				case 'houses_wall_choices':			return doHousesWallChoices(pc, msg);
				case 'houses_wall_set':				return doHousesWallSet(pc, msg);
				case 'houses_wall_buy':				return doHousesWallBuy(pc, msg);
				case 'houses_wall_preview':			return doHousesWallPreview(pc, msg);

				case 'houses_floor_choices':			return doHousesFloorChoices(pc, msg);
				case 'houses_floor_set':			return doHousesFloorSet(pc, msg);
				case 'houses_floor_buy':			return doHousesFloorBuy(pc, msg);
				case 'houses_floor_preview':			return doHousesFloorPreview(pc, msg);

				case 'houses_ceiling_choices':			return doHousesCeilingChoices(pc, msg);
				case 'houses_ceiling_set':			return doHousesCeilingSet(pc, msg);
				case 'houses_ceiling_buy':			return doHousesCeilingBuy(pc, msg);
				case 'houses_ceiling_preview':			return doHousesCeilingPreview(pc, msg);
				*/
		/* deprecated */ /* case 'houses_deco_mode':			return doNoEnergyMode(pc, msg);
				case 'no_energy_mode':				return doNoEnergyMode(pc, msg);

				case 'tower_set_name':				return doTowerSetName(pc, msg);
				case 'tower_set_floor_name':			return doTowerSetFloorName(pc, msg);
				case 'houses_set_name':				return doHousesSetName(pc, msg);
				case 'houses_visit':				return doHousesVisit(pc, msg);
				case 'houses_signpost':				return doHousesSignpost(pc, msg);

				case 'furniture_drop':				return doFurnitureDrop(pc, msg);
				case 'furniture_move':				return doFurnitureMove(pc, msg);
				case 'furniture_pickup':			return doFurniturePickup(pc, msg);
				case 'furniture_upgrade_purchase':		return doFurnitureUpgradePurchase(pc, msg);
				case 'furniture_set_zeds':			return doFurnitureSetZeds(pc, msg);
				case 'furniture_set_user_config':		return doFurnitureSetUserConfig(pc, msg);
				case 'itemstack_set_user_config':		return doItemstackSetUserConfig(pc, msg);
				case 'resnap_minimap':				return doResnapMiniMap(pc, msg);

				case 'cultivation_start':			return doCultivationStart(pc, msg);
				case 'cultivation_purchase':			return doCultivationPurchase(pc, msg);

				// imagination
				case 'imagination_purchase':			return doImaginationPurchase(pc, msg);
				case 'imagination_purchase_confirmed':		return doImaginationPurchaseConfirmed(pc, msg);
				case 'imagination_shuffle':			return doImaginationShuffle(pc, msg);

				case 'nudgery_start':				return doNudgeryStart(pc, msg);
				case 'itemstack_nudge':				return doItemstackNudge(pc, msg);

				case 'contact_list_opened':			return doContactListOpened(pc, msg);

				case 'cultivation_mode_ended':		return doCultivationModeEnded(pc, msg);

				case 'item_discovery_dialog_closed':	return itemDiscoveryDialogClosed(pc, msg);

				case 'snap_travel':			return doSnapTravel(pc, msg);
				case 'snap_travel_forget':		return doSnapTravelForget(pc, msg);

				case 'avatar_get_choices':			return doAvatarGetChoices(pc, msg);

				case 'share_track':				return doShareButton(pc, msg);

				case 'craftybot_add':				return doCraftybotMessage(pc, msg);
				case 'craftybot_remove':			return doCraftybotMessage(pc, msg);
				case 'craftybot_cost':				return doCraftybotMessage(pc, msg);
				case 'craftybot_pause':				return doCraftybotMessage(pc, msg);
				case 'craftybot_lock':				return doCraftybotMessage(pc, msg);
				case 'craftybot_refuel':			return doCraftybotMessage(pc, msg);

				case 'hi_emote_missile_hit':		return doHiEmoteMissileHit(pc, msg);
				case 'get_hi_emote_leaderboard':		return doGetHiEmoteLeaderboard(pc, msg);
				*/
			}


			log.info(pc.tsid+' '+msg);
			var rsp = make_rsp(msg);
			rsp.success = false;
			if (msg.type){
				rsp.msg = 'unrecognized msg type: '+msg.type;
			}else{
				rsp.msg = 'unspecified msg type';
			}
			//pc.apiSendMsg(rsp);
			socket.addIncomingMessage(rsp);
		}

		function make_rsp(req){
			return {
				msg_id: req.msg_id,
					type: req.type
			};
		}

		function overlay_key_to_url(key){
			return config.overlays.overlays_map[key];
		}

		function make_bag(bag){
			var contents = bag.getContents();

			var itemstacks = {};
			for (var n in contents){
				var it = contents[n];
				if (it){
					itemstacks[it.tsid] = {
						class_tsid: it.class_id,
							label: it.getLabel ? it.getLabel() : it.label,
							count: it.count,
							slot: it.slot,
							version: it.version,
							path_tsid: it.path
					};

					if (it.z) itemstacks[it.tsid].z = it.z;
					if (it.state) itemstacks[it.tsid].s = it.buildState();
					if (it.is_tool) itemstacks[it.tsid].tool_state = it.get_tool_state();
					if (it.is_consumable) itemstacks[it.tsid].consumable_state = it.get_consumable_state();
					if (it.is_powder && parseInt(it.getClassProp('maxCharges')) > 0) itemstacks[it.tsid].powder_state = it.get_powder_state();
					if (it.getTooltipLabel) itemstacks[it.tsid].tooltip_label = it.getTooltipLabel();
					if (pc && !it.isSelectable(pc)) itemstacks[it.tsid].not_selectable = true; // Probably just a new message type to turn it on/off
					itemstacks[it.tsid].soulbound_to = (it.isSoulbound() && it.soulbound_to) ? it.soulbound_to : null;

					// Config?
					if (it.make_config) itemstacks[it.tsid].config = it.make_config();

					// Is this a bag?
					if (it.is_bag && !it.hasTag('not_openable')){
						itemstacks[it.tsid].slots = it.capacity;

						var sub = make_bag(it);
						for (var i in sub){
							itemstacks[i] = sub[i];
						}
					}
				}
			}

			return itemstacks;
		}

		function make_item(item, pc){
			var ret = make_item_simple(item);
			if (config.is_dev){
				ret.ctor_func = 'make_item';
			}
			ret.version = item.version;
			ret.path_tsid = item.path;
			if (item.state) ret.s = item.buildState(pc);
			if (typeof item.onStatus == 'function' && pc) ret.status = item.onStatus(pc); // Action indicators, replace with config?
			if (item.is_tool) ret.tool_state = item.get_tool_state(); // Replace with config
			if (item.is_consumable) ret.consumable_state = item.get_consumable_state(); // Used on firefly jars for recipes, replace with config
			if (item.getTooltipLabel) ret.tooltip_label = item.getTooltipLabel(); // Used in tools, not sure why this isn't just in getLabel()
			if (!item.isSelectable(pc)) ret.not_selectable = true; // Probably just a new message type to turn it on/off
			ret.soulbound_to = (item.isSoulbound() && item.soulbound_to) ? item.soulbound_to : null;
			if (item.getSubClass) ret.subclass_tsid = item.getSubClass();

			// Is this a bag?
			if (item.is_bag && !item.hasTag('not_openable')){
				ret.slots = item.capacity;

				if (item.is_trophycase){
					ret.itemstacks = make_bag(item);
				}

			}

			// Config?
			if (item.make_config){
				ret.config = item.make_config();
			}

			// Rooked status
			if (item.isRookable()){
				if (item.isRooked()){
					ret.rs = true;
				}
				else{
					ret.rs = false;
				}
			}

			return ret;
		}

		function make_item_simple(item){
			var ret = {
				class_tsid	: item.class_tsid,
					x		: item.x,
					y		: item.y,
					label	: item.getLabel ? item.getLabel() : item.label,
					count	: item.count
			};
			if (item.z !== undefined && item.z !== null) ret.z = item.z;
			if (config.is_dev){
				ret.ctor_func = 'make_item_simple';
			}

			return ret;
		}

		function doLoginStart(pc, msg, isRelogin){

			//log.info('***LOGIN-START-'+pc.tsid+'-1');

			pc.didStartStreetMove();

			var rsp = make_rsp(msg);
			rsp.success = true;

			log.info('LOGIN_START'+'pc='+pc.tsid+'loc='+pc.location.tsid+'played='+pc.getTimePlayed());

			if (isRelogin){
				rsp.relogin_type = msg.relogin_type;
				// simulate moving into location
				pc.location.apiMoveIn(pc, pc.x, pc.y);

				// Call the player's java code to make end of the move arrangements
				pc.apiEndLocationMove(pc.location);
			}else{
				//
				// Let's make sure the player is in a good place
				//

				var below = pc.location.apiGetPointOnTheClosestPlatformLineBelow(pc.x, pc.y-1);
				if (!below){
					var above = pc.location.apiGetPointOnTheClosestPlatformLineAbove(pc.x, pc.y);
					if (above){
						pc.apiSetXY(above.x, above.y);
					}
					else{
						log.error(pc+" is in a bad place, but can't be fixed");
					}
				}

				//
				// sounds file, if defined
				//

				if (config.sounds.sounds_url){
					rsp.sounds_file = config.sounds.sounds_url;

					rsp.ambient_library = {
						'default': [
							config.sounds.music_map['FOREST_AMBIENT1'],
							config.sounds.music_map['FOREST_AMBIENT2'],
							config.sounds.music_map['FOREST_AMBIENT3'],
							config.sounds.music_map['FOREST_AMBIENT4']
						],
						'caverns': [
							config.sounds.music_map['AMBIENT_CAVERNS1'],
							config.sounds.music_map['AMBIENT_CAVERNS2'],
							config.sounds.music_map['AMBIENT_CAVERNS3'],
							config.sounds.music_map['AMBIENT_CAVERNS4']
						],
						'uralia': [
							config.sounds.music_map['AMBIENT_URALIA1'],
							config.sounds.music_map['AMBIENT_URALIA2'],
							config.sounds.music_map['AMBIENT_URALIA3'],
							config.sounds.music_map['AMBIENT_URALIA4']
						],
						'firebog': [
							config.sounds.music_map['AMBIENT_FIREBOGS1'],
							config.sounds.music_map['AMBIENT_FIREBOGS2'],
							config.sounds.music_map['AMBIENT_FIREBOGS3'],
							config.sounds.music_map['AMBIENT_FIREBOGS4'],
							config.sounds.music_map['AMBIENT_FIREBOGS5'],
							config.sounds.music_map['AMBIENT_FIREBOGS6'],
							config.sounds.music_map['AMBIENT_FIREBOGS7']
						],
						'savanna': [
							config.sounds.music_map['AMBIENT_SAVANNA1'],
							config.sounds.music_map['AMBIENT_SAVANNA2'],
							config.sounds.music_map['AMBIENT_SAVANNA3'],
							config.sounds.music_map['AMBIENT_SAVANNA4'],
							config.sounds.music_map['AMBIENT_SAVANNA5'],
							config.sounds.music_map['AMBIENT_SAVANNA6']
						],
						'highlands': [
							config.sounds.music_map['AMBIENT_HIGHLANDS1'],
							config.sounds.music_map['AMBIENT_HIGHLANDS2'],
							config.sounds.music_map['AMBIENT_HIGHLANDS3'],
							config.sounds.music_map['AMBIENT_HIGHLANDS4'],
							config.sounds.music_map['AMBIENT_HIGHLANDS5'],
							config.sounds.music_map['AMBIENT_HIGHLANDS6'],
							config.sounds.music_map['AMBIENT_HIGHLANDS7']
						],
						'cave': [
							config.sounds.music_map['CAVE_MUSIC1'],
							config.sounds.music_map['CAVE_MUSIC2'],
							config.sounds.music_map['CAVE_MUSIC3'],
							config.sounds.music_map['CAVE_MUSIC4'],
							config.sounds.music_map['CAVE_MUSIC5']
						],
						'ix': [
							config.sounds.music_map['AMBIENT_IX_1'],
							config.sounds.music_map['AMBIENT_IX_2'],
							config.sounds.music_map['AMBIENT_IX_3'],
							config.sounds.music_map['AMBIENT_IX_4'],
							config.sounds.music_map['AMBIENT_IX_5'],
							config.sounds.music_map['AMBIENT_IX_6'],
							config.sounds.music_map['AMBIENT_IX_7'],
							config.sounds.music_map['AMBIENT_IX_8'],
							config.sounds.music_map['AMBIENT_IX_9'],
							config.sounds.music_map['AMBIENT_IX_10'],
							config.sounds.music_map['AMBIENT_IX_11'],
							config.sounds.music_map['AMBIENT_IX_12'],
							config.sounds.music_map['AMBIENT_IX_13'],
							config.sounds.music_map['AMBIENT_IX_14'],
							config.sounds.music_map['AMBIENT_IX_15'],
							config.sounds.music_map['AMBIENT_IX_16'],
							config.sounds.music_map['AMBIENT_IX_17'],
							config.sounds.music_map['AMBIENT_IX_18']
						],
						'andra_kajuu': [
							config.sounds.music_map['ANDRA_KAJUU_1'],
							config.sounds.music_map['ANDRA_KAJUU_2'],
							config.sounds.music_map['ANDRA_KAJUU_3'],
							config.sounds.music_map['ANDRA_KAJUU_4'],
							config.sounds.music_map['ANDRA_KAJUU_5'],
							config.sounds.music_map['ANDRA_KAJUU_6'],
							config.sounds.music_map['ANDRA_KAJUU_7'],
							config.sounds.music_map['ANDRA_KAJUU_8'],
							config.sounds.music_map['ANDRA_KAJUU_9'],
							config.sounds.music_map['ANDRA_KAJUU_10'],
							config.sounds.music_map['ANDRA_KAJUU_11'],
							config.sounds.music_map['ANDRA_KAJUU_12'],
							config.sounds.music_map['ANDRA_KAJUU_13'],
							config.sounds.music_map['ANDRA_KAJUU_14'],
							config.sounds.music_map['ANDRA_KAJUU_15']
						],
						'kloro_haoma': [
							config.sounds.music_map['AMBIENT_KLORO_HAOMA1']
						],
						'urwok': [
							config.sounds.music_map['AMBIENT_URWOK1'],
							config.sounds.music_map['AMBIENT_URWOK2'],
							config.sounds.music_map['AMBIENT_URWOK3'],
							config.sounds.music_map['AMBIENT_URWOK4'],
							config.sounds.music_map['AMBIENT_URWOK5'],
							config.sounds.music_map['AMBIENT_URWOK6'],
							config.sounds.music_map['AMBIENT_URWOK7'],
							config.sounds.music_map['AMBIENT_URWOK8']
						],
						'jal': [
							config.sounds.music_map['JAL1'],
							config.sounds.music_map['JAL2']
						],
						'nottis': [
							config.sounds.music_map['WINTER_HUB1'],
							config.sounds.music_map['WINTER_HUB2'],
							config.sounds.music_map['WINTER_HUB3'],
							config.sounds.music_map['WINTER_HUB4'],
							config.sounds.music_map['WINTER_HUB5']
						],
						'bortola_muufo': [
							config.sounds.music_map['AMBIENT_FOREST_SLOW1'],
							config.sounds.music_map['AMBIENT_FOREST_SLOW2'],
							config.sounds.music_map['AMBIENT_FOREST_SLOW3'],
							config.sounds.music_map['AMBIENT_FOREST_SLOW4']
						],
						'hell': [
							config.sounds.music_map['HELL']
						]
					};

					// these map hub ids to records in the ambient_library above
					rsp.ambient_hub_map = {
						'78': 'caverns', // Ilmenskie Deeps
						'50': 'caverns', // Ilmenskie Caverns
						'18': 'caverns', // obaix on dev, for testing
						'51': 'uralia',  // Uralia
						'40': 'hell',

						'63': 'firebog',
						'71': 'firebog',
						'72': 'firebog',
						'77': 'firebog',
						'99': 'firebog',

						'86': 'savanna',
						'95': 'savanna',
						'90': 'savanna',
						'91': 'savanna',

						'76': 'highlands',
						'93': 'highlands',
						'109': 'highlands',
						'114': 'highlands',

						'107': 'cave',
						'106': 'cave',

						'85': 'andra_kajuu',
						'89': 'andra_kajuu',
						'113': 'andra_kajuu',
						'119': 'andra_kajuu',
						'102': 'andra_kajuu', // actually Ormonos, yay!
						'105': 'andra_kajuu', // actually Lida, yay!

						'27': 'ix',

						'133': 'kloro_haoma', // actually Kloro, yay!
						'131': 'kloro_haoma', // actually Haoma, yay!

						'126': 'urwok', // actually Roobrik, yay!
						'128': 'urwok', // actually Balzare, yay!

						'136': 'jal',
						'140': 'jal', // actually Samudra, yay!

						'137': 'nottis',
						'141': 'nottis', // actually Drifa, yay!

						'75': 'bortola_muufo', // actually bortola, yay!
						'97': 'bortola_muufo', // actually yay!
						'112': 'bortola_muufo', // actually brillah yay!
						'116': 'bortola_muufo', // actually haraiva yay!

						'88': 'bortola_muufo', // karnata
						'110': 'cave' // massadoe
					};
				}

				//
				// map data
				//

				rsp.world_map_url = overlay_key_to_url('world_map');

				//
				// basic info about the player
				//

				rsp.pc = pc.make_hash_with_location();


				//
				// misc stuff
				//

				rsp.pc.role = 'peon';
				if (pc.is_help) rsp.pc.role = 'help';
				if (pc.is_god) rsp.pc.role = 'god';
				if (pc.is_guide){
					rsp.pc.role = 'guide';
					rsp.pc.guide_on_duty = pc.guide_on_duty ? true : false;
				}
				rsp.prefs = pc.getPrefs();


				//
				// stats & metabolics
				//

				rsp.pc.stats = {};
				pc.stats_get_login(rsp.pc.stats);
				pc.metabolics_get_login(rsp.pc.stats);


				//
				// contents of the pc's bags
				//

				rsp.pc.itemstacks = make_bag(pc);

				var furniture_bag = pc.furniture_get_bag();
				if (furniture_bag){
					var contents = furniture_bag.getContents();

					for (var n in contents){
						var it = contents[n];
						if (it){
							rsp.pc.itemstacks[it.tsid] = make_item(it);
						}
					}
				}


				//
				// quests, buffs & familiar
				//

				rsp.quests = pc.quests_get_status();

				rsp.buffs = pc.buffs_get_active();

				rsp.familiar = pc.familiar_get_login();

				rsp.groups = pc.groups_get_login();
				/*
				if (!pc.live_help_group || (!in_array_real(pc.live_help_group, config.live_help_groups) && !in_array_real(pc.live_help_group, config.newbie_live_help_groups)) || time() - pc.date_last_loggedin >= 3600){
					if (pc.stats_get_level() < 11){
						pc.live_help_group = choose_one(config.newbie_live_help_groups);
					}
					else{
						pc.live_help_group = choose_one(config.live_help_groups);
					}
				}
				rsp.live_help_group = pc.live_help_group;
				if (!pc.global_chat_group || !in_array_real(pc.global_chat_group, config.global_chat_groups) || time() - pc.date_last_loggedin >= 3600) pc.global_chat_group = choose_one(config.global_chat_groups);
				rsp.global_chat_group = pc.global_chat_group;

				if (pc.canJoinTradeChat()){
					if (!pc.trade_chat_group || !in_array_real(pc.trade_chat_group, config.trade_chat_groups) || time() - pc.date_last_loggedin >= 3600) pc.trade_chat_group = choose_one(config.trade_chat_groups);
					rsp.trade_chat_group = pc.trade_chat_group;
				}
				*/
				rsp.prompts = pc.prompts_get_login();

				rsp.pc.hi_emote_variant = pc.hi_emote_variant;
				rsp.pc.escrow_tsid = pc.trading.storage_tsid;
				rsp.pc.rewards_bag_tsid = pc.rewards.storage_tsid;
				rsp.pc.mail_bag_tsid = pc.mail.storage_tsid;
				rsp.pc.trophy_storage_tsid = pc.trophies_find_container().tsid;
				rsp.pc.auction_storage_tsid = pc.auctions_find_container().tsid;
				rsp.pc.furniture_bag_tsid = pc.furniture.storage_tsid;
				rsp.pc.needs_account = (pc.quickstart_needs_account && pc.location.class_tsid != 'newxp_intro' && pc.location.class_tsid != 'newxp_training1') ? true : false;

				rsp.acl_key_count = pc.acl_keys_count_received();
				rsp.pol_info = pc.houses_get_login();
				rsp.home_info = pc.houses_get_login_new();

				rsp.overlay_urls = config.overlays.overlays_map;
				rsp.newxp_locations = config.newxp_locations;

				var hi_variants_tracker = apiFindObject(config.hi_variants_tracker);
				var hi_variants_login_data = {};
				if (hi_variants_tracker) hi_variants_login_data = hi_variants_tracker.get_login_data();
				var infector_pc = (hi_variants_login_data.yesterdays_top_infector_tsid) ? apiFindObject(hi_variants_login_data.yesterdays_top_infector_tsid) : null;
				rsp.hi_emote_data = {
					hi_emote_variants: config.base.hi_emote_variants,
						hi_emote_variants_color_map: config.base.hi_emote_variants_color_map,
						hi_emote_variants_name_map: config.base.hi_emote_variants_name_map,
						hi_emote_leaderboard: hi_variants_login_data.leaderboard,
						yesterdays_variant_winner: hi_variants_login_data.yesterdays_winner,
						yesterdays_variant_winner_count: hi_variants_login_data.yesterdays_winner_count,
						yesterdays_top_infector_tsid: hi_variants_login_data.yesterdays_top_infector_tsid,
						yesterdays_top_infector_count: hi_variants_login_data.yesterdays_top_infector_count,
						yesterdays_top_infector_variant: hi_variants_login_data.yesterdays_top_infector_variant,
						yesterdays_top_infector_pc: (infector_pc && infector_pc.is_player) ? infector_pc.make_hash() : null
				};


				/* we used to send only a subset, but it is not too much data to just send it all, and we can use it in client
				var client_overlay_keys = ['tower_sign_scaffolding_overlay', 'fox_brush', 'proto_puff', 'smoke_puff', 'world_map', 'neuron_burst', 'rook_attack_test', 'rook_attack_fx_test', 'rook_fly_side', 'rook_fly_up', 'rook_fly_up_flv', 'rook_flock', 'rook_fly_forward', 'rook_familiar', 'sonic_boom', 'rook_fly_up_fractal_flv'];
				for (var i=0;i<client_overlay_keys.length;i++) {
				var o = client_overlay_keys[i];
				rsp.overlay_urls[o] = overlay_key_to_url(o);
				}
				*/

				var path_data = pc.getPathRsp();
				if (path_data){
					rsp.path_info = path_data;
				}

				rsp.camera_abilities = pc.getCameraAbilities();
			}

			//log.info('***LOGIN-START-'+pc.tsid+'-2');

			rsp.location = pc.location.prep_geometry(pc);
			// Rewrite the world map url
			if (rsp.overlay_urls && rsp.location.mapData  && rsp.location.mapData.world_map) rsp.overlay_urls['world_map'] = rsp.location.mapData.world_map;

			//log.info('***LOGIN-START-'+pc.tsid+'-3');


			//
			// send item definitions for all items
			//
			// this is a horrible hack and is temporary!
			// a special 'item' called 'catalog' contains an array of class_tsids
			//

			var catalog = apiFindItemPrototype('catalog');
			var tsids = catalog.class_tsids;

			// do not send these in rsp
			var skip_props = config.base.itemDef_skip_props;

			// send these props only if their value is not the default value specified
			var default_values = config.base.itemDef_default_values;

			// send this to client so it can apply the default values
			rsp.default_item_values = default_values;

			rsp.items = {};
			for (var n in tsids){
				var tsid = tsids[n];
				try {
					var itemProto = apiFindItemPrototype(tsid);
					rsp.items[tsid] = Utils.copy_hash(itemProto.itemDef);

					rsp.items[tsid].has_infopage = itemProto.has_infopage;
					if (itemProto.proxy_item) rsp.items[tsid].proxy_item = itemProto.proxy_item;

					for (var i in default_values){
						if (rsp.items[tsid][i] == default_values[i]) {
							delete rsp.items[tsid][i];
						}
					}

					for (var i in skip_props){
						delete rsp.items[tsid][i];
					}

					if (itemProto.getSubClasses) rsp.items[tsid].subclasses = itemProto.getSubClasses();
					if (itemProto.is_routable) rsp.items[tsid].is_routable = true;

				} catch (e){
					//rsp.items[tsid] = {};
					log.error("can't find prototype for "+tsid+" from catalog during login_start");
				}
			}

			// Invoking sets catalog
			catalog = apiFindItemPrototype('catalog_invoking_sets');
			rsp.invoking = {
				sets: catalog.sets,
					blockers: {
						items: {
							'furniture_chassis': {
								width: 740
							},
							'home_sign': {
								width: 116
							},
							'magic_rock': {
								width: 116
							},
							'patch_seedling': {
								width: 286
							},
							'wood_tree': {
								width: 286
							},
							'trant_bean': {
								width: 286
							},
							'trant_spice': {
								width: 286
							},
							'trant_bubble': {
								width: 286
							},
							'trant_egg': {
								width: 286
							},
							'trant_fruit': {
								width: 286
							},
							'trant_gas': {
								width: 286
							},
							'trant_bean_dead': {
								width: 286
							},
							'trant_spice_dead': {
								width: 286
							},
							'trant_bubble_dead': {
								width: 286
							},
							'trant_egg_dead': {
								width: 286
							},
							'trant_fruit_dead': {
								width: 286
							},
							'trant_gas_dead': {
								width: 286
							}
						},
						signpost: {
							width: 260
						}
					}
			};

			// Deco sets catalog
			catalog = apiFindItemPrototype('catalog_userdeco_sets');
			rsp.userdeco = {
				sets: catalog.sets
			};


			// Recipe catalog
			catalog = apiFindItemPrototype('catalog_recipes');

			rsp.recipes = {};
			for (var rid in catalog.recipes){
				if (catalog.recipes[rid].learnt == 3) continue;

				var r = get_recipe(rid); // get_recipe sets some other stuff up for us, so let's call it

				// Copy the recipe so we don't modify the catalog
				r = Utils.copy_hash(r);
				r.id = rid; // We need recipe id too

				// Discoverable?
				if (r.learnt == 0) r.discoverable = 1;

				// Get the tool that makes this recipe
				var tool = apiFindItemPrototype(r.tool);

				// Change task_limit based on potential upgrades
				var task_limit_multiplier = pc.get_task_limit_multiplier(tool);
				if (task_limit_multiplier != 1.0){
					r.task_limit = Math.round(r.task_limit * task_limit_multiplier);
				}

				// Do we know this recipe?
				if (!pc.recipes.recipes[rid]){
					// We implicitly know all transmogrification recipes
					if (!tool || tool.getClassProp('making_type') != 'transmogrification'){
						r.learnt = 0;
					}
					else if (rid == 288 && isPiDay()) {
						// we implicitly know the pi recipe
						r.learnt = 0;
					}
				}
				else if (r.discoverable){
					r.learnt = 1;
				}


				// Explain if we can make this thing, and why we can't if we can't
				if (r.learnt){
					r.disabled = false;
					if (r.skills){
						for (var s in r.skills){
							if (!pc.skills_has(r.skills[s])){
								r.disabled = true;
								r.disabled_reason = "You need to learn the "+pc.skills_linkify(r.skills[s])+" skill.";
								break;
							}
						}
					}

					if (r.achievements){
						for (var a in r.achievements){
							if (!pc.achievements_has(r.achievements[a])){
								r.disabled = true;
								r.disabled_reason = "You need to get the "+pc.achievements_linkify(r.achievements[a])+" achievement.";
								break;
							}
						}
					}
				}

				rsp.recipes[rid] = r;
			}


			//log.info('***LOGIN-START-'+pc.tsid+'-4');

			//
			// the player's buddylists
			//

			rsp.buddies = pc.buddies_get_login();
			rsp.ignoring = pc.buddies_get_ignoring_login();

			//log.info('***LOGIN-START-'+pc.tsid+'-5');


			//
			// in a party?
			//

			var m = pc.party_members();
			if (m){
				rsp.party = {
					members: m
				};
			}

			//log.info('***LOGIN-START-'+pc.tsid+'-6');


			//
			// Loading info
			//

			rsp.loading_info = pc.location.getLoadingInfo(pc);


			//
			// Skill urls
			//

			rsp.skill_urls = pc.skills_get_urls();

			//log.info('***LOGIN-START-'+pc.tsid+'-7');

			//
			// send it
			//

			pc.apiSendMsgAsIs(rsp);

			//
			// Perf testing
			//

			if (msg.perf_testing && msg.perf_testing == true){
				if (!pc.after_perf_test_location){
					pc.after_perf_test_location = {
						tsid: pc.location.tsid,
							x: pc.x,
							y: pc.y
					};
				}

				delete pc.halt_perf_test;
			}
			else if (pc.after_perf_test_location){
				pc.halt_perf_test = true;
			}
		}


function get_recipe(id){

	var prot = apiFindItemPrototype('catalog_recipes');
	if (prot.recipes[id] && prot.recipes[id].tool){
		var tool = apiFindItemPrototype(prot.recipes[id].tool);
		// Find the verb on this tool that makes recipe id 'id'
		for (var v in tool.verbs){
			// Is this a making verb?
			if (tool.verbs[v].making){
				for (var r2=0; r2<tool.verbs[v].making.recipes.length; r2++){
					// Verb 'v' makes recipe id 'id'
					if (tool.verbs[v].making.recipes[r2] == id){
						prot.recipes[id].tool_verb = v;
						break;
					}
				}
			}

			if (prot.recipes[id].tool_verb) break;
		}
	}

	if (prot.recipes[id] && prot.recipes[id].inputs){
		// Find consumables
		for (var i=0; i<prot.recipes[id].inputs.length; i++){
			var input = apiFindItemPrototype(prot.recipes[id].inputs[i][0]);
			if (input && input.is_consumable){
				prot.recipes[id].inputs[i][2] = true;
			}
			else{
				prot.recipes[id].inputs[i][2] = false;
			}
		}
	}

	return prot.recipes[id];
}


function isPiDay(){
	var date = new Date();

	// Months are zero indexed but days aren't for some reason.
	if ((date.getUTCMonth() +1) == 3){
		if  (date.getUTCDate() == 14){
			return true;
		}
		// Should be true as long as it is Pi day somewhere in the world. Date line is at +/- 12 from UTC
		// So we will check the dates on both sides:
		else if (date.getUTCDate() == 15 && date.getUTCHours() < 12){
			// Still Pi day in timezones 12 hours behind UTC
			return true;
		}
		else if (date.getUTCDate() == 13 && date.getUTCHours() >= 12){
			// Is Pi day already in timezones 12 hours ahead of UTC
			return true;
		}
	}

	//log.info("month is "+(date.getMonth()+1)+" and day is "+date.getDate());
	return false;
}

		// JS START
        // JS END
	}
}

class Key {}
