package {
    import com.bit101.components.NumericStepper;
    import com.bit101.components.PushButton;
    import com.bit101.components.RadioButton;
    import com.bit101.components.VBox;
    import com.bit101.utils.MinimalConfigurator;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;

    /**
     *
     * @author maciek grzybowski, 30.10.2013 23:55
     *
     */
    public class SettingsPanel extends Sprite {

        private var _model:SimulationModel;

        private var _config:MinimalConfigurator;

        public function SettingsPanel(rect:Rectangle, model:SimulationModel) {
            _model = model;

            var bg:Sprite = new Sprite();
            bg.graphics.beginFill(0xEEEEEE);
            bg.graphics.drawRect(0, 0, rect.width, rect.height);
            bg.graphics.endFill();
            addChild(bg);

            var layout:XML =    <comps>
                                    <VBox x="10" y="10">
                                        <Label text="time step:"/>
                                        <RadioButton label="1/60s" groupName="stepTime" event="click:onStepTimeChanged" selected="false" />
                                        <RadioButton label="1/40s" groupName="stepTime" event="click:onStepTimeChanged" selected="false" />
                                        <RadioButton label="1/30s" groupName="stepTime" event="click:onStepTimeChanged" selected="false" />
                                        <RadioButton label="1/20s" groupName="stepTime" event="click:onStepTimeChanged" selected="false" />
                                    </VBox>
                                    <VBox x="90" y="10">
                                        <Label text="mode:"/>
                                        <RadioButton label="adjust velocity" groupName="fixMode" event="click:onFixModeChanged" selected="false" />
                                        <RadioButton label="adjust angle" groupName="fixMode" event="click:onFixModeChanged" selected="false" />
                                    </VBox>
                                    <VBox x="230" y="10" id="timeVBox">
                                        <Label text="steps number:"/>
                                        <NumericStepper id="stepsNS" minimum="10" maximum="200" step="1" value="80" repeatTime="0" event="change:onStepsChanged" />
                                    </VBox>

                                    <VBox x="230" y="60" id="velocityVBox">
                                    </VBox>
                                    <PushButton id="launchButton" x="530" y="10" width="100" height="100" label="LAUNCH" event="click:onLaunchClicked"/>
                                </comps>

            if (_model.stepTime <= 1/60) layout.VBox[0].RadioButton[0].@selected = true;
            else if (_model.stepTime <= 1/40) layout.VBox[0].RadioButton[1].@selected = true;
            else if (_model.stepTime <= 1/30) layout.VBox[0].RadioButton[2].@selected = true;
            else if (_model.stepTime <= 1/20) layout.VBox[0].RadioButton[3].@selected = true;

            if (_model.mode == SimulationModel.MODE_ADJUST_VELOCITY) layout.VBox[1].RadioButton[0].@selected = true;
            else if (_model.mode == SimulationModel.MODE_ADJUST_ANGLE) layout.VBox[1].RadioButton[1].@selected = true;

            layout.VBox[2].NumericStepper.@value = _model.steps;

            _config = new MinimalConfigurator(this);
            _config.parseXML(layout);

            _model.stateChanged.add(stateChanged);
            _model.modeChanged.add(modeChanged);
            _model.stepsChanged.add(stepsChanged);
        }

        public function onStepTimeChanged(event:Event):void {
            _model.state = SimulationModel.STATE_AIM;
            var button:RadioButton = event.currentTarget as RadioButton;
            switch (button.label) {
                case "1/60s":
                    _model.stepTime = 1/60;
                    break;
                case "1/40s":
                    _model.stepTime = 1/40;
                    break;
                case "1/30s":
                    _model.stepTime = 1/30;
                    break;
                case "1/20s":
                    _model.stepTime = 1/20;
                    break;

            }
        }

        public function onStepsChanged(event:Event):void {
            _model.state = SimulationModel.STATE_AIM;
            var stepper:NumericStepper = event.currentTarget as NumericStepper;
            _model.steps = stepper.value;
        }

        public function onFixModeChanged(event:Event):void {
            var button:RadioButton = event.currentTarget as RadioButton;
            switch (button.label) {
                case "adjust velocity":
                    _model.mode = SimulationModel.MODE_ADJUST_VELOCITY;
                    break;
                case "adjust angle":
                    _model.mode = SimulationModel.MODE_ADJUST_ANGLE;
                    break;

            }
        }

        public function onLaunchClicked(event:MouseEvent):void {
            _model.state = (_model.state + 1) % 2;
        }

        //

        private function stateChanged(new_state:int):void {
            if (new_state == SimulationModel.STATE_AIM) {
                _launchButton.label = "LAUNCH";
            }
            else if (new_state == SimulationModel.STATE_LAUNCHED) {
                _launchButton.label = "RESET";
            }
        }

        private function modeChanged(new_mode:int):void {
            if (new_mode == SimulationModel.MODE_ADJUST_VELOCITY) {
                _timeVBox.enabled = true;
                _velocityVBox.enabled = false;
            }
            else if (new_mode == SimulationModel.MODE_ADJUST_ANGLE) {
                _timeVBox.enabled = false;
                _velocityVBox.enabled = true;
            }
        }

        private function stepsChanged(new_steps:int):void {
            if (_model.mode != SimulationModel.MODE_ADJUST_ANGLE) {
                _stepsNS.value = new_steps;
            }
        }

        // getters

        private function get _launchButton():PushButton {
            return _config.getCompById("launchButton") as PushButton;
        }

        private function get _velocityVBox():VBox {
            return _config.getCompById("velocityVBox") as VBox;
        }

        private function get _timeVBox():VBox {
            return _config.getCompById("timeVBox") as VBox;
        }

        private function get _stepsNS():NumericStepper {
            return _config.getCompById("stepsNS") as NumericStepper;
        }
    }
}
