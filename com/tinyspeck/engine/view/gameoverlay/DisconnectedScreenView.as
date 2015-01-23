package com.tinyspeck.engine.view.gameoverlay {
	import com.tinyspeck.core.beacon.StageBeacon;
	import com.tinyspeck.engine.control.TSFrontController;
	import com.tinyspeck.engine.filters.ColorMatrix;
	import com.tinyspeck.engine.model.TSModelLocator;
	import com.tinyspeck.engine.port.CSSManager;
	import com.tinyspeck.engine.view.AbstractTSView;
	import com.tinyspeck.engine.view.util.StaticFilters;
	import com.tinyspeck.tstweener.TSTweener;
	
	import flash.display.Graphics;
	import flash.text.TextField;
	
	public class DisconnectedScreenView extends AbstractTSView {
		
		/* singleton boilerplate */
		public static var _instance:DisconnectedScreenView = null;
        public static function get instance() : DisconnectedScreenView {
            if (_instance == null) {
                _instance = new DisconnectedScreenView();
            }
            return _instance;
        }
		
		private static var _BW_FILTER_ARRAY:Array = null;
		private static function get BW_FILTER_ARRAY() : Array {
			if (_BW_FILTER_ARRAY == null) {
				_BW_FILTER_ARRAY = [ColorMatrix.getFilter(0, 0, -100)];
			}
			return _BW_FILTER_ARRAY;
		}
		
		private var model:TSModelLocator;
		
		private const _tf:TextField = new TextField();
		private var _opacity:Number = .6;
		
		public function DisconnectedScreenView() {
			CONFIG::god {
				if(_instance) throw new Error('Singleton');
			}
			
			model = TSModelLocator.instance;
			
			buttonMode = false;
			useHandCursor = false;
			mouseEnabled = true;
			mouseChildren = true;
			
			_tf.styleSheet = CSSManager.instance.styleSheet;
			_tf.selectable = false;
			_tf.multiline = true;
			_tf.wordWrap = true;
			_tf.width = 700;
			_tf.filters = StaticFilters.disconnectScreen_GlowA;
			addChild(_tf);

			visible = false;
		}
		
		public function refresh():void {
			_draw();
			_tf.x = Math.round((StageBeacon.stage.stageWidth-_tf.width)/2);
			_tf.y = Math.round((StageBeacon.stage.stageHeight-_tf.height)/2)-100;
		}
		
		public function hide():void {
			TSTweener.removeTweens(this);
			visible = false;
			StageBeacon.game_parent.filters = [];
		}
		
		public function show(msg:String, delay_secs:int):void {
			mouseChildren = mouseEnabled = false;
			_tf.htmlText = '<p class="disconnected_screen">'+msg+'</p>';
			_tf.height = _tf.textHeight+6;
			if (visible) StageBeacon.stage.focus = StageBeacon.stage;
			refresh();
			visible = true;
			TSTweener.removeTweens(this);
			if (delay_secs == 0) {
				alpha = 1;
				mouseChildren = mouseEnabled = true;
				StageBeacon.game_parent.filters = BW_FILTER_ARRAY;
			} else {
				alpha = 0;
				TSTweener.addTween(this, {alpha:1, time:.3, transition:'linear', delay:delay_secs, onComplete:afterTween});
			}
			UnFocusedScreenView.instance.hide();
			TSFrontController.instance.addUnderCursor(this);
		}
		
		private function afterTween():void {
			DisconnectedScreenView.instance.mouseChildren = DisconnectedScreenView.instance.mouseEnabled = true;
			StageBeacon.game_parent.filters = BW_FILTER_ARRAY;
		}
		
		protected function _draw():void {
			var g:Graphics = graphics;
			g.clear();
			g.lineStyle(0, 0x000000, 0);
			g.beginFill(0x000000, _opacity);
			g.drawRect(0, 0, StageBeacon.stage.stageWidth, StageBeacon.stage.stageHeight);
		}
	}
}
