package {
	
	import flash.net.SharedObject;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class GameLogic {
		
		public static function ColorPossibleMoves( p:Piece, level:Level ):void {
			for ( var x:uint = 0 ; x < level.tilesX ; x++ ) {
				for ( var y:uint = 0 ; y < level.tilesY ; y++ ) {
					var tile:Tile = GameData.GlbMoveLogic._gameTiles[ Key.MakeKey(x, y)];
					if( p.canMoveTo( tile ) ) {
						tile.drawSelection();
					}
					else if( p.canAttackTo( tile ) ) {
						tile.drawAttack();
					}
				}
			}
		}
		
		public static function FindMovesForPiece( t:Tile, p:Piece, level:Level ):Array {
			var moveInfo:Array = new Array();
			
			for ( var x:uint = 0 ; x < level.tilesX ; x++ ) {
				for ( var y:uint = 0 ; y < level.tilesY ; y++ ) {
					var tile:Tile = GameData.GlbMoveLogic._gameTiles[ Key.MakeKey(x, y)];
					if( p.canMoveTo( tile ) ) {
						moveInfo.push( new MoveInfo( t, p, tile ) );
					}
				}
			}
			
			return moveInfo;
		}
		
		public static function FindAttacksForPiece( t:Tile, p:Piece, level:Level ):Array {
			var attacks:Array = new Array();
			
			for ( var x:uint = 0 ; x < level.tilesX ; x++ ) {
				for ( var y:uint = 0 ; y < level.tilesY ; y++ ) {
					var tile:Tile = GameData.GlbMoveLogic._gameTiles[ Key.MakeKey(x, y)];
					if( p.canAttackTo( tile ) ) {
						attacks.push( new MoveInfo( t, p, tile ) );
					}
				}
			}
			
			return attacks;
		}
		
		private static function _UserSawLevel():Boolean {
			for each ( var levelNum:int in GameData.SeenLevelGrown ) {
				if( GameData.GlbLevels.getLevelNumber() == levelNum ) {
					return true;
				}
			}
			
			return false;
		}
		
		public static function DrawBoard( clickCallBack:Function, document:MovieClip ):void {
			HideArrows();
			var level:Level = GameData.GlbLevels.getCurrentLevel();
			GameData.Document.currentLevel.text = "Level " + GameData.GlbLevels.getLevelNumber();
			
			var showNewPiece:Boolean = ( level.newPiece != Piece.INVALID );
			var newPiece:Piece = null;
			
			// SeenLevelGrown
			if ( !showNewPiece && GameData.GlbLevels.getLevelNumber() != 1 && _UserSawLevel() == false ) {
					
				GameData.Document.boardGrew.visible = true;
				trace( "show " + GameData.GlbLevels.getLevelNumber() );
				trace( GameData.SeenLevelGrown );
				GameData.SeenLevelGrown.push( GameData.GlbLevels.getLevelNumber() );
			}
			
			GameData.CurrentLevel = level;
			
			const offsetX:Number = ( Constants.CANVAS_X / level.tilesX / 2 );
			const offsetY:Number = ( Constants.CANVAS_Y / level.tilesY / 2 );
			const circleRad:Number = offsetX;
			
			for ( var i:uint = 0 ; i < level.tilesX ; i++ ) {
				var x:Number = i * ( Constants.CANVAS_X / level.tilesX ) + offsetX;
				for ( var j:uint = 0 ; j < level.tilesY ; j++ ) {
					var y:Number = j * ( Constants.CANVAS_Y / level.tilesY ) + offsetY;
					
					var gameTile:Tile = new Tile( i, j );
					gameTile.addEventListener( MouseEvent.MOUSE_UP, clickCallBack );
					gameTile.drawTile( x, y, circleRad, document );
					
					var creationKey:String = i + "key" + j;
					GameData.GlbMoveLogic._gameTiles[ creationKey ] = gameTile;
				}
			}

			for each ( var levelInfo:LevelInfo in level.levelInfo ) {
				var tile:Tile = GameData.GlbMoveLogic._gameTiles[Key.MakeKey( levelInfo.x, levelInfo.y )];
				tile.addPeice( levelInfo.piece );

				if ( showNewPiece && newPiece == null && level.newPiece == tile.getPiece().getType() ) {
					var pieceNotYetSeen:Boolean = true;
					for each( var p:uint in GameData.SeenPieces ) {
						if( level.newPiece == p ) {
							pieceNotYetSeen = false;
							break;
						}	 					
					}

					if ( pieceNotYetSeen ) {
						newPiece = tile.getPiece();
						GameData.Document.newPiece.visible = true;
						GameData.Document.newPiece.x = GameData.Document.height - tile.getCenterX() - 150;
						GameData.Document.newPiece.y = GameData.Document.height - tile.getCenterY() - 290;
						GameData.SeenPieces.push( level.newPiece );
					}
				}
			}
			
			//Reverse the pieces
			for each ( levelInfo in level.levelInfo ) {
				var revX:uint = level.tilesX - 1 - levelInfo.x;
				var revY:uint = level.tilesY - 1 - levelInfo.y;
				
				tile = GameData.GlbMoveLogic._gameTiles[Key.MakeKey( revX, revY )];
				tile.addPeice( levelInfo.piece.CopyAsPlayer( Constants.PLAYER ) );
			}
		}
		
		public static function ClearSelectedTile():void {
			ClearSelectedTiles( GameData.CurrentLevel );
			
			GameData.SelectedPiece = null;
			GameData.SelectedTile = null;
		}
		
		public static function ClearSelectedTiles( level:Level ):void {
			for ( var x:uint = 0 ; x < level.tilesX ; x++ ) {
				for ( var y:uint = 0 ; y < level.tilesY ; y++ ) {
					var tile:Tile = GameData.GlbMoveLogic._gameTiles[ Key.MakeKey( x, y )];
					if ( tile.getPiece() != null && tile.getPiece().samePlayer( GameData.CurrentPlayer ) && 
						tile.getPiece().getType() == Piece.FLAG ) {
							continue;
						}
					
					tile.clearSelection();
				}
			}
		}
		
		public static function CheckMovesExists():Boolean {			
			for each( var t:Tile in GameData.GlbMoveLogic._gameTiles ) {
				if( t.getPiece() == null )
					continue;
					
				var p:Piece = t.getPiece();
				if ( p.samePlayer( GameData.CurrentPlayer ) == false )
					continue;
			
				for ( var x:uint = 0 ; x < GameData.CurrentLevel.tilesX ; x++ ) {
					for ( var y:uint = 0 ; y < GameData.CurrentLevel.tilesY ; y++ ) {
						var tile:Tile = GameData.GlbMoveLogic._gameTiles[ Key.MakeKey(x, y)];
						if( p.canAttackTo( tile ) ) {
							return true;
						}
						if( p.canMoveTo( tile ) ) {
							return true;
						}
					}
				}
			}
			
			return false;
		}
		
		public static function SwitchCurrentPlayer():void {
			if ( GameData.CurrentPlayer == Constants.AI_PLAYER )
				GameData.CurrentPlayer = Constants.PLAYER;
			else
				GameData.CurrentPlayer = Constants.AI_PLAYER;
		}
		
		public static function GhostTile( t:Tile, p:Piece ):void {
			if( GameData.LastGhostedTile != null ) {
				GameData.LastGhostedTile.removeGhostPiece();
			}
			
			t.ghostPiece( p );
			GameData.LastGhostedTile = t;
		}
		
		public static function OnCircleMouseClick( me:MouseEvent ):void {
			GameStateMachine.UserClicksTile( Tile(me.target) );	
		}
		
		public static function CleanupLevel():void {
			for each( var tile:Tile in GameData.GlbMoveLogic._gameTiles ) {
				tile.getCanvas().removeChild( tile );
			}
		}
		
		public static function HideArrows():void {
			GameData.Document.arrowUp.visible = false;
			GameData.Document.arrowDown.visible = false;
			GameData.Document.arrowLeft.visible = false;
			GameData.Document.arrowRight.visible = false;
			GameData.Document.arrowDownRight.visible = false;
			GameData.Document.arrowDownLeft.visible = false;
			GameData.Document.arrowUpRight.visible = false;
			GameData.Document.arrowUpLeft.visible = false;
			GameData.Document.newPiece.visible = false;
			GameData.Document.boardGrew.visible = false;
		}
		
		public static function SaveState():void {
			var savedLevel:SharedObject = SharedObject.getLocal("savedLevel");
			savedLevel.data.level = GameData.MaxLevelUnlocked;
			savedLevel.data.levelMedium = GameData.MaxLevelUnlockedMedium;
			savedLevel.data.levelHard = GameData.MaxLevelUnlockedHard;
			savedLevel.data.sawMoveHelp = GameData.SawMoveHelp;
			savedLevel.data.sawSelectHelp = GameData.SawSelectHelp;
			savedLevel.data.seenPieces = GameData.SeenPieces;
			savedLevel.data.seenLevelGrown = GameData.SeenLevelGrown;
			savedLevel.data.difficulty = GameData.GetDiff();
			savedLevel.data.SeenTakeFlagHint = GameData.SeenTakeFlagHint;
			savedLevel.flush();
		}
		
		public static function LoadState():void {
			var savedLevel:SharedObject = SharedObject.getLocal("savedLevel");
			//savedLevel.data.level is 0 if un-defined
			GameData.MaxLevelUnlocked = savedLevel.data.level;
			GameData.MaxLevelUnlockedMedium = savedLevel.data.levelMedium;
			GameData.MaxLevelUnlockedHard = savedLevel.data.levelHard;
			//false if un-defined
//			GameData.SawMoveHelp = savedLevel.data.sawMoveHelp;
//			GameData.SawSelectHelp = savedLevel.data.sawSelectHelp;
//			GameData.SeenPieces = savedLevel.data.seenPieces;
//			GameData.SeenLevelGrown = savedLevel.data.seenLevelGrown;
//			GameData.SetDiff( savedLevel.data.difficulty );
//			GameData.SeenTakeFlagHint = savedLevel.data.SeenTakeFlagHint;
			
			if( GameData.SeenLevelGrown == null )
				GameData.SeenLevelGrown = new Array();
				
			if( GameData.SeenPieces == null )
				GameData.SeenPieces = new Array();
		}
	}
}
