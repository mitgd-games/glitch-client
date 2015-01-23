package com.tinyspeck.engine.view.gameoverlay
{
	import com.tinyspeck.engine.model.LayoutModel;
	import com.tinyspeck.engine.model.TSModelLocator;
	import com.tinyspeck.tstweener.TSTweener;
	
	import flash.display.Sprite;

	public class FlashBulbView extends Sprite {
		
		/* singleton boilerplate */
		public static var _instance:FlashBulbView = null;
        public static function get instance() : FlashBulbView {
            if (_instance == null) {
                _instance = new FlashBulbView();
            }
            return _instance;
        }
		
		public function FlashBulbView(){
			CONFIG::god {
				if(_instance) throw new Error('Singleton');
			}
			visible = false;
		}
		
		/** Flashbulb! */
		public function flash(onComplete:Function=null, ...args):void {
			visible = true;
			refresh();
			
			alpha = 0;
			const self:FlashBulbView = this;
			TSTweener.addTween(this, {alpha:1, time:0.3, transition:'easeInExpo'});
			TSTweener.addTween(this, {alpha:0, time:0.75, delay:.45, transition:'easeOutExpo',
				onComplete:function():void {
					self.visible = false;
					if(onComplete != null) {
						onComplete.apply(null, args);
					}
				}
			});
		}
		
		public function refresh():void {
			if (visible) {
				const lm:LayoutModel = TSModelLocator.instance.layoutModel;
				graphics.clear();
				graphics.beginFill(0xFFFFFF);
				graphics.drawRect(0, 0, lm.loc_vp_w, lm.loc_vp_h);
				graphics.endFill();
			}
		}
	}
}