package com.reversefold.glitch.server.player {
    import com.reversefold.glitch.server.data.Config;
    import com.reversefold.glitch.server.player.Player;

    import org.osmf.logging.Log;
    import org.osmf.logging.Logger;

    public class DailyHistory {
        private static var log : Logger = Log.getLogger("server.Player");

        public var config : Config;
        public var player : Player;
        public var skills;

        public function DailyHistory(config : Config, player : Player) {
            this.config = config;
            this.player = player;
            daily_history_init();
        }


public function daily_history_init(){
    if (this.daily_history === undefined || this.daily_history === null){
        this.daily_history = apiNewOwnedDC(this);
        this.daily_history.label = 'Daily History';
        this.daily_history.days = {};
    }
}

public function daily_history_reset(){
    if (this.daily_history){
        //delete this.daily_history.days;
        //this.daily_history.apiDelete();
        //delete this.daily_history;

        this.daily_history.days = {};
    }

    this.daily_history_init();
}

public function daily_history_get_day(day_key){
    this.daily_history_init();
    if (!this.daily_history.days[day_key]) return null;

    return this.daily_history.days[day_key];
}

public function daily_history_get(day_key, label){
    this.daily_history_init();
    if (!this.daily_history.days[day_key]) return null;
    if (!this.daily_history.days[day_key][label]) return null;

    return this.daily_history.days[day_key][label];
}

public function daily_history_increment(label, value){
    this.daily_history_init();
    var today = current_day_key();
    if (!this.daily_history.days[today]) this.daily_history.days[today] = {};

    if (!this.daily_history.days[today][label]) this.daily_history.days[today][label] = 0;

    this.daily_history.days[today][label] += value;
}

public function daily_history_push(label, value){
    this.daily_history_init();
    var today = current_day_key();
    if (!this.daily_history.days[today]) this.daily_history.days[today] = {};

    if (!this.daily_history.days[today][label]) this.daily_history.days[today][label] = [];

    this.daily_history.days[today][label].push(value);
    this.daily_history.utime = time();
}

public function daily_history_flag(label){
    this.daily_history_init();
    var today = current_day_key();
    if (!this.daily_history.days[today]) this.daily_history.days[today] = {};

    this.daily_history.days[today][label] = true;
}

public function daily_history_archive(day_key){
    this.daily_history_init();

    if (!this.daily_history.days[day_key]) return;

    var args = {
        player_tsid: this.tsid,
        day_key: day_key,
        data: utils.JSON_stringify(this.daily_history.days[day_key])
    };

    utils.http_post('callbacks/daily_history_archive.php', args, this.tsid);
}

public function daily_history_archive_all(){
    this.daily_history_init();

    for (var day_key in this.daily_history.days){
        this.daily_history_archive(day_key);
    }
}

    }
}
