package {

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Rectangle;
    import flash.utils.getTimer;

    [SWF(width="640", height="480", frameRate="60", backgroundColor="000000")]
    public class PhysicTrajectoryApp extends Sprite {

        private var _model:SimulationModel;
        private var _view:SimulationView;
        private var _controller:SimulationController;

        private var _settings:SettingsPanel;

        public function PhysicTrajectoryApp() {
            addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
            addEventListener(Event.ENTER_FRAME, update, false, 0, true);
        }

        private function init(event:Event):void {
            var simulationRect:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight - 120);
            _model = new SimulationModel(simulationRect);

            _view = new SimulationView(simulationRect);
            addChild(_view);

            _controller = new SimulationController(_model, _view);

            // defaults:
            _model.setTargetPosition(220, 150);
            _model.steps = 80;
            _model.stepTime = 1/30;
            _model.velocity = 300;
            _model.gravity.setxy(0, 200);
            _model.trajectory = 0;

            // settings panel:
            var settingsRect:Rectangle = new Rectangle(simulationRect.left, simulationRect.bottom, simulationRect.width, stage.stageHeight - simulationRect.height);
            _settings = new SettingsPanel(settingsRect, _model);
            _settings.x = simulationRect.left;
            _settings.y = simulationRect.bottom;
            addChild(_settings);

            _previousUpdateTime = getTimer();
        }

        private var _previousUpdateTime:Number;
        private function update(event:Event):void {
            var temp:Number = _previousUpdateTime;
            _previousUpdateTime = getTimer();

            if (_controller) {
                _controller.update(Math.min(1/60, (_previousUpdateTime - temp)/1000));
            }
        }
    }
}
