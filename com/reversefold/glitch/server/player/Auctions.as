package com.reversefold.glitch.server.player {
    import com.reversefold.glitch.server.Common;
    import com.reversefold.glitch.server.Server;
    import com.reversefold.glitch.server.Utils;
    import com.reversefold.glitch.server.data.Config;
    import com.reversefold.glitch.server.player.Player;
    
    import org.osmf.logging.Log;
    import org.osmf.logging.Logger;

    public class Auctions extends Common {
        private static var log : Logger = Log.getLogger("server.player.auctions");

        public var config : Config;
        public var player : Player;
		
        public var label : String;
		public var active;
		public var done;
		public var cancelled;
		public var expired;
		public var prompts;
		public var hiddenItems = {};

        public function Auctions(config : Config, player : Player) {
            this.config = config;
            this.player = player;
        }


// yeah!


public function auctions_init(){

    if (this.label  === undefined || label  === null){
        //this.auctions = Server.instance.apiNewOwnedDC(this);
        this.label  = 'Auctions';
    }

    if (!this.active)  this.active = {};
    if (!this.done)    this.done = {};
    if (!this.cancelled)   this.cancelled = {};
    if (!this.expired) this.expired = {};
    if (!this.prompts) this.prompts = {};

    this.auctions_check_expired();
}

public function auctions_find_container(){
    for (var i in this.hiddenItems){
        var it = this.hiddenItems[i];
        if (it.is_auctioncontainer){
            return it;
        }
    }

    // Still here? Make a new one
    var it = Server.instance.apiNewItemStack('bag_private', 1);
    it.label = 'Private Auction Storage';
    it.is_auctioncontainer = true;

    this.apiAddHiddenStack(it);

    return it;
}

public function auctions_delete(destroy_items){
    if (this.active){

        for (var i in this.active){
            this.auctions_cancel(i, destroy_items);
        }

        apiDeleteTimers();
		this.player.auctions = new Auctions(config, player);
		/*
        this.active = null;
		this.cancelled = null;
		this.done = null;
		this.prompts = null;
		this.expired = null;
		*/
    }
}

public function auctions_get_uid_for_item(item_tsid){
    if (this.active){
        for (var i in this.active){
            var details = this.active[i];
            if (details.stack.tsid == item_tsid) return i;
        }
    }
    return null;
}

public function auctions_reset(destroy_items){
    if (this.active){

        for (var i in this.active){
            this.auctions_cancel(i, destroy_items);
        }

        this.active = {};
        this.done = {};
        this.cancelled = {};
        this.expired = {};
    }
}

public function auctions_start(stack, count, cost, fee_percent, fee_min){

    fee_percent = typeof(fee_percent) != 'undefined' ? fee_percent : 0;
    fee_min  = typeof(fee_min) != 'undefined' ? fee_min : 0;

    this.auctions_init();

    //
    // too many auctions already?
    //
    if (num_keys(this.active)>=100){
        return {
            ok: 0,
            error: 'max_auctions'
        };
    }

    //
    // do we own this stack?
    //

    var temp = stack.apiGetLocatableContainerOrSelf();
    if (temp.tsid != this.player.tsid){

        return {
            ok: 0,
            error: 'not_yours'
        };
    }

    //
    // is it bound to us?
    //
    if (stack.isSoulbound()){
        return{
            ok: 0,
            error: 'stack_is_soulbound'
        };
    }

    //
    // check stack isn't hidden
    // (that usually means the stack is already being auctioned, might
    // mean other things in future)
    //

    if (stack.isHidden || stack.container.is_auctioncontainer){
        return {
            ok: 0,
            error: 'hidden_stack'
        };
    }

    //
    // check count is ok
    //

    count = intval(count);
    if (count < 1){
        return {
            ok: 0,
            error: 'bad_count'
        };
    }

    if (count > stack.count){
        return {
            ok: 0,
            error: 'too_many'
        };
    }


    //
    // is the cost ok?
    //

    cost = intval(cost);
    if (cost < 1){
        return {
            ok: 0,
            error: 'bad_cost'
        };
    } else if (cost > 9999999){
        return {
            ok: 0,
            error: 'cost_too_high'
        };
    }

    //
    // work out the fee and check they can pay
    //

    if (fee_percent){
        var fee = intval(cost/100 * fee_percent);
        fee = fee > fee_min ? fee : fee_min;

        if (!this.player.stats.stats_try_remove_currants(fee, {type: 'auction_fee', class_id: stack.class_tsid})){
            return {
                ok: 0,
                error: "You don't have enough currants for the listing fee."
            };
        }
    }

    //
    // do we need to split the stack off?
    //

    var _use = this.player.bag.removeItemStack(stack.path);

    if (count < stack.count){

        _use = stack.apiSplit(count);
        if (!_use){
            return {
                ok: 0,
                error: 'cant_split'
            };
        } else {
            stack.apiPutBack();
        }
    }

    //
    // create the auction
    //

    Server.instance.apiLogAction('AUCTION_START', 'pc='+this.player.tsid, 'stack='+_use.tsid, 'count='+count);

    if (_use.onAuctionList) _use.onAuctionList(this);

    var storage = this.auctions_find_container();

    storage.apiAddHiddenStack(_use);

    var key = this.auctions_get_uid();

    this.active[key] = {
        stack   : _use,
        created : time(),
        expires : config.is_dev ? time() + (60 * 60 * 24) : time() + (60 * 60 * 72), // only 72h auctions for now
        cost    : cost
    };

    this.auctions_sync(key);


    return {
        ok: 1,
        uid: key
    };
}

public function auctions_cancel(uid, destroy_items=false){

    uid = str(uid);

    this.auctions_init();

    //
    // does it exist?
    //

    if (!this.active[uid]){
        return {
            ok: 0,
            error: 'not_found'
        };
    }


    //
    // got enough space?
    //

    var details = this.active[uid];

    //
    // cancel it
    //

    delete this.active[uid];
    var stack = details.stack;

    Server.instance.apiLogAction('AUCTION_CANCEL', 'pc='+this.player.tsid, 'stack='+stack.tsid, 'count='+stack.count);
    this.auctions_flatten(details, "cancelled");
    details.cancelled = time();
    this.cancelled[uid] = details;
    this.auctions_sync(uid);

    if (destroy_items){
        stack.apiDelete();
    }
    else{
        // give the items back by mail
        this.player.mail.mail_add_auction_delivery(stack.tsid, config.auction_delivery_time, uid, this.player.tsid, 'cancelled');
    }

    return {
        ok: 1
    };
}

public function auctions_expire(uid){

    uid = str(uid);

    //
    // does it exist?
    //

    if (!this.active[uid]){
        return {
            ok: 0,
            error: 'not_found'
        };
    }


    var details = this.active[uid];

    //
    // cancel it
    //

    delete this.active[uid];
    var stack = details.stack;

    this.player.activity_notify({
        type    : 'auction_expire',
        item    : stack.class_tsid,
        qty : stack.count,
        cost    : details.cost
    });

    this.auctions_flatten(details, "expired");
    details.expired = time();
    this.expired[uid] = details;
    this.auctions_sync(uid);

    Server.instance.apiLogAction('AUCTION_EXPIRE', 'pc='+this.player.tsid, 'stack='+stack.tsid, 'count='+stack.count);

    this.player.mail.mail_add_auction_delivery(stack.tsid, config.auction_delivery_time, uid, this.player.tsid, 'expired');

    return {
        ok: 1
    };
}

public function auctions_purchase(uid, buyer, commission, preflight){

    commission = typeof(commission) != 'undefined' ? commission : 0;

    //
    // does this auction exist?
    //

    uid = str(uid);

    var details = this.active[uid];

    if (!details){
        return {
            ok: 0,
            error: 'not_found'
        };
    }


    //
    // is this our own auction?
    //

    if (buyer.tsid == this.player.tsid){

        return {
            ok: 0,
            error: 'is_ours'
        };
    }


    //
    // can the buyer afford it?
    //

    if (!buyer.stats_has_currants(details.cost)){

        return {
            ok: 0,
            error: 'no_cash'
        };
    }


    //
    // does the buyer have space to recieve it?
    //

    if (buyer.isBagFull(details.stack) && !details.stack.has_parent('furniture_base')){

        return {
            ok: 0,
            error: 'no_space'
        };
    }

    if (buyer.mail_count_uncollected_auctions() > 50){
        return {
            ok: 0,
            error: 'mailbox_full'
        };
    }


  //
  // Now that we're done checking for exceptions,
  // decide whether or not to go through with the purchase
  // based on whether we've been asked to preflight the
  // purchase or not
  //

  if(preflight) {
    return {
      ok: 1
    };
  }

    //
    // put it in the activity stream
    //

    // we delete this reference first, so that there's no way
    // we'll try some other action on the auction while we're
    // running the code below. later on we'll re-anchor the
    // details into the 'done' list.
    delete this.active[uid];

    var stack = details.stack;
    this.auctions_flatten(details, "bought");

    this.player.activity_notify({
        type    : 'auction_buy',
        who : buyer.tsid,
        item    : stack.class_tsid,
        qty : stack.count,
        cost    : details.cost
    });


    //
    // log it to the economy sales table
    //

    Utils.http_get('callbacks/auctions_purchased.php', {
        seller_tsid : this.player.tsid,
        buyer_tsid  : buyer.tsid,
        item_class_tsid : stack.class_tsid,
        qty     : stack.count,
        total_price : details.cost
    });


    //
    // let the player know in-game
    //

    var prompt_txt;
    var prompt_count;
    var prompt_items;
    var full_items;
    var purchase_txt = stack.count+'x '+(stack.count>1 ? stack.name_plural : stack.name_single);


    if (num_keys(this.prompts)){
        prompt_count = this.prompts.count+1;
        prompt_items = this.prompts.items;
        prompt_items.push(purchase_txt);
        full_items = prompt_items;
        var extra = 0;

        if (prompt_count > 10){
            extra = prompt_count-10;
            full_items = prompt_items;
            prompt_items = prompt_items.slice(0, 9);
        }
        prompt_txt = prompt_count+' of your auctions were purchased: ';
        var last = num_keys(prompt_items)-1;
        for(var i in prompt_items){
            prompt_txt += prompt_items[i];
            if (i == last-1 && !extra){
                prompt_txt += ' and ';
            } else if (i != last){
                prompt_txt += ', ';
            }
        }
        if (extra) prompt_txt += ' and '+extra+(extra > 1 ? ' others' : ' other');

        prompt_items = full_items;

        this.player.prompts.prompts_remove(this.prompts.uid);
    } else {
        prompt_txt = "Someone bought your auction of "+purchase_txt;
        prompt_items = [ stack.count+"x "+stack.name_plural ];
        prompt_count = 1;
    }

    var prompt_uid = this.player.prompts.prompts_add({
        callback    : 'auctions_sold_callback',
        txt     : prompt_txt,
        timeout     : 0,
        choices     : [
            { label : 'OK', value: 'accept' }
        ]
    });

    this.prompts = {uid: prompt_uid, count: prompt_count, items: prompt_items};

    //
    // resolve
    //

    buyer.mail_add_auction_delivery(stack.tsid, config.auction_delivery_time, uid, this.player.tsid, 'purchased');

    buyer.stats_remove_currants(details.cost, {type: 'auction_buy', class_id: stack.class_tsid, count: stack.count});

    var percentage = (100-commission)/100;

    var proceeds = Math.round(details.cost * ((100-commission)/100));

    var result = this.player.stats.stats_add_currants(proceeds, {type:'auction_buy',class_id: stack.class_tsid, count: stack.count});

    Server.instance.apiLogAction('AUCTION_PURCHASE', 'pc='+this.player.tsid, 'buyer='+buyer.tsid, 'stack='+stack.tsid, 'count='+stack.count, 'currants='+proceeds);

    // Item callback for a sold auction.
    if (stack.onAuctionSold) {
        stack.onAuctionSold(this, buyer);
    }

    details.sold = time();
    details.buyer = buyer;

    this.done[uid] = details;

    this.auctions_sync(uid);

    //
    // quests?
    //

    this.player.quests.quests_inc_counter('auctions_sold_'+details.class_tsid, details.count);

    //
    // spendy achievements
    //

    if (details.cost >= 1009){
        buyer.achievements_grant('big_spender');
    }

    if (details.cost >= 2003){
        buyer.achievements_grant('el_big_spenderino');
    }

    if (details.cost >= 5003){
        buyer.achievements_grant('moneybags_magoo');
    }

    return {
        ok: 1
    };
}

public function auctions_expired_callback(details, choice){
}
public function auctions_sold_callback(details, choice){
    this.prompts = {};
}


// this function removes the stack ref and replace it with flattened data.
// we do this because the stack can be destroyed after its returned to a player.
public function auctions_flatten(details, reason){

    if (!details.stack){

        log.info(time());
        log.info(details);

        throw "trying to flatten a flat auction. was flattened "+details.flat_when+" for reason "+details.flat_reason;
    }

    details.flat_when = time();
    details.flat_reason = reason;
    details.count = details.stack.count;
    details.class_tsid = details.stack.class_tsid;
    delete details.stack;
}

public function auctions_get_uid(){

    var uid = time();

    while (
        this.active[str(uid)] ||
        this.done[str(uid)] ||
        this.cancelled[str(uid)]
    ){
        uid++;
    }

    return str(uid);
}

public function auctions_sync(uid){

    Utils.http_get('callbacks/auctions_update.php', {
        'player_tsid'   : this.player.tsid,
        'auction_uid'   : uid
    });
}

public function auctions_sync_all(){

    Utils.http_get('callbacks/auctions_update.php', {
        'player_tsid'   : this.player.tsid
    });
}

public function auctions_sync_everything(){

    for (var i in this.active  ) this.auctions_sync(i);
    for (var i in this.done    ) this.auctions_sync(i);
    for (var i in this.cancelled   ) this.auctions_sync(i);
    for (var i in this.expired ) this.auctions_sync(i);
}

public function admin_auctions_get(args){

    this.auctions_check_expired();

    var data = null;
    var status = 'not_found';

    if (this.active[args.uid]){

        data = Utils.copy_hash(this.active[args.uid]);
        data.label = data.stack.getLabel ? data.stack.getLabel() : data.stack.label;
        data.count = data.stack.count;
        data.class_tsid = data.stack.class_tsid;
        data.stack_tsid = data.stack.tsid;

        if (data.stack.hasTag('tool') || data.stack.hasTag('potion')){
            data.is_tool = 1;
            if (data.stack.getClassProp('display_wear') == 1){
                data.tool_uses = data.stack.getInstanceProp('points_remaining');
                data.tool_capacity = data.stack.getClassProp('points_capacity');
            }
                data.tool_broken = data.stack.getInstanceProp('is_broken');
        } else if (data.stack.hasTag('powder') && intval(data.stack.getClassProp('maxCharges'))){
            data.is_tool = 1;
            data.tool_uses = data.stack.getInstanceProp('charges');
            data.tool_capacity = data.stack.getClassProp('maxCharges');
        } else if (data.stack.has_parent('furniture_base')) {
            data.is_furniture = 1;
            data.furniture_upgrades = data.stack.getUpgrades(this, true);
            data.furniture_upgrade_id = data.stack.getInstanceProp('upgrade_id');
        }
        delete data.stack;

        status = 'active';
    }

    if (this.cancelled[args.uid]){

        data = Utils.copy_hash(this.cancelled[args.uid]);
        status = 'cancelled';
    }

    if (this.done[args.uid]){

        data = Utils.copy_hash(this.done[args.uid]);
        data.buyer_tsid = data.buyer.tsid;
        delete data.buyer;

        status = 'done';
    }

    if (this.expired[args.uid]){

        data = Utils.copy_hash(this.expired[args.uid]);
        status = 'expired';
    }


    if (status == 'not_found'){

        return {
            ok  : 0,
            error   : 'not_found'
        };

    }else{
        return {
            ok  : 1,
            status  : status,
            data    : data
        };
    }
}

public function admin_auctions_get_all(){

    return { ok : 1,
         active   : this.active,
         done     : this.done,
         cancelled: this.cancelled,
         expired  : this.expired
        };
}

public function admin_auctions_relist_broken(args){
    //
    // do we own this stack?
    //

    var stack = Server.instance.apiFindObject(args.stack_tsid);

    if (!stack){
        return {
            ok: 0,
            error: 'no_stack'
        };
    }

    if (!stack.isHidden){
        return {
            ok: 0,
            error: 'not_hidden'
        };
    }

    for (var i in this.active){
        if (this.active[i].stack.tsid == args.stack_tsid){
            return {
                ok: 0,
                error: 'already_listed'
            };
        }
    }

    var temp = stack.apiGetLocatableContainerOrSelf();
    if (temp.tsid != this.player.tsid){

        return {
            ok: 0,
            error: 'not_yours'
        };
    }

    //
    // temporarily pop the stack back into existence
    //

    if (this.player.bag.isBagFull(stack) && !stack.has_parent('furniture_base')){

        return {
            ok: 0,
            error: 'bags_full'
        };
    }

    this.player.bag.addItemStack(stack);

    this.auctions_start(stack, args.count, args.cost, 0, 0);
}

public function admin_auctions_private_bag_items(){
    var cont = this.auctions_find_container();

    return cont.hiddenItems;
}

public function admin_auctions_return_expired_item(args){
    this.player.mail.mail_add_auction_delivery(args.tsid, 0, args.uid, this.player.tsid, 'expired');
    return 1;
}

public function admin_auctions_start(args){

    if (this.player.isInTimeout()){
        return {
            ok: 0,
            error: 'account_suspended'
        };
    }

    if (!args.cost || args.cost < 1){
        return {
            ok: 0,
            error: 'no_cost'
        };
    }

    var stack = Server.instance.apiFindObject(args.stack_tsid);

    if (!stack){
        return {
            ok: 0,
            error: 'no_stack'
        };
    }

    if (stack.hasTag('no_auction') || stack.hasTag('bag')){
        return {
            ok: 0,
            error: 'not_allowed'
        };
    }

    if (stack.isSoulbound()){
        return {
            ok: 0,
            error: 'not_allowed'
        };
    }

    if (!args.fee_min){
        args.fee_min = 0;
    }

    if (!args.fee_percent){
        args.fee_percent = 0;
    }

    return this.auctions_start(stack, args.count, args.cost, args.fee_percent, args.fee_min);
}

public function admin_auctions_purchase(args){

    var buyer = Server.instance.apiFindObject(args.buyer_tsid);

    if (!buyer){
        return {
            ok: 0,
            error: 'no_buyer'
        };
    }

    if (!args.commission){
        args.commission = 0;
    }

    return this.auctions_purchase(args.uid, buyer, args.commission, args.preflight);
}

public function admin_auctions_expire(args){
    return this.auctions_expire(args.uid);
}

public function admin_auctions_cancel(args){

    return this.auctions_cancel(args.uid);
}

public function admin_auctions_clear_from_history(args){
    if (this.cancelled[args.uid]){
        delete this.cancelled[args.uid];
    }
    if (this.expired[args.uid]){
        delete this.expired[args.uid];
    }
    if (this.done[args.uid]){
        delete this.done[args.uid];
    }
}

public function auctions_check_expired(){

    for (var i in this.active){

        if (this.active[i].expires < time()){
            this.auctions_expire(i);
        }
    }
}

    }
}
