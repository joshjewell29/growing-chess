package {
	
	import flash.events.MouseEvent;
	import flash.display.Sprite;

	public class GameButton extends Sprite {
		
		private var _onClickCallBack:Function;
		private var _customSimpleButton:CustomSimpleButton;
		
		public function GameButton( 
			defaultImage:Sprite,
			onMouseOverImage:Sprite,
			onPressImage:Sprite,
			x:Number,
			y:Number,
			onClick:Function ):void {
				
			defaultImage = new GameResources.Button_Test_Norm();
			_customSimpleButton = new CustomSimpleButton( defaultImage, onMouseOverImage, onPressImage );
            addChild( _customSimpleButton );
				
			this.x = x;
			this.y = y;
			this.width = 100;
			this.height = 100;
			buttonMode = true;
			_onClickCallBack = onClick;
			addEventListener( MouseEvent.CLICK, _onClick );
		}
		
		private function _onClick( me:MouseEvent ):void {
			_onClickCallBack();
		}
	}
}

import flash.display.Sprite;
import flash.display.SimpleButton;

class CustomSimpleButton extends SimpleButton {

    public function CustomSimpleButton( defaultImage:Sprite, onMouseOverImage:Sprite, onPressImage:Sprite ) {
        downState      = onPressImage;
        overState      = onMouseOverImage;
        upState        = defaultImage;
        hitTestState   = defaultImage;
        
        useHandCursor  = true;
    }
}