package {
    import com.bit101.components.Label;
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
                                    <VBox x="20" y="10">
                                        <Label text="time step:"/>
                                        <RadioButton label="1/60s" groupName="stepTime" event="click:onStepTimeChanged" selected="false" />
                                        <RadioButton label="1/40s" groupName="stepTime" event="click:onStepTimeChanged" selected="false" />
                                        <RadioButton label="1/30s" groupName="stepTime" event="click:onStepTimeChanged" selected="false" />
                                        <RadioButton label="1/20s" groupName="stepTime" event="click:onStepTimeChanged" selected="false" />
                                    </VBox>
                                    <VBox x="100" y="10">
                                        <Label text="initial velocity:"/>
                                        <NumericStepper id="velocityNS" minimum="10" maximum="1000" step="1" value="0" repeatTime="0" event="change:onVelocityChanged" />
                                        <Label text="steps to draw:"/>
                                        <NumericStepper id="stepsNS" minimum="10" maximum="200" step="1" value="0" repeatTime="0" event="change:onStepsChanged" />
                                    </VBox>
                                    <VBox x="210" y="10">
                                        <Label text="gravity:"/>
                                        <NumericStepper id="gravityNS" minimum="10" maximum="1000" step="1" value="0" repeatTime="0" event="change:onGravityChanged" />
                                    </VBox>
                                    <VBox x="320" y="10">
                                        <Label text="launch trajectory:"/>
                                        <RadioButton label="green" groupName="trajectory" event="click:onTrajectoryChanged" selected="false" />
                                        <RadioButton label="blue" groupName="trajectory" event="click:onTrajectoryChanged" selected="false" />
                                    </VBox>
                                    <Label id="alertLabel" x="210" y="74" text=""/>
                                    <PushButton id="launchButton" x="530" y="10" width="100" height="100" label="LAUNCH" event="click:onLaunchClicked"/>
                                </comps>

            if (_model.stepTime <= 1/60) layout.VBox[0].RadioButton[0].@selected = true;
            else if (_model.stepTime <= 1/40) layout.VBox[0].RadioButton[1].@selected = true;
            else if (_model.stepTime <= 1/30) layout.VBox[0].RadioButton[2].@selected = true;
            else if (_model.stepTime <= 1/20) layout.VBox[0].RadioButton[3].@selected = true;

            if (_model.trajectory == 0) layout.VBox[3].RadioButton[0].@selected = true;
            else  layout.VBox[3].RadioButton[1].@selected = true;

            layout.VBox[1].NumericStepper[0].@value = _model.velocity;
            layout.VBox[1].NumericStepper[1].@value = _model.steps;
            layout.VBox[2].NumericStepper.@value = _model.gravity.y;

            _config = new MinimalConfigurator(this);
            _config.parseXML(layout);

            _alertLabel.textField.textColor = 0xFF0000;
            _alertLabel.text = _model.alertMessage;
            _alertLabel.visible = _alertLabel.text != "";

            _model.stateChanged.add(stateChanged);
            _model.alertMessageChanged.add(alertMessageChanged);
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

        public function onTrajectoryChanged(event:Event):void {
            _model.state = SimulationModel.STATE_AIM;
            var button:RadioButton = event.currentTarget as RadioButton;
            switch (button.label) {
                case "green":
                    _model.trajectory = 0;
                    break;
                case "blue":
                    _model.trajectory = 1;
                    break;
            }
        }

        public function onStepsChanged(event:Event):void {
            _model.state = SimulationModel.STATE_AIM;
            var stepper:NumericStepper = event.currentTarget as NumericStepper;
            _model.steps = stepper.value;
        }

        public function onVelocityChanged(event:Event):void {
            _model.state = SimulationModel.STATE_AIM;
            var stepper:NumericStepper = event.currentTarget as NumericStepper;
            _model.velocity = stepper.value;
        }

        public function onGravityChanged(event:Event):void {
            _model.state = SimulationModel.STATE_AIM;
            var stepper:NumericStepper = event.currentTarget as NumericStepper;
            _model.setGravity(stepper.value);
        }

        public function onLaunchClicked(event:MouseEvent):void {
            _model.state = (_model.state + 1) % 2;
        }

        //

        private function stateChanged():void {
            if (_model.state == SimulationModel.STATE_AIM) {
                _launchButton.label = "LAUNCH";
            }
            else if (_model.state == SimulationModel.STATE_LAUNCHED) {
                _launchButton.label = "RESET";
            }
        }

        private function alertMessageChanged():void {
            _alertLabel.text = _model.alertMessage;
            _alertLabel.visible = _alertLabel.text != "";
        }

        // getters

        private function get _launchButton():PushButton {
            return _config.getCompById("launchButton") as PushButton;
        }

        private function get _alertLabel():Label {
            return _config.getCompById("alertLabel") as Label;
        }
    }
}
