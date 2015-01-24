package com.reversefold.glitch.server.player {
    import com.reversefold.glitch.server.Common;
    import com.reversefold.glitch.server.Server;
    import com.reversefold.glitch.server.data.Config;
    import com.reversefold.glitch.server.player.Player;
    
    import org.osmf.logging.Log;
    import org.osmf.logging.Logger;

    public class Items extends Common {
        private static var log : Logger = Log.getLogger("server.player.items");

        public var config : Config;
        public var player : Player;
		
		public var items;
		public var delayedCreateItems;
		public var on_discovery_closed;
		public var swf_one;
		public var swf_two;
		public var swf_three;
		public var glitch_game;
		public var zilloweenTreaters;
		public var food_history;

        public function Items(config : Config, player : Player) {
            this.config = config;
            this.player = player;
        }

//#include inc_artifacts.js
public var artifact_map = {
    'butterfly_hair_clip':{
        'artifact': 'artifact_butterfly_hair_clip',
        'pieces': [
            'artifact_butterfly_hair_clip_piece1',
            'artifact_butterfly_hair_clip_piece2',
            'artifact_butterfly_hair_clip_piece3',
            'artifact_butterfly_hair_clip_piece4'
        ]
    },
    'chicken_brick':{
        'artifact': 'artifact_chicken_brick',
        'pieces': [
            'artifact_chicken_brick_piece1',
            'artifact_chicken_brick_piece2',
            'artifact_chicken_brick_piece3',
            'artifact_chicken_brick_piece4',
            'artifact_chicken_brick_piece5'
        ]
    },
    'glove_metal_finger':{
        'artifact': 'artifact_glove_metal_finger',
        'pieces': [
            'artifact_glove_metal_finger_piece1',
            'artifact_glove_metal_finger_piece2',
            'artifact_glove_metal_finger_piece3'
        ]
    },
    'magical_pendant':{
        'artifact': 'artifact_magical_pendant',
        'pieces': [
            'artifact_magical_pendant_piece1',
            'artifact_magical_pendant_piece2',
            'artifact_magical_pendant_piece3'
        ]
    },
    'mirror_with_scribbles':{
        'artifact': 'artifact_mirror_with_scribbles',
        'pieces': [
            'artifact_mirror_with_scribbles_piece1',
            'artifact_mirror_with_scribbles_piece2',
            'artifact_mirror_with_scribbles_piece3',
            'artifact_mirror_with_scribbles_piece4',
            'artifact_mirror_with_scribbles_piece5'
        ]
    },
    'mysterious_cube':{
        'artifact': 'artifact_mysterious_cube',
        'pieces': [
            'artifact_mysterious_cube_piece1',
            'artifact_mysterious_cube_piece2',
            'artifact_mysterious_cube_piece3',
            'artifact_mysterious_cube_piece4',
            'artifact_mysterious_cube_piece5'
        ]
    },
    'nose_of_china':{
        'artifact': 'artifact_nose_of_china',
        'pieces': [
            'artifact_nose_of_china_piece1',
            'artifact_nose_of_china_piece2'
        ]
    },
    'platinumium_spork':{
        'artifact': 'artifact_platinumium_spork',
        'pieces': [
            'artifact_platinumium_spork_piece1',
            'artifact_platinumium_spork_piece2'
        ]
    },
    'torn_manuscript':{
        'artifact': 'artifact_torn_manuscript',
        'pieces': [
            'artifact_torn_manuscript_piece1',
            'artifact_torn_manuscript_piece2',
            'artifact_torn_manuscript_piece3',
            'artifact_torn_manuscript_piece4'
        ]
    },
    'wooden_apple':{
        'artifact': 'artifact_wooden_apple',
        'pieces': [
            'artifact_wooden_apple_piece1',
            'artifact_wooden_apple_piece2',
            'artifact_wooden_apple_piece3',
            'artifact_wooden_apple_piece4'
        ]
    }
};

public var artifact_necklaces = {
    'artifact_necklace_amazonite_piece': {
        required: 17,
        produces: 'artifact_necklace_amazonite'
    },
    'artifact_necklace_rhyolite_piece': {
        required: 17,
        produces: 'artifact_necklace_rhyolite'
    },
    'artifact_necklace_onyx_piece': {
        required: 19,
        produces: 'artifact_necklace_onyx'
    },
    'artifact_necklace_redtigereye_piece': {
        required: 19,
        produces: 'artifact_necklace_redtigereye'
    },
    'artifact_necklace_imperial_piece': {
        required: 23,
        produces: 'artifact_necklace_imperial'
    }
};

public function artifactPieceAdded(stack){
    if (artifact_necklaces[stack.class_tsid]){
        if (this.items_has(stack.class_tsid, artifact_necklaces[stack.class_tsid].required)){
            this.apiSetTimerX('createArtifactNecklace', 1*1000, stack.class_tsid);
        }
    }
    else{
        var artifact_type = this.findArtifactForPiece(stack.class_tsid);
        if (artifact_map[artifact_type] && artifact_map[artifact_type].pieces){
            var has_all_pieces = true;
            for (var i in artifact_map[artifact_type].pieces){
                if (!this.items_has(artifact_map[artifact_type].pieces[i], 1)){
                    has_all_pieces = false;
                    break;
                }
            }

            if (has_all_pieces){
                this.apiSetTimerX('createArtifact', 1*1000, artifact_type);
            }
        }
    }
}

public function findArtifactForPiece(class_tsid){
    var artifact;

    for (var i in artifact_map){
        for (var j in artifact_map[i].pieces){
            if (artifact_map[i].pieces[j] == class_tsid){
                artifact = i;
                break;
            }
        }
    }

    return artifact;
}


public function createArtifact(artifact_type){
    var prot = Server.instance.apiFindItemPrototype(artifact_map[artifact_type].artifact);
    this.player.announcements.announce_vp_overlay({
            duration: 5000,
            locking: true,
            width: 500,
            x: '50%',
            top_y: '15%',
            click_to_advance: false,
            text: [
                '<p align="center"><span class="nuxp_vog">You\'ve combined all the artifact pieces to make a '+prot.label+'!</span></p>'
            ]
        });

    var stack = null;
    for (var i in artifact_map[artifact_type].pieces){
        stack = this.player.bag.removeItemStackClass(this.artifact_map[artifact_type].pieces[i], 1);
        if (!stack) break;
        stack.apiDelete();
    }

    this.apiSetTimerX('createItemFromGround', 5000, artifact_map[artifact_type].artifact, 1);
    this.player.achievements.achievements_increment('artifacts_made', artifact_map[artifact_type].artifact, 1);
}


public function createArtifactNecklace(piece_type){
    var prot = Server.instance.apiFindItemPrototype(artifact_necklaces[piece_type].produces);
    this.player.announcements.announce_vp_overlay({
            duration: 5000,
            locking: true,
            width: 500,
            x: '50%',
            top_y: '15%',
            click_to_advance: false,
            text: [
                '<p align="center"><span class="nuxp_vog">You\'ve combined '+artifact_necklaces[piece_type].required+' beads to make a '+prot.label+'!</span></p>'
            ]
        });

    this.items_destroy(piece_type, artifact_necklaces[piece_type].required);

    this.apiSetTimerX('createItemFromGround', 5000, artifact_necklaces[piece_type].produces, 1);
    this.player.achievements.achievements_increment('necklaces_made', artifact_necklaces[piece_type].produces, 1);
}

// END inc_artifacts.js

public function items_has(class_tsid, num){
    if (!num) num = 1;

    return this.player.bag.countItemClass(class_tsid) >= num ? true : false;
}

// Return what, if anything, we have from the list
public function items_has_list(class_list, num) {
    var out_list = [];
    for(var i in class_list) {
        if(this.player.bag.countItemClass(class_list[i]) >= num) {
            out_list.push(class_list[i]);
        }
    }

    return out_list;
}

// Return what, if anything, we have from the drop table
public function items_has_drops(drop_table, num) {
    var out_list = [];
    var prot = Server.instance.apiFindItemPrototype('catalog_drop_tables');
    if (prot.drop_tables[drop_table]){
        var table = prot.drop_tables[drop_table];
        for (var drop_chance in table.drops){
            var items = table.drops[drop_chance];
            for (var i in items){
                if(this.player.bag.countItemClass(items[i].class_id) >= num) {
                    out_list.push(items[i].class_id);
                }
            }
        }
    }

    return out_list;
}

//
// this function gives both items and other bonuses
//
public function items_give_multiple(items, from_familiar){

    for (var i in items){

        if (i == '_currants'){

            this.player.stats.stats_add_currants(items[i]);
        }else{
            if (from_familiar){
                this.createItemFromFamiliar(i, items[i]);
            }
            else{
                this.createItem(i, items[i]);
            }
        }

    }
}

//
// just like the function above, but makes a message
//
public function items_format_multiple(items){

    var out = [];

    for (var i in items){

        if (i == '_currants'){

            if (items[i] == 1){
                out.push("1 currant");
            }else{
                out.push(items[i]+' currants');
            }
        }else{
            var proto = Server.instance.apiFindItemPrototype(i);

            if (items[i] == 1){
                out.push(proto.article+" "+proto.name_single);
            }else{
                out.push(items[i]+" "+proto.name_plural);
            }
        }
    }

    return pretty_list(out, ' and ');
}

public function items_destroy(class_id, num){
    var stacks = this.takeItemsFromBag(class_id, num);

    if (stacks){
        for (var i in stacks){
            stacks[i].apiDelete();
        }
        return 1;
    }
    return 0;
}

//
// takes a list of item class and num pairs to delete from bag
// e.g. [['apple',4],['orange',1],['paper',12]]
// does all or nothing, returns true if it worked
//

public function items_destroy_multi(items){
    var all_stacks = [];
    var ok = 1;
    for (var i in items){
        var s = this.takeItemsFromBag(items[i][0], items[i][1]);
        if (s){
            all_stacks.push(s);
        }else{
            log.info("failed to get stack of "+items[i][1]+" x "+items[i][0]);
            ok = 0;
            break;
        }
    }
    for (var i in all_stacks){
        for (var j in all_stacks[i]){
            if (ok){
                all_stacks[i][j].apiDelete();
            }else{
                all_stacks[i][j].apiPutBack();
            }
        }
    }
    return ok;
}



public function get_stacks_by_class(class_id){

    var out = [];

    var items = this.player.bag.getAllContents();
    for (var i in items){
        if (items[i].class_id == class_id){
            out.push(items[i]);
        }
    }
    return out;
}


public function get_item_counts_including_bags(){

    var items = {};

    var all_items = this.player.bag.getAllContents();
    for (var i in all_items){
        var it = all_items[i];
        if (!items[it.class_tsid]) items[it.class_tsid] = 0;
        items[it.class_tsid] += it.getCount();

        if (it.is_bag){
            var sub_items = it.get_item_counts(true);
            for (var j in sub_items){
                if (!items[j]) items[j] = 0;
                items[j] += sub_items[j];
            }
        }
    }

    return items;
}

public function find_items_including_bags(class_tsid, args){
    var is_function = (typeof class_tsid == 'function');

    var all_items = this.player.bag.getAllContents();
    var items = [];
    for (var i in all_items){
        var it = all_items[i];

        var ok = 0;
        if (is_function) ok = (it && class_tsid(it, args));
        if (!is_function) ok = (it && it.class_tsid == class_tsid) ? true : false;

        if (ok && this.items[i] != null) items.push(this.items[i]);

        if (!ok && it.is_bag){
            var tmp = items.concat(it.findItemClass(class_tsid, args));
            if (tmp.length > 0){
                items = tmp;
            }
        }
    }

    return items;
}


//
// Find out if we have num of class_id items in our inventory
// Excludes all hidden items
//

public function checkItemsInBag(class_id, num){
    var found_num =0;
    var items = this.player.bag.getAllContents();
    for (var i in items){
        if (items[i].class_id == class_id && !items[i].isHidden){

            found_num += items[i].count;

            if (found_num >= num) return 1;
        }
    }
    return 0;
}

public function hasEmptySlot(){
    if (!this.player.bag.isBagFull()) return true;

    var contents = this.player.bag.getContents();
    for (var slot in contents){
        if (contents[slot] && contents[slot].is_bag && !contents[slot].isHidden){
            if (!contents[slot].isBagFull()) return true;
        }
    }

    return false;
}

// this function returns an array of stacks, else null
public function takeItemsFromBag(class_id, num){
    var stacks = [];
    var found_num = 0;

    var items = this.player.bag.getAllContents();
    for (var i in items){
        if (items[i].class_id == class_id){
            var it = this.player.bag.removeItemStack(items[i].path);

            if (found_num + it.count > num){

                // take part of the stack
                var needed = num - found_num;
                var _use = it.apiSplit(needed);

                if (_use){
                    it.apiPutBack();
                    stacks.push(_use);
                    found_num += _use.count;
                }else{
                    // this appears to be a bug!
                    log.info('unable to split off '+needed+" from a stack of "+it.count);
                }

            }else{
                stacks.push(it);
                found_num += it.count;
            }

            if (found_num == num){
                return stacks;
            }
        }
    }

    // we didn't find enough - put them back
    for (var i in stacks){
        stacks[i].apiPutBack();
    }

    return null;
}

public function createItem(class_id, num, destroy_remainder=null, props=null){
    var s = Server.instance.apiNewItemStack(class_id, num);
    if (!s) return num;

    var size = s.count;
    var remaining = this.player.bag.addItemStack(s);
    if (size < num){
        remaining += this.createItem(class_id, num-size, destroy_remainder, props);
    }

    if (remaining && !destroy_remainder){
        remaining = this.player.location.createItem(class_id, remaining, this.player.x, this.player.y-29, 100, this, props);
    }

    return remaining;
}

public function createItemFromGround(class_id, num, destroy_remainder=null, props=null){
    var s = Server.instance.apiNewItemStackFromXY(class_id, num, this.player.x, this.player.y);
    if (!s) return num;

    if (props) {
        for (var i in props) {
            s[i] = props[i];
        }
    }

    var size = s.count;
    var remaining = this.player.bag.addItemStack(s);
    if (size < num){
        var remaining_two = this.createItemFromGround(class_id, num-size, destroy_remainder, props);
    }
    else {
        var remaining_two = 0;
    }

    this.player.apiSendLocMsgX({type: "pc_itemstack_verb"});

    if (destroy_remainder && remaining) {
        s.apiDelete();
    }
    else if (remaining){
        remaining = this.player.location.createItem(class_id, remaining, this.player.x, this.player.y-29, 100, this, props);
    }

    return remaining + remaining_two;
}

public function createItemFromXY(class_id, num, x, y, destroy_remainder, props){
    var s = Server.instance.apiNewItemStackFromXY(class_id, num, x, y);
    if (!s) return num;

    if (props) {
        for (var i in props) {
            s[i] = props[i];
        }
    }

    var size = s.count;
    var remaining = this.player.bag.addItemStack(s);
    if (size < num){
        var remaining_two = this.createItemFromGround(class_id, num-size, destroy_remainder, props);
    }
    else {
        var remaining_two = 0;
    }

    this.player.apiSendLocMsgX({type: "pc_itemstack_verb"});

    if (destroy_remainder && remaining) {
        s.apiDelete();
    }
    else if (remaining){
        remaining = this.player.location.createItem(class_id, remaining, this.player.x, this.player.y-29, 100, this, props);
    }

    return remaining + remaining_two;
}

public function createItemFromFamiliar(class_id, num, props=null){
    var s = Server.instance.apiNewItemStackFromFamiliar(class_id, num);
    if (!s) return num;

    if (props) {
        for (var i in props) {
            s[i] = props[i];
        }
    }

    var size = s.count;
    var remaining = this.player.bag.addItemStack(s);
    if (size < num){
        remaining += this.createItemFromFamiliar(class_id, num-size, props);
    }

    if (remaining){
        // Anything remaining from the familiar we automatically place in rewards overflow storage
        this.player.rewards.rewards_store(Server.instance.apiNewItemStack(class_id, remaining));
        s.apiDelete();
    }

    return remaining;
}

public function createItemFromOffsetDelayed(class_id, num, sourcePosition, destroy_remainder, delay, message, sourceItem) {
    // Create pending item list if it doesn't exist
    var theTime = delay / 1000 + time();

    if(!this.delayedCreateItems) {
        this.delayedCreateItems = {};
    }

    while (this.delayedCreateItems[theTime]){
        // collision on this second. move ahead 1
        theTime++;
    }

    // Push new item
    this.delayedCreateItems[theTime] = {'class_id': class_id, 'num': num, 'sourcePosition': sourcePosition, 'destroy_remainder': destroy_remainder, 'message': message, 'sourceItem': sourceItem};
    // Schedule item receipt
    this.apiSetTimer('createDelayedItems', delay);
}

public function createItemFromSourceDelayed(class_id, num, sourceItem, destroy_remainder, delay, message) {
    // Create pending item list if it doesn't exist
    var theTime = delay / 1000 + time();

    if(!this.delayedCreateItems) {
        this.delayedCreateItems = {};
    }

    while (this.delayedCreateItems[theTime]){
        // collision on this second. move ahead 1
        theTime++;
    }

    // Push new item
    this.delayedCreateItems[theTime] = {'class_id': class_id, 'num': num, 'sourceItem': sourceItem, 'destroy_remainder': destroy_remainder, 'message': message};
    // Schedule item receipt
    this.apiSetTimer('createDelayedItems', delay);
}

// Create any pending items, and reschedule self if necessary.
public function createDelayedItems() {
    var newItem = null;
    var nextCreation = -1;

    for(var i in this.delayedCreateItems) {
        if (1 > time()) {
            if(nextCreation == -1 || nextCreation < i) {
                nextCreation = i;
            }
            continue;
        }


        // create item
        newItem = this.delayedCreateItems[i];
        try {
            if(newItem.sourcePosition) {
                this.createItemFromOffset(newItem.class_id, newItem.num, newItem.sourcePosition, newItem.destroy_remainder, newItem.sourceItem);
            } else if (newItem.sourceItem) {
                this.createItemFromSource(newItem.class_id, newItem.num, newItem.sourceItem, newItem.destroy_remainder);
            }
        } catch (e) {
            log.info("ERROR: Create delayed item failed from hash "+newItem+".");
            throw e;
        }
        if(newItem.message) {
            this.player.sendActivity(newItem.message);
        }
        delete this.delayedCreateItems[i];
    }

    if(nextCreation != -1) {
        this.apiSetTimer('createDelayedItems', (nextCreation - time()) * 1000);
    }
}

public function createItemFromOffset(class_id, num, sourcePosition, destroy_remainder, sourceItem, props=null){
    var ix = (sourcePosition ? sourcePosition.x : 0) + ((sourceItem) ? sourceItem.x : 0);
    var iy = (sourcePosition ? sourcePosition.y : 0) + ((sourceItem) ? sourceItem.y : 0);

    var s = Server.instance.apiNewItemStackFromXY(class_id, num, ix, iy);
    if (!s) return num;

    if (this.player.bag.isBagFull(s)){
        s.apiDelete();
        if (!destroy_remainder){
            return this.player.location.createItem(class_id, num, ix, iy - 20, 100, null, props);
        }
        else{
            return num;
        }
    }

    var size = s.count;
    var remaining = this.player.bag.addItemStack(s);
    if (size < num){
        remaining += this.createItemFromOffset(class_id, num-size, sourceItem, destroy_remainder, props);
    }

    if (remaining && !destroy_remainder){
        remaining = this.player.location.createItem(class_id, remaining, ix, iy-20, 100, this, props);
    }

    return remaining;
}


public function createItemFromOffsetWithEscrow(class_id, num, sourcePosition, destroy_remainder, sourceItem, props=null){
    var ix = (sourcePosition ? sourcePosition.x : 0) + ((sourceItem) ? sourceItem.x : 0);
    var iy = (sourcePosition ? sourcePosition.y : 0) + ((sourceItem) ? sourceItem.y : 0);

    var s = Server.instance.apiNewItemStackFromXY(class_id, num, ix, iy);
    if (!s) return num;

    if (this.player.bag.isBagFull(s)){
        if (!destroy_remainder){
            //log.info("ESCROW: putting item into escrow "+s);
            return this.player.rewards.rewards_store(s);
        }
        else{
            //log.info("ESCROW: deleting item");
            s.apiDelete();
            return num;
        }
    }

    var size = s.count;
    var remaining = this.player.bag.addItemStack(s);
    //log.info("ESCROW: added to pack "+s);
    if (size < num){
        //log.info("ESCROW: calling recursively "+(num-size));
        remaining += this.createItemFromOffsetWithEscrow(class_id, num-size, sourceItem, destroy_remainder, props);
    }

    if (remaining && !destroy_remainder){
        log.info("ESCROW: creating item in location  "+remaining);
        remaining = this.player.location.createItem(class_id, remaining, ix, iy-20, 100, this, props);
    }

    return remaining;
}


public function createItemFromSource(class_id, num, sourceItem, destroy_remainder, props=null){
    var s = Server.instance.apiNewItemStackFromSource(class_id, num, sourceItem);
    if (!s) return num;

    if (props) {
        for (var i in props) {
            log.info("Copying "+i+" = "+props[i]+" to "+s);
            s[i] = props[i];
        }
    }

    if (this.player.bag.isBagFull(s)){
        s.apiDelete();
        if (!destroy_remainder){
            if (sourceItem.getContainerType() == 'street'){
                return this.player.location.createItem(class_id, num, sourceItem ? sourceItem.x : this.player.x, sourceItem.y-20, 100, this, props);
            }
            else{
                return this.player.location.createItem(class_id, num, this.player.x, this.player.y-20, 100, this, props);
            }
        }
        else{
            return num;
        }
    }

    var size = s.count;
    var remaining = this.player.bag.addItemStack(s);
    if (size < num){
        remaining += this.createItemFromSource(class_id, num-size, sourceItem, destroy_remainder, props);
    }

    if (remaining && !destroy_remainder){
        if (sourceItem.getContainerType() == 'street'){
            remaining = this.player.location.createItem(class_id, remaining, sourceItem.x, sourceItem.y-20, 100, this, props);
        }
        else{
            remaining = this.player.location.createItem(class_id, remaining, this.player.x, this.player.y-20, 100, this, props);
        }
    }

    return remaining;
}


public function items_destory_stack(tsid){

    var s = this.player.location.apiLockStack(tsid);

    if (!s){
        var items = this.player.bag.getAllContents();
        s = items[tsid];
    }

    if (!s){
        return 0;
    }

    s.apiDelete();
    this.player.apiSendLocMsg({ type: 'location_event' });

    return 1;
}

public function items_added(stack){

    if (stack.container && stack.container.isHidden) return;

    //if (config.is_dev) log.info(this+' items_added: '+stack+' ('+this.player.bag.countItemClass(stack.class_id)+')');

    this.player.quests.quests_changed_item(stack.class_id); // For when we care that you are always carrying it during the quest
    this.player.quests.quests_set_flag('acquired_'+stack.class_id); // For when we care that at some point during the quest, you got it
    var achievements_to_check = this.player.achievements.achievements_get_from_counter('in_inventory', stack.class_id);
    for (var id in achievements_to_check){
        if (!this.player.achievements.achievements_has(id) && this.player.achievements.achievements_check_in_inventory(id)){
            this.player.achievements.achievements_grant(id);
        }
    }

    //
    // Is this our first time seeing this?
    //

    this.player.counters.counters_increment('items_collected', stack.class_tsid);
    var seen_count = this.player.counters.counters_get_label_count('items_collected', stack.class_tsid);
    var discovery_dialog_shown = false;
    if (seen_count == 1 && this.player.isOnline() && (this.player.has_done_intro || this.player.location.class_tsid == 'newbie_island')){
        var context = {'verb':'new_item','stack':stack.class_tsid};
        var xp = this.player.stats.stats_add_xp(config.base.qurazy_rewards[this.player.stats.level-1], false, context);
        if (stack.suppress_discovery) {
            // This stack has been set to supress the discovery dialogue when added. Remove that property.
            delete stack.suppress_discovery;
        } else if (!stack.hasTag('no_discovery_dialog')){
            if (this.player.location.class_tsid == 'newbie_island' && !this.player.imagination.imagination_has_upgrade('encyclopeddling')){
                this.player.sendActivity(stack.label+'!. You discovered a useful new item +'+xp+'IMG', null, false, true);
            }else{
                var rsp = {
                    'type'      : 'get_item_info',
                    'class_tsid'    : stack.class_tsid,
                    'is_new'    : true,
                    'xp'        : xp,
                    'callback_msg_when_closed': 'item_discovery_dialog_closed'
                };

                this.player.apiSendMsg(rsp);
                this.player.announcements.announce_sound('DISCOVER_USEFUL_NEW_ITEM');
                discovery_dialog_shown = true;
            }
        }
    }
    else if (seen_count == 1 && (!this.player.has_done_intro)){
        this.player.announcements.overlay_dismiss('pack_instructions');
        this.player.showPack();
    }
    else if (seen_count == 2 && stack.class_tsid == 'your_papers'){
        if (this.player.achievements.achievements_has('you_have_papers')){
            this.player.prompts.prompts_add({
                txt     : 'You have already completed Your Papers, but you can sell, trade, or give these to other players so they can complete Their Papers.',
                timeout     : 60,
                choices     : [
                    { value : 'ok', label : 'OK' }
                ]
            });
        }
    }

    if (!this.player.buffs.buffs_has('hog_tie') && (stack.class_tsid == 'hogtied_piggy' || (stack.is_bag && stack.countItemClass('hogtied_piggy')))){
        this.player.buffs.buffs_apply('hog_tie');
    }

    // Check for glitch game item
    if (stack.class_tsid == 'swf_1') {
        if (this.items_has('swf_2', 1) && this.items_has('swf_3', 1)) {
            this.apiSetTimer('createGlitchGame', 400);
        }
    }
    else if (stack.class_tsid == 'swf_2') {
        if (this.items_has('swf_1', 1) && this.items_has('swf_3', 1)) {
            this.apiSetTimer('createGlitchGame', 400);
        }
    }
    else if (stack.class_tsid == 'swf_3') {
        if (this.items_has('swf_1', 1) && this.items_has('swf_2', 1)) {
            this.apiSetTimer('createGlitchGame', 400);
        }
    }

    if (stack.class_tsid == 'camera' || (stack.is_bag && stack.countItemClass('camera'))){
        this.player.sendCameraAbilities();
    }

    if (this.player.location && this.player.location.eventFired){
        this.player.location.eventFired('items_added', this, {pc:this, stack:stack});
    }

    if (stack.hasTag('artifactpiece')){
        if (discovery_dialog_shown){
            this.on_discovery_closed = {func: 'artifactPieceAdded', args:{stack:stack}};
        }else{
            this.artifactPieceAdded(stack);
        }
    }
}

public function items_removed(stack){

    if (stack.container && stack.container.isHidden) return;

    if (config.is_dev) log.info(this+' items_removed: '+stack+' ('+this.player.bag.countItemClass(stack.class_id)+'), count: '+stack.count);

    this.player.quests.quests_changed_item(stack.class_id);

    if (!this['!is_trading'] && this.player.trading.trading_has_escrow_items()){
        this.player.trading.trading_rollback();
    }

    this.player.rewards.rewards_return();

    if (this.player.buffs.buffs_has('hog_tie') && (stack.class_tsid == 'hogtied_piggy' || (stack.is_bag && stack.countItemClass('hogtied_piggy')))){
        this.player.buffs.buffs_remove('hog_tie');
    }

    if (stack.class_tsid == 'camera' || (stack.is_bag && stack.countItemClass('camera'))){
        this.player.sendCameraAbilities();
    }
}

//
// Attempt to return the stack safely back to the player.
// If we know where it came from, we put it back there
// Otherwise we put it anywhere that fits
//

public function items_put_back(stack){
    if (stack.container){
        stack.apiPutBack();
    }
    else{
        this.player.bag.addItemStack(stack);
    }
}

public function has_key(key_id){
    function has_key(it, key){ return it.is_key && it.classProps.key_id == key; }

    return this.player.bag.findFirst(has_key, key_id);
}

public function items_find_working_tool(class_tsid){
    function is_tool(it, args){ return it.is_tool && it.isWorking() && it.class_tsid == args ? true : false; }
    return this.player.bag.findFirst(is_tool, class_tsid);
}

//#############################################################################
// Glitch game item support

public function createGlitchGame() {

    this.player.announcements.announce_vp_overlay({
            duration: 5000,
            locking: true,
            width: 500,
            x: '50%',
            top_y: '15%',
            click_to_advance: false,
            text: [
                '<p align="center"><span class="nuxp_vog">You\'ve got multiple SWFs! That makes a Flash based MMO!</span></p>'
            ]
        });

    if (this.swf_one != null || this.swf_two != null || this.swf_three != null){
        log.info("While creating game, SWF trackers already exist");
    }

    this.swf_one = this.player.bag.findFirst('swf_1');

    if (this.swf_one) {
        this.swf_one.takeable_drop(this);
    }

    this.apiSetTimer('onDropFirstSwf', 400);
}

public function onDropFirstSwf() {
    this.swf_two = this.player.bag.findFirst('swf_2');

    if (this.swf_two) {
        this.player.location.apiPutItemIntoPosition(this.swf_two, this.player.x + 40, this.player.y);
    }

    this.apiSetTimer('onDropSecondSwf', 400);
}

public function onDropSecondSwf() {
    this.swf_three = this.player.bag.findFirst('swf_3');

    if (this.swf_three) {
        this.player.location.apiPutItemIntoPosition(this.swf_three, this.player.x + 80, this.player.y);
    }

    this.apiSetTimer('onDropThirdSwf', 400);
}

public function onDropThirdSwf() {
    this.glitch_game = this.createItemFromGround('game_box', 1);

    this.apiSetTimer('onFinishCreateGame', 400);
}

public function onFinishCreateGame() {

    if (this.swf_one == null || this.swf_two == null || this.swf_three == null) {
        log.info("Found invalid SWF while deleting swfs!");
    }

    this.swf_one.apiDelete();
    this.swf_two.apiDelete();
    this.swf_three.apiDelete();

    this.swf_one = null;
    this.swf_two = null;
    this.swf_three = null;

    // Check again
    if (this.items_has('swf_1', 1) && this.items_has('swf_2', 1) && this.items_has('swf_3', 1)) {
        this.apiSetTimer('createGlitchGame', 400);
    }
}

//#############################################################################
// Zilloween special

public function zilloweenTreater(pc, candy_tsid) {
    if (this.zilloweenTreaters && !this.zilloweenTreaters.players) {
        this.zilloweenTreaters = null;
    }

    if (!this.zilloweenTreaters) {
        this.zilloweenTreaters = {};//Server.instance.apiNewOwnedDC(this);
        this.zilloweenTreaters.players = {};
    }

    this.zilloweenTreaters.players[time()] = {'player':pc.tsid, 'candy':candy_tsid};
}

public function zilloweenBoostCheck(candy_tsid) {
    if (!this.zilloweenTreaters) return;

    var treaters = this.zilloweenTreaters.players;
    if (treaters) {
        var now = time();

        for (var t in treaters) {
            if ((now - t) <= 30) {
                if (treaters[t].candy == candy_tsid) {
                    var pc = getPlayer(treaters[t].player);
                    pc.metabolics_add_mood(20);
                    pc.sendActivity("Hey! They're eating the candy! They like it! Yay!");
                    delete treaters[t];
                }
            }
            else {
                delete treaters[t];
            }
        }
    }
}

public function clearZilloweenData() {
    if (this.zilloweenTreaters) delete this.zilloweenTreaters.players;
}

//##############################################################
// FOOD BONUS:
// For testing: subtracts 1 day from all timestamps.
public function food_bonus_subtract_day(num) {
    if (!this.food_history)  return;

    for (var i in this.food_history.list) {
        this.food_history.list[i] = this.food_history.list[i] -  game_days_to_ms(num);
    }
}

public function find_bag_with_category(category){
    var all_items = this.player.bag.getAllContents();
    for (var i in all_items){
        var it = all_items[i];
        if (it.is_bag && it.hasBagCategory && it.hasBagCategory(category)){
            return it;
        }
    }
    return null;
}

public function itemDiscoveryDialogClosed(msg){
    if (this.on_discovery_closed){
        this[this.on_discovery_closed.func](this.on_discovery_closed.args.stack);
    }

    this.on_discovery_closed = null;
}

    }
}
