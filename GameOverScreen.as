package {
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class GameOverScreen {
		
		private var _parent:Sprite;
		private var _screen:MovieClip = new MovieClip();
		private var _msg:TextField = new TextField();
		private var _buttonClickCmd:Function;
		private var _nxtLvlButton:Sprite = new GameResources.Button_Next_Level();
		private var _replayLvlButton:Sprite = new GameResources.BtnReplay();
		
		public function GameOverScreen( parent:Sprite ):void {
			_parent = parent;
			
			const x:Number = 150;
			const y:Number = 100;
			
			var clearBackground:Sprite = new Sprite();
			clearBackground.graphics.beginFill( 0x000000, 0.2 );
			clearBackground.graphics.drawRect( 0, 0, GameData.Document.width, GameData.Document.height );
			_screen.addChild( clearBackground );
			
			var spr:Sprite = new Sprite();
			spr.graphics.beginFill( 0x00ff00, 1.0 );
			spr.graphics.drawRect( x, y, 300, 200 );
			_screen.addChild( spr );

			_msg.x = 0 + x;
			_msg.y = 50 + y;
			_msg.width = 300;
			_msg.mouseEnabled = false;
			_screen.addChild( _msg );
			
			const buttonX:Number = 150;
			const buttonY:Number = 100;
			const buttonWidth:Number = 100;
			const buttonHeight:Number = 100;
			
			_nxtLvlButton.x = buttonX + x;
			_nxtLvlButton.y = buttonY + y;
			_nxtLvlButton.width = buttonWidth;
			_nxtLvlButton.height = buttonHeight;
			_nxtLvlButton.addEventListener( MouseEvent.CLICK, _onButtonClick );
			_nxtLvlButton.buttonMode = true;
			_screen.addChild( _nxtLvlButton );
			
			_replayLvlButton.x = buttonX + x;
			_replayLvlButton.y = buttonY + y;
			_replayLvlButton.width = buttonWidth;
			_replayLvlButton.height = buttonHeight;
			_replayLvlButton.addEventListener( MouseEvent.CLICK, _onButtonClick );
			_replayLvlButton.buttonMode = true;
			_screen.addChild( _replayLvlButton );
		}
		
		private function _onButtonClick( me:MouseEvent ):void {
			hide();
			_buttonClickCmd();
		}
		
		public function show( msg:String, buttonClickCmd:Function, victory:Boolean ):void {
			if( _parent.contains( _screen ) )
				return;
				
			if( victory ) {
				_nxtLvlButton.visible = true;
				_replayLvlButton.visible = false;
			}
			else {
				_nxtLvlButton.visible = false;
				_replayLvlButton.visible = true;
			}
				
			_buttonClickCmd = buttonClickCmd;
				
			_msg.text = msg;
			_parent.addChild( _screen );
		}
		
		public function hide():void {
			if( !_parent.contains( _screen ) )
				return;
				
			_parent.removeChild( _screen );
		}
	}
}
