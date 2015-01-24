package com.reversefold.glitch.server.player {
    import com.reversefold.glitch.server.Common;
    import com.reversefold.glitch.server.data.Config;
    import com.reversefold.glitch.server.player.Player;

    import org.osmf.logging.Log;
    import org.osmf.logging.Logger;

    public class Groups extends Common {
        private static var log : Logger = Log.getLogger("server.player.Groups");

        public var config : Config;
        public var player : Player;

        public function Groups(config : Config, player : Player) {
            this.config = config;
            this.player = player;
        }


public function groups_init(){

    if (this.groups === undefined || this.groups === null){
        this.groups = Server.instance.apiNewOwnedDC(this);
        this.groups.label = 'Groups';
        this.groups.groups = {};
    }

    if (!this.group_invites){
        this.group_invites = {};
    }

    if (!this.group_applied){
        this.group_applied = {};
    }

    if (this.group_chatrooms){
        delete this.group_chatrooms;
    }

    if (!this.group_chats){
        this.group_chats = [];
    }
}

public function groups_delete_all(){

    // TODO: clean up!
}



//
// create a new group
//

public function groups_create(name, desc, mode){

    var group = Server.instance.apiNewGroup('group');

    group.doCreate(name, desc, mode, this);

    if (!this.groups) this.player.init();
    this.groups.groups[group.tsid] = group;

    var info = group.get_basic_info();

    if (info.mode != 'private'){
        this.player.activity_notify({
            type    : 'group_join',
            group   : group.tsid
        });
    }


    //
    // if they're online, send info
    //


    info.type = 'groups_join';
    info.tsid = group.tsid;

    this.player.sendMsgOnline(info);

    utils.http_get('callbacks/groups_joined.php', {
        group_tsid: group.tsid,
        pc_tsid: this.player.tsid
    });

    return group.tsid;
}


//
// delete a group
//

public function groups_delete(tsid){

    var group = Server.instance.apiFindObject(tsid);

    if (!group) return null;

    group.doDelete(this);

    return 1;
}




//
// join a group
//

public function groups_join(tsid){

    var group = Server.instance.apiFindObject(tsid);

    if (!group) return null;

    var ret = group.join(this);
    if (!ret['ok']) return ret;

    if (!this.groups) this.player.init();
    this.groups.groups[group.tsid] = group;

    var info = group.get_basic_info();

    if (info.mode != 'private'){
        this.player.activity_notify({
            type    : 'group_join',
            group   : group.tsid
        });
    }


    //
    // if they're online, send info
    //


    info.type = 'groups_join';
    info.tsid = group.tsid;

    this.player.sendMsgOnline(info);

    utils.http_get('callbacks/groups_joined.php', {
        group_tsid: group.tsid,
        pc_tsid: this.player.tsid
    });

    return ret;
}

public function groups_apply(tsid){

    var group = Server.instance.apiFindObject(tsid);

    if (!group) return null;

    return group.apply(this);
}

public function groups_applied(group){

    this.groups_init();
    this.group_applied[group.tsid] = 1;
}

public function groups_unapplied(group){

    this.groups_init();
    delete this.group_applied[group.tsid];
}

//
// leave a group
//

public function groups_leave(tsid, promote_tsid){

    var group = Server.instance.apiFindObject(tsid);

    if (!group) return null;

    if (!group.leave(this, promote_tsid)) return 0;


    //
    // remove pointer from pc->group
    //

    if (this.groups && this.groups.groups){

        delete this.groups.groups[tsid];
    }


    //
    // if we're online, point out we left the group
    //

    this.player.sendMsgOnline({
        type: 'groups_leave',
        tsid: tsid
    });

    utils.http_get('callbacks/groups_left.php', {
        group_tsid: tsid,
        pc_tsid: this.player.tsid
    });

    return 1;
}

//
// The group told us we left, not the other way around
//

public function groups_left(tsid){
    //
    // remove pointer from pc->group
    //

    if (this.groups && this.groups.groups){

        delete this.groups.groups[tsid];
    }


    //
    // if we're online, point out we left the group
    //

    this.player.sendMsgOnline({
        type: 'groups_leave',
        tsid: tsid
    });

    utils.http_get('callbacks/groups_left.php', {
        group_tsid: tsid,
        pc_tsid: this.player.tsid
    });

    return 1;
}

public function adminGetGroups(){

    var out = {
        groups: [],
        invites: []
    };

    if (this.groups){
        var gg = this.groups.groups;
        for (var i in gg){

            out.groups.push(gg[i].get_basic_info());
        }
    }
    if (this.group_invites){
        for (var i in this.group_invites){
            var g = Server.instance.apiFindObject(i);
            if (g){
                var invite = g.get_invite(this.player.tsid);
                if (invite){
                    var info = g.get_basic_info();
                    info.invite = invite;

                    out.invites.push(info);
                }
            }
        }
    }

    out.num_groups = num_keys(out.groups);
    out.max_groups = config.max_groups;
    out.num_invites = num_keys(out.invites);

    if (this.player.isGreeter()) out.max_groups++;

    return out;
}

public function adminDeleteGroup(args){
    return this.groups_delete(args.tsid);
}

public function adminCreateGroup(args){
    return this.groups_create(args.name, args.desc, args.mode);
}

public function adminJoinGroup(args){
    return this.groups_join(args.tsid);
}

public function adminLeaveGroup(args){
    return this.groups_leave(args.tsid);
}

public function adminApplyGroup(args){
    return this.groups_apply(args.tsid);
}

public function adminGetGroupPromotionCandidate(args){

    var group = Server.instance.apiFindObject(args.tsid);

    if (!group) return null;

    return group.get_promote_candidate();
}

public function groups_count(){

    return this.groups ? num_keys(this.groups.groups) : 0;
}

public function groups_get_login(){

    var out = {};

    if (this.groups){
        var gg = this.groups.groups;
        for (var i in gg){

            out[i] = gg[i].get_very_basic_info();
        }
    }

    return out;
}


public function groups_chat(tsid, txt){

    // Handle chat-only groups first
    if (in_array_real(tsid, config.live_help_groups) || in_array_real(tsid, config.newbie_live_help_groups) || in_array_real(tsid, config.global_chat_groups) || in_array_real(tsid, config.trade_chat_groups)){
        Server.instance.apiFindObject(tsid).chat_send(this, txt);
    }
    else if (this.groups && this.groups.groups[tsid]){

        this.groups.groups[tsid].chat_send(this, txt);
    }else{
        this.player.sendActivity("Group not found");
    }
}

public function groups_chat_join(tsid){

    // Handle chat-only groups first
    if (in_array_real(tsid, config.live_help_groups) || in_array_real(tsid, config.newbie_live_help_groups) || in_array_real(tsid, config.global_chat_groups) || in_array_real(tsid, config.trade_chat_groups)){
        Server.instance.apiFindObject(tsid).chat_join(this);

        if (!this.group_chat) this.groups_init();
        if (!in_array_real(tsid, this.group_chats)) this.group_chats.push(tsid);
    }
    else if (this.groups && this.groups.groups[tsid]){

        this.groups.groups[tsid].chat_join(this);
    }else{
        this.player.sendActivity("Group not found");
    }

}

public function groups_chat_leave(tsid){
    log.info(this+' groups_chat_leave: '+tsid);

    // Handle chat-only groups first
    if (in_array_real(tsid, config.live_help_groups) || in_array_real(tsid, config.newbie_live_help_groups) || in_array_real(tsid, config.global_chat_groups) || in_array_real(tsid, config.trade_chat_groups)){
        Server.instance.apiFindObject(tsid).chat_leave(this);

        if (this.group_chats){
            array_remove_value(this.group_chats, tsid);
        }
    }
    else if (this.groups && this.groups.groups[tsid]){

        this.groups.groups[tsid].chat_leave(this);
    }else{
        this.player.sendActivity("Group not found");
    }

}

public function groups_logout(){
    log.info(this+' groups_logout');

    if (this.groups){
        var gg = this.groups.groups;
        for (var i in gg){
            log.info(this+' groups_logout: '+gg[i]);
            gg[i].chat_logout(this);
        }
    }

    // Now log us out of the chat-only groups
    if (this.group_chats){
        for (var i=0; i<this.group_chats.length; i++){
            var c = this.group_chats[i];
            log.info(this+' groups_logout: '+c);
            Server.instance.apiFindObject(c).chat_logout(this);
            array_remove_value(this.group_chats, c);
        }
    }
}

public function groups_is_in_chat(tsid){
    // Handle chat-only groups first
    if (in_array_real(tsid, config.live_help_groups) || in_array_real(tsid, config.newbie_live_help_groups) || in_array_real(tsid, config.global_chat_groups) || in_array_real(tsid, config.trade_chat_groups)){
        return in_array_real(tsid, this.group_chats);
    }
    else if (this.groups && this.groups.groups[tsid]){

        return this.groups.groups[tsid].chat_is_in_roster(this.player.tsid);
    }else{
        return false;
    }
}


public function groups_invited(group){

    this.groups_init();
    this.group_invites[group.tsid] = 1;
}

public function groups_uninvited(group){

    this.groups_init();
    delete this.group_invites[group.tsid];

    utils.http_get('callbacks/groups_declined.php', {
        group_tsid: group.tsid,
        pc_tsid: this.player.tsid
    });
}


public function groups_get_status(tsid){

    this.groups_init();

    if (this.group_invites[tsid]) return 'invited';

    if (this.group_applied[tsid]) return 'applied';

    if (this.groups.groups[tsid]) return 'member';

    return 'none';
}

public function groups_get_all(){

    // used for the player's god groups page

    var tsids = [];
    var out = {};

    for (var i in this.groups.groups){
        tsids.push(i);
        out[i] = {
            rel : 'member'
        };
    }
    for (var i in this.group_invites){
        tsids.push(i);
        out[i] = {
            rel : 'invite'
        };
    }
    for (var i in this.group_applied){
        tsids.push(i);
        out[i] = {
            rel : 'applied'
        };
    }

    var ret = Server.instance.apiCallMethod('get_member_status', tsids, this.player.tsid);
    for (var i in ret){
        out[i].rev = ret[i];
    }

    return out;
}

public function groups_has(tsid){
    if (in_array_real(tsid, config.live_help_groups) || in_array_real(tsid, config.newbie_live_help_groups) || in_array_real(tsid, config.global_chat_groups) || in_array_real(tsid, config.trade_chat_groups)) return true;

    return this.groups.groups[tsid] ? true : false;
}

public function groups_get(tsid){
    if (in_array_real(tsid, config.live_help_groups) || in_array_real(tsid, config.newbie_live_help_groups) || in_array_real(tsid, config.global_chat_groups) || in_array_real(tsid, config.trade_chat_groups)){
        return Server.instance.apiFindObject(tsid);
    }
    else{
        return this.groups.groups[tsid];
    }
}

public function groups_check_pointers(){
    if (!this.groups || !this.groups.groups) return 0;

    var gg = this.groups.groups;
    for (var i in gg){
        var g = Server.instance.apiFindObject(i);
        if (!g || !g.is_member(this) || g.getProp('deleted')){
            log.info(this+" groups_check_pointers deleting "+i);
            delete gg[i];
        }
    }

    var gi = this.group_invites;
    for (var i in gi){
        var g = Server.instance.apiFindObject(i);
        if (!g || !g.get_invite(this.player.tsid) || g.getProp('deleted')){
            log.info(this+" groups_check_pointers deleting invite "+i);
            delete gg[i];
        }
    }

    var ga = this.group_applied;
    for (var i in ga){
        var g = Server.instance.apiFindObject(i);
        if (!g || !g.get_apply(this.player.tsid) || g.getProp('deleted')){
            log.info(this+" groups_check_pointers deleting application "+i);
            delete gg[i];
        }
    }

    return 1;
}

    }
}
