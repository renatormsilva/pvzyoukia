package windows
{
   import com.net.http.Connection;
   import constants.AMFConnectionConstants;
   import entity.EvolutionOrg;
   import entity.Task;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import manager.LangManager;
   import node.Icon;
   import pvz.compose.panel.ComposeWindowNew;
   import pvz.task.rpc.Task_rpc;
   import utils.FuncKit;
   import utils.GetDomainRes;
   
   public class ShortcutComposeWindow extends Sprite
   {
      
      private static var m_instance:ShortcutComposeWindow;
      
      private static var m_insCreating:Boolean;
      
      private static const UPDATA_TASK:int = 0;
      
      private static const UPDATA_RUSH:int = 1;
      
      private var myInterval:uint;
      
      private var _startP:Point = new Point(700,330);
      
      private var _endX:Number = 510;
      
      private var _mc:Sprite;
      
      private var _compData:Array;
      
      private var _currentOrgId:int;
      
      private var _index:int = 0;
      
      private var _evoluId:uint;
      
      private var _evolorg:EvolutionOrg;
      
      private var closed:Boolean = false;
      
      public function ShortcutComposeWindow()
      {
         super();
         this.name = "ShortcutComposeWindow";
      }
      
      public static function get getShortcutComposeInstance() : ShortcutComposeWindow
      {
         if(m_instance == null)
         {
            m_insCreating = true;
            m_instance = new ShortcutComposeWindow();
            m_insCreating = false;
         }
         return m_instance;
      }
      
      private function addEvents() : void
      {
         this._mc["close"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["left"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["right"].addEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["compose"].addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onDown(param1:MouseEvent) : void
      {
         this.stage.addEventListener(MouseEvent.MOUSE_UP,this.onUp);
         var _loc2_:Rectangle = new Rectangle(0,0,520,430);
         this.startDrag(false,_loc2_);
      }
      
      private function onUp(param1:MouseEvent) : void
      {
         this.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
         this.stopDrag();
      }
      
      private function removeEvents() : void
      {
         this._mc["close"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["left"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["right"].removeEventListener(MouseEvent.CLICK,this.onClick);
         this._mc["compose"].removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(param1:MouseEvent) : void
      {
         var _loc2_:ComposeWindowNew = null;
         switch(param1.currentTarget.name)
         {
            case "close":
               this.closed = true;
               this.hide();
               break;
            case "left":
               if(this._index <= 0)
               {
                  return;
               }
               --this._index;
               this.showOrg();
               break;
            case "right":
               if(this._index >= this._compData.length - 1)
               {
                  return;
               }
               ++this._index;
               this.showOrg();
               break;
            case "compose":
               _loc2_ = new ComposeWindowNew(null,this.upDateTask,false,true);
               _loc2_.appointToOrgId(this._evolorg.id);
               this.hide();
         }
      }
      
      public function connection() : void
      {
         if(this.closed)
         {
            return;
         }
         var _loc1_:Connection = new Connection(PlantsVsZombies.getRPCUrl(),this.onResult,this.onStatus);
         _loc1_.call(AMFConnectionConstants.RPC_GET_EVOLUTION_ORGS,UPDATA_RUSH);
      }
      
      public function upDateTask() : void
      {
         if(PlantsVsZombies._task != null && PlantsVsZombies._task.getStatus() == Task.STATUS_1)
         {
            return;
         }
         PlantsVsZombies.showDataLoading(true);
         var _loc1_:Connection = new Connection(PlantsVsZombies.getRPCUrl(),this.onResult,this.onStatus);
         _loc1_.call(AMFConnectionConstants.RPC_TASK_INFO,UPDATA_TASK);
      }
      
      public function onResult(param1:int, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Task_rpc = null;
         if(param1 == UPDATA_RUSH)
         {
            this.hide();
            if(param2 == null || (param2 as Array).length < 1)
            {
               return;
            }
            if(this._mc == null)
            {
               this._mc = GetDomainRes.getSprite("shortcutEvolutionWindow");
               this.addEvents();
            }
            if(!this.contains(this._mc))
            {
               this.addChild(this._mc);
            }
            if(!PlantsVsZombies._node.contains(this))
            {
               _loc3_ = PlantsVsZombies._node.getChildIndex(PlantsVsZombies._node["player_other"]);
               PlantsVsZombies._node.addChildAt(this,_loc3_);
            }
            this.readReData(param2 as Array);
            this.showOrg();
            this.show();
         }
         else if(param1 == UPDATA_TASK)
         {
            _loc4_ = new Task_rpc();
            PlantsVsZombies._task = _loc4_.getTask(param2);
            if(PlantsVsZombies.firstpage != null)
            {
               PlantsVsZombies.firstpage.showTaskType();
            }
            PlantsVsZombies.showDataLoading(false);
            this.connection();
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
      
      private function readReData(param1:Array) : void
      {
         var _loc2_:Object = null;
         var _loc3_:EvolutionOrg = null;
         if(param1 == null || param1.length < 1)
         {
            return;
         }
         this._compData = [];
         for each(_loc2_ in param1)
         {
            _loc3_ = new EvolutionOrg();
            _loc3_.id = _loc2_.id;
            _loc3_.picid = _loc2_.img_id;
            _loc3_.Info = _loc2_.name;
            this._compData.push(_loc3_);
         }
      }
      
      private function changevisible() : void
      {
         if(this._index == 0)
         {
            this._mc["left"].visible = false;
            if(this._compData.length == 1)
            {
               this._mc["right"].visible = false;
            }
            else
            {
               this._mc["right"].visible = true;
            }
         }
         else if(this._index == this._compData.length - 1)
         {
            this._mc["left"].visible = true;
            this._mc["right"].visible = false;
         }
         else
         {
            this._mc["left"].visible = true;
            this._mc["right"].visible = true;
         }
      }
      
      private function showOrg() : void
      {
         this.changevisible();
         FuncKit.clearAllChildrens(this._mc["picnode"]);
         this._evolorg = this._compData[this._index];
         if(this._evolorg == null)
         {
            return;
         }
         Icon.setUrlIcon(this._mc["picnode"],this._evolorg.picid,Icon.ORGANISM_1);
         var _loc1_:String = "</b></font><font color=\'#ff0000\' size=\'13\'><b>" + this._evolorg.Info + "</b></font><font size=\'13\'><b>";
         this._mc["txt"].htmlText = "<font size=\'13\'><b>" + LangManager.getInstance().getLanguage("window171",_loc1_) + "</b></font>";
         this._mc["txt"].selectable = false;
      }
      
      private function show() : void
      {
         if(this.x == this._endX)
         {
            return;
         }
         this.x = this._startP.x;
         this.y = this._startP.y;
         this.myInterval = setInterval(this.move,5);
      }
      
      private function move() : void
      {
         this.x += (this._endX - this._startP.x) * 0.1;
         if(this.x <= this._endX)
         {
            this.x = this._endX;
            clearInterval(this.myInterval);
         }
      }
      
      public function hide() : void
      {
         if(PlantsVsZombies._node.getChildByName("ShortcutComposeWindow") == null)
         {
            return;
         }
         clearInterval(this.myInterval);
         this._compData = null;
         this.x = this._startP.x;
         this._index = 0;
         FuncKit.clearAllChildrens(this._mc["picnode"]);
         this.removeEvents();
         this.removeChild(this._mc);
         this._mc = null;
         this.parent.removeChild(this);
      }
   }
}

