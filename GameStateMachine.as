package {
	
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.Dictionary;
	
	public class GameStateMachine {
		
		private static var _AiTimer:Timer = new Timer( 500, 1 );
		private static var _enemyPieceSelected:Boolean = false;
				
		public static function UserClicksTile( tile:Tile ):void {
			const LockShowEnemyMoveLevel:uint = 2;
			
			if( GameData.Document.newPiece.visible ) {
				GameData.Document.newPiece.visible = false;
			}
			if ( GameData.Document.boardGrew.visible ) {
				GameData.Document.boardGrew.visible = false;
			}
			
			if( _enemyPieceSelected ) {
				_enemyPieceSelected = false;
				GameLogic.ClearSelectedTiles( GameData.CurrentLevel );
			}
			
			GameStateMachine._AiTimer.addEventListener( TimerEvent.TIMER_COMPLETE, _AIMoveLogic );
			
			var tileHasPiece:Boolean = ( tile.getPiece() != null );
			var selectOwnPiece:Boolean = ( 
			GameData.SelectedPiece == null && tileHasPiece && tile.getPiece().samePlayer( GameData.CurrentPlayer ));
			
			var selectEnemyPiece:Boolean = ( 
			GameData.SelectedPiece == null && tileHasPiece && tile.getPiece().samePlayer( Constants.AI_PLAYER ));
				
			var deselectTile:Boolean = ( tileHasPiece && tile.getPiece() == GameData.SelectedPiece );
				
			var tryToMove:Boolean = ( GameData.SelectedPiece != null && tile.getPiece() == null );
			
			var tryToAttack:Boolean = ( 
				GameData.SelectedPiece != null && 
				 tileHasPiece && 
				 !tile.getPiece().samePlayer( GameData.CurrentPlayer ) );
				
			var selectNewPiece:Boolean = ( 
				GameData.SelectedPiece != null && 
				tileHasPiece && 
				tile.getPiece().samePlayer( GameData.CurrentPlayer ) );

			if ( tileHasPiece && tile.getPiece().samePlayer( GameData.CurrentPlayer ) && tile.getPiece().getType() == Piece.FLAG ) {
				return;			
			}
			else if ( selectOwnPiece ) {
				if ( GameData.Document.clickPieceInstruction.visible ) {
					GameData.Document.clickPieceInstruction.visible = false;
					GameData.SawSelectHelp = true;
				}
				if ( GameData.SawMoveHelp == false ) {
					GameData.Document.clickMoveInstruction.visible = true;
				}
				SelectTile( tile );
			}
			else if ( selectEnemyPiece && GameData.GlbLevels.getLevelNumber() > LockShowEnemyMoveLevel ) {
				_ShowEnemyMoves( tile );
			}
			else if( deselectTile ) {
				DeSelectTile();
			}
			else if( tryToMove ) {
				var moved:Boolean = TryToMove( GameData.SelectedTile, GameData.SelectedPiece, tile );
				if ( moved ) {
					if( GameData.Document.clickMoveInstruction.visible ) {
						GameData.Document.clickMoveInstruction.visible = false;
						GameData.SawMoveHelp = true;
						if( GameData.SeenTakeFlagHint == false ) {
							GameData.Document.takeFlagHint.visible = true;
						}
					}
					
					if ( GameData.MovesLogged < GameData.MOVES_TO_LOG ) {
						Utility.LogAction( "Player Moved." );
						GameData.MovesLogged++;
					}
					
					DeSelectTile();
					GameLogic.SwitchCurrentPlayer();
					
					var movesExist:Boolean = GameLogic.CheckMovesExists();
					if( movesExist ) {
						GameStateMachine._AiTimer.start();
					}
					else {
						VictoryNoMoves();//Ai has no moves
					}
				}
			}
			else if( tryToAttack ) {
				var pieceTaken:Piece = tile.getPiece();
				var attackSuccess:Boolean = TryToAttack( GameData.SelectedTile, GameData.SelectedPiece, tile );
				if ( attackSuccess ) {
					if ( GameData.AttacksLogged < GameData.ATTACKS_TO_LOG ) {
						Utility.LogAction( "Player Attacked." );
						GameData.AttacksLogged++;
					}
					
					DeSelectTile();
					
					var flagTaken:Boolean = CheckFlagTaken( pieceTaken );
					if ( flagTaken && GameData.CurrentPlayer == Constants.PLAYER ) {
						VictoryFlagCapture();
					}
					else if ( flagTaken && GameData.CurrentPlayer == Constants.AI_PLAYER ) {
						LossFlag();
					}
					else {
						GameLogic.SwitchCurrentPlayer();
						movesExist = GameLogic.CheckMovesExists();
						if( movesExist ) {
							GameStateMachine._AiTimer.start();
						}
						else {
							VictoryNoMoves();
						}
					}
				}
				else if ( GameData.GlbLevels.getLevelNumber() > LockShowEnemyMoveLevel ) {
					_ShowEnemyMoves( tile );
				}
			}
			else if( selectNewPiece ) {
				DeSelectTile();
				SelectTile( tile );
			}
			else {
				//throw new Error( "UserClicksTile has un-defined condition met" );
			}
		}
		
		private static function _ShowEnemyMoves( tile:Tile ):void {
			DeSelectTile();
			ShowEnemyMoves( tile );
			_enemyPieceSelected = true;
		}
		
		private static function _AIMoveLogic( te:TimerEvent ):void {
			var tookPieceAfterAttack:Piece = AIMove( GameData.CurrentLevel );
			if ( tookPieceAfterAttack != null && tookPieceAfterAttack.getType() == Piece.FLAG ) {
				LossFlag();
			}
			else {
				GameLogic.SwitchCurrentPlayer();
				var movesExist:Boolean = GameLogic.CheckMovesExists();
				if( !movesExist ) {
					LossNoMoves();
				}
			}
			
			var flagTile:Tile = GameData.GlbMoveLogic._gameTiles[ Key.MakeKey( GameData.CurrentLevel.playerCenterX, GameData.CurrentLevel.playerCenterY )];
			if( _CheckFlagInDanger() ) {
				flagTile.drawDanger();
			}
			else {
				flagTile.clearSelection();
			}
		}
		
		private static function _CheckFlagInDanger():Boolean {
			var flagTile:Tile = GameData.GlbMoveLogic._gameTiles[ Key.MakeKey( GameData.CurrentLevel.playerCenterX, GameData.CurrentLevel.playerCenterY )];
			
			for each( var t:Tile in GameData.GlbMoveLogic._gameTiles ) {
				if( t.getPiece() == null )
					continue;
					
				var p:Piece = t.getPiece();
				if ( p.samePlayer( Constants.PLAYER ) == true )
					continue;
					
				if( p.canAttackTo( flagTile ) ) {
					return true;
				}
			}
			
			return false;
		}
		
		public static function VictoryFlagCapture():void {
			Utility.LogAction( "VictoryFlagCapture" );
			GameData.GlbGameOverScreen.show( "You took the opponents flag!", _VictoryButtonPress, true );
			
			if( GameData.Document.takeFlagHint.visible ) {
				GameData.Document.takeFlagHint.visible = false;
			}
		}
		
		public static function VictoryNoMoves():void {
			Utility.LogAction( "VictoryNoMoves" );
			GameData.GlbGameOverScreen.show( "You win, your opponent has no moves!", _VictoryButtonPress, true );
		}
		
		private static function _VictoryButtonPress():void {
			Utility.LogAction( "_VictoryButtonPress" );
			GameLogic.CleanupLevel();
			
			GameData.CurrentPlayer = Constants.PLAYER;
			GameData.GlbMoveLogic._gameTiles = new Dictionary();
			
			GameData.GlbLevels.progressToNextLevel();
			GameLogic.DrawBoard( GameLogic.OnCircleMouseClick, GameData.Document.boardLayer );
		}
		
		public static function LossFlag():void {
			Utility.LogAction( "LossFlag" );
			GameData.GlbGameOverScreen.show( "The opponent took your flag.", _LossButtonPress, false );
		}
		
		public static function LossNoMoves():void {
			Utility.LogAction( "LossNoMoves" );
			GameData.GlbGameOverScreen.show( "You have no more moves.", _LossButtonPress, false );
		}
		
		public static function ChangeLevel():void {
			_LossButtonPress();
		}
		
		private static function _LossButtonPress():void {
			Utility.LogAction( "_LossButtonPress" );
			GameLogic.CleanupLevel();
			
			GameData.CurrentPlayer = Constants.PLAYER;
			GameData.GlbMoveLogic._gameTiles = new Dictionary();
			
			GameData.GlbLevels.rebuild();
			GameLogic.DrawBoard( GameLogic.OnCircleMouseClick, GameData.Document.boardLayer );
		}
		
		public static function CheckFlagTaken( p:Piece ):Boolean {
			if ( p.getType() == Piece.FLAG )
				return true;
			else
				return false;
		}
		
		public static function TryToAttack( tileToMoveFrom:Tile, pieceToMove:Piece, destTile:Tile ):Boolean {			
			if( pieceToMove.canAttackTo( destTile ) == false ) {
				return false;
			}
			
			_UpdateArrow( tileToMoveFrom, destTile );

			GameLogic.GhostTile( tileToMoveFrom, pieceToMove );
			tileToMoveFrom.removePiece();
			
			trace( "Piece Taken " + destTile.getPiece() );
			
			destTile.removePiece();
			destTile.addPeice( pieceToMove );
			
			return true;
		}
		
		public static function TryToMove( tileToMoveFrom:Tile, pieceToMove:Piece, destTile:Tile ):Boolean {
			if ( pieceToMove.canMoveTo( destTile ) == false ) {
				return false;
			}

			_UpdateArrow( tileToMoveFrom, destTile );

			GameLogic.GhostTile( tileToMoveFrom, pieceToMove );
			tileToMoveFrom.removePiece();
			destTile.addPeice( pieceToMove );
			return true;			
		}
		
		private static function _UpdateArrow( tileToMoveFrom:Tile, destTile:Tile ):void {
			var movedUp:Boolean = ( tileToMoveFrom.getY() > destTile.getY() );
			var movedDown:Boolean = ( tileToMoveFrom.getY() < destTile.getY() );
			var movedLeft:Boolean = ( tileToMoveFrom.getX() > destTile.getX() );
			var movedRight:Boolean = ( tileToMoveFrom.getX() < destTile.getX() );
			
			GameLogic.HideArrows();
			
			var arrow:Sprite = null;
			if( movedDown && movedRight )
				arrow = GameData.Document.arrowDownRight;
			else if( movedDown && movedLeft )
				arrow = GameData.Document.arrowDownLeft;
			else if ( movedUp && movedRight)
				arrow = GameData.Document.arrowUpRight;
			else if( movedUp && movedLeft )
				arrow = GameData.Document.arrowUpLeft;
			else if( movedUp )
				arrow = GameData.Document.arrowUp;
			else if( movedDown )
				arrow = GameData.Document.arrowDown;
			else if( movedLeft )
				arrow = GameData.Document.arrowLeft;
			else if ( movedRight )
				arrow = GameData.Document.arrowRight;
				
			var minY:Number = Math.min( tileToMoveFrom.getCenterY(), destTile.getCenterY() );
			var maxY:Number = Math.max( tileToMoveFrom.getCenterY(), destTile.getCenterY() );
			var minX:Number = Math.min( tileToMoveFrom.getCenterX(), destTile.getCenterX() );
			var maxX:Number = Math.max( tileToMoveFrom.getCenterX(), destTile.getCenterX() );
			
			arrow.visible = true;
			arrow.x = minX;
			arrow.y = minY;
			arrow.height = maxY - minY;
			arrow.width = maxX - minX;
			
			if( arrow.height == 0 )
				arrow.height = 10;
				
			if( arrow.width == 0 )
				arrow.width = 10;
		}
		
		public static function ShowEnemyMoves( tile:Tile ):void {
			tile.drawSelection();
			GameLogic.ColorPossibleMoves( tile.getPiece(), GameData.CurrentLevel );
		}
		
		public static function SelectTile( tile:Tile ):void {
			GameData.SelectedPiece = tile.getPiece();
			GameData.SelectedTile = tile;
			tile.drawSelection();
			GameLogic.ColorPossibleMoves( tile.getPiece(), GameData.CurrentLevel );
			GameData.Document.movementControl.showPiece( tile.getPiece().getType() );
		}
		
		public static function DeSelectTile():void {
			GameLogic.ClearSelectedTiles( GameData.CurrentLevel );
			GameData.SelectedPiece = null;
			GameData.SelectedTile = null;
			GameData.Document.movementControl.clearShownPiece();
		}
		
		public static function AIMove( level:Level ):Piece {
			var allMoves:Array = new Array();	
					
			for each( var t:Tile in GameData.GlbMoveLogic._gameTiles ) {
				if( t.getPiece() == null )
					continue;
					
				var p:Piece = t.getPiece();
				if ( p.samePlayer( Constants.AI_PLAYER ) == false )
					continue;

				var attacks:Array = GameLogic.FindAttacksForPiece( t, p, level );
				for each( var attackInfo:MoveInfo in attacks ) {
					allMoves.push( attackInfo );
				}
			}
			
			for each( t in GameData.GlbMoveLogic._gameTiles ) {
				if( t.getPiece() == null )
					continue;
					
				p = t.getPiece();
				if ( p.samePlayer( Constants.AI_PLAYER ) == false )
					continue;

				if ( p.getType() == Piece.FLAG )
					continue;
					
				var possibleMoves:Array = GameLogic.FindMovesForPiece( t, p, level );
				for each( var moveInfo:MoveInfo in possibleMoves ) {
					allMoves.push( moveInfo );
				}
			}
			
			var move:MoveInfo = _GetMove( allMoves );
			if( move == null )
				return null;

			if ( move.tileTo.getPiece() == null ) {
				var movedPiece:Piece = move.tileTo.getPiece();
				TryToMove( move.tileFrom, move.pieceFrom, move.tileTo );
				return movedPiece;
			}
			else {
				var tookPiece:Piece = move.tileTo.getPiece();
				TryToAttack( move.tileFrom, move.pieceFrom, move.tileTo );
				return tookPiece;
			}
			
			return null;
		}
		
		private static function _GetMove( allMoves:Array ):MoveInfo {
			_EvaluateMoves( allMoves );
			
			var bestMove:MoveInfo = null;
			for each ( var move:MoveInfo in allMoves ) {
				if( bestMove == null )
					bestMove = move;

				if ( move.value > bestMove.value )
					bestMove = move;
			}
			return bestMove;
		}
		
		private static function _EvaluateMoves( allMoves:Array ):void {
			trace( "_EvaluateMoves " + allMoves.length );
			const PTS_TAKE_FLAG:Number = 9999;
			const PTS_FOR_CAPTURE:Number = 1;
			const PTS_ATTACK_FLAG:Number = 1;
			const PTS_DEFEND_FLAG:Number = 1;
			const PTS_TIER2:Number = 1;
			const PTS_TIER3:Number = 2;
			const PTS_MOVE_FORWARD:Number = 0.30;
			const PTS_BAD_TRADE:Number = -2;
			const PTS_KILL_CHECKING_ENEMY:Number = 5;
			
			const AVOID_MOVE:String = "AvoidMove";
			const TAKE:String = "Take";
			const CAP_FLAG:String = "CapFlag";
			
			var losPieces:Array = _GetLosFlagPieces();
			
			for each ( var move:MoveInfo in allMoves ) {
				if ( GameData.GetDiff() == GameData.EASY || GameData.GetDiff() == GameData.MED || GameData.GetDiff() == GameData.HARD ) {
					if ( move.tileTo.getPiece() != null ) {
						if( GameData.GetDiff() == GameData.EASY ) {
							if ( Math.random() < 0.5 ) {
								// 50% chance to avoid attack
								move.reasons.push( AVOID_MOVE );
								move.value -= PTS_FOR_CAPTURE;
							}
							else {
								move.reasons.push( TAKE );
								move.value += PTS_FOR_CAPTURE;
							}	
						}
						else {
							move.reasons.push( TAKE );
							move.value += PTS_FOR_CAPTURE;
						}
					}
	
					if ( move.tileTo.getPiece() != null && move.tileTo.getPiece().getType() == Piece.FLAG ) {
						move.reasons.push( CAP_FLAG );
						move.value += PTS_TAKE_FLAG;
					}
				}

				if ( GameData.GetDiff() == GameData.MED || GameData.GetDiff() == GameData.HARD ) {
					if( _TileNearEnemyFlag( move.tileTo ) ) {
						move.reasons.push( "NearEnemyFlag" );
						move.value += PTS_ATTACK_FLAG;
					}
	
					if ( _TileNearOwnFlag( move.tileTo )) {
						move.reasons.push( "NearAiFlag" );
						move.value += PTS_DEFEND_FLAG;
					}
						
					if( _Tier2Piece( move.tileTo ) ) {
						move.reasons.push( "CapTier2" );
						move.value += PTS_TIER2;
					}
						
					if( _Tier3Piece( move.tileTo ) ) {
						move.reasons.push( "CapTier3" );
						move.value += PTS_TIER3;
					}
						
//					if( _TileCenterBoard( move.tileTo ) )
//						move.value += PTS_MID_FIELD;

					//forward movement
					if ( move.tileFrom.getY() < move.tileTo.getY() ) {
						move.reasons.push( "MoveForward" );
						move.value += PTS_MOVE_FORWARD;
					}

					if ( _TileNearOwnFlag( move.tileFrom ) ) {//Don't want to leave the flag defense.
						move.reasons.push( "LeaveFlag" );
						move.value -= PTS_DEFEND_FLAG;
					}

					if ( _TileInFrontOfFlag( move.tileTo ) ) {
						move.reasons.push( "ProtectFlagFront" );
						move.value += 2;
					}

					if ( _TileInFrontOfFlag( move.tileFrom ) ) {
						move.reasons.push( "LeaveFlagFront" );
						move.value -= 1;
					}
				}

				if ( GameData.GetDiff() == GameData.HARD ) {					
					var canBeKilled:Boolean = _PieceCanBeKilled( move.tileTo );
					if( canBeKilled ) {
						move.reasons.push( "LosePiece" );
				 		move.value -= 1.25;
					}
				 		
				 	if( canBeKilled && _BadTrade( move.tileFrom, move.tileTo ) ) {
				 		move.reasons.push( "BadTrade" );
				 		move.value += PTS_BAD_TRADE;
					}
					else if ( canBeKilled && !_BadTrade( move.tileFrom, move.tileTo ) && move.tileTo.getPiece() != null ) {
				 		move.reasons.push( "GoodTrade" );
				 		move.value += 1;
				 	}

					//Retreat if the piece can be killed
					if ( _PieceCanBeKilled( move.tileFrom ) && !_PieceCanBeKilled( move.tileTo )) {
						move.reasons.push( "RunAway" );
						move.value += 1;
						if( _Tier3Piece( move.tileFrom ) ) {
							move.reasons.push( "RunAwayTier3" );
							move.value += 1.2;
						}
					}

					if ( _MoveHasCover( move.tileTo, move.tileFrom.getPiece() ) ) {
						move.reasons.push( "MoveHasCover" );
						move.value += 1;
					}

					if ( move.tileTo.getPiece() != null ) {
						move.reasons.push( "CapPiece" );
						move.value += _GetPointsForPiece( move.tileTo );
					}
						
					for each ( var p:Piece in losPieces ) {
						if ( move.tileTo.getPiece() == p ) {
							move.reasons.push( "KillFlagAttacker" );
							move.value += PTS_KILL_CHECKING_ENEMY;
						}
					}
				}
			}
			
			for each ( move in allMoves ) {
				trace( move );
			}
		}
		
		private static function _GetLosFlagPieces():Array {
			var flagTile:Tile = GameData.GlbMoveLogic._gameTiles[Key.MakeKey( 
				GameData.CurrentLevel.centerX, GameData.CurrentLevel.centerY )];

			var piecesLosFlag:Array = new Array();
			for each( var t:Tile in GameData.GlbMoveLogic._gameTiles ) {
				if( t.getPiece() == null )
					continue;

				if ( t.getPiece().samePlayer( Constants.AI_PLAYER ) )
					continue;
				
				if( t.getPiece().canAttackTo(flagTile))
					piecesLosFlag.push( t.getPiece() );
			}
			return piecesLosFlag;
		}
		
		private static function _BadTrade( from:Tile, to:Tile ):Boolean {
			if( from.getPiece() == null || to.getPiece() == null )
				return false;
				
			if( from.getPiece().getType() > to.getPiece().getType() )
				return true;
			else
				return false;
		}
		
		//Meant to give a small edge to the better pieces.
		private static function _GetPointsForPiece( tile:Tile ):Number {
			if( tile.getPiece() == null )
				return 0;
				
			var pts:Number = 0;
			switch( tile.getPiece().getType() ) {
				case Piece.QUEEN3:
			 		pts += 0.01;
				case Piece.ROOK3:
			 		pts += 0.01;
				case Piece.BISH3:
			 		pts += 0.01;
				case Piece.PAWN3:
			 		pts += 0.01;
				case Piece.QUEEN2:
			 		pts += 0.01;
				case Piece.ROOK2:
			 		pts += 0.01;
				case Piece.BISH2:
			 		pts += 0.01;
				case Piece.PAWN2:
			 		pts += 0.01;
				case Piece.QUEEN1:
			 		pts += 0.01;
				case Piece.ROOK1:
			 		pts += 0.01;
				case Piece.BISH1:
			 		pts += 0.01;
				case Piece.PAWN1:
			 		pts += 0.01;
			}
			return pts;
		}
		
		private static function _MoveHasCover( tile:Tile, pieceToCheck:Piece ):Boolean {
			for each( var t:Tile in GameData.GlbMoveLogic._gameTiles ) {
				if( t.getPiece() == null )
					continue;
					
				if( t.getPiece() == pieceToCheck )
					continue;

				if ( t.getPiece().samePlayer( Constants.PLAYER ) )
					continue;
					
				if( t.getPiece().couldAttackToWithPiece( tile ) )
					return true;
			}
			
			return false;
		}
		
//		private static function _PieceInDanger( tile:Tile ):Boolean {
//			for each( var t:Tile in GameData.GlbMoveLogic._gameTiles ) {
//				if( t.getPiece() == null )
//					continue;
//
//				if ( t.getPiece().samePlayer( Constants.AI_PLAYER ) )
//					continue;
//					
//				if( t.getPiece().couldAttackToWithPiece( tile ) )
//					return true;
//			}
//			
//			return false;
//		}
		
		private static function _PieceCanBeKilled( tile:Tile ):Boolean {
			for each( var t:Tile in GameData.GlbMoveLogic._gameTiles ) {
				if( t.getPiece() == null )
					continue;

				if ( t.getPiece().samePlayer( Constants.AI_PLAYER ) )
					continue;
					
				if( t.getPiece().couldAttackToWithPiece( tile ) )
					return true;
			}
			
			return false;
		}
		
		private static function _Tier2Piece( tile:Tile ):Boolean {
			if( tile.getPiece() == null )
				return false;
				
			switch( tile.getPiece().getType() ) {
				case Piece.ROOK2:
				case Piece.BISH2:
				case Piece.QUEEN2:
				case Piece.PAWN2:
					return true;
				default:
					return false;
			}
		}
		
		private static function _Tier3Piece( tile:Tile ):Boolean {
			if( tile.getPiece() == null )
				return false;
				
			switch( tile.getPiece().getType() ) {
				case Piece.ROOK3:
				case Piece.BISH3:
				case Piece.QUEEN3:
				case Piece.PAWN3:
					return true;
				default:
					return false;
			}
		}
		
		private static function _TileInFrontOfFlag( tile:Tile ):Boolean {
			if( GameData.CurrentLevel.centerX == tile.getX() && GameData.CurrentLevel.centerY == tile.getY() - 1 )
				return true;
			else
				return false;
		}
		
		private static function _TileNearOwnFlag( tile:Tile ):Boolean {
			var xDiff:int = Math.abs( tile.getX() - GameData.CurrentLevel.centerX );
			var yDiff:int = Math.abs( tile.getY() - GameData.CurrentLevel.centerY );

			if ( xDiff <= 1 && yDiff <= 1 )
				return true;
			else
				return false;
		}
		
		private static function _TileNearEnemyFlag( tile:Tile ):Boolean {
			var xDiff:int = Math.abs( tile.getX() - GameData.CurrentLevel.playerCenterX );
			var yDiff:int = Math.abs( tile.getY() - GameData.CurrentLevel.playerCenterY );

			if ( xDiff <= 1 && yDiff <= 1 )
				return true;
			else
				return false;
		}
		
//		private static function _TileCenterBoard( tile:Tile ):Boolean {
//			if ( tile.getY() == GameData.CurrentLevel.midY )
//				return true;
//			else
//				return false;
//		}
	}
}
