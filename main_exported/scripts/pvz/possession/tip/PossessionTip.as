package pvz.possession.tip
{
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import manager.LangManager;
   import manager.PlayerManager;
   import pvz.possession.Possession;
   import pvz.possession.PossessionNode;
   import tip.Tips;
   import utils.FuncKit;
   import utils.Singleton;
   import utils.TextFilter;
   import zlib.utils.DomainAccess;
   
   public class PossessionTip extends Tips
   {
      
      private var _background:MovieClip;
      
      private var _o:InteractiveObject;
      
      private var _p:Possession;
      
      private var playerManager:PlayerManager = Singleton.getInstance(PlayerManager);
      
      internal var _index:int = 0;
      
      internal var _type:int = 0;
      
      public function PossessionTip()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("_mc_possession_tip");
         this._background = new _loc1_();
         this.visible = false;
         this.miaobian();
         this.addChild(this._background);
      }
      
      public function setLoction(param1:int, param2:int) : void
      {
         this.x = this._o.x + param1;
         this.y = this._o.y + param2 - 48;
      }
      
      public function setTip(param1:InteractiveObject, param2:Possession, param3:DisplayObjectContainer, param4:int, param5:int) : void
      {
         this._o = param1;
         this._p = param2;
         this._index = param4;
         this._type = param5;
         if(this._o != null)
         {
            this.clearAllEvent();
         }
         this.visible = true;
         if(parent == null)
         {
            param3.addChild(this);
         }
         else
         {
            parent.setChildIndex(this,parent.numChildren - 1);
         }
         this._o.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
         this.setText();
      }
      
      private function clearAllEvent() : void
      {
         this._o.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      override public function destroy() : void
      {
         this.clearAllEvent();
         this._o = null;
         this._p = null;
         FuncKit.clearAllChildrens(this);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         this.visible = false;
      }
      
      private function setText() : void
      {
         if(this._index == 0)
         {
            this._background._txt_name.text = this._p.getOccupyName();
            this._background._txt_grade.text = LangManager.getInstance().getLanguage("possession001") + this._p.getOccupyGrade();
         }
         else
         {
            this._background._txt_grade.text = LangManager.getInstance().getLanguage("possession001") + this._p.getMasterLv();
            this._background._txt_name.text = this._p.getMaster();
         }
         if(this._type == PossessionNode.HOST && this._p.getPossessionId() == this._p.getOccupyId() && this._p.getPossessionId() == this.playerManager.getPlayerOther().getId())
         {
            (this._background._txt_lasttime as TextField).textColor = 16777215;
            this._background._txt_lasttime.text = LangManager.getInstance().getLanguage("possession041") + this._p.getHonor();
         }
         else
         {
            (this._background._txt_lasttime as TextField).textColor = 6736896;
            this._background._txt_lasttime.text = this.getLastTime(this._p.getOccupyTime());
         }
         this._background._txt_cdtime.text = this.getCDTime(this._p.getLastAwardTime());
         this._background._txt_income.text = LangManager.getInstance().getLanguage("possession002") + this._p.getIncome();
         this._background.visible = true;
      }
      
      private function getLastTime(param1:int) : String
      {
         if(this._p.getPossessionId() == this._p.getOccupyId() && this._p.getPossessionId() != 0)
         {
            return "";
         }
         var _loc2_:int = PossessionNode.MAX_TIME - (FuncKit.currentTimeMillis() / 1000 - param1);
         var _loc3_:int = int(_loc2_ / 3600);
         var _loc4_:int = int((_loc2_ - _loc3_ * 60 * 60) / 60);
         var _loc5_:int = int(_loc2_ - _loc3_ * 3600 - _loc4_ * 60);
         return LangManager.getInstance().getLanguage("possession003",_loc3_,_loc4_);
      }
      
      private function getCDTime(param1:int) : String
      {
         if(this._p.getOccupyId() != this.playerManager.getPlayer().getId())
         {
            return LangManager.getInstance().getLanguage("possession005");
         }
         var _loc2_:int = PossessionNode.CD_TIME - (FuncKit.currentTimeMillis() / 1000 - param1);
         if(_loc2_ <= 0)
         {
            if(PossessionNode.INCOME_TIME - (FuncKit.currentTimeMillis() / 1000 - param1) > 0)
            {
               return LangManager.getInstance().getLanguage("possession040");
            }
            return LangManager.getInstance().getLanguage("possession006");
         }
         var _loc3_:int = int(_loc2_ / 3600);
         var _loc4_:int = int((_loc2_ - _loc3_ * 60 * 60) / 60);
         var _loc5_:int = int(_loc2_ - _loc3_ * 3600 - _loc4_ * 60);
         return LangManager.getInstance().getLanguage("possession004",_loc3_,_loc4_);
      }
      
      private function miaobian() : void
      {
         TextFilter.MiaoBian(this._background._txt_name,1118481);
         TextFilter.MiaoBian(this._background._txt_grade,1118481);
         TextFilter.MiaoBian(this._background._txt_lasttime,1118481);
         TextFilter.MiaoBian(this._background._txt_cdtime,1118481);
         TextFilter.MiaoBian(this._background._txt_income,1118481);
      }
   }
}

