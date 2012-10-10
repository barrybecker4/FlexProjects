package  com.becker.common {
    import flash.media.Sound;
    import flash.media.SoundTransform;
    

    public class Sounds
    {    
        
        [Embed(source="../../../assets/sounds/collision/hithard.mp3")]
        private static const hitClass:Class;

        [Embed(source="../../../assets/sounds/collision/scrapew.mp3")]
        private static const scrapeClass:Class;
    
        public function Sounds()
        {
        }
        
        public static function playHit(volume:Number = 1.0):void
        {
            playSound(hitClass, volume);
        }
        
        public static function playScrape(volume:Number = 1.0):void
        {
            playSound(scrapeClass, volume);
        }
        
        
        private static function playSound(soundClass:Class, volume:Number = 1.0):void
        {
            var sound:Sound = new soundClass() as Sound;
            var transform:SoundTransform = new SoundTransform(volume);
            sound.play(0, 1, transform);
            /*
            var soundEffect:SoundEffect = new SoundEffect();
            soundEffect.volumeFrom = volume;
            soundEffect.volumeTo = volume;
            soundEffect.source = soundClass;
            soundEffect.useDuration = false;
            soundEffect.play();
            */
        }
                       
    }
}