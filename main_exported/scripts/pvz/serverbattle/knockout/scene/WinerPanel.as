package pvz.serverbattle.knockout.scene
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import utils.FuncKit;
   import utils.GetDomainRes;
   import zmyth.ui.TextFilter;
   
   public class WinerPanel extends Sprite
   {
      
      private var panel:MovieClip;
      
      public function WinerPanel()
      {
         super();
         if(this.panel == null)
         {
            this.panel = GetDomainRes.getMoveClip("serverBattle.knockout.winer");
         }
         this.addChild(this.panel);
         TextFilter.MiaoBian(this.panel["nickname"],0);
         TextFilter.MiaoBian(this.panel["servername"],0);
      }
      
      public function destory() : void
      {
         this.panel["gx"].stop();
         this.removeChild(this.panel);
      }
      
      public function initUi(param1:Pothunter = null) : void
      {
         if(param1 == null)
         {
            return;
         }
         FuncKit.clearAllChildrens(this.panel["pic"]);
         PlantsVsZombies.setHeadPic(this.panel["pic"],PlantsVsZombies.getHeadPicUrl(param1.getfaceurl()),PlantsVsZombies.HEADPIC_BIG,param1.getviptime(),param1.getvipgrade());
         this.panel["nickname"].text = param1.getnickName();
         this.panel["nickname"].selectable = false;
         this.panel["servername"].text = param1.getservername();
         this.panel["servername"].selectable = false;
      }
   }
}

