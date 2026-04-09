package core.managers
{
   import core.interfaces.IPanel;
   import core.interfaces.IScene;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.MouseEvent;
   
   public class GameManager
   {
      
      private static var m_instance:GameManager;
      
      public static var m_gameHeight:Number;
      
      public static var m_gameWidth:Number;
      
      public static var pvzStage:Stage;
      
      private var m_node:Sprite;
      
      private var m_topLayer:Sprite;
      
      private var m_panelLayer:Sprite;
      
      private var m_scenceLayer:Sprite;
      
      private var m_tiplayer:Sprite;
      
      private var m_draglayer:Sprite;
      
      private var m_currTipsList:Array = [];
      
      private var m_backgroud:Shape;
      
      public function GameManager()
      {
         super();
      }
      
      public static function getInstance() : GameManager
      {
         if(m_instance == null)
         {
            m_instance = new GameManager();
         }
         return m_instance;
      }
      
      public function init(param1:Sprite, param2:Sprite) : void
      {
         param1.addChild(param2);
         this.m_node = param2;
         pvzStage = this.m_node.stage;
         m_gameWidth = this.m_node.stage.stageWidth;
         m_gameHeight = this.m_node.stage.stageHeight;
         this.m_backgroud = this.BG();
         this.initPvzLayer();
      }
      
      private function initPvzLayer() : void
      {
         this.m_topLayer = new Sprite();
         this.m_panelLayer = new Sprite();
         this.m_scenceLayer = new Sprite();
         this.m_tiplayer = new Sprite();
         this.m_draglayer = new Sprite();
         this.m_node.stage.addChild(this.m_scenceLayer);
         this.m_node.stage.addChild(this.m_panelLayer);
         this.m_node.stage.addChild(this.m_draglayer);
         this.m_node.stage.addChild(this.m_tiplayer);
         this.m_node.stage.addChild(this.m_topLayer);
      }
      
      public function set framerate(param1:int) : void
      {
         if(this.m_node == null)
         {
            throw new Error("Root is null!");
         }
         this.m_node.stage.frameRate = param1;
      }
      
      public function get pvzNode() : Sprite
      {
         return this.m_node;
      }
      
      public function get draglayer() : Sprite
      {
         return this.m_draglayer;
      }
      
      public function get toplayer() : Sprite
      {
         return this.m_topLayer;
      }
      
      public function get scenceLayer() : Sprite
      {
         return this.m_scenceLayer;
      }
      
      public function get panelLayer() : Sprite
      {
         return this.m_panelLayer;
      }
      
      private function BG() : Shape
      {
         var _loc1_:Shape = new Shape();
         _loc1_.graphics.beginFill(16777215,0.01);
         _loc1_.graphics.drawRect(0,0,m_gameWidth,m_gameHeight);
         _loc1_.graphics.endFill();
         return _loc1_;
      }
      
      public function showPanel(param1:*) : void
      {
         if(param1 is IPanel)
         {
            this.m_panelLayer.addChildAt(this.m_backgroud,0);
            this.m_backgroud.visible = true;
            this.m_topLayer.addChild(param1);
         }
         else if(param1 is IScene)
         {
            this.m_scenceLayer.addChild(param1);
         }
      }
      
      public function hidePanel(param1:*) : void
      {
         if(param1.parent != null)
         {
            if(param1 is IPanel)
            {
               this.m_backgroud.visible = false;
            }
            param1.parent.removeChild(param1);
         }
      }
      
      public function showTips(param1:DisplayObject, param2:MouseEvent) : void
      {
         if(param1 != null && param2 != null)
         {
            param1.x = param2.stageX + 10;
            param1.y = param2.stageY + 2;
         }
         if(param1.x + param1.width > m_gameWidth)
         {
            param1.x = m_gameWidth - param1.width * 2;
         }
         if(param1.y + param1.height > m_gameHeight)
         {
            param1.y = m_gameHeight - param1.height;
         }
         if(param1.x < 0)
         {
            param1.x = 0;
         }
         if(param1.y < 0)
         {
            param1.y = 0;
         }
         if(this.m_currTipsList.indexOf(param1) < 0)
         {
            this.m_currTipsList.push(param1);
         }
         this.m_tiplayer.addChild(param1);
      }
      
      public function hideTips() : void
      {
         var _loc1_:DisplayObject = null;
         for each(_loc1_ in this.m_currTipsList)
         {
            if(_loc1_ != null && _loc1_.parent != null)
            {
               _loc1_.parent.removeChild(_loc1_);
               if(Object(_loc1_).clear != null)
               {
                  Object(_loc1_).clear();
               }
            }
         }
         this.m_currTipsList.length = 0;
      }
   }
}

