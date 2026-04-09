package pvz.serverbattle.knockout.scene
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import utils.FuncKit;
   import utils.ReBuidBitmap;
   import zmyth.ui.TextFilter;
   
   public class Pothunter extends Sprite
   {
      
      private var backGround:ReBuidBitmap;
      
      private var _win1:int;
      
      private var _win2:int;
      
      private var _win3:int;
      
      private var _win4:int;
      
      private var _servername:String;
      
      private var _faceurl:String;
      
      private var nickname:String;
      
      private var _viptime:int;
      
      private var _vipgrade:int;
      
      public function Pothunter()
      {
         super();
         if(this.backGround == null)
         {
            this.backGround = new ReBuidBitmap("serverBattle.knockout.playernode");
         }
         this.addChild(this.backGround);
      }
      
      public function setwin1(param1:int) : void
      {
         this._win1 = param1;
      }
      
      public function getwin1() : int
      {
         return this._win1;
      }
      
      public function setwin2(param1:int) : void
      {
         this._win2 = param1;
      }
      
      public function getwin2() : int
      {
         return this._win2;
      }
      
      public function setwin3(param1:int) : void
      {
         this._win3 = param1;
      }
      
      public function getwin3() : int
      {
         return this._win3;
      }
      
      public function setwin4(param1:int) : void
      {
         this._win4 = param1;
      }
      
      public function getwin4() : int
      {
         return this._win4;
      }
      
      public function setservername(param1:String) : void
      {
         this._servername = param1;
      }
      
      public function getservername() : String
      {
         return this._servername;
      }
      
      public function setfaceurl(param1:String) : void
      {
         this._faceurl = param1;
      }
      
      public function getfaceurl() : String
      {
         return this._faceurl;
      }
      
      public function setviptime(param1:int) : void
      {
         this._viptime = param1;
      }
      
      public function getviptime() : int
      {
         return this._viptime;
      }
      
      public function setvipgrade(param1:int) : void
      {
         this._vipgrade = param1;
      }
      
      public function getvipgrade() : int
      {
         return this._vipgrade;
      }
      
      public function setnickName(param1:String) : void
      {
         this.nickname = param1;
         this.setName(param1);
      }
      
      public function getnickName() : String
      {
         return this.nickname;
      }
      
      private function setName(param1:String) : void
      {
         var _loc2_:TextField = new TextField();
         _loc2_.text = this._servername + "  " + param1;
         _loc2_.textColor = 16777215;
         _loc2_.width = 150;
         _loc2_.selectable = false;
         _loc2_.x = 10;
         _loc2_.y = 4;
         TextFilter.MiaoBian(_loc2_,0);
         this.addChild(_loc2_);
      }
      
      public function destroy() : void
      {
         this.backGround.dispose();
         FuncKit.clearAllChildrens(this);
         this.parent.removeChild(this);
      }
   }
}

