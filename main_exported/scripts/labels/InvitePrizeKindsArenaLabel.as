package labels
{
   import com.net.http.Connection;
   import com.net.http.IConnection;
   import com.res.IDestroy;
   import constants.AMFConnectionConstants;
   import entity.Tool;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.APLManager;
   import manager.LangManager;
   import node.Icon;
   import pvz.arena.entity.ArenaPrize;
   import tip.ToolsTip;
   import utils.FuncKit;
   import utils.TextFilter;
   import zlib.utils.DomainAccess;
   
   public class InvitePrizeKindsArenaLabel extends Sprite implements IConnection, IDestroy
   {
      
      internal var _ap:ArenaPrize = null;
      
      internal var _mc:MovieClip = null;
      
      internal var tips:ToolsTip = null;
      
      public function InvitePrizeKindsArenaLabel()
      {
         super();
         var _loc1_:Class = DomainAccess.getClass("kindsArenaPrize");
         this._mc = new _loc1_();
         this._mc.visible = false;
         this.addEvent();
         addChild(this._mc);
         TextFilter.MiaoBian(this._mc["_txt_str2"],16777164,1,5,5);
         TextFilter.MiaoBian(this._mc["_txt_str3"],16777164,1,5,5);
      }
      
      public function getPositionY() : int
      {
         return this.y + 88;
      }
      
      public function netConnectionSend(param1:String, param2:String, param3:int, ... rest) : void
      {
         APLManager.reset(3);
         APLManager.reset(4);
         var _loc5_:Connection = new Connection(param1,this.onResult,this.onStatus);
         _loc5_.call(param2,param3);
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         if(param2)
         {
            this._ap.setIsGet(true);
            this._mc["_draw_already"].visible = true;
            PlantsVsZombies.showSystemErrorInfo(LangManager.getInstance().getLanguage("node005"));
         }
      }
      
      public function onStatus(param1:int, param2:Object) : void
      {
         if(param2.code == AMFConnectionConstants.RPC_ERROR_RUNTIME)
         {
            PlantsVsZombies.showSystemErrorInfo(AMFConnectionConstants.getErrorInfo(param2.description));
            PlantsVsZombies.showDataLoading(false);
         }
      }
      
      public function setInfo(param1:ArenaPrize, param2:Boolean) : void
      {
         this._ap = param1;
         if(param1.getIsGet() == 1)
         {
            if(!param2)
            {
               this._mc["_draw_already"].visible = false;
               this._mc["_draw_not"].visible = false;
            }
         }
         else
         {
            this._mc["_draw_already"].visible = false;
         }
         if(param1.getRankMin() == 0)
         {
            param1.setRankMin(1);
         }
         this.setArenaRank(param1.getRankMin(),param1.getRankMax());
         this.setTool(this._mc["_pic_0"],this._mc["_pic_num_0"],param1.getTools()[0] as Tool);
         this.setTool(this._mc["_pic_1"],this._mc["_pic_num_1"],param1.getTools()[1] as Tool);
         this._mc["_pic_0"].addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._mc["_pic_1"].addEventListener(MouseEvent.ROLL_OVER,this.onOver2);
         this._mc["_txt_str2"].text = (param1.getTools()[0] as Tool).getName();
         this._mc["_txt_str3"].text = (param1.getTools()[1] as Tool).getName();
         this._mc.visible = true;
      }
      
      private function setTool(param1:MovieClip, param2:MovieClip, param3:Tool) : void
      {
         Icon.setUrlIcon(param1,param3.getPicId(),Icon.TOOL_1);
         var _loc4_:DisplayObject = FuncKit.getNumEffect(param3.getNum() + "");
         _loc4_.x = -_loc4_.width;
         param2.addChild(_loc4_);
      }
      
      private function setArenaRank(param1:int, param2:int) : void
      {
         var _loc3_:DisplayObject = FuncKit.getNumEffect(param1 + "");
         var _loc4_:DisplayObject = FuncKit.getNumEffect(param2 + "");
         _loc3_.x = -_loc3_.width;
         this._mc["_pic_rank_1"].addChild(_loc3_);
         this._mc["_pic_rank_2"].addChild(_loc4_);
      }
      
      private function addEvent() : void
      {
         this._mc["_draw"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      public function destroy() : void
      {
         this._mc["_pic_0"].removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this._mc["_pic_1"].removeEventListener(MouseEvent.ROLL_OVER,this.onOver2);
         this._mc["_draw"].removeEventListener(MouseEvent.CLICK,this.onClick);
         FuncKit.clearAllChildrens(this);
      }
      
      private function getAward() : Array
      {
         var _loc3_:Array = null;
         var _loc1_:Array = new Array();
         var _loc2_:int = 0;
         while(_loc2_ < this._ap.getTools().length)
         {
            _loc3_ = new Array();
            _loc3_.push("tool");
            _loc3_.push((this._ap.getTools()[_loc2_] as Tool).getOrderId());
            _loc1_.push(_loc3_);
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function getPositionX() : int
      {
         if(this.parent.x + this.parent.parent.x + this.parent.parent.parent.x + this.x > 500)
         {
            return this.x - 200;
         }
         return this.x + 120;
      }
      
      private function getPrize() : void
      {
         this.netConnectionSend(PlantsVsZombies.getRPCUrl(),AMFConnectionConstants.RPC_ARENA_GET,0);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.name == "_draw")
         {
            this.getPrize();
         }
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         if(this.tips == null)
         {
            this.tips = new ToolsTip();
         }
         this.tips.setTooltip(this._mc._pic_0,this._ap.getTools()[0]);
         this.tips.setLoction(this.getPositionX(),this.getPositionY());
      }
      
      private function onOver2(param1:MouseEvent) : void
      {
         if(this.tips == null)
         {
            this.tips = new ToolsTip();
         }
         this.tips.setTooltip(this._mc._pic_1,this._ap.getTools()[1]);
         this.tips.setLoction(this.getPositionX(),this.getPositionY());
      }
   }
}

