package com.reversefold.glitch.server.player {
    import com.reversefold.glitch.server.Common;
    import com.reversefold.glitch.server.data.Config;
    import com.reversefold.glitch.server.player.Player;

    import org.osmf.logging.Log;
    import org.osmf.logging.Logger;

    public class Towers extends Common {
        private static var log : Logger = Log.getLogger("server.player.Towers");

        public var config : Config;
        public var player : Player;

        public function Towers(config : Config, player : Player) {
            this.config = config;
            this.player = player;
        }


public function getTestTower(){

    // we must already have a house for this to work
    if (!this.player.houses.home || !this.player.houses.home.exterior) return null;

    if (this.tower_tsid){

        var tower = Server.instance.apiFindObject(this.tower_tsid);
        delete this.tower_tsid;
        this.player.houses.home.tower = tower;
        this.player.houses.home.exterior.homes_position_tower(tower, 48, -97);
    }

    if (!this.player.houses.home.tower){

        var tower = Server.instance.apiNewLocation("Test Tower", config.is_prod ? '15' : '28', 'POL_'+this.player.tsid, 'tower');
        tower.tower_create(this);
        this.player.houses.home.tower = tower;
        this.player.houses.home.exterior.homes_position_tower(tower, 48, -97);
    }

    this.player.houses.home.tower.tower_set_label(this.label+"'s Tower");

    return this.player.houses.home.tower;
}

public function getTower(){
    if (!this.player.houses.home || !this.player.houses.home.exterior) return null;

    return this.player.houses.home.tower;
}

public function visitTower(){
    var tower = this.getTestTower();
    tower.tower_rebuild();
    var pos = tower.tower_get_teleport_point();
    this.player.teleportToLocationDelayed(tower.tsid, pos[0], pos[1]);
}

public function rebuildTower(){
    var tower = this.getTestTower();
    if (this.player.location.tsid == tower.tsid) tower.tower_rebuild();
}

public function setTowerFloors(num){
    var tower = this.getTestTower();
    if (this.player.location.tsid == tower.tsid) tower.tower_set_floors(num);
}

public function resetTower(){
    var tower = this.getTestTower();
    if (this.player.location.tsid == tower.tsid) tower.tower_reset();
}

public function removeTower(){
    if (!this.player.houses.home) return;

    if (this.player.houses.home.exterior){
        var chassis = this.player.houses.home.exterior.homes_get_tower_chassis();
        if (chassis){
            for (var i in this.player.houses.home.exterior.geometry.layers.middleground.doors){
                var d = this.player.houses.home.exterior.geometry.layers.middleground.doors[i];
                if (d.itemstack_tsid == chassis.tsid){
                    delete this.player.houses.home.exterior.geometry.layers.middleground.doors[i];
                    this.player.houses.home.exterior.apiGeometryUpdated();
                    break;
                }
            }

            chassis.apiDelete();
            this.player.houses.home.exterior.upgrades_move_players('misc');
        }
    }

    if (this.player.houses.home.tower) this.player.houses.home.tower.tower_delete();

    delete this.player.houses.home.tower;
    delete this.tower_tsid;
}

    }
}
