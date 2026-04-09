package pvz.serverbattle.knockout.scene
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import utils.GetDomainRes;
   
   public class GuessButton extends Sprite
   {
      
      private var _basebutton:MovieClip;
      
      public var id:int;
      
      public var _status:int = 1;
      
      public var index:int = 0;
      
      public function GuessButton()
      {
         super();
         this._basebutton = GetDomainRes.getMoveClip("serverBattle.knockout.nodeButton");
         this._basebutton.gotoAndStop(1);
         this.addChild(this._basebutton);
      }
      
      public function destroy() : void
      {
         this._basebutton.stop();
         this.parent.removeChild(this);
      }
      
      public function updataType(param1:uint) : void
      {
         this._basebutton.gotoAndStop(param1);
      }
      
      public function set status(param1:int) : void
      {
         this._status = param1;
         this.updataType(param1);
      }
      
      public function get status() : int
      {
         return this._status;
      }
   }
}

