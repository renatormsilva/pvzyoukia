package pvz.copy.ui.sprites
{
   import com.res.IDestroy;
   import entity.Tool;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import manager.LangManager;
   import pvz.copy.models.limit.LimitCheckPointVo;
   import pvz.copy.ui.tips.LimitCheckPonitTips;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import utils.TextFilter;
   
   public class LimitCheckPointSprite extends Sprite implements IDestroy
   {
      
      private var _data:LimitCheckPointVo;
      
      private var _callback:Function;
      
      private var _tips:LimitCheckPonitTips;
      
      private var _mc:MovieClip;
      
      private var _isClick:Boolean = true;
      
      public function LimitCheckPointSprite(param1:LimitCheckPointVo, param2:Function)
      {
         super();
         this.mouseEnabled = true;
         this.mouseChildren = false;
         this.buttonMode = true;
         this._mc = GetDomainRes.getMoveClip("pvz.limitcopy.checkPointNode");
         this._mc["bossIcon"].visible = false;
         this._mc.bg1.visible = false;
         addChild(this._mc);
         this._data = param1;
         this._callback = param2;
         this.addEvent();
         this.initView();
         TextFilter.MiaoBian(this._mc["name_txt"],1118481);
         TextFilter.MiaoBian(this._mc["exp_times"],17895697);
         TextFilter.MiaoBian(this._mc["challage_times"],1118481);
      }
      
      private function addEvent() : void
      {
         addEventListener(MouseEvent.MOUSE_UP,this.onHandler);
         addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      private function onOut(param1:MouseEvent) : void
      {
         if(this._isClick)
         {
            TextFilter.removeFilter(this._mc["picNode"]);
         }
         if(this._tips)
         {
            this._tips.destroy();
            this._tips.hideTips();
         }
      }
      
      private function onOver(param1:MouseEvent) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:Tool = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:Tool = null;
         if(this._isClick)
         {
            TextFilter.MiaoBian(this._mc["picNode"],16776960,0.6,6,6);
         }
         if(this._data.getPrizeExp() <= 0 && this._data.getPrizeMoney() <= 0 && this._data.getToolsForMaybe() == null && this._data.getToolsForSure() == null)
         {
            return;
         }
         if(this._tips == null)
         {
            this._tips = new LimitCheckPonitTips();
         }
         var _loc2_:Object = new Object();
         if(this._data.getToolsForMaybe())
         {
            _loc3_ = new Array();
            for each(_loc4_ in this._data.getToolsForMaybe())
            {
               _loc5_ = new Tool(_loc4_);
               _loc3_.push(_loc5_);
            }
            _loc2_.maybeTools = _loc3_;
         }
         if(this._data.getToolsForSure())
         {
            _loc6_ = new Array();
            for each(_loc7_ in this._data.getToolsForSure())
            {
               _loc8_ = new Tool(_loc7_);
               _loc6_.push(_loc8_);
            }
            _loc2_.sureTools = _loc6_;
         }
         if(this._data.getPrizeMoney() > 0)
         {
            _loc2_.money = this._data.getPrizeMoney();
         }
         if(this._data.getPrizeExp() > 0)
         {
            _loc2_.exp = this._data.getPrizeExp();
         }
         this._tips.initTips(_loc2_,this._data.getNameStr());
         this._tips.showTips(param1);
      }
      
      private function onHandler(param1:MouseEvent) : void
      {
         if(this._data.getStaus() == 3)
         {
            return;
         }
         if(this._data.getChallageTimes() == 0)
         {
            FuncKit.showSystermInfo(LangManager.getInstance().getLanguage("activtyCopy014"));
            return;
         }
         if(this._callback != null)
         {
            this._callback(this._data);
         }
      }
      
      private function initView() : void
      {
         if(this._data.getChallageTimes() != -1)
         {
            this._mc.bg1.visible = true;
            this._mc["challage_times"].text = LangManager.getInstance().getLanguage("activtyCopy004") + this._data.getChallageTimes();
         }
         this._mc["name_txt"].text = this._data.getNameStr();
         this._mc["picNode"].addChild(GetDomainRes.getDisplayObject("pvz.avatar" + this._data.getPicid()));
         this._mc["exp_times"].text = this._data.getExpTimes();
         if(this._data.isBossCp())
         {
            this._mc["bossIcon"].visible = true;
         }
         if(this._data.getStaus() != 2)
         {
            if(this._data.getStaus() == 3)
            {
               this.buttonMode = false;
               this._isClick = false;
               FuncKit.setNoColor(this._mc["picNode"]);
               FuncKit.setNoColor(this._mc["bossIcon"]);
            }
         }
      }
      
      public function destroy() : void
      {
         FuncKit.clearNoColorState(this);
         removeEventListener(MouseEvent.MOUSE_UP,this.onHandler);
         removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
         removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
   }
}

