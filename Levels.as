package {

	public class Levels {
		
		private var _currentLevel:uint = 0;
		private var _levelArray:Array;
		private var _moveLogic:MoveLogic;
		
		public function Levels( moveLogic:MoveLogic ):void {
			_moveLogic = moveLogic;
			_buildLevels( moveLogic );
		}
		
		public function setCurrentLevel( currentLevel:uint ):void {
			_currentLevel = currentLevel;
		}

		private function _AddLevel( moveLogic:MoveLogic, size:uint, possiblePieces:Array, newPiece:uint = NaN ):void {
			var level:Level = LevelGenerator.MakeLevel( moveLogic, size, possiblePieces );
			level.newPiece = newPiece;
			_levelArray.push( level );
		}
		
		private function _buildLevels( moveLogic:MoveLogic ):void {
			_levelArray = new Array();

			var possiblePieces:Array = new Array();
			
			possiblePieces.push( Piece.PAWN1 );
			_AddLevel( moveLogic, 3, possiblePieces );
			_AddLevel( moveLogic, 4, possiblePieces );
			
			possiblePieces.push( Piece.ROOK1 );
			_AddLevel( moveLogic, 4, possiblePieces, Piece.ROOK1 );
			
			possiblePieces.push( Piece.BISH1 );
			_AddLevel( moveLogic, 4, possiblePieces, Piece.BISH1 );
			
			possiblePieces.push( Piece.QUEEN1 );
			_AddLevel( moveLogic, 5, possiblePieces, Piece.QUEEN1 );
			_AddLevel( moveLogic, 6, possiblePieces );
			
			possiblePieces.push( Piece.PAWN2 );
			_AddLevel( moveLogic, 6, possiblePieces, Piece.PAWN2 );
			
			possiblePieces.push( Piece.ROOK2 );
			_AddLevel( moveLogic, 6, possiblePieces, Piece.ROOK2 );
			
			possiblePieces.push( Piece.BISH2 );
			_AddLevel( moveLogic, 6, possiblePieces, Piece.BISH2 );
			
			possiblePieces.push( Piece.QUEEN2 );
			_AddLevel( moveLogic, 6, possiblePieces, Piece.QUEEN2 );
			_AddLevel( moveLogic, 7, possiblePieces );
			
			possiblePieces.push( Piece.PAWN3 );
			_AddLevel( moveLogic, 7, possiblePieces, Piece.PAWN3 );
			
			possiblePieces.push( Piece.ROOK3 );
			_AddLevel( moveLogic, 7, possiblePieces, Piece.ROOK3 );
			
			possiblePieces.push( Piece.BISH3 );
			_AddLevel( moveLogic, 7, possiblePieces, Piece.BISH3 );
			
			possiblePieces.push( Piece.QUEEN3 );
			_AddLevel( moveLogic, 7, possiblePieces, Piece.QUEEN3 );
			_AddLevel( moveLogic, 8, possiblePieces );
			
			trace( "Level Count = " + _levelArray.length );
			//_currentLevel = 14;
		}
		
		public function getCurrentLevel():Level {
			return _levelArray[_currentLevel];
		}
		
		public function getLevelNumber():uint {
			return _currentLevel + 1;
		}
		
		public function rebuild():void {
			_buildLevels( _moveLogic );
		}
		
		public function progressToNextLevel():void {
			_buildLevels( _moveLogic );
			
			_currentLevel++;
			var lastLevelBeaten:Boolean = false;
			if( _currentLevel >= _levelArray.length ) {
				trace( "No more levels remain.");
				lastLevelBeaten = true;
				_currentLevel--;
			}

			if ( lastLevelBeaten ) {
				GameData.Document.levelSelectScreen.show();
				GameData.Document.difficultyBeatScreeen.show();
			}
			
			Utility.LogAction( "progressToNextLevel" + _currentLevel );

			if ( GameData.GetDiff() == GameData.EASY ) {
				if( _currentLevel > GameData.MaxLevelUnlocked ) {
					GameData.MaxLevelUnlocked = _currentLevel;
				}
			}
			else if ( GameData.GetDiff() == GameData.MED ) {
				if ( _currentLevel > GameData.MaxLevelUnlockedMedium ) {
					GameData.MaxLevelUnlockedMedium = _currentLevel;
				}
			}
			else if ( GameData.GetDiff() == GameData.HARD ) {
				if ( _currentLevel > GameData.MaxLevelUnlockedHard ) {
					GameData.MaxLevelUnlockedHard = _currentLevel;
				}
			}
			
			// If you beat a level on a higher difficulty you earn it on the easier ones.
			if ( GameData.MaxLevelUnlockedHard > GameData.MaxLevelUnlockedMedium )
				GameData.MaxLevelUnlockedMedium = GameData.MaxLevelUnlockedHard;
			
			if( GameData.MaxLevelUnlockedMedium > GameData.MaxLevelUnlocked )
				GameData.MaxLevelUnlocked = GameData.MaxLevelUnlockedMedium;
			
			GameLogic.SaveState();
		}
	}
	
}
