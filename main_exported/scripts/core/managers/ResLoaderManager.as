package core.managers
{
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import loading.UILoading;
   import utils.FuncKit;
   import zlib.event.ForeletEvent;
   
   public class ResLoaderManager
   {
      
      private static var m_instance:ResLoaderManager;
      
      private static var url_dic:Dictionary = new Dictionary(true);
      
      public function ResLoaderManager()
      {
         super();
      }
      
      public static function get instance() : ResLoaderManager
      {
         if(m_instance == null)
         {
            m_instance = new ResLoaderManager();
         }
         return m_instance;
      }
      
      public static function LoadSwfResByXml(param1:Function, param2:Sprite, param3:String, param4:String) : void
      {
         var m_uiLoad:UILoading = null;
         var onAllComp:Function = null;
         var onResloaded:Function = param1;
         var node:Sprite = param2;
         var headurl:String = param3;
         var url:String = param4;
         onAllComp = function(param1:ForeletEvent = null):void
         {
            m_uiLoad.remove();
            m_uiLoad = null;
            url_dic[url] = true;
            if(onResloaded != null)
            {
               onResloaded();
            }
         };
         if(url_dic[url] != null)
         {
            if(onResloaded != null)
            {
               onResloaded();
            }
            return;
         }
         m_uiLoad = new UILoading(node,headurl,url + "?" + FuncKit.currentTimeMillis());
         m_uiLoad.addEventListener(ForeletEvent.ALL_COMPLETE,onAllComp);
      }
   }
}

