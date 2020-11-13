package {
	
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.display.Sprite;

	public class GrowingChess extends Sprite {
		
		private var _txtInfo:TextField = new TextField();
		public var levelSelectScreen:LevelSelectScreen = null;
		public var mainScreen:MainScreen = null;
		public var _backGround:Sprite = new Sprite();
		
		public var arrowDown:Sprite = new GameResources.ArrowDown();
		public var arrowUp:Sprite = new GameResources.ArrowUp();
		public var arrowLeft:Sprite = new GameResources.ArrowLeft();
		public var arrowRight:Sprite = new GameResources.ArrowRight();
		
		public var arrowDownRight:Sprite = new GameResources.ArrowDownRight();
		public var arrowDownLeft:Sprite = new GameResources.ArrowDownLeft();
		public var arrowUpRight:Sprite = new GameResources.ArrowUpRight();
		public var arrowUpLeft:Sprite = new GameResources.ArrowUpLeft();
		
		public var clickPieceInstruction:Sprite = new GameResources.ClickPiece();
		public var clickMoveInstruction:Sprite = new GameResources.ClickMove();
		public var takeFlagHint:Sprite = new GameResources.TakeFlagHint();
		public var newPiece:Sprite = new GameResources.NewPiece();
		public var boardGrew:Sprite = new GameResources.BoardGrew();
		public var boardLayer:MovieClip = new MovieClip();
		public var movementControl:MovementDisplayControl = new MovementDisplayControl();
		public var currentLevel:TextField = new TextField();
		public var difficultyBeatScreeen:DifficultyBeatScreen;
		
		public function GrowingChess():void {
			GameLogic.LoadState();
									
			_backGround.alpha = 0.1;
			drawEasyBackground();
			addChild( _backGround );
			
			addChild( boardLayer );
			
			GameData.UserId = GUID.create();
			Utility.LogAction( "User Connected" );

			addChild( arrowDown );
			addChild( arrowUp );
			addChild( arrowLeft );
			addChild( arrowRight );
			
			addChild( arrowDownRight );
			addChild( arrowDownLeft );
			addChild( arrowUpRight );
			addChild( arrowUpLeft );
						
			GameData.Document = this;
			
			clickPieceInstruction.x = 250;
			clickPieceInstruction.y = 50;
			clickPieceInstruction.width = 200;
			clickPieceInstruction.height = 400;
			clickPieceInstruction.mouseEnabled = false;
			clickPieceInstruction.visible = false;
			if ( GameData.SawSelectHelp == false ) {
				clickPieceInstruction.visible = true;
				GameData.SawSelectHelp = true;
			}
			addChild( clickPieceInstruction );
			
			clickMoveInstruction.x = 35;
			clickMoveInstruction.y = 100;
			clickMoveInstruction.width = 400;
			clickMoveInstruction.height = 200;
			clickMoveInstruction.visible = false;
			clickMoveInstruction.mouseEnabled = false;
			addChild( clickMoveInstruction );
			
			takeFlagHint.x = 90;
			takeFlagHint.y = -40 + 200;
			takeFlagHint.width = 200;
			takeFlagHint.height = 400;
			takeFlagHint.visible = false;
			takeFlagHint.mouseEnabled = false;
			addChild( takeFlagHint );
			
			newPiece.visible = false;
			newPiece.mouseEnabled = false;
			newPiece.width = 200;
			newPiece.height = 200;
			addChild( newPiece );
			
			boardGrew.visible = false;
			boardGrew.mouseEnabled = false;
			boardGrew.x = width / 2 - 100;
			boardGrew.y = height / 2 - 100;
			boardGrew.width = 200;
			boardGrew.height = 200;
			addChild( boardGrew );
			
			if ( GameData.GetDiff() == GameData.EASY ) {
				drawEasyBackground();
			}
			else if ( GameData.GetDiff() == GameData.MED ) {
				drawMediumBackground();
			}
			else {
				drawHardBackground();
			}
			
			_txtInfo.text = "";
			_txtInfo.x = 400;
			_txtInfo.y = 0;
			_txtInfo.width = 400;
			addChild( _txtInfo );
			
			currentLevel.x = 400;
			currentLevel.scaleY = 4.5;
			currentLevel.width = 400;
			addChild( currentLevel );
			
			var btn:Sprite = new GameResources.BtnLevelSelect();
			btn.x = 415;
			btn.y = 130;
			btn.buttonMode = true;
			btn.height = 75;
			btn.width = 150;
			addChild( btn );
			
			movementControl.x = 400;
			movementControl.y = 225;
			movementControl.width = 150;
			movementControl.height = 150;
			addChild( movementControl );
			
			//var btn:But
//			var gameButton:GameButton = new GameButton( 
//				new GameResources.Button_Test_Norm(), 
//				new GameResources.Button_Test_Over(),
//				new GameResources.Button_Test_Press(),
//				400,
//				300,
//				_onClickButtonTest );
//			addChild( gameButton );
			
			levelSelectScreen = new LevelSelectScreen( this );
			btn.addEventListener( MouseEvent.CLICK , _onMenuScreenClick );
			
			GameData.GlbGameOverScreen = new GameOverScreen( this );
			mainScreen = new MainScreen( this );
			mainScreen.show();
			
			difficultyBeatScreeen = new DifficultyBeatScreen( this );
		}
		
		public function drawEasyBackground():void {
			trace( "drawEasyBackground" );
			_backGround.graphics.clear();
			_backGround.graphics.beginFill( 0xFFFFFF );
			_backGround.graphics.drawRect(0, 0, width, height);
		}
		
		public function drawMediumBackground():void {
			_backGround.graphics.clear();
			_backGround.graphics.beginFill( 0x00FF00 );
			_backGround.graphics.drawRect(0, 0, width, height);
		}
		
		public function drawHardBackground():void {
			_backGround.graphics.clear();
			_backGround.graphics.beginFill( 0xFF0000 );
			_backGround.graphics.drawRect(0, 0, width, height);
		}
		
		private function _onMenuScreenClick( me:MouseEvent ):void {
			Utility.LogAction( "_onMenuScreenClick" );
			levelSelectScreen.show();
		}
	}
}
