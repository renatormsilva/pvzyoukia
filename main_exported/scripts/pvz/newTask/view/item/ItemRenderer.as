package pvz.newTask.view.item
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import manager.JSManager;
   import manager.TeachHelpManager;
   import pvz.newTask.ctrl.NewTaskCtrl;
   import pvz.newTask.data.TaskVo;
   import pvz.registration.view.panel.module.HtmlUtil;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import windows.PrizesWindow;
   import zlib.utils.Func;
   
   public class ItemRenderer extends Sprite
   {
      
      private var _task:TaskVo;
      
      private var item:MovieClip;
      
      private var iconSp:MovieClip;
      
      private var title:TextField;
      
      private var dis:TextField;
      
      private var sp:Sprite;
      
      private var tag:MovieClip;
      
      private var btn:MovieClip;
      
      private var numTxt:Sprite;
      
      private var isOver:MovieClip;
      
      private var reTxt:TextField;
      
      public function ItemRenderer()
      {
         super();
         this.init();
      }
      
      public static function layoutHorizontal(param1:DisplayObjectContainer, param2:Number = 0, param3:int = 0) : void
      {
         var _loc7_:DisplayObject = null;
         if(!param1)
         {
            return;
         }
         var _loc4_:int = param1.numChildren;
         if(_loc4_ == 0)
         {
            return;
         }
         var _loc5_:int = param3;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = param1.getChildAt(_loc6_);
            _loc7_.x = _loc5_;
            _loc5_ = _loc7_.width + _loc7_.x + param2;
            _loc6_++;
         }
      }
      
      private function init() : void
      {
         this.item = GetDomainRes.getMoveClip("pvz.newTask.item");
         this.title = this.item.title;
         this.dis = this.item.dis;
         this.iconSp = this.item.icon;
         this.addChild(this.item);
         this.numTxt = new Sprite();
         this.numTxt.x = 520;
         this.numTxt.y = 13;
         this.numTxt.visible = false;
         this.addChild(this.numTxt);
         this.tag = GetDomainRes.getMoveClip("pvz.newTask.tag");
         this.tag.gotoAndStop(1);
         this.tag.x = 505;
         this.tag.y = 10;
         this.tag.visible = false;
         this.addChild(this.tag);
         this.btn = GetDomainRes.getMoveClip("pvz.newTask.taskBtn");
         this.btn.gotoAndStop(1);
         this.btn.x = 475;
         this.btn.y = 60;
         this.addChild(this.btn);
         this.sp = new Sprite();
         this.sp.x = 143;
         this.sp.y = 60;
         this.addChild(this.sp);
         this.addEvent();
      }
      
      public function setData(param1:TaskVo) : void
      {
         var obj:Object = null;
         var icon:Bitmap = null;
         var ty:int = 0;
         var dis1:DisplayObject = null;
         var dis2:DisplayObject = null;
         var res:String = null;
         var xie:Bitmap = null;
         var reward:ItemReward = null;
         var task:TaskVo = param1;
         Func.clearAllChildrens(this.iconSp);
         Func.clearAllChildrens(this.sp);
         this._task = task;
         try
         {
            icon = GetDomainRes.getBitmap("task_" + task.icon);
         }
         catch(e:Error)
         {
            icon = GetDomainRes.getBitmap("task_" + 1);
         }
         this.iconSp.addChild(icon);
         this.title.htmlText = HtmlUtil.bold(task.title);
         this.dis.htmlText = task.dis;
         if(task.maxCount > 0)
         {
            this.tag.visible = false;
            ty = task.curCount < task.maxCount ? 0 : 1;
            dis1 = this.getNumBit(task.curCount,ty);
            dis2 = this.getNumBit(task.maxCount,ty);
            res = ty ? "pvz.newTask.taskxiegang1" : "pvz.newTask.taskxiegang";
            xie = GetDomainRes.getBitmap(res);
            this.numTxt.addChild(dis1);
            this.numTxt.addChild(xie);
            this.numTxt.addChild(dis2);
            this.numTxt.visible = true;
            layoutHorizontal(this.numTxt);
            this.numTxt.x = 592 - this.numTxt.width - 10;
         }
         else
         {
            this.numTxt.visible = false;
            if(task.state)
            {
               this.tag.gotoAndStop(2);
               this.tag.visible = true;
            }
            else
            {
               this.tag.gotoAndStop(1);
               this.tag.visible = true;
            }
         }
         if(task.state)
         {
            this.btn.mouseEnabled = true;
            this.btn.buttonMode = true;
            this.btn.gotoAndStop(2);
         }
         else if(task.gotoId)
         {
            this.btn.mouseEnabled = true;
            this.btn.buttonMode = true;
            this.btn.gotoAndStop(3);
         }
         else
         {
            this.btn.gotoAndStop(1);
            this.btn.buttonMode = false;
            this.btn.mouseEnabled = false;
         }
         for each(obj in task.reward)
         {
            reward = new ItemReward();
            reward.upData(obj);
            this.sp.addChild(reward);
         }
         layoutHorizontal(this.sp);
      }
      
      public function addEvent() : void
      {
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.remove);
         this.btn.addEventListener(MouseEvent.CLICK,this.btnClick);
      }
      
      public function delEvent() : void
      {
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.remove);
         this.btn.removeEventListener(MouseEvent.CLICK,this.btnClick);
      }
      
      private function btnClick(param1:MouseEvent) : void
      {
         if(this.btn.currentFrame == 2)
         {
            if(this._task.id == 125)
            {
               this.showCollectionGameJs();
            }
            NewTaskCtrl.getNewTaskCtrl().getTaskReward(this._task.id,NewTaskCtrl.getNewTaskCtrl().getCurTyp(),this.getReward);
         }
         else if(this.btn.currentFrame == 3)
         {
            NewTaskCtrl.getNewTaskCtrl().Close();
            TeachHelpManager.I.hideArrow();
            PlantsVsZombies.firstpage.gotoScence(this._task.gotoId);
         }
      }
      
      private function getReward() : void
      {
         var _loc1_:PrizesWindow = new PrizesWindow(NewTaskCtrl.getNewTaskCtrl().refTask,PlantsVsZombies._node);
         _loc1_.show(this._task.reward,NewTaskCtrl.getNewTaskCtrl().startUp);
         NewTaskCtrl.getNewTaskCtrl().addPrize(this._task.reward);
      }
      
      public function remove(param1:Event) : void
      {
         this.delEvent();
         FuncKit.clearAllChildrens(this);
         this._task = null;
      }
      
      private function getNumBit(param1:Number, param2:int = 0) : DisplayObject
      {
         var _loc3_:DisplayObject = null;
         var _loc5_:Number = NaN;
         var _loc6_:Sprite = null;
         var _loc7_:DisplayObject = null;
         var _loc8_:Bitmap = null;
         var _loc9_:DisplayObject = null;
         var _loc4_:String = param2 ? "Feared" : "Fear";
         if(param1 < FuncKit.YI && param1 > FuncKit.WAN)
         {
            _loc5_ = Math.floor(param1 / FuncKit.WAN);
            _loc6_ = new Sprite();
            _loc7_ = _loc6_.addChild(FuncKit.getNumEffect(_loc5_ + "",_loc4_));
            if(param2 == 0)
            {
               _loc7_.scaleX = _loc7_.scaleY = 0.55;
            }
            _loc8_ = param2 ? GetDomainRes.getBitmap("pvz.newTask.wan1") : GetDomainRes.getBitmap("pvz.newTask.wan");
            _loc9_ = _loc6_.addChild(_loc8_);
            _loc9_.x = _loc7_.width;
            _loc7_.y = 0;
            _loc9_.y = 0;
            _loc3_ = _loc6_;
         }
         else
         {
            _loc3_ = FuncKit.getNumDisplayObject(param1,_loc4_);
            if(param2 == 0)
            {
               _loc3_.scaleX = _loc3_.scaleY = 0.55;
            }
         }
         return _loc3_;
      }
      
      private function showCollectionGameJs() : void
      {
         JSManager.gotoJsTask();
      }
   }
}

