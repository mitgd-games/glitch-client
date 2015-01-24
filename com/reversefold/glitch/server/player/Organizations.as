package com.reversefold.glitch.server.player {
    import com.reversefold.glitch.server.Common;
    import com.reversefold.glitch.server.data.Config;
    import com.reversefold.glitch.server.player.Player;

    import org.osmf.logging.Log;
    import org.osmf.logging.Logger;

    public class Organizations extends Common {
        private static var log : Logger = Log.getLogger("server.player.organizations");

        public var config : Config;
        public var player : Player;

        public function Organizations(config : Config, player : Player) {
            this.config = config;
            this.player = player;
        }


//
// An organization is like a group, but different.
// inc_groups.js can do much of what we do here -- we only define/use functions here where we want different behavior
//

public function organizations_init(){

    if (this.organizations === undefined || this.organizations === null){
        this.organizations = Server.instance.apiNewOwnedDC(this);
        this.organizations.label = 'Organizations';
        this.organizations.organizations = {};
    }
}

public function organizations_delete_all(){

    // TODO: clean up!
    if (this.organizations){
        this.organizations.apiDelete();
        delete this.organizations;
    }
}


//
// create a new group
//

public function organizations_create(name, desc){

    var organization = Server.instance.apiNewGroup('organization');

    organization.doCreate(name, desc, 'public_apply', this); // Invite/apply

    this.organizations.organizations[organization.tsid] = organization;

    return organization;
}


//
// delete a group
//

public function organizations_delete(tsid){
    if (!tsid) return null;

    var organization = Server.instance.apiFindObject(tsid);

    if (!organization) return null;

    organization.doDelete(this);

    return 1;
}


//
// log us out of chat when we log out of the game
//

public function organizations_logout(){

    if (this.organizations){
        for (var i in this.organizations.organizations){

            this.organizations.organizations[i].chat_logout(this);
        }
    }
}

//
// join an org
//

public function organizations_join(tsid){

    var org = Server.instance.apiFindObject(tsid);

    if (!org) return null;

    var ret = org.join(this);
    if (!ret['ok']) return ret;

    if (!this.organizations) this.player.init();
    this.organizations.organizations[org.tsid] = org;

    var info = org.get_basic_info();

    if (info.mode != 'private'){
        this.player.activity_notify({
            type    : 'group_join',
            group   : group.tsid
        });
    }


    //
    // if they're online, send info
    //


    info.type = 'organizations_join';
    info.tsid = org.tsid;

    this.player.sendMsgOnline(info);

    Utils.http_get('callbacks/organizations_joined.php', {
        organization_tsid: org.tsid,
        pc_tsid: this.player.tsid
    });

    return ret;
}


//
// remove this pc from the passed org.
// this function just removes pointers - it doesn't deal with auto-promotion, deletion, etc
//

public function organizations_left(organization){

    //
    // remove pointer from pc->organization
    //

    if (this.organizations && this.organizations.organizations){

        delete this.organizations.organizations[organization.tsid];
    }


    //
    // if we're online, point out we left the organization
    //

    this.player.sendMsgOnline({
        type: 'organizations_leave',
        tsid: organization.tsid
    });

    Utils.http_get('callbacks/organizations_left.php', {
        organization_tsid: organization.tsid,
        pc_tsid: this.player.tsid
    });
}

//
// Do we have an organization?
//

public function organizations_has(){
    this.organizations_init();
    return num_keys(this.organizations.organizations) ? true : false;
}

//
// Return our organization. This only works if everyone only has one, which is true for now
//

public function organizations_get(){
    this.organizations_init();

    for (var i in this.organizations.organizations){
        return this.organizations.organizations[i];
    }
}

    }
}
