package com.tinyspeck.engine.view.gameoverlay {
	import com.tinyspeck.tstweener.TSTweener;
	
	import com.tinyspeck.core.beacon.StageBeacon;
	import com.tinyspeck.engine.control.TSFrontController;
	import com.tinyspeck.engine.model.TSModelLocator;
	import com.tinyspeck.engine.port.AssetManager;
	import com.tinyspeck.engine.port.IMoveListener;
	import com.tinyspeck.engine.view.AbstractTSView;
	import com.tinyspeck.engine.view.IFocusableComponent;
	import com.tinyspeck.engine.view.ui.chat.InputField;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class UnFocusedScreenView extends AbstractTSView implements IMoveListener {
		
		/* singleton boilerplate */
		public static var _instance:UnFocusedScreenView = null;
        public static function get instance() : UnFocusedScreenView {
            if (_instance == null) {
                _instance = new UnFocusedScreenView();
            }
            return _instance;
        }
		
		private var model:TSModelLocator;
		
		public var opacity:Number = 0;
		
		private var focused_comp:IFocusableComponent;
		private var target_swf:MovieClip;
		private var target_bm:Bitmap;
		private var target_bm_container:Sprite = new Sprite();
		private var container:Sprite = new Sprite();
		
		private var no_go:Boolean = true;/*!CONFIG::god*/
		
		public function UnFocusedScreenView() {
			CONFIG::god {
				if(_instance) throw new Error('Singleton');
			}
			
			if (no_go) return;
			
			model = TSModelLocator.instance;
			
			buttonMode = false;
			useHandCursor = false;
			mouseEnabled = false;
			mouseChildren = true;
			
			container.visible = false;
			container.mouseEnabled = true;
			container.mouseChildren = false;
			container.buttonMode = true;
			container.useHandCursor = true;
			addChild(container);

			visible = false;
			
			TSFrontController.instance.registerMoveListener(this);
			StageBeacon.flash_focus_changed_sig.add(onStageFocusChange);
			onStageFocusChange(StageBeacon.flash_has_focus);
			
			//var target_str:String = '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';
			//var target_str:String = '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';
			var target_str:String = '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';
			AssetManager.instance.loadBitmapFromBASE64('focus_target', target_str, onBASE64targetLoaded);
			target_swf = new (AssetManager.instance.assets.focus_off)();
			container.addChild(target_swf);
			container.addChild(target_bm_container);
			target_bm_container.visible = false;
			//refresh();
			
			container.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			container.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
		}
		
		// IMoveListener funcs
		// -----------------------------------------------------------------
		
		public function moveLocationHasChanged():void {
		
		}
		
		public function moveLocationAssetsAreReady():void {
		
		}
		
		public function moveMoveStarted():void {
			container.visible = false;
		}
		
		public function moveMoveEnded():void {
			container.visible = true;
		}
		
		// -----------------------------------------------------------------
		// END IMoveListener funcs
		
		public function setRollover(gameRenderer:DisplayObject):void {
			gameRenderer.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			gameRenderer.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
		
		private function onRollOver(e:MouseEvent):void {
			target_bm_container.visible = true;
		}
		
		private function onRollOut(e:MouseEvent):void {
			target_bm_container.visible = false;
		}
		
		private function onBASE64targetLoaded(key:String, bm:Bitmap):void {
			target_bm = bm;
			target_bm_container.addChild(target_bm);
			target_swf.x = Math.round((target_bm.width-target_swf.width)/2);
			target_bm.y = target_swf.height;
			refresh();
		}
		
		public function focusChanged(focused_comp:IFocusableComponent, was_focused_comp:IFocusableComponent):void {
			if (no_go) return;
			this.focused_comp = focused_comp;
			showHide();
		}
		
		public function onStageFocusChange(value:Boolean):void {
			if (no_go) return;
			showHide();
		}
		
		private function showHide(go:Boolean=false):void {
			if (no_go) return;
			var in_chat:Boolean;
			
			if (focused_comp && focused_comp is InputField && InputField(focused_comp).is_for_chat) {
				in_chat = true;
			}
			
			if (StageBeacon.flash_has_focus && !in_chat) {
				// this trickiness allows a click on the container to not register as a click in the location
				// (if we immediately hide(), then this view is hidden before the mousedown/mouseup/click happens, and the click goes through to the location)
				if (go) {
					hide();
				} else {
					StageBeacon.waitForNextFrame(showHide, true);
				}
			} else {
				//show('')
				show()
				target_bm_container.visible = !StageBeacon.flash_has_focus; // make it visible if flash does not have focus
			}
		}
		
		public function refresh():void {
			if (no_go) return;
			_draw();
			
			container.x = Math.round((model.layoutModel.loc_vp_w-container.width)/2);//model.layoutModel.gutter_w + Math.round((model.layoutModel.loc_vp_w-10-container.width));
			container.y = model.layoutModel.loc_vp_h-10-container.height;
		}
		
		public function hide():void {
			if (no_go) return;
			TSTweener.removeTweens(container);
			visible = false;
		}
		
		public function show():void {
			if (no_go) return;
			if (model.stateModel.editing) return;
			if (model.netModel.disconnected_msg) return;
			// this is stupid and I am not sure why it was here. it fucks up things when focussing on inputFields
			//if (visible) StageBeacon.stage.focus = StageBeacon.stage;
			refresh();
			visible = true;
			pulse();
		}
		
		private function pulse():void {
			TSTweener.removeTweens(container);
			var a:Number = container.alpha > .5 ? .4 : .6;
			TSTweener.addTween(container, {alpha:a, time:1, transition:'easeInOutSine', onComplete:pulse});
		}
		
		protected function _draw():void {
			var g:Graphics = graphics;
			g.clear();
			g.lineStyle(0, 0x000000, 0);
			g.beginFill(0x000000, opacity);
			g.drawRect(0, 0, model.layoutModel.loc_vp_w, model.layoutModel.loc_vp_w);
		}
	}
}
