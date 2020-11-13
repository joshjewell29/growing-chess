package {
	
	import flash.utils.Dictionary;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	
	public class LevelSelectScreen {
		
		private var _parent:Sprite;
		private var _screen:MovieClip = new MovieClip();
		private var _buttons:Dictionary = new Dictionary();
		private var _backGround:Sprite = new Sprite();
		private var _easy:Sprite = new GameResources.BtnEasyLevelSelect();
		private var _med:Sprite = new GameResources.BtnMediumLevelSelect();
		private var _hard:Sprite = new GameResources.BtnHardLevelSelect();
		private var _mainMenu:Sprite = new GameResources.BtnMainMenu();
		
		public function LevelSelectScreen( parent:Sprite ):void {
			_parent = parent;
			
			_backGround.graphics.beginFill( 0xFFFFFF );
			_backGround.graphics.drawRect( 0, 0, GameData.Document.width, GameData.Document.height );
			_screen.addChild( _backGround );

			const buttonSize:Number = 75;
			const fillerSpace:Number = 10;
			const count:uint = 4;
			const offsetX:Number = 20;
			const offsetY:Number = 20;
			
			for( var x:int = 0 ; x < count ; x++ ) {
				for( var y:int = 0 ; y < count ; y++ ) {
					var levelIndex:uint = ( x ) + ( y * count );
					if ( levelIndex >= Constants.LEVEL_COUNT )
						continue;
						
					var btnImage:Sprite = new GameResources.Level_Button();
					var lvlButton:LevelButton = new LevelButton( btnImage );
					lvlButton.x = offsetX + x * buttonSize + fillerSpace*x;
					lvlButton.y = offsetY + y * buttonSize + fillerSpace*y;
					
					lvlButton.width = buttonSize;
					lvlButton.height = buttonSize;
					
					lvlButton.level = levelIndex;
					lvlButton.addEventListener( MouseEvent.CLICK, _onClick );
					
					_screen.addChild( lvlButton );
					_buttons[levelIndex] = lvlButton;
				}
			}
			
			_easy.x = 400;
			_easy.y = 0;
			_easy.width = 100;
			_easy.height = 50;
			_easy.buttonMode = true;
			_easy.addEventListener( MouseEvent.CLICK, _onClickEasy );
			_screen.addChild( _easy );
			
			_med.x = 400;
			_med.y = 75;
			_med.width = 100;
			_med.height = 50;
			_med.alpha = 0.5;
			_med.buttonMode = false;
			_med.mouseEnabled = false;
			_med.addEventListener( MouseEvent.CLICK, _onClickMedium );
			_screen.addChild( _med );
			
			_hard.x = 400;
			_hard.y = 150;
			_hard.width = 100;
			_hard.height = 50;
			_hard.alpha = 0.5;
			_hard.buttonMode = false;
			_hard.mouseEnabled = false;
			_hard.addEventListener( MouseEvent.CLICK, _onClickHard );
			_screen.addChild( _hard );
			
			_mainMenu.x = 400;
			_mainMenu.y = 300;
			_mainMenu.width = 100;
			_mainMenu.height = 50;
			_mainMenu.addEventListener( MouseEvent.CLICK, _onClickMainMenu );
			_screen.addChild( _mainMenu );
			
			show();
		}
		
		private function _onClickMainMenu( me:MouseEvent ):void {
			GameData.Document.mainScreen.show();
			hide();
			Utility.LogAction( "_onClickEasy" );
		}
		
		private function _onClickEasy( me:MouseEvent ):void {
			_drawEasy();
			
			GameData.SetDiff( GameData.EASY );
			_updateLevelButtons();
			Utility.LogAction( "_onClickEasy" );
			GameData.Document.drawEasyBackground();
			GameLogic.SaveState();
		}
		
		private function _onClickMedium( me:MouseEvent ):void {
			_drawMedium();
			
			GameData.SetDiff( GameData.MED );
			_updateLevelButtons();
			Utility.LogAction( "_onClickMedium" );
			GameData.Document.drawMediumBackground();
			GameLogic.SaveState();
		}
		
		private function _onClickHard( me:MouseEvent ):void {
			_drawHard();
			
			GameData.SetDiff( GameData.HARD );
			_updateLevelButtons();
			Utility.LogAction( "_onClickHard" );
			GameData.Document.drawHardBackground();
			GameLogic.SaveState();
		}
		
		private function _drawEasy():void {
			_backGround.graphics.clear();
			_backGround.graphics.beginFill( 0xFFFFFF );
			_backGround.graphics.drawRect( 0, 0, GameData.Document.width, GameData.Document.height );
		}
		
		private function _drawMedium():void {
			_backGround.graphics.clear();
			_backGround.graphics.beginFill( 0x00FF00 );
			_backGround.graphics.drawRect( 0, 0, GameData.Document.width, GameData.Document.height );
		}
		
		private function _drawHard():void {
			_backGround.graphics.clear();
			_backGround.graphics.beginFill( 0xFF0000 );
			_backGround.graphics.drawRect( 0, 0, GameData.Document.width, GameData.Document.height );
		}
		
		private function _onClick( me:MouseEvent ):void {
			var lvlButton:LevelButton = LevelButton( me.currentTarget );
			
			if( !lvlButton.mouseEnabled )
				return;
				
			var indexOfLevelToPlay:uint = lvlButton.level;
			
			Utility.LogAction( "select level" + indexOfLevelToPlay );

			GameData.GlbLevels.setCurrentLevel( indexOfLevelToPlay );
			GameStateMachine.ChangeLevel();
			hide();
		}
		
		public function show():void {
			if( _parent.contains( _screen ) )
				return;

			if ( GameData.GetDiff() == GameData.EASY )
				_drawEasy();
			else if ( GameData.GetDiff() == GameData.MED )
				_drawMedium();
			else
				_drawHard();

			if ( GameData.MediumUnlocked ) {
				_med.alpha = 1.0;
				_med.buttonMode = true;
				_med.mouseEnabled = true;
			}

			if ( GameData.HardUnlocked ) {
				_hard.alpha = 1.0;
				_hard.buttonMode = true;
				_hard.mouseEnabled = true;
			}

			_updateLevelButtons();
				
			_parent.addChild( _screen );
		}
		
		private function _updateLevelButtons():void {
			var levelsUnlocked:uint = GameData.MaxLevelUnlocked;
			if ( GameData.GetDiff() == GameData.MED ) {
				levelsUnlocked = GameData.MaxLevelUnlockedMedium;
			}
			else if( GameData.GetDiff() == GameData.HARD ) {
				levelsUnlocked = GameData.MaxLevelUnlockedHard;
			}
			
			//Disable All
			for each( var lb:LevelButton in _buttons ) {
				lb.alpha = 0.3;
				lb.mouseEnabled = false;
				lb.buttonMode = false;
			}
			
			//Enable Unlocked
			for ( var i:uint = 0 ; i <= levelsUnlocked ; i++ ) {
				var btn:LevelButton = _buttons[i];
				btn.alpha = 1.0;
				btn.mouseEnabled = true;
				btn.buttonMode = true;
			}
		}
		
		public function hide():void {
			if( !_parent.contains( _screen ) )
				return;
				
			_parent.removeChild( _screen );
		}
	}
}
