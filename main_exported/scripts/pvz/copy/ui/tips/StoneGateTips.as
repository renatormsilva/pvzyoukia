package pvz.copy.ui.tips
{
   import manager.LangManager;
   import pvz.copy.models.stone.StoneGateData;
   import pvz.genius.tips.BaseSectionsTips;
   
   public class StoneGateTips extends BaseSectionsTips
   {
      
      private var infoItem1:TipsItem;
      
      private var infoItem2:TipsItem;
      
      private var infoItem3:TipsItem;
      
      public function StoneGateTips()
      {
         super("stone.chapterTips",false);
      }
      
      override public function show(param1:Object) : void
      {
         createTips();
         var _loc2_:StoneGateData = param1 as StoneGateData;
         var _loc3_:Array = _loc2_.getMustReward();
         var _loc4_:Array = _loc2_.getPostReward();
         var _loc5_:Array = _loc2_.getThroughReward();
         var _loc6_:String = _loc2_.getName();
         var _loc7_:Boolean = _loc2_.getBoss() == 1 ? true : false;
         this.infoItem1 = new TipsItem(LangManager.getInstance().getLanguage("copy003"),_loc3_);
         this.infoItem2 = new TipsItem(LangManager.getInstance().getLanguage("copy004"),_loc4_,true);
         this.infoItem3 = new TipsItem(LangManager.getInstance().getLanguage("copy010"),_loc5_);
         if(_loc7_)
         {
            _ui.name_txt.text = _loc6_;
         }
         else
         {
            _ui.name_txt.htmlText = "<font color=\'#ffffff\' size=\'15\'><center>" + _loc6_ + "</center></font>";
         }
         _ui.isBoss.visible = _loc7_;
         _bg.addChild(this.infoItem1);
         _bg.addChild(this.infoItem2);
         _bg.addChild(this.infoItem3);
         _layout.addDisToGroup(this.infoItem1);
         _layout.addDisToGroup(this.infoItem2);
         _layout.addDisToGroup(this.infoItem3);
         reLayout();
      }
      
      override public function clear() : void
      {
         if(this.infoItem1 != null)
         {
            this.infoItem1.clear();
         }
         if(this.infoItem2 != null)
         {
            this.infoItem2.clear();
         }
         if(this.infoItem3 != null)
         {
            this.infoItem3.clear();
         }
         _layout.clearGroup();
      }
   }
}

