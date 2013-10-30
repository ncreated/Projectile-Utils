package {
    import com.bit101.components.PushButton;

    import flash.display.Sprite;

    /**
     *
     * @author maciek grzybowski, 30.10.2013 23:55
     *
     */
    public class SettingsPanel extends Sprite {

        private var _button:PushButton;

        public function SettingsPanel() {
            _button = new PushButton();
            _button.x = 10;
            _button.y = 10;
            _button.label = "Hello!";
            addChild(_button);
        }
    }
}
