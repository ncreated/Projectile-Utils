package {

    /**
     *
     * @author maciek grzybowski, 03.11.2013 23:11
     *
     */
    public class SimulationController {

        private var _model:SimulationModel;
        private var _view:SimulationView;


        public function SimulationController(model:SimulationModel, view:SimulationView) {
            _model = model;
            _view = view;
            _view.clicked.add(onViewClicked);
        }

        public function update(dt:Number):void {
            _model.space.step(dt);

            _view.drawSpace(_model.space);

            if (_model.state == SimulationModel.STATE_AIM) {
                if (_model.mode == SimulationModel.MODE_CALCULATE_VELOCITY) {
                    _model.calculateVelocity();
                }
                else if (_model.mode == SimulationModel.MODE_CALCULATE_TIME) {
                    _model.calculateStepsNumber();
                }
                _view.drawTrajectory(_model.body.position, _model.launchVelocity, _model.gravity, _model.steps, _model.stepTime);
                _view.moveMarkerToPosition(_model.targetPosition.x, _model.targetPosition.y);
            }
        }

        private function onViewClicked(x:Number, y:Number):void {
            if (_model.state == SimulationModel.STATE_LAUNCHED) {
                _model.state = SimulationModel.STATE_AIM;
            }
            _model.targetPosition.setTo(x, y);
        }
    }
}
