package tip
{
   import com.res.IDestroy;
   import entity.Organism;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import manager.ArtWordsManager;
   import manager.LangManager;
   import utils.FuncKit;
   import utils.GetDomainRes;
   
   public class OrgUpInfoTips extends Sprite implements IDestroy
   {
      
      private var _mc:MovieClip;
      
      private var _line1:TextField;
      
      private var _tHp:MovieClip;
      
      private var _tAttack:MovieClip;
      
      private var _tNew_Miss:MovieClip;
      
      private var _tNew_Precision:MovieClip;
      
      private var _tMiss:MovieClip;
      
      private var _tPrecision:MovieClip;
      
      private var _tSpeed:MovieClip;
      
      private var _baseOrg:Organism;
      
      private var _org:Organism;
      
      private var _o:InteractiveObject;
      
      public function OrgUpInfoTips()
      {
         super();
         this._mc = GetDomainRes.getMoveClip("tip.orgUpInfoTip");
         this.addChild(this._mc);
         this._line1 = this._mc["line1"];
         this._tHp = this._mc["hp_txt"];
         this._tAttack = this._mc["attack_txt"];
         this._tNew_Miss = this._mc["new_miss_txt"];
         this._tNew_Precision = this._mc["new_precision_txt"];
         this._tMiss = this._mc["miss_txt"];
         this._tPrecision = this._mc["precision_txt"];
         this._tSpeed = this._mc["speed_txt"];
      }
      
      public function setOrgTip(param1:InteractiveObject, param2:Organism, param3:Organism) : void
      {
         this._baseOrg = param2;
         this._org = param3;
         this._o = param1;
         this.setTxt();
         this.setLoction(400,350);
         if(parent == null)
         {
            PlantsVsZombies._node.addChild(this);
         }
         else
         {
            parent.setChildIndex(this,parent.numChildren - 1);
         }
         this._o.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      public function setLoction(param1:Number, param2:Number) : void
      {
         this.x = this._o.x + this._o.parent.x + this._o.parent.parent.x - this.width / 2 + param1;
         this.y = this._o.y + this._o.parent.y + this._o.parent.parent.y - this.height + param2;
      }
      
      private function setTxt() : void
      {
         var _loc1_:String = this.getRedColorStr(this._org.getGrade());
         this._line1.htmlText = LangManager.getInstance().getLanguage("battle015",this._baseOrg.getName(),this._baseOrg.getGrade(),_loc1_);
         this._tHp.addChild(ArtWordsManager.instance.getArtWordByTwoNumber(this._baseOrg.getHp_max().toNumber(),this._org.getHp_max().toNumber(),16777215,65280,13,1,true));
         this._tAttack.addChild(ArtWordsManager.instance.getArtWordByTwoNumber(this._baseOrg.getAttack(),this._org.getAttack(),16777215,65280,13,1,true));
         this._tNew_Miss.addChild(ArtWordsManager.instance.getArtWordByTwoNumber(this._baseOrg.getNewMiss(),this._org.getNewMiss(),16777215,65280,13,1,true));
         this._tNew_Precision.addChild(ArtWordsManager.instance.getArtWordByTwoNumber(this._baseOrg.getNewPrecision(),this._org.getNewPrecision(),16777215,65280,13,1,true));
         this._tMiss.addChild(ArtWordsManager.instance.getArtWordByTwoNumber(this._baseOrg.getMiss(),this._org.getMiss(),16777215,65280,13,1,true));
         this._tPrecision.addChild(ArtWordsManager.instance.getArtWordByTwoNumber(this._baseOrg.getPrecision(),this._org.getPrecision(),16777215,65280,13,1,true));
         this._tSpeed.addChild(ArtWordsManager.instance.getArtWordByTwoNumber(this._baseOrg.getSpeed(),this._org.getSpeed(),16777215,65280,13,1,true));
      }
      
      private function getRedColorStr(param1:Object) : String
      {
         return "<font color=\'#00ff00\'>" + String(param1) + "</font>";
      }
      
      protected function onOut(param1:MouseEvent) : void
      {
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
         parent.removeChild(this);
         this._o.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
      }
      
      public function destroy() : void
      {
         if(this._o.hasEventListener(MouseEvent.ROLL_OUT))
         {
            this._o.removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
         }
         FuncKit.clearAllChildrens(this);
         this._mc = null;
         this._baseOrg = null;
         this._org = null;
      }
   }
}

