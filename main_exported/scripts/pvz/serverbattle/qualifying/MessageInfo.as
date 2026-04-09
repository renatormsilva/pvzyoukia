package pvz.serverbattle.qualifying
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import pvz.serverbattle.entity.Message;
   import zlib.utils.DomainAccess;
   
   public class MessageInfo extends Sprite
   {
      
      private var _txtgroup:MovieClip;
      
      public function MessageInfo()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("server_message_info");
         this._txtgroup = new _loc1_();
         this._txtgroup.mouseEnabled = false;
         this._txtgroup.mouseChildren = false;
         this.addChild(this._txtgroup);
      }
      
      public function update(param1:Message) : void
      {
         this._txtgroup["_txt0"].text = param1.getName1().txt;
         (this._txtgroup["_txt0"] as TextField).textColor = param1.getName1().color;
         this._txtgroup["_txt1"].text = param1.getWinStats().txt;
         (this._txtgroup["_txt1"] as TextField).textColor = param1.getWinStats().color;
         this._txtgroup["_txt2"].text = param1.getName2().txt;
         (this._txtgroup["_txt2"] as TextField).textColor = param1.getName2().color;
         this._txtgroup["_txt3"].text = param1.getPropName().txt;
         (this._txtgroup["_txt3"] as TextField).textColor = param1.getPropName().color;
         this._txtgroup["_txt4"].text = param1.getBattleStaus().txt;
         (this._txtgroup["_txt4"] as TextField).textColor = param1.getBattleStaus().color;
      }
   }
}

