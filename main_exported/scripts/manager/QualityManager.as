package manager
{
   public class QualityManager
   {
      
      public static const LIEZHI:int = 1;
      
      public static const PUTONG:int = 2;
      
      public static const YOUXIU:int = 3;
      
      public static const JINGLIANG:int = 4;
      
      public static const JIPING:int = 5;
      
      public static const SHISHI:int = 6;
      
      public static const CHUANSHUO:int = 7;
      
      public static const SHENQI:int = 8;
      
      public static const MOWANG:int = 9;
      
      public static const ZHANSHEN:int = 10;
      
      public static const ZHIZUN:int = 11;
      
      public static const MOSHEN:int = 12;
      
      public static const YAOSI:int = 13;
      
      public static const BUXIU:int = 14;
      
      public static const YONGHENG:int = 15;
      
      public static const TAISHANG:int = 16;
      
      public static const HUNDUN:int = 17;
      
      public static const WUJI:int = 18;
      
      public function QualityManager()
      {
         super();
      }
      
      public static function getQualityIdByLevel(param1:uint) : int
      {
         var _loc2_:int = 0;
         if(param1 > 0 && param1 < MOSHEN)
         {
            _loc2_ = ToolManager.TOOL_COMP_QUALITY;
         }
         else if(param1 == MOSHEN)
         {
            _loc2_ = ToolManager.TOOL_COMP_QUALITY_YAOSI;
         }
         else if(param1 == YAOSI)
         {
            _loc2_ = ToolManager.TOOL_COMP_QUALITY_BUXIU;
         }
         else if(param1 == BUXIU)
         {
            _loc2_ = ToolManager.TOOL_COMP_QUALITY_YONGHENG;
         }
         else if(param1 == YONGHENG)
         {
            _loc2_ = ToolManager.TOOL_COMP_QUALITY_TAISHANG;
         }
         else if(param1 == TAISHANG)
         {
            _loc2_ = ToolManager.TOOL_COMP_QUALITY_HUNDUN;
         }
         else if(param1 == HUNDUN)
         {
            _loc2_ = ToolManager.TOOL_COMP_QUALITY_WUJI;
         }
         else
         {
            if(param1 != WUJI)
            {
               throw new Error("不能提升品质！！");
            }
            _loc2_ = ToolManager.TOOL_COMP_QUALITY_WUJI;
         }
         return _loc2_;
      }
      
      public static function getQualityLevelByName(param1:String) : int
      {
         switch(param1)
         {
            case "劣质":
               return LIEZHI;
            case "普通":
               return PUTONG;
            case "优秀":
               return YOUXIU;
            case "精良":
               return JINGLIANG;
            case "极品":
               return JIPING;
            case "史诗":
               return SHISHI;
            case "传说":
               return CHUANSHUO;
            case "神器":
               return SHENQI;
            case "魔王":
               return MOWANG;
            case "战神":
               return ZHANSHEN;
            case "至尊":
               return ZHIZUN;
            case "魔神":
               return MOSHEN;
            case "耀世":
               return YAOSI;
            case "不朽":
               return BUXIU;
            case "永恒":
               return YONGHENG;
            case "太上":
               return TAISHANG;
            case "混沌":
               return HUNDUN;
            case "无极":
               return WUJI;
            default:
               return 0;
         }
      }
      
      public static function getQualityPullulateQue(param1:Number) : Number
      {
         var _loc2_:Number = 0;
         if(param1 >= 0 && param1 <= MOSHEN)
         {
            _loc2_ = 1 + (param1 - 1) * 0.05;
         }
         else if(param1 == YAOSI)
         {
            _loc2_ = 1.65;
         }
         else if(param1 > HUNDUN)
         {
            _loc2_ = 2.6;
         }
         else if(param1 > TAISHANG)
         {
            _loc2_ = 2.35;
         }
         else if(param1 > YONGHENG)
         {
            _loc2_ = 2.2;
         }
         else if(param1 > YAOSI)
         {
            _loc2_ = 1.5 + 0.15 * Math.pow(2,param1 - 13);
         }
         return _loc2_;
      }
   }
}

